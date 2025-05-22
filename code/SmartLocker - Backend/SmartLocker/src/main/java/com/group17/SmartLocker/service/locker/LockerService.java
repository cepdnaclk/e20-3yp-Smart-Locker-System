package com.group17.SmartLocker.service.locker;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
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
import com.group17.SmartLocker.service.mqtt.MessageHandler;
import com.group17.SmartLocker.service.mqtt.MqttPublisher;
import com.group17.SmartLocker.service.mqtt.MqttSubscriber;
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


//    @Override
//    public String unlockLocker(String username, Long clusterId) {
//
//        // todo: Users should be allowed to use a preferred username
//        String userId = username;
//
//        List<Locker> availableLockers = lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
//        LockerLog activeLog = lockerLogService.findActiveLog(userId);
//
//        if(activeLog != null ){
//
//            // send Mqtt message to unlock (Unlocking the occupied locker)
//            sendMqttMessageToLockerUnlock(clusterId, Math.toIntExact(activeLog.getLocker().getLockerId()), "1");
//
//            /*
//             * Should check the locker status and update the locker log details
//             * If the locker is not closed locker log status should be in UNSAFE status
//             * UNSAFE : should send a notification to the user to close the locker properly
//             */
//
//            /*
//             * If the user finishes the service from the locker
//             * This should be inside an if else statement
//             * Because the locker status should be checked
//             */
//            activeLog.setStatus(LockerLogStatus.OLD);
//            try {
//                activeLog.setReleasedTime(LocalDateTime.now());
//                activeLog.getLocker().setLockerStatus(LockerStatus.AVAILABLE); // change locker status
//            } catch (Exception e) {
//                throw new RuntimeException(e);
//            }
//
//            lockerLogRepository.save(activeLog);
//            lockerRepository.save(activeLog.getLocker());
//            return "Locker Unlocked! Locker Number: " + activeLog.getLocker().getDisplayNumber();
//        }
//        else{
//
//            if(availableLockers.isEmpty()){
//                return "Sorry, No available lockers!";
//            }
//
//            Locker locker = availableLockers.get(0);
//            LockerLog lockerLog = new LockerLog();
//
//            // send Mqtt message to unlock (Unlocking a new existing locker
//            sendMqttMessageToLockerUnlock(clusterId, Math.toIntExact(locker.getLockerId()), "0");
//
//            // change lockerlog status
//            lockerLog.setAccessTime(LocalDateTime.now());
//            lockerLog.setStatus(LockerLogStatus.ACTIVE);
//
//
//            lockerLog.setLocker(locker);
//            locker.setLockerStatus(LockerStatus.OCCUPIED);
//            lockerRepository.save(locker);
//
//            lockerLog.setUser(userRepository.findByUsername(userId));
//            lockerLogRepository.save(lockerLog);
//
//            return "Please use the locker with locker number: " + locker.getDisplayNumber();
//        }
//    }
//

    /*
     * A helper method to the unlock locker function
     * Publish mqtt messages for given clusterId, lockerId and already assign state
     */
    public void sendMqttMessageToLockerUnlock(Long clusterId, Long lockerId, String alreadyAssign){
        // publish the unlock Mqtt request message

        //create the message payload
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode payload = mapper.createObjectNode();

        payload.put("clusterID", clusterId.toString());
        payload.put("lockerID", lockerId.toString());
        payload.put("alreadyAssign", alreadyAssign);

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
    }

    /*
     * A helper method to the check the locker status, (properly closed or not)
     * Publish mqtt messages for a specific topic
     */
    public void sendMqttMessageToCheckLockerStatus(Long clusterId, Long lockerId ){
        // publish the unlock Mqtt request message

        System.out.println("📡 Publishing locker status check for: Cluster " + clusterId + ", Locker " + lockerId);

        //create the message payload
        ObjectMapper mapper = new ObjectMapper();
        ObjectNode payload = mapper.createObjectNode();

        payload.put("clusterId", clusterId.toString());
        payload.put("lockerId", lockerId.toString());

        String message = null;
        try {
            message = mapper.writeValueAsString(payload);
        } catch (JsonProcessingException e) {
            throw new RuntimeException(e);
        }

        // send the Mqtt message
        try {
            System.out.println("message sent to esp32/checkLockerStatus");
            mqttPublisher.publish("esp32/checkLockerStatus", message);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public String assignLocker(String username, Long clusterId){

        String userId = username;

        List<Locker> availableLockers = lockerRepository.findByLockerClusterIdAndLockerStatus(clusterId, LockerStatus.AVAILABLE);
        LockerLog activeOrUnsafeLog = lockerLogService.findActiveOrUnsafeLog(userId);

        if(activeOrUnsafeLog == null){
            /*
            * There should not have any active logs when user come to assign a locker
            */

            System.out.println("⚡ assignLocker() invoked");

            if(availableLockers.isEmpty()){
                return "Sorry, No available lockers!";
            }

            Locker locker = availableLockers.get(0); // find an available locker
            Long lockerId = locker.getLockerId();
            LockerLog lockerLog = new LockerLog(); // create a locker log

            // send Mqtt message to unlock (Unlocking a new existing locker)
            sendMqttMessageToLockerUnlock(clusterId, locker.getLockerId(), "0");

            // change locker log status
            lockerLog.setAccessTime(LocalDateTime.now());
            lockerLog.setStatus(LockerLogStatus.UNSAFE);
            lockerLog.setLocker(locker);

            locker.setLockerStatus(LockerStatus.OCCUPIED);
            lockerRepository.save(locker);
            lockerLog.setUser(userRepository.findByUsername(userId));
            lockerLogRepository.save(lockerLog);


            // Delay execution for 1.5 minutes
            try {
                Thread.sleep(1000); // 90000 milliseconds = 1.5 minutes
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt(); // good practice
                System.err.println("Thread was interrupted");
            }

            System.out.println("✅ After sleep, sending locker status request...");

            // asking for the locker status
            sendMqttMessageToCheckLockerStatus(clusterId, lockerId);

            // Todo: make this to send as notifications
            return "Please use the locker with locker number: " + locker.getDisplayNumber(); // change this accordingly
        }
        else{
            // Todo: make this to send notification
            System.out.println("You have already used a locker.");
            return "You have already used a locker.";
        }


    }

    @Override
    public String accessLocker(String username){

        String userId = username;
        LockerLog activeLog = lockerLogService.findActiveLog(userId); // find the active log
        Long clusterId = activeLog.getLocker().getLockerCluster().getId();

        if(activeLog != null){
            Locker locker = activeLog.getLocker();
            Long lockerId = locker.getLockerId();

            // change locker log details
            activeLog.setStatus(LockerLogStatus.UNSAFE);
            lockerLogRepository.save(activeLog);

            // send Mqtt message to unlock (Unlocking the assigned locker)
            sendMqttMessageToLockerUnlock(clusterId, lockerId, "1");

            // Delay execution for 1.5 minutes
            try {
                Thread.sleep(1000); // 90000 milliseconds = 1.5 minutes
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                System.err.println("Thread was interrupted");
            }

            // asking for the locker status
            System.out.println("sendMqttMessageToCheckLockerStatus method invoking");
            sendMqttMessageToCheckLockerStatus(clusterId, lockerId);

            // Todo: make this to send as notifications
            return "Locker unlocked, Use the your locker with locker number: " + locker.getDisplayNumber();
        }
        else{
            // Todo: make this to send as notifications
            return "You have not assigned to a locker!";
        }

    }

    @Override
    public String unassignLocker(String username){

         System.out.println("unassign locker");

         String userId = username;

         LockerLog activeLog = lockerLogService.findActiveLog(userId); // find the active log
         Long clusterId = activeLog.getLocker().getLockerCluster().getId();

         if(activeLog != null){

             Locker locker = activeLog.getLocker();
             Long lockerId = locker.getLockerId();

             // change locker log details
             activeLog.setStatus(LockerLogStatus.UNSAFE);
             activeLog.setReleasedTime(LocalDateTime.now());
             lockerLogRepository.save(activeLog);

             // send Mqtt message to unlock (Unlocking the assigned locker)
             sendMqttMessageToLockerUnlock(clusterId, lockerId, "1");

             // Delay execution for 1.5 minutes
             try {
                 Thread.sleep(1000); // 90000 milliseconds = 1.5 minutes
             } catch (InterruptedException e) {
                 Thread.currentThread().interrupt();
                 System.err.println("Thread was interrupted");
             }

             // asking for the locker status
             sendMqttMessageToCheckLockerStatus(clusterId, lockerId);

             return "Locker unlocked, Use the your locker with locker number: " + locker.getDisplayNumber();
         }
         else{
             return "You have not any lockers assigned!";
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


    // handling locker status messages coming from the esp32
    public void lockerStatusHandle(String message){

        Long clusterId = null;
        Long lockerId = null;
        Integer status = null;

        // extract fields from the incoming Mqtt message
        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(message);
            clusterId = Long.parseLong(root.get("clusterId").asText());  // spelling preserved as is
            lockerId = Long.parseLong(root.get("lockerId").asText());
            status = Integer.parseInt(root.get("status").asText());

        } catch (Exception e) {
            System.err.println("Failed to parse MQTT message: " + e.getMessage());
        }

        // Find the locker log of the locker which is unsafe
        LockerLog lockerLog = lockerLogRepository.findByLocker_LockerIdAndStatus(lockerId, LockerLogStatus.UNSAFE);

        /*
        * Event : User selected the unassign option
        */
        if(lockerLog.getReleasedTime() != null){

            if(status == null){
                System.out.println("Error : Status is null.");
            }
            else if(status == 0){
                /*
                * Event :  User properly remove his belongings from the locker
                */
                lockerLog.setStatus(LockerLogStatus.OLD);
                Locker locker = lockerLog.getLocker();
                locker.setLockerStatus(LockerStatus.AVAILABLE);

                lockerLogRepository.save(lockerLog);
                lockerRepository.save(locker);
            }
            else if (status == 3) {
                /*
                * Event : User did not remove all the belongings from the locker or
                * locker is not properly closed after using
                */
                lockerLog.setStatus(LockerLogStatus.OLD);
                Locker locker = lockerLog.getLocker();
                locker.setLockerStatus(LockerStatus.BLOCKED);

                lockerLogRepository.save(lockerLog);
                lockerRepository.save(locker);

                // Todo : notification should be sent informing this
            }
            else{
                System.out.println("Unidentified locker status");
            }
        }

        /*
        * Event : User selected the assign option or access option
        */
        else{
            if(status == null){
                System.out.println("Error : Status is null.");
            }
            else if(status == 1){
                /*
                * Event : User has not properly closed the locker
                */
                // Todo: send another request to check the locker status
                // Again check the locker status
                // Delay execution for 0.5 minutes
                try {
                    Thread.sleep(30000); // 90000 milliseconds = 0.5 minutes
                } catch (InterruptedException e) {
                    Thread.currentThread().interrupt();
                    System.err.println("Thread was interrupted");
                }

                // asking for the locker status
                sendMqttMessageToCheckLockerStatus(clusterId, lockerId);

                // Todo: Notify the user
            }
            else if(status == 2){
                /*
                * Event : User has properly closed the locker
                */

                lockerLog.setStatus(LockerLogStatus.ACTIVE);
                lockerLogRepository.save(lockerLog);

                // Todo: Notify the user
            }
            else{
                System.out.println("Unidentified locker status");
            }
        }

    }
}
