//package com.group17.SmartLocker.service;
//
//import com.group17.SmartLocker.model.Locker;
//import com.group17.SmartLocker.model.LockerLog;
//import com.group17.SmartLocker.model.User;
//import com.group17.SmartLocker.repository.LockerLogRepository;
//import com.group17.SmartLocker.repository.LockerRepository;
//import com.group17.SmartLocker.repository.UserRepository;
//import org.springframework.stereotype.Service;
//import org.springframework.web.client.RestTemplate;
//
//import java.time.LocalDateTime;
//import java.util.Optional;
//
//@Service
//public class LockerService {
//
//    private final LockerRepository lockerRepository;
//    private final LockerLogRepository lockerLogRepository;
//    private final UserRepository userRepository;
//    private final RestTemplate restTemplate;
//
//    public LockerService(LockerRepository lockerRepository, LockerLogRepository lockerLogRepository,
//                         UserRepository userRepository, RestTemplate restTemplate) {
//        this.lockerRepository = lockerRepository;
//        this.lockerLogRepository = lockerLogRepository;
//        this.userRepository = userRepository;
//        this.restTemplate = restTemplate;
//    }
//
//    public String unlockLocker(Long lockerId, String userId) {
//        Optional<User> userOpt = userRepository.findById(userId);
//        Optional<Locker> lockerOpt = lockerRepository.findById(lockerId);
//
//        if (userOpt.isEmpty() || lockerOpt.isEmpty()) {
//            return "User or Locker not found";
//        }
//
//        Locker locker = lockerOpt.get();
//        if (!locker.isAvailable()) {
//            return "Locker is currently in use";
//        }
//
//        // Mark locker as in use
//        locker.setAvailable(false);
//        lockerRepository.save(locker);
//
//        // Log the access
//        LockerLog log = new LockerLog();
//        log.setLocker(locker);
//        log.setUser(userOpt.get());
//        log.setAccessTime(LocalDateTime.now());
//        lockerLogRepository.save(log);
//
//        // Send request to ESP32 to unlock locker
//        String espUrl = "http://esp32-ip-address/unlock?lockerId=" + lockerId;
//        String espResponse = restTemplate.getForObject(espUrl, String.class);
//
//        return espResponse.equals("SUCCESS") ? "Locker unlocked successfully" : "Failed to unlock locker";
//    }
//}
