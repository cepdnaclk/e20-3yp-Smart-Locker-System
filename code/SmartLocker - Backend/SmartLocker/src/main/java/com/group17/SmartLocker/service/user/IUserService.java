package com.group17.SmartLocker.service.user;

import com.group17.SmartLocker.model.User;

import java.util.List;
import java.util.Map;

public interface IUserService {
    List<User> getAllUsers();

    User createUser(User user);

    User getUserById(String id);

    User updateUser(String id, User userDetails);

    User editUserDetails(String id, Map<String, Object> updates);

    void deleteUser(String id);
}
