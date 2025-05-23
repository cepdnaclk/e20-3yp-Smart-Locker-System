package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.model.Locker;

import java.util.List;

public interface ILockerService {
//    String unlockLocker(String username, Long clusterId);

    String assignLocker(String username, Long clusterId);

    String accessLocker(String username);

    String unassignLocker(String username);

    List<Locker> getAllLockers();

    List<Locker> getAllLockersByCluster(Long clusterId);

    List<Locker> getAvailableLockersByCluster(Long clusterId);

    List<Locker> getOccupiedLockersByCluster(Long clusterId);

    Locker addLockerToCluster(Long clusterId);

    Locker updateLockerDetails(Long lockerId, LockerDto locker);

    void deleterLocker(Long lockerId);

}
