package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.config.JwtUtil;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;
import com.group17.SmartLocker.DTO.AuthRequest;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/auth")
public class AuthController{

    private final AuthenticationManager authenticationManager;
    private final JwtUtil jwtUtil;
//    private final UserRepository userRepository;
//    private final PasswordEncoder passwordEncoder;

    public AuthController(AuthenticationManager authenticationManager, JwtUtil jwtUtil) {
        this.authenticationManager = authenticationManager;
        this.jwtUtil = jwtUtil;
    }

//    @GetMapping("/login")
//    public ResponseEntity<String> login() {
//        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
//
//        if (authentication.isAuthenticated()) {
//            UserPrincipal userPrincipal = (UserPrincipal) authentication.getPrincipal();
//            return ResponseEntity.ok("Login successful for user: " + userPrincipal.getUsername());
//        }
//        return ResponseEntity.status(401).body("Login failed");
//    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthRequest request) {
        Authentication authentication;
        try {
            authentication = authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getUsername(), request.getPassword())
            );
        } catch (Exception e) {
            return ResponseEntity.status(401).body("Authentication failed: " + e.getMessage());
        }

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String jwt = jwtUtil.generateToken(userDetails);

        Map<String, String> response = new HashMap<>();
        response.put("token", jwt);

        return ResponseEntity.ok(jwt);
    }

}
