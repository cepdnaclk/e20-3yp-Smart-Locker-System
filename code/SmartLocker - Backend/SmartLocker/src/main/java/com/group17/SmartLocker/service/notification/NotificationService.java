package com.group17.SmartLocker.service.notification;

import com.group17.SmartLocker.model.Notification;
import com.group17.SmartLocker.repository.NotificationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.MessagingException;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final NotificationRepository notificationRepository;
    private final SimpMessagingTemplate messagingTemplate;

    public void sendAndSave(String userId, String title, String message, String type) {

        /*
        * This method is to create a notification and send it via websocket and
        * save it in the repository
        */

        try {
            Notification notification = new Notification();
            notification.setUserId(userId);
            notification.setTitle(title);
            notification.setMessage(message);
            notification.setType(type);
            notification.setTimestamp(LocalDateTime.now());
            notificationRepository.save(notification);

            // Send via WebSocket too
            messagingTemplate.convertAndSend("/topic/notifications/" + userId, notification);
        } catch (MessagingException e) {
            throw new RuntimeException(e);
        }
    }
}
