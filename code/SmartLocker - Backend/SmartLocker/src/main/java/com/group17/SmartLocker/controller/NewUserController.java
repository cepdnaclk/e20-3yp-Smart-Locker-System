package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.DTO.NewUserRegistrationDto;
import com.group17.SmartLocker.model.LockerUser;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.service.NewUserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

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

    // Admin views pending users
    @GetMapping("/pending")
    public List<NewUser> getPendingUsers() {
        return newUserService.getPendingUsers();
    }


    // Admin approves user
    @PutMapping("/approve/{id}")
    public ResponseEntity<String> approveUser(@PathVariable Long id) {
        Optional<LockerUser> lockerUser = newUserService.approveUser(id);
        return lockerUser.isPresent() ?
                ResponseEntity.ok("User approved and moved to LockerUser.") :
                ResponseEntity.notFound().build();
    }

    // Admin rejects user
    @DeleteMapping("/reject/{regNo}")
    public ResponseEntity<String> rejectUser(@PathVariable Long regNo) {
        newUserService.rejectUser(regNo);
        return ResponseEntity.ok("User rejected and removed.");
    }
}

