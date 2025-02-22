package com.group17.SmartLocker.entity;

import org.springframework.stereotype.Component;

@Component
public class User {

    private String id;
    private String fingerPrint;

    public User(String id, String fingerPrint) {
        this.id = id;
        this.fingerPrint = fingerPrint;
    }

    public User() {
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFingerPrint() {
        return fingerPrint;
    }

    public void setFingerPrint(String fingerPrint) {
        this.fingerPrint = fingerPrint;
    }
}
