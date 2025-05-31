package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.model.Locker;

import java.util.List;

public interface ILockerService {
//    String unlockLocker(String username, Long clusterId);

    void assignLocker(String username, Long clusterId);

    String accessLocker(String username, String source);

    String unassignLocker(String username, String source);

    List<LockerDto> getAllLockers();

    List<LockerDto> getAllLockersByCluster(Long clusterId);

    List<Locker> getAvailableLockersByCluster(Long clusterId);

    List<Locker> getOccupiedLockersByCluster(Long clusterId);

    Locker addLockerToCluster(Long clusterId);

    Locker updateLockerDetails(Long lockerId, Locker locker);

    void deleterLocker(Long lockerId);

}
