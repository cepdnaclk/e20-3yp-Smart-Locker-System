package com.group17.SmartLocker.service.locker;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
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
import com.group17.SmartLocker.service.mqtt.MqttPublisher;
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
    private final MqttPublisher mqttPublisher;

    @Override
    public String unlockLocker(String username, Long clusterId) {

        // todo: Users should be allowed to use a preferred username
        String userId = username;

        List<Locker> availableLockers = lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
        LockerLog activeLog = lockerLogService.findActiveLog(userId);

        if(activeLog != null ){

            // publish the unlock request

            //create the message payload
            ObjectMapper mapper = new ObjectMapper();
            ObjectNode payload = mapper.createObjectNode();

            String lockerId = activeLog.getLocker().getLockerId().toString();

            payload.put("clusterID", clusterId.toString());
            payload.put("lockerID", lockerId);
            payload.put("alreadyAssign", "1");

            String message = null;
            try {
                message = mapper.writeValueAsString(payload);
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            // send the Mqtt message
            try {
                mqttPublisher.publish("esp32/unlock", message);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
            
            /*
            * Should check the locker status and update the locker log details
            * If the locker is not closed locker log status should be in UNSAFE status
            * UNSAFE : should send a notification to the user to close the locker properly
            */

            /*
            * If the user finishes the service from the locker
            * This should be inside an if else statement
            * Because the locker status should be checked
            */
            activeLog.setStatus(LockerLogStatus.OLD);
            try {
                activeLog.setReleasedTime(LocalDateTime.now());
                activeLog.getLocker().setLockerStatus(LockerStatus.AVAILABLE); // change locker status
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            lockerLogRepository.save(activeLog);
            lockerRepository.save(activeLog.getLocker());
            return "Locker Unlocked! Locker Number: " + activeLog.getLocker().getDisplayNumber();
        }
        else{

            if(availableLockers.isEmpty()){
                return "Sorry, No available lockers!";
            }

            Locker locker = availableLockers.get(0);
            LockerLog lockerLog = new LockerLog();

            // publish the unlock request
            ObjectMapper mapper = new ObjectMapper();
            ObjectNode payload = mapper.createObjectNode();

            String lockerId = locker.getLockerId().toString();

            payload.put("clusterID", clusterId.toString());
            payload.put("lockerID", lockerId);
            payload.put("alreadyAssign", "0");

            // Create the message payload
            String message = null;
            try {
                message = mapper.writeValueAsString(payload);
            } catch (JsonProcessingException e) {
                throw new RuntimeException(e);
            }
            try {
                mqttPublisher.publish("esp32/unlock", message);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }

            // change lockerlog status
            lockerLog.setAccessTime(LocalDateTime.now());
            lockerLog.setStatus(LockerLogStatus.ACTIVE);


            lockerLog.setLocker(locker);
            locker.setLockerStatus(LockerStatus.OCCUPIED);
            lockerRepository.save(locker);

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

    // Todo: change this function to add multiple lockers to a cluster once
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
