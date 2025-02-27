//package com.group17.SmartLocker.controller;
//
//import com.group17.SmartLocker.model.NewUser;
//import com.group17.SmartLocker.model.RegisteredUser;
//import com.group17.SmartLocker.repository.NewUserRepository;
//import com.group17.SmartLocker.repository.RegisteredUserRepository;
//import com.group17.SmartLocker.security.JwtUtil;
//import jakarta.servlet.http.HttpSession;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.stereotype.Controller;
//import org.springframework.ui.Model;
//import org.springframework.web.bind.annotation.*;
//
//import java.util.Optional;
//
//@Controller
//@RequestMapping("/api/auth")
//public class AuthController {
//
//    private final NewUserRepository newUserRepository;
//    private final JwtUtil jwtUtil;
//    private final PasswordEncoder passwordEncoder;
//
//    public AuthController(NewUserRepository newUserRepository, JwtUtil jwtUtil, PasswordEncoder passwordEncoder) {
//        this.newUserRepository = newUserRepository;
//        this.jwtUtil = jwtUtil;
//        this.passwordEncoder = passwordEncoder;
//    }
//
//    @GetMapping("/login")
//    public String showLoginPage() {
//        return "login"; // Returns login.html
//    }
//
//    @PostMapping("/login")
//    public String login(@RequestParam String username,
//                        @RequestParam String password,
//                        HttpSession session,
//                        Model model) {
//        Optional<NewUser> userOpt = newUserRepository.findByUsername(username);
//
//        if (userOpt.isPresent()) {
//            NewUser user = userOpt.get();
//
//            if (passwordEncoder.matches(password, user.getPassword()) && user.getRole().equals("ROLE_ADMIN")) {
//                String token = jwtUtil.generateToken(username);
//                session.setAttribute("jwtToken", token);
//                return "redirect:/api/users/pending"; // Redirect to pending users page
//            }
//        }
//
//        model.addAttribute("error", "Invalid username or password");
//        return "login"; // Show login page again with error
//    }
//}
