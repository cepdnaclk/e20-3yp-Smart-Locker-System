package com.group17.SmartLocker.model;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.*;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "lockerUser")
public class LockerUser {

    @Id
    private String id;

    @Column(name = "fingerPrint")
    private String fingerPrint;

}
