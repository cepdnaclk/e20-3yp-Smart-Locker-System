package com.group17.SmartLocker.dto;


import com.group17.SmartLocker.enums.LockerStatus;
import com.group17.SmartLocker.model.LockerCluster;
import lombok.Data;


@Data
public class LockerDto {
    private Long displayNumber;
    private LockerStatus lockerStatus;
    private LockerCluster lockerCluster;
}
