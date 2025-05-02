// this comment is added to check the pull requests

package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.newUser.NewUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/admin")
public class AdminController {

    private final NewUserService newUserService;

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


}
