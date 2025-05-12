package com.group17.SmartLocker.service.lockerLog;

;
import com.group17.SmartLocker.model.LockerLog;

public interface ILockerLogService {
    LockerLog findActiveLog(String userId);
}
