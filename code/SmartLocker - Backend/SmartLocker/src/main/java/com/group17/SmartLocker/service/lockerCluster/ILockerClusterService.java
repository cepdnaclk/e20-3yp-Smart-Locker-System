package com.group17.SmartLocker.service.lockerCluster;

import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.model.LockerCluster;

import java.util.List;

public interface ILockerClusterService {

    LockerCluster addLockerCluster(LockerClusterDto lockerCluster);

    LockerCluster getLockerClusterById(Long clusterId);

    List<LockerClusterDto> getAllLockerClusters();

    LockerCluster updateLockerCluster(Long lockerClusterId, LockerClusterDto lockerCluster);

    void deleteLockerClusterById(Long lockerClusterId);
}
