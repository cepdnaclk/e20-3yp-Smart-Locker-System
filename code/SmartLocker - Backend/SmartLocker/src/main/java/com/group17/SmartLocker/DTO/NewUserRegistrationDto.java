package com.group17.SmartLocker.DTO;

import lombok.Data;

@Data
public class NewUserRegistrationDto {

    private String regNo;
    private String firstName;
    private String lastName;
    private String contactNumber;
    private String email;
    private String password;
}
