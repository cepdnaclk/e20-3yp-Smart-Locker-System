package com.group17.SmartLocker.dto;

import com.group17.SmartLocker.model.LockerLog;
import lombok.Data;

import java.util.List;

@Data
public class UserDetailsDto {

    private String firstName;
    private String lastName;
    private String contactNumber;
    private String email;
    private List<LockerLog> lockerLogs;
}
