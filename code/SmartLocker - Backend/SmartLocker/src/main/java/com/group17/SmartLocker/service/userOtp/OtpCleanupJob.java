package com.group17.SmartLocker.service.userOtp;

import com.group17.SmartLocker.repository.UserOtpRepository;
import com.group17.SmartLocker.model.UserOtp;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
@RequiredArgsConstructor
public class OtpCleanupJob {

    /*
    * This job is invoked in 30 minutes interval to delete the expired otp codes
    * to keep the otp codes updated
    */
    private final UserOtpRepository userOtpRepository;

    @Scheduled(fixedRate = 1800000) // Every half an hour (in milliseconds)
    public void deleteExpiredOtps() {
        List<UserOtp> expiredOtps = userOtpRepository.findAll()
                .stream()
                .filter(otp -> otp.getExpiresAt().isBefore(LocalDateTime.now()))
                .toList();

        if (!expiredOtps.isEmpty()) {
            userOtpRepository.deleteAll(expiredOtps);
            System.out.println("🧹 Expired OTPs cleaned: " + expiredOtps.size());
        }
    }
}
