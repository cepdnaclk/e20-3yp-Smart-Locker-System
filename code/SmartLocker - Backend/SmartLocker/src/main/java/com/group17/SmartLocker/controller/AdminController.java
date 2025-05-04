package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.model.User;
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
    public ResponseEntity<List<User>> getAllUsers(){
        try {
            List<User> users = userService.getAllUsers();
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
    public ResponseEntity<User> getUserById(@PathVariable String id){
        try {
            User user = userService.getUserById(id);
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

}
