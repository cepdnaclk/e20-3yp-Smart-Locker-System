package com.group17.SmartLocker.repository;

import com.group17.SmartLocker.model.Image;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ImageRepository extends JpaRepository<Image, Long> {
    Image findByUserUsername(String username);

}
