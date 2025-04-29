package com.group17.SmartLocker.service;

import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.lockerUser.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private UserService userService;

    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId("E20002");
        user.setUsername("E20002");
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john.doe@example.com");
        user.setFingerPrint("fingerprint_data");
    }

    // Test Get All Users
    @Test
    void testGetAllUsers() {
        when(userRepository.findAll()).thenReturn(Arrays.asList(user));

        List<User> users = userService.getAllUsers();

        assertEquals(1, users.size());
        assertEquals("E20002", users.get(0).getId());

        verify(userRepository, times(1)).findAll();
    }

    // Test Create User
    @Test
    void testCreateUser() {
        when(userRepository.save(any(User.class))).thenReturn(user);

        User createdUser = userService.createUser(user);

        assertNotNull(createdUser);
        assertEquals("E20002", createdUser.getId());

        verify(userRepository, times(1)).save(any(User.class));
    }

    // Test Get User by ID (Success)
    @Test
    void testGetUserById() {
        when(userRepository.findById("E20002")).thenReturn(Optional.of(user));

        ResponseEntity<User> response = userService.getUserById("E20002");

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("E20002", response.getBody().getId());

        verify(userRepository, times(1)).findById("E20002");
    }

    // Test Get User by ID (User Not Found)
    @Test
    void testGetUserById_NotFound() {
        when(userRepository.findById("E20002")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ResourceNotFoundException.class, () -> {
            userService.getUserById("E20002");
        });

        assertEquals("User not exist with id: E20002", exception.getMessage());

        verify(userRepository, times(1)).findById("E20002");
    }

    // Test Update User (Success)
    @Test
    void testUpdateUser() {
        User updatedUserDetails = new User();
        updatedUserDetails.setFingerPrint("new_fingerprint");

        when(userRepository.findById("E20002")).thenReturn(Optional.of(user));
        when(userRepository.save(any(User.class))).thenReturn(user);

        ResponseEntity<User> response = userService.updateUser("E20002", updatedUserDetails);

        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("new_fingerprint", response.getBody().getFingerPrint());

        verify(userRepository, times(1)).findById("E20002");
        verify(userRepository, times(1)).save(any(User.class));
    }

    // Test Update User (User Not Found)
    @Test
    void testUpdateUser_NotFound() {
        when(userRepository.findById("E20002")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ResourceNotFoundException.class, () -> {
            userService.updateUser("E20002", new User());
        });

        assertEquals("User not exist with id: E20002", exception.getMessage());

        verify(userRepository, times(1)).findById("E20002");
        verify(userRepository, never()).save(any(User.class));
    }

    // Test Delete User (Success)
    @Test
    void testDeleteUser() {
        when(userRepository.findById("E20002")).thenReturn(Optional.of(user));

        ResponseEntity<HttpStatus> response = userService.deleteUser("E20002");

        assertEquals(HttpStatus.NO_CONTENT, response.getStatusCode());

        verify(userRepository, times(1)).findById("E20002");
        verify(userRepository, times(1)).delete(user);
    }

    // Test Delete User (User Not Found)
    @Test
    void testDeleteUser_NotFound() {
        when(userRepository.findById("E20002")).thenReturn(Optional.empty());

        Exception exception = assertThrows(ResourceNotFoundException.class, () -> {
            userService.deleteUser("E20002");
        });

        assertEquals("User not exist with id: E20002", exception.getMessage());

        verify(userRepository, times(1)).findById("E20002");
        verify(userRepository, never()).delete(any(User.class));
    }
}

