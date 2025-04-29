package com.group17.SmartLocker.service.lockerUser;

import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    // CRUD operations for the user

    // Get all users
    public List<User> getAllUsers(){
        return userRepository.findAll();
    }

    // Create a user
    public User createUser(User user){

        return userRepository.save(user);
    }

    // Get user by id
    public ResponseEntity<User> getUserById(String id){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        return ResponseEntity.ok(user);
    }

    // Update user
    public ResponseEntity<User> updateUser(String id, User userDetails){
        User updateUser = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        updateUser.setFingerPrint(userDetails.getFingerPrint());

        userRepository.save(updateUser);

        return ResponseEntity.ok(updateUser);
    }

    // Delete user
    public ResponseEntity<HttpStatus> deleteUser(String id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        userRepository.delete(user);

        return new ResponseEntity<>(HttpStatus.NO_CONTENT);
    }
}
