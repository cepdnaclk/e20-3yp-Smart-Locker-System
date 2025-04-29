package com.group17.SmartLocker.controller;


import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.lockerUser.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@CrossOrigin("*")
@RestController
@RequestMapping("/api")
public class UserController {

    @Autowired
    private UserService userService;


    // get all registered users
    @GetMapping("/user/getAllUsers")
    public List<User> getAllUsers(){
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
