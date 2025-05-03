package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.enums.LockerLogStatus;
import com.group17.SmartLocker.enums.LockerStatus;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.Locker;
import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.repository.LockerLogRepository;
import com.group17.SmartLocker.repository.LockerRepository;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.lockerLog.LockerLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class LockerService implements ILockerService{

    private final LockerLogService lockerLogService;
    private final LockerRepository lockerRepository;
    private final LockerLogRepository lockerLogRepository;
    private final UserRepository userRepository;

    @Override
    public String unlockLocker(String username, Long clusterId) {

        // todo: Users should be allowed to use a preferred username
        String userId = username;

        Optional<List<Locker>> availableLockers = getAvailableLockers(clusterId);
        LockerLog activeLog = lockerLogService.findActiveLog(userId);

        if(activeLog != null){
            activeLog.setStatus(LockerLogStatus.UNSAFE);
            // todo : after this, a mqtt request should be sent to the locker to unlock the locker
            // until the locker signals back to the backend that locker is closed, the lockerLogStatus should be unsafe
            activeLog.setReleasedTime(LocalDateTime.now());
            return "Locker Unlocked! Locker Number: " + activeLog.getLocker().getDisplayNumber();
        }
        else{
            List<Locker> lockers = availableLockers.
                    orElseThrow(() -> new ResourceNotFoundException("Sorry!, No lockers available"));

            Locker locker = lockers.get(0);
            LockerLog lockerLog = new LockerLog();

            lockerLog.setAccessTime(LocalDateTime.now());
            lockerLog.setStatus(LockerLogStatus.UNSAFE);
            // todo : after this, a mqtt request should be sent to the locker to unlock the locker
            // until the locker signals back to the backend that locker is closed, the lockerLogStatus should be unsafe
            lockerLog.setLocker(locker);
            lockerLog.setUser(userRepository.findByUsername(userId));

            lockerLogRepository.save(lockerLog);

            return "Please use the locker with locker number: " + locker.getDisplayNumber();
        }
    }

    @Override
    public Optional<List<Locker>> getAvailableLockers(Long clusterId){
        List<Locker> availableLockers = lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
        return availableLockers.isEmpty() ? Optional.empty() : Optional.of(availableLockers);
    }
}
