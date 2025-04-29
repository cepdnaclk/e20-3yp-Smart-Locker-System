package com.group17.SmartLocker.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.group17.SmartLocker.dto.NewUserDto;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.newUser.NewUserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class NewUserControllerTest {

    private MockMvc mockMvc;

    @Mock
    private NewUserService newUserService;

    @InjectMocks
    private NewUserController newUserController;

    private NewUser newUser;
    private User approvedUser;
    private NewUserDto newUserDto;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(newUserController).build();

        newUserDto = new NewUserDto();
        newUserDto.setRegNo("E20003");
        newUserDto.setFirstName("Jane");
        newUserDto.setLastName("Smith");
        newUserDto.setEmail("jane.smith@example.com");
        newUserDto.setPassword("password123");

        newUser = new NewUser();
        newUser.setId(1L);
        newUser.setRegNo("E20003");
        newUser.setFirstName("Jane");
        newUser.setLastName("Smith");
        newUser.setEmail("jane.smith@example.com");

        approvedUser = new User();
        approvedUser.setId("E20003");
        approvedUser.setUsername("E20003");
        approvedUser.setFirstName("Jane");
        approvedUser.setLastName("Smith");
        approvedUser.setEmail("jane.smith@example.com");
    }

    // Test Register New User
    @Test
    void testRegisterUser() throws Exception {
        when(newUserService.registerUser(any(NewUserDto.class))).thenReturn(newUser);

        mockMvc.perform(post("/api/newUsers/register")
                        .contentType("application/json")
                        .content(new ObjectMapper().writeValueAsString(newUserDto)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.regNo").value("E20003"))
                .andExpect(jsonPath("$.firstName").value("Jane"));

        verify(newUserService, times(1)).registerUser(any(NewUserDto.class));
    }

    // Test Get Pending Users
    @Test
    void testGetPendingUsers() throws Exception {
        List<NewUser> pendingUsers = Arrays.asList(newUser);
        when(newUserService.getPendingUsers()).thenReturn(pendingUsers);

        mockMvc.perform(get("/api/admin/pending"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.size()").value(1))
                .andExpect(jsonPath("$[0].regNo").value("E20003"));

        verify(newUserService, times(1)).getPendingUsers();
    }

    // Test Approve User (Success)
    @Test
    void testApproveUser_Success() throws Exception {
        when(newUserService.approveUser(1L)).thenReturn(Optional.of(approvedUser));

        mockMvc.perform(put("/api/admin/approve/1"))
                .andExpect(status().isOk())
                .andExpect(content().string("User approved and moved to LockerUser."));

        verify(newUserService, times(1)).approveUser(1L);
    }

    // Test Approve User (User Not Found)
    @Test
    void testApproveUser_NotFound() throws Exception {
        when(newUserService.approveUser(1L)).thenReturn(Optional.empty());

        mockMvc.perform(put("/api/admin/approve/1"))
                .andExpect(status().isNotFound());

        verify(newUserService, times(1)).approveUser(1L);
    }

    // Test Reject User
    @Test
    void testRejectUser() throws Exception {
        doNothing().when(newUserService).rejectUser(1L);

        mockMvc.perform(delete("/api/admin/reject/1"))
                .andExpect(status().isOk())
                .andExpect(content().string("User rejected and removed."));

        verify(newUserService, times(1)).rejectUser(1L);
    }
}
