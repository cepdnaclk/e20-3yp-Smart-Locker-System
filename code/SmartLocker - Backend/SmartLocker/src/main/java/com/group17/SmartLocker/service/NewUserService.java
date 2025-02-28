package com.group17.SmartLocker.service;

import com.group17.SmartLocker.DTO.NewUserRegistrationDto;
import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.Status;
import com.group17.SmartLocker.model.LockerUser;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.repository.LockerUserRepository;
import com.group17.SmartLocker.repository.NewUserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NewUserService {
    private final NewUserRepository newUserRepository;
    private final LockerUserRepository lockerUserRepository;
    private final PasswordEncoder passwordEncoder;

    public NewUserService(NewUserRepository newUserRepository, PasswordEncoder passwordEncoder, LockerUserRepository lockerUserRepository) {
        this.newUserRepository = newUserRepository;
        this.lockerUserRepository = lockerUserRepository;
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

        return newUserRepository.save(newUser);
    }

    // Accept or reject users

    // Get pending users
    public List<NewUser> getPendingUsers() {
        return newUserRepository.findByStatus(Status.PENDING);
    }

    // Admin approves user and move the user in to the locker user table
    public Optional<LockerUser> approveUser(Long id) {
        
        Optional<NewUser> newUserOpt = newUserRepository.findById(id);

        if (newUserOpt.isPresent()) {
            LockerUser lockerUser = getLockerUser(newUserOpt);

            lockerUserRepository.save(lockerUser); // Save approved user

            // Delete from NewUser table
            newUserRepository.deleteById(id);

            return Optional.of(lockerUser);
        }
        return Optional.empty();
    }

    // Convert new user to a locker user after admin approval
    private static LockerUser getLockerUser(Optional<NewUser> newUserOpt) {

        NewUser newUser = newUserOpt.get();

        // Create new LockerUser
        LockerUser lockerUser = new LockerUser();
        lockerUser.setId(String.valueOf(newUser.getRegNo())); // Use regNo as id
        lockerUser.setUsername(newUser.getRegNo()); // Use username as id
        lockerUser.setPassword(newUser.getPassword());
        lockerUser.setFirstName(newUser.getFirstName());
        lockerUser.setLastName(newUser.getLastName());
        lockerUser.setEmail(newUser.getEmail());
        lockerUser.setContactNumber(newUser.getContactNumber());

        return lockerUser;
    }

    // Reject a user
    public void rejectUser(Long id) {
        newUserRepository.deleteById(id);
    }
}

