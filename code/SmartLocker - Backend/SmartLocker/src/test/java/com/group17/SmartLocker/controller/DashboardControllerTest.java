package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.DashboardResponse;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpHeaders;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class DashboardControllerTest {

    private MockMvc mockMvc;

    @Mock
    private JwtService jwtService;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private DashboardController dashboardController;

    private User adminUser;
    private User normalUser;
    private final String validAdminToken = "Bearer valid-admin-token";
    private final String validUserToken = "Bearer valid-user-token";

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(dashboardController).build();

        adminUser = new User();
        adminUser.setUsername("adminUser");
        adminUser.setFirstName("Admin");
        adminUser.setRole(com.group17.SmartLocker.enums.Role.ADMIN);

        normalUser = new User();
        normalUser.setUsername("normalUser");
        normalUser.setFirstName("User");
        normalUser.setRole(com.group17.SmartLocker.enums.Role.USER);
    }

    // Test Admin Dashboard Access (Success)
    @Test
    void testGetAdminDashboard_Success() throws Exception {
        when(jwtService.extractUsername("valid-admin-token")).thenReturn("adminUser");
        when(userRepository.findByUsername("adminUser")).thenReturn(adminUser);

        mockMvc.perform(get("/api/admin/dashboard")
                        .header(HttpHeaders.AUTHORIZATION, validAdminToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("Admin Dashboard"))
                .andExpect(jsonPath("$.message").value("Welcome, Admin"));

        verify(jwtService, times(1)).extractUsername("valid-admin-token");
        verify(userRepository, times(1)).findByUsername("adminUser");
    }

    // Test Admin Dashboard Access (Forbidden)
    @Test
    void testGetAdminDashboard_AccessDenied() throws Exception {
        when(jwtService.extractUsername("valid-user-token")).thenReturn("normalUser");
        when(userRepository.findByUsername("normalUser")).thenReturn(normalUser);

        mockMvc.perform(get("/api/admin/dashboard")
                        .header(HttpHeaders.AUTHORIZATION, validUserToken))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.title").value("Access Denied"));

        verify(jwtService, times(1)).extractUsername("valid-user-token");
        verify(userRepository, times(1)).findByUsername("normalUser");
    }

    // Test User Dashboard Access (Success)
    @Test
    void testGetUserDashboard_Success() throws Exception {
        when(jwtService.extractUsername("valid-user-token")).thenReturn("normalUser");
        when(userRepository.findByUsername("normalUser")).thenReturn(normalUser);

        mockMvc.perform(get("/api/user/dashboard")
                        .header(HttpHeaders.AUTHORIZATION, validUserToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.title").value("User Dashboard"))
                .andExpect(jsonPath("$.message").value("Welcome! User"));

        verify(jwtService, times(1)).extractUsername("valid-user-token");
        verify(userRepository, times(1)).findByUsername("normalUser");
    }

    // Test User Dashboard Access (Forbidden)
    @Test
    void testGetUserDashboard_AccessDenied() throws Exception {
        when(jwtService.extractUsername("valid-admin-token")).thenReturn("adminUser");
        when(userRepository.findByUsername("adminUser")).thenReturn(adminUser);

        mockMvc.perform(get("/api/user/dashboard")
                        .header(HttpHeaders.AUTHORIZATION, validAdminToken))
                .andExpect(status().isForbidden())
                .andExpect(jsonPath("$.title").value("Access Denied"));

        verify(jwtService, times(1)).extractUsername("valid-admin-token");
        verify(userRepository, times(1)).findByUsername("adminUser");
    }
}
