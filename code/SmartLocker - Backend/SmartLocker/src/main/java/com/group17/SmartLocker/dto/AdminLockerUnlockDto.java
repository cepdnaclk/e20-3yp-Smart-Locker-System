package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class AdminLockerUnlockDto {
    private Long lockerId;
    private Long lockerClusterId;
    private String password;
}
