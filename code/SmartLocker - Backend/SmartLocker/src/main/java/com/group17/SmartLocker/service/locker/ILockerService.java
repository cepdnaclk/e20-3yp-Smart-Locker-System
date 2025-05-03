package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.model.Locker;

import java.util.List;
import java.util.Optional;

public interface ILockerService {
    String unlockLocker(String username, Long clusterId);
    Optional<List<Locker>> getAvailableLockers(Long clusterId);

}
