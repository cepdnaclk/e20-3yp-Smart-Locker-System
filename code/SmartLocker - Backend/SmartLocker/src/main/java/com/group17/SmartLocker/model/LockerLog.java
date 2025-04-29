package com.group17.SmartLocker.model;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "locker_logs")
public class LockerLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long logId;
    @Column(nullable = false)
    private LocalDateTime accessTime;
    private LocalDateTime releasedTime;

    @ManyToOne
    @JoinColumn(name = "locker_id", nullable = false)
    private Locker locker;  // References Locker entity

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;  // References User entity
}

