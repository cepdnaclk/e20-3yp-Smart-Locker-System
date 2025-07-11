package com.group17.SmartLocker.dto;

import com.group17.SmartLocker.enums.LockerLogStatus;
import lombok.Data;

import java.time.LocalDateTime;

@Data
public class LockerLogDto {

    private Long logId;
    private LocalDateTime accessTime;
    private LocalDateTime releasedTime;
    private LockerLogStatus status;
    private String location;
    private Long lockerId;
}
