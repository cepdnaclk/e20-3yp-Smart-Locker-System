package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class UpdatePasswordDto {
    private String usernameOrEmail;
    private String newPassword;
    private Integer otp;
}

