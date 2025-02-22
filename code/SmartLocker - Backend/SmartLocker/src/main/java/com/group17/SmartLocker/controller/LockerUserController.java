package com.group17.SmartLocker.controller;


import com.group17.SmartLocker.model.LockerUser;
import com.group17.SmartLocker.service.LockerUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@CrossOrigin("*")
@RestController
@RequestMapping("/api/lockerUser")
public class LockerUserController {

    @Autowired
    private LockerUserService lockerUserService;

    @GetMapping
    public List<LockerUser> getAllLockerUsers(){
        return lockerUserService.getAllLockerUsers();
    }

    @PostMapping
    public LockerUser createLockerUser(@RequestBody LockerUser lockerUser){

        return lockerUserService.createLockerUser(lockerUser);
    }

    @GetMapping("{id}")
    public ResponseEntity<LockerUser> getLockerUserById(@PathVariable String id){

        return lockerUserService.getLockerUserById(id);
    }

    @PutMapping("{id}")
    public ResponseEntity<LockerUser> updateLockerUser(@PathVariable String id, @RequestBody LockerUser lockerUserDetails){

        return lockerUserService.updateLockerUser(id, lockerUserDetails);
    }

    @DeleteMapping("{id}")
    public ResponseEntity<HttpStatus> deleteLockerUser(@PathVariable String id){

        return lockerUserService.deleteLockerUser(id);
    }

}
