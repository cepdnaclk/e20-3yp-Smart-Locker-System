package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.model.NewUser;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface NewUserRepository extends JpaRepository<NewUser, Long> {
//    Optional<NewUser> findByUsername(String username);
}
