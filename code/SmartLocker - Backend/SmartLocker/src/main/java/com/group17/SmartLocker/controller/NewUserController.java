package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.DTO.NewUserRegistrationDto;
import com.group17.SmartLocker.service.NewUserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@CrossOrigin("*")
@RestController
@RequestMapping("/api/newUsers")
public class NewUserController {
    private final NewUserService newUserService;

    public NewUserController(NewUserService newUserService) {
        this.newUserService = newUserService;
    }

    @PostMapping("/register")
    public ResponseEntity<String> registerUser(@RequestBody NewUserRegistrationDto newUSerDto) {
        newUserService.registerUser(newUSerDto);
        return ResponseEntity.ok("User registered successfully and pending approval.");
    }
}

