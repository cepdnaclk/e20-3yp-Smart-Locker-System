package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.NewUserDto;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.service.newUser.NewUserService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@CrossOrigin("*")
@RestController
@RequestMapping("/api")
public class NewUserController {
    private final NewUserService newUserService;

    public NewUserController(NewUserService newUserService) {
        this.newUserService = newUserService;
    }

    @PostMapping("/newUsers/register")
    public NewUser registerUser(@RequestBody NewUserDto newUSerDto) {

        return newUserService.registerUser(newUSerDto);
    }

    // Admin views pending users
    @GetMapping("/admin/pending")
    public List<NewUser> getPendingUsers() {
        return newUserService.getPendingUsers();
    }


    // Admin approves user
    @PutMapping("/admin/approve/{id}")
    public ResponseEntity<String> approveUser(@PathVariable Long id) {
        Optional<User> lockerUser = newUserService.approveUser(id);
        return lockerUser.isPresent() ?
                ResponseEntity.ok("User approved and moved to LockerUser.") :
                ResponseEntity.notFound().build();
    }

    // Admin rejects user
    @DeleteMapping("/admin/reject/{id}")
    public ResponseEntity<String> rejectUser(@PathVariable Long id) {
        newUserService.rejectUser(id);
        return ResponseEntity.ok("User rejected and removed.");
    }
}

