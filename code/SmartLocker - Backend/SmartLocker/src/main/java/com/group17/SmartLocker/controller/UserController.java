package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.ChangePasswordDto;
import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.dto.LockerLogDto;
import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.enums.OtpType;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.exception.UnauthorizedActionException;
import com.group17.SmartLocker.model.Image;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.model.Notification;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repsponse.ApiResponse;
import com.group17.SmartLocker.service.image.ImageService;
import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.lockerCluster.LockerClusterService;
import com.group17.SmartLocker.service.notification.NotificationService;
import com.group17.SmartLocker.service.userOtp.UserOtpService;
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

import static com.group17.SmartLocker.enums.OtpType.PASSWORD_RESET;
import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;
import static software.amazon.awssdk.http.HttpStatusCode.NOT_FOUND;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/user")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;
    private final LockerService lockerService;
    private final LockerClusterService lockerClusterService;
    private final NotificationService notificationService;
    private final ImageService imageService;

//    //todo: Implement the api end point to unlock the locker
//    // send cluster id and the token to the service layer
//    @GetMapping("/unlockLocker")
//    public ResponseEntity<ApiResponse> unlockLocker(HttpServletRequest request, @RequestParam Long clusterId){
//
//        String jwtToken = "";
//        // Extract token from the http request. No need to check the token in null.
//        // There should be a token to access this endpoint ?
//        String authHeader = request.getHeader("Authorization");
//        if (authHeader != null && authHeader.startsWith("Bearer ")) {
//            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
//        }
//
//        try {
//            String message = lockerService.unlockLocker(jwtService.extractUsername(jwtToken), clusterId);
//            return ResponseEntity.ok(new ApiResponse("Success", message));
//        } catch (Exception e) {
//            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body(new ApiResponse(e.getMessage(), null));
//        }
//
//    }


    // access the assigned locker
    @GetMapping("/accessLocker")
    public ResponseEntity<String> accessLocker(HttpServletRequest request) {
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String username = jwtService.extractUsername(jwtToken);
            return ResponseEntity.ok(lockerService.accessLocker(username, "1"));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }


    // unassign the assigned locker
    @GetMapping("/unassign")
    public ResponseEntity<String> unassignLocker(HttpServletRequest request) {
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String username = jwtService.extractUsername(jwtToken);
            return ResponseEntity.ok(lockerService.unassignLocker(username, "2"));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // to view users their user details
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


    // to edit own details of the user
    @PatchMapping("/editProfile")
    public ResponseEntity<User> patchUser(HttpServletRequest request, @RequestBody Map<String, Object> updates) {

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
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/logs")
    public ResponseEntity<List<LockerLogDto>> getUserLogs(HttpServletRequest request) {

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.getLockerLogs(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/lockerAvailability/{clusterId}")
    public ResponseEntity<LockerClusterDto> getLockerClusterDetails(@PathVariable Long clusterId) {
        try {
            LockerCluster lockerCluster = lockerClusterService.getLockerClusterById(clusterId);

            LockerClusterDto lockerClusterDto = new LockerClusterDto();

            lockerClusterDto.setClusterName(lockerCluster.getClusterName());
            lockerClusterDto.setLockerClusterDescription(lockerCluster.getLockerClusterDescription());
            lockerClusterDto.setTotalNumberOfLockers(lockerCluster.getTotalNumberOfLockers());
            lockerClusterDto.setAvailableNumberOfLockers(lockerCluster.getAvailableNumberOfLockers());

            lockerClusterDto.setLatitude(lockerCluster.getLatitude());
            lockerClusterDto.setLongitude(lockerCluster.getLongitude());

            return ResponseEntity.ok(lockerClusterDto);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/getOtpCode")
    public ResponseEntity<String> getOtpCode(HttpServletRequest request) {
        // find the username to get the otp code
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.getOtpCode(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/generateNewOtpCode")
    public ResponseEntity<String> generateNewOtpCode(HttpServletRequest request) {
        // find the username to get the otp code
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.generateOtpCodeManually(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/getAllNotifications")
    public ResponseEntity<List<Notification>> getAllNotifications(HttpServletRequest request) {
        // find the username to get the otp code
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(notificationService.getAllNotifications(jwtService.extractUsername(jwtToken)));
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

    /*
    * Change password by using current password
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

}