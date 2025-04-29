package com.group17.SmartLocker.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.lockerUser.UserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.Arrays;
import java.util.List;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@CrossOrigin("*")
class UserControllerTest {

    private MockMvc mockMvc;

    @Mock
    private UserService userService;

    @InjectMocks
    private UserController userController;

    private User user;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(userController).build();

        user = new User();
        user.setId("E20002");
        user.setUsername("E20002");
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john.doe@example.com");
        user.setPassword("password123");
    }

    // Test Get All Users
    @Test
    void testGetAllUsers() throws Exception {
        List<User> users = Arrays.asList(user);
        when(userService.getAllUsers()).thenReturn(users);

        mockMvc.perform(get("/api/admin/getAllUsers"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.size()").value(1))
                .andExpect(jsonPath("$[0].id").value("E20002"))
                .andExpect(jsonPath("$[0].firstName").value("John"));

        verify(userService, times(1)).getAllUsers();
    }

    // Test Create New User
    @Test
    void testCreateUser() throws Exception {
        when(userService.createUser(any(User.class))).thenReturn(user);

        mockMvc.perform(post("/api/admin/createNewUser")
                        .contentType("application/json")
                        .content(new ObjectMapper().writeValueAsString(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("E20002"))
                .andExpect(jsonPath("$.username").value("E20002"));

        verify(userService, times(1)).createUser(any(User.class));
    }

    // Test Get User By ID (Success)
    @Test
    void testGetUserById_Success() throws Exception {
        when(userService.getUserById("E20002")).thenReturn(ResponseEntity.ok(user));

        mockMvc.perform(get("/api/admin/findUserById/E20002"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("E20002"))
                .andExpect(jsonPath("$.firstName").value("John"));

        verify(userService, times(1)).getUserById("E20002");
    }

    // Test Get User By ID (Not Found)
    @Test
    void testGetUserById_NotFound() throws Exception {
        when(userService.getUserById("E20002")).thenReturn(ResponseEntity.notFound().build());

        mockMvc.perform(get("/api/admin/findUserById/E20002"))
                .andExpect(status().isNotFound());

        verify(userService, times(1)).getUserById("E20002");
    }

    // Test Update User
    @Test
    void testUpdateUser() throws Exception {
        when(userService.updateUser(eq("E20002"), any(User.class))).thenReturn(ResponseEntity.ok(user));

        mockMvc.perform(put("/api/admin/updateUserById/E20002")
                        .contentType("application/json")
                        .content(new ObjectMapper().writeValueAsString(user)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("E20002"));

        verify(userService, times(1)).updateUser(eq("E20002"), any(User.class));
    }

    // Test Delete User
    @Test
    void testDeleteUser() throws Exception {
        when(userService.deleteUser("E20002")).thenReturn(ResponseEntity.status(HttpStatus.NO_CONTENT).build());

        mockMvc.perform(delete("/api/admin/deleteUserByID/E20002"))
                .andExpect(status().isNoContent());

        verify(userService, times(1)).deleteUser("E20002");
    }
}

