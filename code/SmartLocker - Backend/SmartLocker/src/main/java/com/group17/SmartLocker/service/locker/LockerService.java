package com.group17.SmartLocker.service.locker;

import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.enums.LockerLogStatus;
import com.group17.SmartLocker.enums.LockerStatus;
import com.group17.SmartLocker.exception.LockerOccupiedException;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.Locker;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.repository.LockerClusterRepository;
import com.group17.SmartLocker.repository.LockerLogRepository;
import com.group17.SmartLocker.repository.LockerRepository;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.lockerLog.LockerLogService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@RequiredArgsConstructor
@Service
public class LockerService implements ILockerService{

    private final LockerLogService lockerLogService;
    private final LockerRepository lockerRepository;
    private final LockerLogRepository lockerLogRepository;
    private final UserRepository userRepository;
    private final LockerClusterRepository lockerClusterRepository;

    @Override
    public String unlockLocker(String username, Long clusterId) {

        // todo: Users should be allowed to use a preferred username
        String userId = username;

        List<Locker> availableLockers = lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
        LockerLog activeLog = lockerLogService.findActiveLog(userId);

        if(activeLog != null){
            activeLog.setStatus(LockerLogStatus.UNSAFE);
            // todo : after this, a mqtt request should be sent to the locker to unlock the locker
            // until the locker signals back to the backend that locker is closed, the lockerLogStatus should be unsafe
            activeLog.setReleasedTime(LocalDateTime.now());
            return "Locker Unlocked! Locker Number: " + activeLog.getLocker().getDisplayNumber();
        }
        else{

            if(availableLockers.isEmpty()){
                return "Sorry, No available lockers!";
            }

            Locker locker = availableLockers.get(0);
            LockerLog lockerLog = new LockerLog();

            lockerLog.setAccessTime(LocalDateTime.now());
            lockerLog.setStatus(LockerLogStatus.UNSAFE);
            // todo : after this, a mqtt request should be sent to the locker to unlock the locker
            // until the locker signals back to the backend that locker is closed, the lockerLogStatus should be occupied
            lockerLog.setLocker(locker);
            lockerLog.setUser(userRepository.findByUsername(userId));

            lockerLogRepository.save(lockerLog);

            return "Please use the locker with locker number: " + locker.getDisplayNumber();
        }
    }

    @Override
    public List<Locker> getAllLockers() {
        return lockerRepository.findAll();
    }

    @Override
    public List<Locker> getAllLockersByCluster(Long clusterId) {
        return lockerRepository.findByLockerClusterId(clusterId);
    }

    @Override
    public List<Locker> getAvailableLockersByCluster(Long clusterId) {
        return lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
    }

    @Override
    public List<Locker> getOccupiedLockersByCluster(Long clusterId) {
        return lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.OCCUPIED);
    }

    @Override
    public Locker addLockerToCluster(Long clusterId) {

        LockerCluster cluster = lockerClusterRepository.findById(clusterId)
                .orElseThrow(() -> new ResourceNotFoundException("Locker cluster not found with id : " + clusterId));

        // find the number of lockers in the locker cluster
        int lockerCount = lockerRepository.countByLockerClusterId(clusterId);

        Locker locker = new Locker();

        locker.setDisplayNumber(lockerCount + 1);
        locker.setLockerStatus(LockerStatus.AVAILABLE);
        locker.setLockerCluster(cluster);

        return lockerRepository.save(locker);

//        long lockerCount = (long) getAllLockersByCluster(clusterId).size();

//        int lockerCount = getAllLockersByCluster(clusterId)
//                .get(List::size)
//                .orElse(0);

//        long lockerCount = getAllLockersByCluster(clusterId)
//                .stream()
//                .flatMap(List::stream)
//                .count();


//        return Optional.of(lockerClusterRepository.findById(clusterId))
//                .isPresent(() -> {
//                    Locker locker = new Locker();
//                    LockerCluster Locker = lockerClusterRepository.findById(clusterId);
//                    long lockerCount =
//
//                    locker.setDisplayNumber(++lockerCount);
//                    locker.setLockerStatus(LockerStatus.AVAILABLE);
//                    locker.setLockerCluster();
//
//                    return lockerRepository.save(locker);
//                });
//
//
//        Optional<LockerCluster> lockerCluster = lockerClusterRepository.findById(clusterId);
//
//        try {
//            if(lockerCluster.isPresent()){
//
//            }
//        } catch (Exception e) {
//            return ;
//        }
//

    }

    @Override
    public Locker updateLockerDetails(Long lockerId, LockerDto locker) {

        Locker updateLocker = lockerRepository.findById(lockerId)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid locker id!"));

        if(updateLocker.getLockerStatus() == LockerStatus.OCCUPIED){
            throw new LockerOccupiedException("Unable to update locker details. Locker is occupied!");
        }
        updateLocker.setDisplayNumber(locker.getDisplayNumber());
        updateLocker.setLockerStatus(locker.getLockerStatus());
        updateLocker.setLockerCluster(locker.getLockerCluster());

        return lockerRepository.save(updateLocker);
    }

    @Override
    public void deleterLocker(Long lockerId) {

        Locker locker = lockerRepository.findById(lockerId)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid locker id"));
        lockerRepository.delete(locker);

    }


}
