package com.group17.SmartLocker.service.newUser;

import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.NewUserStatus;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.repository.NewUserRepository;
import com.group17.SmartLocker.service.email.EmailService;
import com.group17.SmartLocker.service.user.UserService;
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
    private final UserService userService;
    private final EmailService emailService;

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

            // generate the otp code.
            String otpCode = userService.generateOtpCode(user.getId());

            // send the email
            String subject = "Welcome to SmartLocker – Registration Approved ✅";
            String body = String.format("""
Dear %s,

Welcome to SmartLocker! Your registration has been successfully approved.

🧑 Username: %s
🔑 Password: Password you have entered in the registration
🔐 OTP Code for Fingerprint Registration: %s

👉 Please use the above OTP when prompted by the system to save your fingerprint. This is a one-time verification step to securely link your identity with the SmartLocker system.

If you need assistance or have any questions, feel free to contact our support team.

Thank you,
SmartLocker Admin Team
""", user.getFirstName(), user.getUsername(), otpCode);

            emailService.sendSimpleEmail(user.getEmail(), subject, body);

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

        NewUser newUser = newUserRepository.findById(id)
                        .orElseThrow(() -> new ResourceNotFoundException("New User not found"));

        // send the email
        String subject = "SmartLocker Registration Status – Application Rejected";
        String body = String.format("""
Dear %s,

Thank you for your interest in SmartLocker.

We regret to inform you that your registration has not been approved at this time. After reviewing your submitted information, we determined that it does not meet the current criteria required to proceed.

Please note:
- This decision may be based on incomplete or inconsistent details.
- You are welcome to reapply in the future if your circumstances change.

If you believe this was a mistake or if you have questions, please contact our support team for clarification.

We appreciate your understanding.

Sincerely,
SmartLocker Admin Team
""", newUser.getFirstName());

        // send the email
        emailService.sendSimpleEmail(newUser.getEmail(), subject, body);
        newUserRepository.deleteById(id);
    }
}

