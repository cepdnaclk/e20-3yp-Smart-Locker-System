package com.group17.SmartLocker.service.websocket;

import com.group17.SmartLocker.dto.LockerClusterDto;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class LockerAvailabilityNotifier {
    private final SimpMessagingTemplate messagingTemplate;

    public void notifyAvailability(Long clusterId, LockerClusterDto lockerClusterDto){
        messagingTemplate.convertAndSend("/topic/lockerAvailability/" + clusterId, lockerClusterDto);
    }
}
