package com.group17.SmartLocker.dto;


import com.group17.SmartLocker.enums.LockerStatus;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.model.LockerLog;
import lombok.Data;

import java.util.List;


@Data
public class LockerDto {

    private Long lockerId;
    private int displayNumber;
    private LockerStatus lockerStatus;
    private List<LockerLog> lockerLogs;
    private LockerCluster lockerCluster;
}
