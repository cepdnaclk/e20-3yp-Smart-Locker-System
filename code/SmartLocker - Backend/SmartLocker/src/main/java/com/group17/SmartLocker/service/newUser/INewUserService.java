package com.group17.SmartLocker.service.newUser;

import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.model.User;

import java.util.List;
import java.util.Optional;

public interface INewUserService {
    NewUser registerUser(NewUser newUser);

    // Get pending users
    List<NewUser> getPendingUsers();

    // Admin approves user and move the user in to the locker user table
    Optional<User> approveUser(Long id);

    // Reject a user
    void rejectUser(Long id);
}
