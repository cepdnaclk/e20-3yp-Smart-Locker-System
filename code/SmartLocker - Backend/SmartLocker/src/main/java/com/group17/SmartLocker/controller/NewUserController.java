package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.service.newUser.NewUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/newUsers")
public class NewUserController {
    private final NewUserService newUserService;

    // New user registration
    @PostMapping("/register")
    public NewUser registerUser(@RequestBody NewUser newUSer) {
        return newUserService.registerUser(newUSer);
    }
}

