package com.group17.SmartLocker.service.userOtp;

import com.group17.SmartLocker.enums.OtpType;

public interface IUserOtpService {
    Integer generateOtp(String username, OtpType type);

    boolean validateOtp(String username, Integer otp, OtpType type);
}
