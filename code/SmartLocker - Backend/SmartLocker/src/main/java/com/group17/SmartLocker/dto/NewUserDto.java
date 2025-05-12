package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class NewUserDto {

    private String regNo;
    private String firstName;
    private String lastName;
    private String contactNumber;
    private String email;
    private String password;
}
