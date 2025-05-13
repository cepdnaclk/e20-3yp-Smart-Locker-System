package com.group17.SmartLocker.service.user;

import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.model.User;

import java.util.List;
import java.util.Map;

public interface IUserService {
    List<UserDetailsDto> getAllUsers();

    User createUser(User user);

    UserDetailsDto getUserById(String id);

    User updateUser(String id, User userDetails);

    User editUserDetails(String id, Map<String, Object> updates);

    void deleteUser(String id);

    String getUserIdByUsername(String username);

    // this method is to send the otp code via mqtt publish to the topic
    void sendOtpCode(String message);
}
