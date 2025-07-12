package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class PasswordResetOtpValidationDto {
    private String username;
    private Integer otp;
}
