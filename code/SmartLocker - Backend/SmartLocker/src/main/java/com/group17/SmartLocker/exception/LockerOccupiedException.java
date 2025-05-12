package com.group17.SmartLocker.exception;

public class LockerOccupiedException extends RuntimeException {
    public LockerOccupiedException(String message) {
        super(message);
    }
}
