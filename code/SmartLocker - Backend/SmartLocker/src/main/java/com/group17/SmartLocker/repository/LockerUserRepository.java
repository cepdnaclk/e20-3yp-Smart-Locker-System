package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.model.LockerUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface LockerUserRepository extends JpaRepository<LockerUser, String> {
}
