package com.group17.SmartLocker.service;

import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.LockerUser;
import com.group17.SmartLocker.repository.LockerUserRepository;
import com.group17.SmartLocker.repository.NewUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LockerUserService {

    @Autowired
    private LockerUserRepository lockerUserRepository;

    // CRUD operations for the Locker user

    // Get all users
    public List<LockerUser> getAllLockerUsers(){
        return lockerUserRepository.findAll();
    }

    // Create a user
    public LockerUser createLockerUser(LockerUser lockerUser){

        return lockerUserRepository.save(lockerUser);
    }

    // Get user by id
    public ResponseEntity<LockerUser> getLockerUserById(String id){
        LockerUser lockerUser = lockerUserRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        return ResponseEntity.ok(lockerUser);
    }

    // Update user
    public ResponseEntity<LockerUser> updateLockerUser(String id, LockerUser lockerUserDetails){
        LockerUser updateLockerUser = lockerUserRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        updateLockerUser.setFingerPrint(lockerUserDetails.getFingerPrint());

        lockerUserRepository.save(updateLockerUser);

        return ResponseEntity.ok(updateLockerUser);
    }

    // Delete user
    public ResponseEntity<HttpStatus> deleteLockerUser(String id) {
        LockerUser lockerUser = lockerUserRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        lockerUserRepository.delete(lockerUser);

        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
