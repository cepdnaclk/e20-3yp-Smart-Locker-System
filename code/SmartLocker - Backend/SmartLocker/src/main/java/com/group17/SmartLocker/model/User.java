package com.group17.SmartLocker.model;


import com.group17.SmartLocker.enums.Role;
import jakarta.persistence.*;
import lombok.*;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "user")
public class User {

    @Id
    private String id;

    @Column(name = "fingerPrint")
    private String fingerPrint;

    @Column(nullable = false, unique = true)
    private String username;

    @Column(nullable = false)
    private String password;

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String contactNumber;

    @Column
    private String otp;

    @Column(unique = true)
    private String fingerPrintId;

    @Column(nullable = false)
    private String email;

    @Enumerated(EnumType.STRING)
    private Role role = Role.USER;

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<LockerLog> lockerLogs;
}
