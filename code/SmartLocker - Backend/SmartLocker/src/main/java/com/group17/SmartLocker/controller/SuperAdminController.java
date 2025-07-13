package com.group17.SmartLocker.controller;


import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.admin.AdminService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;
import static org.springframework.http.HttpStatus.OK;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/superAdmin")
public class SuperAdminController {

    private final AdminService adminService;

    // update a user details by id
    @PutMapping("/updateUser/{id}")
    public ResponseEntity<String> updateUser(@PathVariable String id, @RequestBody User userDetails){
        try {
            adminService.updateUser(id, userDetails);
            System.out.printf(userDetails.toString());
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // edit user details
    @PatchMapping("/editUser/{id}")
    public ResponseEntity<String> patchUser(@PathVariable String id, @RequestBody Map<String, Object> updates) {
        try {
            adminService.editUserDetails(id, updates);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    // delete users
    @DeleteMapping("/deleteUser/{id}")
    public ResponseEntity<String> deleteUser(@PathVariable String id){
        try {
            adminService.deleteUser(id);
            return ResponseEntity.status(OK).build();
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

}
