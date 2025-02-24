package com.group17.SmartLocker.service;

import com.group17.SmartLocker.DTO.NewUserRegistrationDto;
import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.Status;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.repository.NewUserRepository;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

@Service
public class NewUserService {
    private final NewUserRepository newUserRepository;
    private final PasswordEncoder passwordEncoder;

    public NewUserService(NewUserRepository newUserRepository, PasswordEncoder passwordEncoder) {
        this.newUserRepository = newUserRepository;
        this.passwordEncoder = passwordEncoder;
    }

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
}

