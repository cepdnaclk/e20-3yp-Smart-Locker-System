package com.group17.SmartLocker.service;

import com.group17.SmartLocker.dto.NewUserRegistrationDto;
import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.Status;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.repository.NewUserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NewUserService {
    private final NewUserRepository newUserRepository;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    public NewUserService(NewUserRepository newUserRepository, PasswordEncoder passwordEncoder, UserRepository userRepository) {
        this.newUserRepository = newUserRepository;
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
    }

    // new user registration process
    public NewUser registerUser(NewUserRegistrationDto newUserDto) {
        NewUser newUser = new NewUser();

        newUser.setRegNo(newUserDto.getRegNo());
        newUser.setFirstName(newUserDto.getFirstName());
        newUser.setLastName(newUserDto.getLastName());
        newUser.setContactNumber(newUserDto.getContactNumber());
        newUser.setEmail(newUserDto.getEmail());
        newUser.setPassword(passwordEncoder.encode(newUserDto.getPassword())); // Encrypt password
        newUser.setRole(Role.NEW_USER); // Default status
        newUser.setStatus(Status.PENDING);

        newUserRepository.save(newUser);

        return newUser;
    }

    // Accept or reject users

    // Get pending users
    public List<NewUser> getPendingUsers() {
        return newUserRepository.findByStatus(Status.PENDING);
    }

    // Admin approves user and move the user in to the locker user table
    public Optional<User> approveUser(Long id) {

        Optional<NewUser> newUserOpt = newUserRepository.findById(id);

        if (newUserOpt.isPresent()) {
            User user = getUser(newUserOpt);

            userRepository.save(user); // Save approved user

            // Delete from NewUser table
            newUserRepository.deleteById(id);

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
    public void rejectUser(Long id) {
        newUserRepository.deleteById(id);
    }
}

