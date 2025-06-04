package com.group17.SmartLocker.dto;

import lombok.Data;

@Data
public class LockerClusterDto {

    private Long id;
    private String clusterName;
    private String lockerClusterDescription;
    private int totalNumberOfLockers;
    private int availableNumberOfLockers;

    private double latitude;
    private double longitude;
}
