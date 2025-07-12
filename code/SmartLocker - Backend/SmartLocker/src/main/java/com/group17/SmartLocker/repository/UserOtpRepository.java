package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.model.UserOtp;
import com.group17.SmartLocker.enums.OtpType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface UserOtpRepository extends JpaRepository<UserOtp, Long> {
    Optional<UserOtp> findFirstByUserAndOtpTypeAndUsedFalseOrderByCreatedAtDesc(User user, OtpType otpType);

}

