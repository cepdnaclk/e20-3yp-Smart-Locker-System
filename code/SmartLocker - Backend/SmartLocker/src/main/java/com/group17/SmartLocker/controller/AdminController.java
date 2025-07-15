package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.*;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.exception.UnauthorizedActionException;
import com.group17.SmartLocker.model.*;
import com.group17.SmartLocker.repsponse.ApiResponse;
import com.group17.SmartLocker.service.admin.AdminService;
import com.group17.SmartLocker.service.email.EmailService;
import com.group17.SmartLocker.service.image.ImageService;
import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.lockerCluster.LockerClusterService;
import com.group17.SmartLocker.service.lockerLog.LockerLogService;
import com.group17.SmartLocker.service.newUser.NewUserService;
import com.group17.SmartLocker.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;
import static org.springframework.http.HttpStatus.OK;
import static software.amazon.awssdk.http.HttpStatusCode.NOT_FOUND;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/admin")
public class AdminController {

    private final NewUserService newUserService;
    private final UserService userService;
    private final LockerService lockerService;
    private final LockerClusterService lockerClusterService;
    private final EmailService emailService;
    private final LockerLogService lockerLogService;
    private final JwtService jwtService;
    private final ImageService imageService;
    private final AdminService adminService;

    // CRUD operations for Admin

    // to view admins their details
    @GetMapping("/profile")
    public ResponseEntity<UserDetailsDto> getUserById(HttpServletRequest request) {

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            UserDetailsDto user = userService.getUserById(jwtService.extractUsername(jwtToken));
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // to edit own details of the admin
    @PatchMapping("/editProfile")
    public ResponseEntity<String> patchUser(HttpServletRequest request, @RequestBody Map<String, Object> updates) {

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String id = userService.getUserIdByUsername(jwtService.extractUsername(jwtToken));
            User user = userService.editUserDetails(id, updates);
            return ResponseEntity.ok("Details updated successfully!");
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    /*
     * Upload profile picture
     */

    @PostMapping("/image/upload/{username}")
    public ResponseEntity<String> upload(@PathVariable String username, @RequestParam("file") MultipartFile file) {
        try {
            Image image = imageService.uploadImage(username, file);
            return ResponseEntity.ok("Image uploaded with ID: " + image.getId());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Upload failed: " + e.getMessage());
        }
    }


    /*
     * Download profile picture
     */
    @GetMapping("/image/download/{username}")
    public ResponseEntity<Resource> downloadProfilePicture(@PathVariable String username) {

        Image image = imageService.getUserImages(username);

        if (image == null || image.getImage() == null) {
            return ResponseEntity
                    .status(HttpStatus.NOT_FOUND)
                    .body(null);
        }

        try {
            ByteArrayResource resource = new ByteArrayResource(
                    image.getImage().getBytes(1, (int) image.getImage().length())
            );

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(image.getFileType()))
                    .header(HttpHeaders.CONTENT_DISPOSITION,
                            "attachment; filename=\"" + image.getFileName() + "\"")
                    .body(resource);

        } catch (SQLException e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    /*
     * Delete profile picture
     */
    @DeleteMapping("/image/delete/{username}")
    public ResponseEntity<ApiResponse> deleteProfilePicture(@PathVariable String username) {
        try {
            imageService.deleteUserImages(username);
            return ResponseEntity.ok(new ApiResponse("Image deleted", null));
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(NOT_FOUND).body(new ApiResponse(e.getMessage(), null));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body(new ApiResponse("Delete failed", e.getMessage()));
        }
    }

    // api endpoints to manage new users

    // Admin views pending users
    @GetMapping("/pending")
    public List<NewUser> getPendingUsers() {
        return newUserService.getPendingUsers();
    }

    // Admin approves user
    @PutMapping("/approve/{id}")
    public ResponseEntity<String> approveUser(@PathVariable Long id) {
        Optional<User> lockerUser = newUserService.approveUser(id);
        return lockerUser.isPresent() ?
                ResponseEntity.ok("User approved and moved to LockerUser.") :
                ResponseEntity.notFound().build();
    }

    // Admin rejects user
    @DeleteMapping("/reject/{id}")
    public ResponseEntity<String> rejectUser(@PathVariable Long id) {
        newUserService.rejectUser(id);
        return ResponseEntity.ok("User rejected and removed.");
    }

    // api endpoints for manage new users

    // get all registered users
    @GetMapping("/getAllUsers")
    public ResponseEntity<List<UserDetailsDto>> getAllUsers(){
        try {
            List<UserDetailsDto> users = userService.getAllUsers();
            return ResponseEntity.ok(users);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // create a new user
    // This should not have an endpoint, there is no point admin creating a single user
//    @PostMapping("/createNewUser")
    public User createUser(@RequestBody User user){
        return userService.createUser(user);
    }

    // find user by id
    @GetMapping("/findUserById/{id}")
    public ResponseEntity<UserDetailsDto> getUserById(@PathVariable String id){
        try {
            UserDetailsDto user = userService.getUserById(id);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // update a user details by id
    @PutMapping("/updateUser/{id}")
    public ResponseEntity<String> updateUser(@PathVariable String id, @RequestBody User userDetails){
        try {
            User user = userService.updateUser(id, userDetails);
            System.out.printf(userDetails.toString());
            return ResponseEntity.status(OK).build();
        } catch (UnauthorizedActionException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // edit user details
    @PatchMapping("/editUser/{id}")
    public ResponseEntity<String> patchUser(@PathVariable String id, @RequestBody Map<String, Object> updates) {
        try {
            userService.editUserDetails(id, updates);
            return ResponseEntity.status(OK).build();
        } catch (UnauthorizedActionException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // delete users
    @DeleteMapping("/deleteUser/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable String id){
        try {
            userService.deleteUser(id);
            return ResponseEntity.status(OK).build();
        } catch (UnauthorizedActionException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // lockerlog management endpoints
    @GetMapping("/getAllLogs")
    public ResponseEntity<List<LockerLogDto>> getAllLogs(){
        try {
            List<LockerLogDto> lockerLogs = lockerLogService.getAllLockerLogs();
            return ResponseEntity.ok(lockerLogs);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // Locker management endpoints

    // get all lockers in the system
    @GetMapping("/getAllLockers")
    public ResponseEntity<List<LockerDto>> getAllLockers(){
        try {
            List<LockerDto> lockers = lockerService.getAllLockers();
            return ResponseEntity.ok(lockers);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // get all the lockers in a specific cluster
    @GetMapping("/getLockerByCluster/{clusterId}")
    public ResponseEntity<List<LockerDto>> getAllLockersByCluster(@PathVariable Long clusterId){
        try {
            List<LockerDto> lockers = lockerService.getAllLockersByCluster(clusterId);
            return ResponseEntity.ok(lockers);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // get available lockers by cluster
    @GetMapping("/getAvailableLockersByCluster/{clusterId}")
    public ResponseEntity<List<Locker>> getAvailableLockersByCluster(@PathVariable Long clusterId){
        try {
            List<Locker> lockers = lockerService.getAvailableLockersByCluster(clusterId);
            return ResponseEntity.ok(lockers);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // get occupied lockers by cluster
    @GetMapping("/getOccupiedLockersByCluster/{clusterId}")
    public ResponseEntity<List<Locker>> getOccupiedLockersByCluster(@PathVariable Long clusterId){
        try {
            List<Locker> lockers = lockerService.getOccupiedLockersByCluster(clusterId);
            return ResponseEntity.ok(lockers);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // add a locker to a cluster
    @PostMapping("/addLockerToACluster/{clusterId}")
    public ResponseEntity<Locker> addLockerToCluster(@PathVariable Long clusterId){
        try {
            Locker locker = lockerService.addLockerToCluster(clusterId);
            return ResponseEntity.ok(locker);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // update locker
    @PutMapping("/updateLockerDetails/{lockerId}")
    public ResponseEntity<Locker> updateLockerDetails(@PathVariable Long lockerId, @RequestBody Locker locker){
        try {
            Locker newLocker = lockerService.updateLockerDetails(lockerId, locker);
            return ResponseEntity.ok(newLocker);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // delete locker
    @DeleteMapping("/deleteLocker/{lockerId}")
    public ResponseEntity<HttpStatus> deleteLocker(@PathVariable Long lockerId){
        try {
            lockerService.deleterLocker(lockerId);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // Locker cluster management

    // add a new locker cluster.
    // when adding a new locker cluster it should be displayed in the map also
    @PostMapping("/addLockerCluster")
    public ResponseEntity<LockerCluster> addLockerCluster(@RequestBody LockerClusterDto lockerClusterDto){
        try {
            LockerCluster lockerCluster = lockerClusterService.addLockerCluster(lockerClusterDto);
            return ResponseEntity.ok(lockerCluster);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // get cluster by id
    @GetMapping("/getClusterById/{clusterId}")
    public ResponseEntity<LockerCluster> getLockerCluster(@PathVariable Long clusterId){
        try {
            LockerCluster lockerCluster = lockerClusterService.getLockerClusterById(clusterId);
            return ResponseEntity.ok(lockerCluster);
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // find all locker clusters
    @GetMapping("/getAllLockerClusters")
    public ResponseEntity<List<LockerClusterDto>> getAllLockerClusters(){
        try {
            List<LockerClusterDto> lockerClusters = lockerClusterService.getAllLockerClusters();
            return ResponseEntity.ok(lockerClusters);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @PutMapping("/updateLockerCluster/{clusterId}")
    public ResponseEntity<LockerClusterDto> updateLockerDetails(@PathVariable Long clusterId, @RequestBody LockerClusterDto lockerClusterDto){
        try {
            LockerClusterDto newLockerCluster = lockerClusterService.updateLockerCluster(clusterId, lockerClusterDto);
            return ResponseEntity.ok(newLockerCluster);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // delete locker
    @DeleteMapping("/deleteLockerCluster/{lockerClusterId}")
    public ResponseEntity<HttpStatus> deleteLockerCluster(@PathVariable Long lockerClusterId){
        try {
            lockerClusterService.deleteLockerClusterById(lockerClusterId);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // Get blocked lockers
    @GetMapping("/getAllBlockedLockers")
    public ResponseEntity<List<LockerDto>> getAllBlockedLockers(){
        try {
            List<LockerDto> lockerClusters = adminService.getBlockedLockersByCluster();
            return ResponseEntity.ok(lockerClusters);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // force unlock locker by the admin
    @PostMapping("/adminLockerUnlock")
    public ResponseEntity<String> adminLockerUnlock(HttpServletRequest request, @RequestBody AdminLockerUnlockDto dto){

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String username = jwtService.extractUsername(jwtToken);

            lockerService.unlockByAdmin(dto.getLockerClusterId(), dto.getLockerId(), username, dto.getPassword());
            return ResponseEntity.status(OK).build();

        } catch (IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Invalid admin credentials");

        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }


    /*
    * Change password by using the current password
    */
    @PatchMapping("/changePassword")
    public ResponseEntity<String> changePassword(
            @RequestBody ChangePasswordDto dto,
            HttpServletRequest request
    ) {
        try {
            // Get username from JWT token
            String authHeader = request.getHeader("Authorization");
            if (authHeader == null || !authHeader.startsWith("Bearer ")) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized");
            }

            String token = authHeader.substring(7);
            String username = jwtService.extractUsername(token); // You must have jwtService injected

            userService.changePassword(username, dto.getCurrentPassword(), dto.getNewPassword());

            return ResponseEntity.ok("Password changed successfully");

        } catch (UnauthorizedActionException e) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body(e.getMessage());
        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Password change failed");
        }
    }

//    // send and email for a test
//    @PostMapping("/sendEmail")
//    public ResponseEntity<HttpStatus> sendEmail(@RequestBody String email){
//        try {
//            System.out.println(email);
//            emailService.sendSimpleEmail(email, "Welcome to SmartLocker", "Your locker access has been registered successfully.");
//            System.out.println("Email sent successfully");
//            return ResponseEntity.status(OK).build();
//        } catch (Exception e) {
//            System.out.println(e.getMessage());
//            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
//        }
//    }
}
