package com.group17.SmartLocker.model;

import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.enums.NewUserStatus;
import jakarta.persistence.*;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "new_users")
public class NewUser{

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false, unique = true)
    private String regNo;

    @Column(nullable = false)
    private String firstName;

    @Column(nullable = false)
    private String lastName;

    @Column(nullable = false, unique = true)
    private String contactNumber;

    @Column(nullable = false)
    private String email;

    @Column(nullable = false)
    private String password;

    @Enumerated(EnumType.STRING)
    private Role role = Role.NEW_USER;

    @Enumerated(EnumType.STRING)
    private NewUserStatus status = NewUserStatus.PENDING;

}

