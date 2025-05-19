package com.group17.SmartLocker.model;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import com.group17.SmartLocker.enums.LockerStatus;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "lockers")
public class Locker {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long lockerId;
    private int displayNumber;

    @Enumerated(EnumType.STRING)
    private LockerStatus lockerStatus;

    @OneToMany(mappedBy = "locker", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private List<LockerLog> lockerLogs;

    @ManyToOne
    @JoinColumn(name = "lockerClusterId", nullable = false)
    private LockerCluster lockerCluster;

}
