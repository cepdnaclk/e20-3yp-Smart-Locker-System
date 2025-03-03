package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.enums.Status;
import com.group17.SmartLocker.model.NewUser;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface NewUserRepository extends JpaRepository<NewUser, Long> {

    List<NewUser> findByStatus(Status status);

    Optional<NewUser> findById(Long id);
//    Optional<NewUser> findByUsername(String username);
}
