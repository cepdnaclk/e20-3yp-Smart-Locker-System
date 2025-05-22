package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.Locker;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repsponse.ApiResponse;
import com.group17.SmartLocker.service.email.EmailService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.lockerCluster.LockerClusterService;
import com.group17.SmartLocker.service.newUser.NewUserService;
import com.group17.SmartLocker.service.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;
import static org.springframework.http.HttpStatus.OK;

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
    public ResponseEntity<User> updateUser(@PathVariable String id, @RequestBody User userDetails){
        try {
            User user = userService.updateUser(id, userDetails);
            System.out.printf(userDetails.toString());
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // edit user details
    @PatchMapping("/editUser/{id}")
    public ResponseEntity<User> patchUser(@PathVariable String id, @RequestBody Map<String, Object> updates) {
        try {
            User user = userService.editUserDetails(id, updates);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // delete users
    @DeleteMapping("/deleteUser/{id}")
    public ResponseEntity<HttpStatus> deleteUser(@PathVariable String id){
        try {
            userService.deleteUser(id);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }


    // Locker management endpoints

    // get all lockers in the system
    @GetMapping("/getAllLockers")
    public ResponseEntity<List<Locker>> getAllLockers(){
        try {
            List<Locker> lockers = lockerService.getAllLockers();
            return ResponseEntity.ok(lockers);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // get all the lockers in a specific cluster
    @GetMapping("/getLockerByCluster/{clusterId}")
    public ResponseEntity<List<Locker>> getAllLockersByCluster(@PathVariable Long clusterId){
        try {
            List<Locker> lockers = lockerService.getAllLockersByCluster(clusterId);
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
    public ResponseEntity<Locker> updateLockerDetails(@PathVariable Long lockerId, @RequestBody LockerDto locker){
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
    @PostMapping("/addLockerCluster/{clusterId}")
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
    public ResponseEntity<LockerCluster> updateLockerDetails(@PathVariable Long clusterId, @RequestBody LockerClusterDto lockerClusterDto){
        try {
            LockerCluster newLockerCluster = lockerClusterService.updateLockerCluster(clusterId, lockerClusterDto);
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
