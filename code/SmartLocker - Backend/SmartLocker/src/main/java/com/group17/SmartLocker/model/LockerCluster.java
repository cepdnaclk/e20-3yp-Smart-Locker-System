package com.group17.SmartLocker.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "locker_clusters")
public class LockerCluster {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String clusterName;
    private String lockerClusterDescription;
    private int totalNumberOfLockers;
    private int availableNumberOfLockers;

    // Cluster location
    private double latitude;
    private double longitude;

    @OneToMany(mappedBy = "lockerCluster", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Locker> lockers;
}
