package com.group17.SmartLocker.service.newUser;

import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.NewUserStatus;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.repository.NewUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class NewUserService implements INewUserService{
    private final NewUserRepository newUserRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    // new user registration process
    // todo : implement the registration number and the username check when a new user registration
    @Override
    public NewUser registerUser(NewUser newUser) {
        try {
            newUser.setPassword(passwordEncoder.encode(newUser.getPassword())); // Encrypt password
            newUser.setRole(Role.NEW_USER); // Default status
            newUser.setStatus(NewUserStatus.PENDING);

            newUserRepository.save(newUser);

            return newUser;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // Get pending users
    @Override
    public List<NewUser> getPendingUsers() {
        // todo : Use Dto to send only the required data to front end;
        // todo : should handle the null array in the controller
        return newUserRepository.findByStatus(NewUserStatus.PENDING);
    }

    // Admin approves user and move the user in to the locker user table
    @Override
    public Optional<User> approveUser(Long id) {
        Optional<NewUser> newUserOpt = newUserRepository.findById(id);
        if (newUserOpt.isPresent()) {
            User user = getUser(newUserOpt);
            userRepository.save(user); // Save approved user
            newUserRepository.deleteById(id); // Delete from NewUser table
            return Optional.of(user);
        }
        return Optional.empty();
    }

    // Convert new user to a locker user after admin approval
    private static User getUser(Optional<NewUser> newUserOpt) {
        NewUser newUser = newUserOpt.get();

        // Create new LockerUser
        User user = new User();
        user.setId(String.valueOf(newUser.getRegNo())); // Use regNo as id
        user.setUsername(newUser.getRegNo()); // Use username as id
        user.setPassword(newUser.getPassword());
        user.setFirstName(newUser.getFirstName());
        user.setLastName(newUser.getLastName());
        user.setEmail(newUser.getEmail());
        user.setContactNumber(newUser.getContactNumber());

        return user;
    }

    // Reject a user
    @Override
    public void rejectUser(Long id) {
        newUserRepository.deleteById(id);
    }
}

