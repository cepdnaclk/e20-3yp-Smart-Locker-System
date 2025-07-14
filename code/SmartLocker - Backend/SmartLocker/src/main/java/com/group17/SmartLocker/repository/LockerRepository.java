package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.enums.LockerStatus;
import com.group17.SmartLocker.model.Locker;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LockerRepository extends JpaRepository<Locker, Long> {

    List<Locker> findByLockerClusterIdAndLockerStatus(Long clusterId, LockerStatus status);

    List<Locker> findByLockerClusterId(Long clusterId);

    int countByLockerClusterId(Long clusterId);

    List<Locker> findByLockerStatus(LockerStatus status);

}
