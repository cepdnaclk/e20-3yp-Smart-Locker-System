package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repsponse.ApiResponse;
import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.user.UserService;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;


import java.util.List;
import java.util.Map;

import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/user")
public class UserController {

    private final UserService userService;
    private final JwtService jwtService;
    private final LockerService lockerService;

    //todo: Implement the api end point to unlock the locker
    // send cluster id and the token to the service layer
    @GetMapping("/unlockLocker")
    public ResponseEntity<ApiResponse> unlockLocker(HttpServletRequest request, @RequestParam Long clusterId){

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String message = lockerService.unlockLocker(jwtService.extractUsername(jwtToken), clusterId);
            return ResponseEntity.ok(new ApiResponse("Success", message));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body(new ApiResponse(e.getMessage(), null));
        }

    }

    // to view users their user details
    @GetMapping("/profile")
    public ResponseEntity<UserDetailsDto> getUserById(HttpServletRequest request){

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            UserDetailsDto user = userService.getUserById(jwtService.extractUsername(jwtToken));
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }


    // to edit own details of the user
    @PatchMapping("/editProfile")
    public ResponseEntity<User> patchUser(HttpServletRequest request, @RequestBody Map<String, Object> updates) {

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String id = userService.getUserIdByUsername(jwtService.extractUsername(jwtToken));
            User user = userService.editUserDetails(id, updates);
            return ResponseEntity.ok(user);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/logs")
    public ResponseEntity<List<LockerLog>> getUserLogs(HttpServletRequest request){

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            UserDetailsDto user = userService.getUserById(jwtService.extractUsername(jwtToken));
            return ResponseEntity.ok(user.getLockerLogs());
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

}
