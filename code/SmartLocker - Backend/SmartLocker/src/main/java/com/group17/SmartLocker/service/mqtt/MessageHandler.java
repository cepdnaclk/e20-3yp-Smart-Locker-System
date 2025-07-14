package com.group17.SmartLocker.service.mqtt;

import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.user.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class MessageHandler {

    private final UserService userService;
    private final LockerService lockerService;

    public void handleIncomingMessage(String topic, String message) {
        // Implement your business logic here
        System.out.println(" ");
        System.out.println("🚀 Handling message in service: " + message + " from topic: " + topic);

        // get the otp code from the database
        if (topic.equals("esp32/getPassword")) {
            userService.sendOtpCode(message);
        }

        // save fingerprint id to the database
        if(topic.equals("esp32/assignFingerprint")){
            userService.saveFingerPrint(message);
        }

        // unlock a locker using fingerprint
        if(topic.equals("esp32/unlockFingerprint")){
            userService.unlockLockerUsingFingerprint(message);
        }

        // handle the locker status check
        if(topic.equals("esp32/lockerStatus")){
            lockerService.lockerStatusHandle(message);
        }
    }

}

