package com.group17.SmartLocker.service;

import com.group17.SmartLocker.service.authentication.AuthenticationResponse;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.authentication.AuthenticationService;
import com.group17.SmartLocker.service.jwt.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthenticationServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @Mock
    private AuthenticationManager authenticationManager;

    @InjectMocks
    private AuthenticationService authenticationService;

    private User user;
    private String jwtToken = "mocked-jwt-token";

    @BeforeEach
    void setUp() {
        user = new User();
        user.setUsername("E20002");
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setPassword("rawPassword");
    }

    // Test Register User
    @Test
    void testRegister() {
        when(passwordEncoder.encode("rawPassword")).thenReturn("encodedPassword");
        when(userRepository.save(any(User.class))).thenReturn(user);
        when(jwtService.generateToken(any(User.class))).thenReturn(jwtToken);

        AuthenticationResponse response = authenticationService.register(user);

        assertNotNull(response);
        assertEquals(jwtToken, response.getToken());

        verify(passwordEncoder, times(1)).encode("rawPassword");
        verify(userRepository, times(1)).save(any(User.class));
        verify(jwtService, times(1)).generateToken(any(User.class));
    }

    // Test Authenticate User
    @Test
    void testAuthenticate() {
        when(userRepository.findByUsername("E20002")).thenReturn(user);
        when(jwtService.generateToken(user)).thenReturn(jwtToken);

        AuthenticationResponse response = authenticationService.authenticate(user);

        assertNotNull(response);
        assertEquals(jwtToken, response.getToken());

        verify(authenticationManager, times(1))
                .authenticate(new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword()));
        verify(userRepository, times(1)).findByUsername("E20002");
        verify(jwtService, times(1)).generateToken(user);
    }

    // Test Authenticate - User Not Found
//    @Test
//    void testAuthenticate_UserNotFound() {
//        when(userRepository.findByUsername("E20002")).thenReturn(null);
//
//        Exception exception = assertThrows(NullPointerException.class, () -> {
//            authenticationService.authenticate(user);
//        });
//
//        assertNotNull(exception);
//
//        verify(authenticationManager, times(1))
//                .authenticate(new UsernamePasswordAuthenticationToken(user.getUsername(), user.getPassword()));
//        verify(userRepository, times(1)).findByUsername("E20002");
//        verify(jwtService, never()).generateToken(any(User.class));
//    }
}
