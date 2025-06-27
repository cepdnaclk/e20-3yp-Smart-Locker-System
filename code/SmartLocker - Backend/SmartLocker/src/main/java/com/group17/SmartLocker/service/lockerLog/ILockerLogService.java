package com.group17.SmartLocker.service.lockerLog;

import com.group17.SmartLocker.dto.LockerLogDto;
import com.group17.SmartLocker.model.LockerLog;

import java.util.List;

public interface ILockerLogService {
    List<LockerLogDto> getAllLockerLogs();

    LockerLog findActiveLog(String userId);

    LockerLog findActiveOrUnsafeLog(String userId);
}
