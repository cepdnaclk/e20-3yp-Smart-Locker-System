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
    private String clusterName;
    private String lockerClusterDescription;
    private int totalNumberOfLockers;
    private int availableNumberOfLockers;

    @OneToMany(mappedBy = "lockerCluster", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Locker> lockers;
}
