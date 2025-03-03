package com.group17.SmartLocker.model;

public class AuthenticationResponse {

    public String getToken() {
        return token;
    }

    private String token;

    public AuthenticationResponse(String token){
        this.token = token;
    }


}
