package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.DashboardResponse;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.JwtService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class DashboardController {

    private final JwtService jwtService;
    private final UserRepository userRepository;

    public DashboardController(JwtService jwtService, UserRepository userRepository) {
        this.jwtService = jwtService;
        this.userRepository = userRepository;
    }

    /**
     * Admin Dashboard API
     * Accessible only by users with the "ADMIN" role.
     */
    @GetMapping("/admin/dashboard")
    public ResponseEntity<DashboardResponse> getAdminDashboard(@RequestHeader("Authorization") String token) {
        // Extract username from JWT
        token = token.substring(7);
        String username = jwtService.extractUsername(token);

        // Fetch user details
        User user = userRepository.findByUsername(username);
        if (user == null || !user.getRole().name().equals("ADMIN")) {
            return ResponseEntity.status(403).body(new DashboardResponse("Access Denied", "You are not authorized!"));
        }

        // Admin-specific response
        DashboardResponse response = new DashboardResponse(
                "Admin Dashboard",
                "Welcome, " + user.getFirstName()
        );
        return ResponseEntity.ok(response);
    }

    /**
     * User Dashboard API
     * Accessible only by users with the "USER" role.
     */
    @GetMapping("/user/dashboard")
    public ResponseEntity<DashboardResponse> getUserDashboard(@RequestHeader("Authorization") String token) {
        // Extract username from JWT
        token = token.substring(7);
        String username = jwtService.extractUsername(token);

        // Fetch user details
        User user = userRepository.findByUsername(username);
        if (user == null || !user.getRole().name().equals("USER")) {
            return ResponseEntity.status(403).body(new DashboardResponse("Access Denied", "You are not authorized!"));
        }

        // User-specific response
        DashboardResponse response = new DashboardResponse(
                "User Dashboard",
                "Welcome! " + user.getFirstName()
        );
        return ResponseEntity.ok(response);
    }
}
