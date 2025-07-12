package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.dto.PasswordResetOtpValidationDto;
import com.group17.SmartLocker.dto.UpdatePasswordDto;
import com.group17.SmartLocker.exception.InvalidOtp;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.service.user.UserService;
import com.group17.SmartLocker.service.userOtp.UserOtpService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import static com.group17.SmartLocker.enums.OtpType.PASSWORD_RESET;
import static org.springframework.http.HttpStatus.INTERNAL_SERVER_ERROR;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/forgotPassword")
public class UserPasswordResetController {
    /*
    * When it comes to password reset there is no token
    * Therefore the endpoint should allow all users to select this option
    * not considering the option
    */

    private final UserOtpService userOtpService;
    private final UserService userService;

    @PostMapping("/generateOtpCode")
    public ResponseEntity<String> generateOtpCode(@RequestParam String identifier){

        /*
        * Generates the otp code for password reset
        * The otp code is valid for 30 minutes
        */

        try {
            userOtpService.generateOtp(identifier, PASSWORD_RESET);
            return ResponseEntity.ok("OTP Generated");
        } catch (Exception e) {
            return ResponseEntity.status(INTERNAL_SERVER_ERROR).build();
        }
    }

    @PostMapping("/validateOtpCode")
    public ResponseEntity<Object> validateOtpCode(@RequestBody PasswordResetOtpValidationDto otpValidationDto){

        /*
         * Generates the otp code for password reset
         * The otp code is valid for 5 minutes
         */

        try {
            return ResponseEntity.ok(userOtpService.validateOtp(otpValidationDto.getUsername(), otpValidationDto.getOtp(), PASSWORD_RESET));
        } catch (Exception e) {
            throw new InvalidOtp("Invalid Otp");
        }
    }

    @PostMapping("/updatePassword")
    public ResponseEntity<String> updatePassword(@RequestBody UpdatePasswordDto updatePasswordDto) {

        /*
        * UpdatePasswordDto
        * String usernameOrEmail : Username or the email of the user
        * String newPassword : New Password of the user
        * Integer otp : 4-digit code (sent via an email)
        */

        try {
            String identifier = updatePasswordDto.getUsernameOrEmail();
            if (userOtpService.validateOtp(
                    identifier,
                    updatePasswordDto.getOtp(),
                    PASSWORD_RESET)){


                userService.updatePasswordByUsernameOrEmail(
                        updatePasswordDto.getUsernameOrEmail(),
                        updatePasswordDto.getNewPassword());

                return ResponseEntity.ok("Password updated successfully.");
            }
            else{
                throw new InvalidOtp("Invalid OTP code");
            }

        } catch (ResourceNotFoundException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to update password.");
        }
    }

}
