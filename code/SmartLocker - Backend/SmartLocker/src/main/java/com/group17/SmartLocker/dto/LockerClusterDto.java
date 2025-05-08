package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class LockerClusterDto {
    private String clusterName;
    private String lockerClusterDescription;
    private int totalNumberOfLockers;
}
