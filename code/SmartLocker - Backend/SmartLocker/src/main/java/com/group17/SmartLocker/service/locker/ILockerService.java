package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.model.Locker;

import java.util.List;
import java.util.Optional;

public interface ILockerService {
    String unlockLocker(String username, Long clusterId);

    Optional<List<Locker>> getAllLockers();

    Optional<List<Locker>> getAllLockersByCluster(Long clusterId);

    Optional<List<Locker>> getAvailableLockersByCluster(Long clusterId);

    Optional<List<Locker>> getOccupiedLockersByCluster(Long clusterId);

    Locker addLockerToCluster(LockerDto locker, Long clusterId);

    Locker updateLockerDetails(Long lockerID, LockerDto locker);

    Locker deleterLocker(Long lockerId);

}
