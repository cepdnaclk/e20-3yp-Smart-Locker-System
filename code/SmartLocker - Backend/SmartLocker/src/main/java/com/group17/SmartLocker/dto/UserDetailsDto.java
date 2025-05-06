package com.group17.SmartLocker.dto;

import com.group17.SmartLocker.model.LockerLog;
import lombok.Data;

import java.util.List;

@Data
public class UserDetailsDto {

    private String id;
    private String username;
    private String firstName;
    private String lastName;
    private String contactNumber;
    private String email;
    private boolean fingerPrintExists; // This is to check the user is using the fingerprint or not
    private List<LockerLog> lockerLogs;
}
