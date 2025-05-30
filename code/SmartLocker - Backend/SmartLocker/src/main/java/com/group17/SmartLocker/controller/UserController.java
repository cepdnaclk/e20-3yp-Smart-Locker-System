package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.dto.LockerLogDto;
import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.lockerCluster.LockerClusterService;
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
    private final LockerClusterService lockerClusterService;

//    //todo: Implement the api end point to unlock the locker
//    // send cluster id and the token to the service layer
//    @GetMapping("/unlockLocker")
//    public ResponseEntity<ApiResponse> unlockLocker(HttpServletRequest request, @RequestParam Long clusterId){
//
//        String jwtToken = "";
//        // Extract token from the http request. No need to check the token in null.
//        // There should be a token to access this endpoint ?
//        String authHeader = request.getHeader("Authorization");
//        if (authHeader != null && authHeader.startsWith("Bearer ")) {
//            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
//        }
//
//        try {
//            String message = lockerService.unlockLocker(jwtService.extractUsername(jwtToken), clusterId);
//            return ResponseEntity.ok(new ApiResponse("Success", message));
//        } catch (Exception e) {
//            return ResponseEntity.status(INTERNAL_SERVER_ERROR).body(new ApiResponse(e.getMessage(), null));
//        }
//
//    }


    // access the assigned locker
    @GetMapping("/accessLocker")
    public ResponseEntity<String> accessLocker(HttpServletRequest request){
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String username = jwtService.extractUsername(jwtToken);
            return ResponseEntity.ok(lockerService.accessLocker(username, "1"));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }


    // unassign the assigned locker
    @GetMapping("/unassign")
    public ResponseEntity<String> unassignLocker(HttpServletRequest request){
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            String username = jwtService.extractUsername(jwtToken);
            return ResponseEntity.ok(lockerService.unassignLocker(username, "1"));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
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
    public ResponseEntity<List<LockerLogDto>> getUserLogs(HttpServletRequest request){

        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.getLockerLogs(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/lockerAvailability/{clusterId}")
    public ResponseEntity<LockerClusterDto> getLockerClusterDetails(@PathVariable Long clusterId){
        try {
            LockerCluster lockerCluster = lockerClusterService.getLockerClusterById(clusterId);

            LockerClusterDto lockerClusterDto = new LockerClusterDto();

            lockerClusterDto.setClusterName(lockerCluster.getClusterName());
            lockerClusterDto.setLockerClusterDescription(lockerCluster.getLockerClusterDescription());
            lockerClusterDto.setTotalNumberOfLockers(lockerCluster.getTotalNumberOfLockers());
            lockerClusterDto.setAvailableNumberOfLockers(lockerCluster.getAvailableNumberOfLockers());

            return ResponseEntity.ok(lockerClusterDto);
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/getOtpCode")
    public ResponseEntity<String> getOtpCode(HttpServletRequest request){
        // find the username to get the otp code
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.getOtpCode(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/generateNewOtpCode")
    public ResponseEntity<String> generateNewOtpCode(HttpServletRequest request){
        // find the username to get the otp code
        String jwtToken = "";
        // Extract token from the http request. No need to check the token in null.
        // There should be a token to access this endpoint ?
        String authHeader = request.getHeader("Authorization");
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwtToken = authHeader.substring(7); // Remove "Bearer " prefix
        }

        try {
            return ResponseEntity.ok(userService.generateOtpCodeManually(jwtService.extractUsername(jwtToken)));
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

}
