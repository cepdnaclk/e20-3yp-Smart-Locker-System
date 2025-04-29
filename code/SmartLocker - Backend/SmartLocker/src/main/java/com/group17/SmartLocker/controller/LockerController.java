//package com.group17.SmartLocker.controller;
//
//import com.group17.SmartLocker.service.MqttPublisherService;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.web.bind.annotation.*;
//
//@RestController
//@RequestMapping("/api/locker")
//public class LockerController {
//
//    @Autowired
//    private MqttPublisherService mqttPublisherService;
//
//    @PostMapping("/unlock/{lockerId}")
//    public String unlockLocker(@PathVariable String lockerId) {
//        try {
//            mqttPublisherService.publishMessage(lockerId);
//            return "Unlock signal sent for locker: " + lockerId;
//        } catch (Exception e) {
//            return "Error: " + e.getMessage();
//        }
//    }
//}
//
//
////package com.group17.SmartLocker.controller;
////
////import com.group17.SmartLocker.service.LockerService;
////import org.springframework.http.ResponseEntity;
////import org.springframework.web.bind.annotation.*;
////
////@RestController
////@RequestMapping("/api/locker")
////public class LockerController {
////
////    private final LockerService lockerService;
////
////    public LockerController(LockerService lockerService) {
////        this.lockerService = lockerService;
////    }
////
////    @PostMapping("/unlock")
////    public ResponseEntity<String> unlockLocker(@RequestParam Long lockerId, @RequestParam String userId) {
////        String response = lockerService.unlockLocker(lockerId, userId);
////        return ResponseEntity.ok(response);
////    }
////}
