package com.group17.SmartLocker.controller;


import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.response.ApiResponse;
import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/user")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;
    private final LockerService lockerService;

    //todo: Implement the api end point to unlock the locker
    // send cluster id and the token to the service layer
    @GetMapping("/unlockLocker")
    public ResponseEntity<ApiResponse> unlockLocker(HttpServletRequest request, @RequestBody Long clusterId){

        System.out.println("Request comes in");
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String message = lockerService.unlockLocker(jwtService.extractUsername(jwtToken), clusterId);
            return ResponseEntity.ok(new ApiResponse("Success", message));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body(new ApiResponse(e.getMessage(), null));
        }

    }


    // get all registered users
    @GetMapping("/getAllUsers")
    public List<User> getAllUsers(){
        System.out.println("Request comes in");
        return userService.getAllUsers();
    }

    // create a new user
    @PostMapping("/admin/createNewUser")
    public User createUser(@RequestBody User user){
        return userService.createUser(user);
    }

    // find user by id
    @GetMapping("/admin/findUserById/{id}")
    public ResponseEntity<User> getUserById(@PathVariable String id){
        return userService.getUserById(id);
    }

    // update a user details by id
    @PutMapping("/admin/updateUserById/{id}")
    public ResponseEntity<User> updateUser(@PathVariable String id, @RequestBody User userDetails){
        return userService.updateUser(id, userDetails);
    }

    // delete users
    @DeleteMapping("/admin/deleteUserByID/{id}")
    public ResponseEntity<HttpStatus> deleteUser(@PathVariable String id){
        return userService.deleteUser(id);
    }

}
