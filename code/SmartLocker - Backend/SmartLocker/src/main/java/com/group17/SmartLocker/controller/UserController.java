package com.group17.SmartLocker.controller;


import com.group17.SmartLocker.entity.User;
import com.group17.SmartLocker.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.concurrent.ExecutionException;

@RestController
@RequestMapping("/User")
public class UserController {

    @Autowired
    private UserService userService;

    @PostMapping("")
    public String saveUser(@RequestBody User user) throws ExecutionException, InterruptedException{

        return userService.saveUser(user);
    }


}
