package com.group17.SmartLocker.service.notification;

import com.group17.SmartLocker.model.Notification;

import java.util.List;

public interface INotificationService {

    void sendAndSave(String userId, String title, String message, String type);

    List<Notification> getAllNotifications(String userId);
}
