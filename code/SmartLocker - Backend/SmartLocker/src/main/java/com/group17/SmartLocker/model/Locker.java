//package com.group17.SmartLocker.model;
//
//import jakarta.persistence.*;
//import lombok.*;
//
//@Getter
//@Setter
//@NoArgsConstructor
//@AllArgsConstructor
//@Entity
//@Table(name = "lockers")
//public class Locker {
//
//    @Id
//    @GeneratedValue(strategy = GenerationType.IDENTITY)
//    private Long lockerId;
//
//    @Column(nullable = false)
//    private boolean isAvailable;  // true = Available, false = In Use
//
//    @Column(nullable = false)
//    private String clusterId;  // Group of lockers
//
//    // Other locker-specific fields (optional)
//}
