package com.group17.SmartLocker.controller;

import com.group17.SmartLocker.model.NewUser;
import com.group17.SmartLocker.service.newUser.NewUserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

@RequiredArgsConstructor
@CrossOrigin("*")
@RestController
@RequestMapping("${api.prefix}/newUsers")
public class NewUserController {
    private final NewUserService newUserService;

    // New user registration
    @PostMapping("/register")
    public NewUser registerUser(@RequestBody NewUser newUSer) {
        return newUserService.registerUser(newUSer);
    }

    // check the azure deployed backend
    @GetMapping("/debug-get")
    public String debugGet() {
        System.out.println("✅ /debug-get endpoint was reached via GET");
        return "GET is supported on /debug-get";
    }

    @PutMapping("/debug-put")
    public String debugPut() {
        System.out.println("✅ /debug-put endpoint was reached via PUT");
        return "PUT is supported on /debug-put";
    }

    @PostMapping("/debug-post")
    public String debugPost(@RequestBody(required = false) String body) {
        System.out.println("✅ /debug-post endpoint was reached via POST");
        System.out.println("📦 Received body: " + body);
        return "POST is supported on /debug-post";
    }
}

