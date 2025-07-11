package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User, String> {
    User findByUsername(String username);

    User findByFingerPrintId(String userFingerPrintId);

    @Query("SELECT u.otp FROM User u WHERE u.otp IS NOT NULL")
    List<String> findAllOtps();

    User findByEmail(String email);
}
