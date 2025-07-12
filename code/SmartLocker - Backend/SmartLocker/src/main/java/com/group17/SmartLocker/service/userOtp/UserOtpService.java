package com.group17.SmartLocker.service.userOtp;

import com.group17.SmartLocker.enums.OtpType;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.UserOtp;
import com.group17.SmartLocker.repository.UserOtpRepository;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.email.EmailService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.concurrent.ThreadLocalRandom;

@Service
@RequiredArgsConstructor
public class UserOtpService implements IUserOtpService {

    private final UserRepository userRepository;
    private final UserOtpRepository otpRepository;
    private final EmailService emailService;

    @Override
    public Integer generateOtp(String identifier, OtpType type) {

        /*
        * This method generates the otp code
        * Save to the database
        * username and the type(purpose) of the otp code is required
        * returns the otp code
        */

        User user = null;

        if (!identifier.isEmpty()) {
            if (identifier.contains("@")) {
                // Update using the email
                user = userRepository.findByEmail(identifier);
            } else {
                // Update using username
                user = userRepository.findByUsername(identifier);
            }
        }

        if (user == null) {
            throw new ResourceNotFoundException("User not found with given email or username.");
        }

        // Generate a 4-digit OTP
        int otp = ThreadLocalRandom.current().nextInt(1000, 10000);


        /*
        * User should receive the otp code as an email
        * user should enter the newest otp code
        */

        String subject = "SmartLocker – OTP Code for Password Reset";
        String body = String.format("""
Dear %s,
                
We received a request to reset your SmartLocker account password.
                
🔐 OTP Code for Password Reset: %s
                
👉 Please enter this code in the app to proceed with resetting your password.
This code is valid for one-time use and will expire in 30 minutes for your security.
                
If you did not request a password reset, please ignore this message or contact our support team immediately.

Thank you,
SmartLocker Admin Team
""", user.getFirstName(), otp);

        emailService.sendSimpleEmail(user.getEmail(), subject, body);

        UserOtp userOtp = new UserOtp();
        userOtp.setOtp(otp);
        userOtp.setOtpType(type);
        userOtp.setUser(user);
        userOtp.setCreatedAt(LocalDateTime.now());
        userOtp.setExpiresAt(LocalDateTime.now().plusMinutes(5));
        userOtp.setUsed(false);

        otpRepository.save(userOtp);
        return otp;
    }

    @Override
    public boolean validateOtp(String identifier, Integer otp, OtpType type) {

        /*
         * This method validates the otp code.
         * Checks the otp code for given username and the otp code type
         * Otp code types : PASSWORD_RESET , FINGERPRINT_REGISTRATION , EMAIL_VERIFICATION
         * No need to be all the otp codes unique
         * Only check the otp code related to the username
         */

        User user = null;

        if (!identifier.isEmpty()) {
            if (identifier.contains("@")) {
                // Update using the email
                user = userRepository.findByEmail(identifier);
            } else {
                // Update using username
                user = userRepository.findByUsername(identifier);
            }
        }

        if (user == null) {
            throw new ResourceNotFoundException("User not found with given email or username.");
        }

        UserOtp userOtp = otpRepository.findFirstByUserAndOtpTypeAndUsedFalseOrderByCreatedAtDesc(user, type)
                .orElseThrow(() -> new ResourceNotFoundException("OTP not found or already used."));

        boolean isValid = (userOtp.getOtp() == otp) && userOtp.getExpiresAt().isAfter(LocalDateTime.now());

        if (isValid) {
            userOtp.setUsed(true);
            otpRepository.save(userOtp);
        }

        return isValid;
    }
}
