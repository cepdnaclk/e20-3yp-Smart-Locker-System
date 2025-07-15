package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.enums.LockerLogStatus;
import com.group17.SmartLocker.model.LockerLog;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LockerLogRepository extends JpaRepository<LockerLog, Long> {
    List<LockerLog> findByUserIdAndStatus(String userId, LockerLogStatus status);

    LockerLog findByLocker_LockerIdAndStatus(Long lockerId, LockerLogStatus status);

}
