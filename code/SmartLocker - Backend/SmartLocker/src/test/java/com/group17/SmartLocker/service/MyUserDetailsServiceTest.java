package com.group17.SmartLocker.service;


import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MyUserDetailsServiceTest {

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private MyUserDetailsService myUserDetailsService;

    private User user;

    @BeforeEach
    void setUp() {
        user = new User();
        user.setId("E20002");
        user.setUsername("E20002");
        user.setFirstName("John");
        user.setLastName("Doe");
        user.setEmail("john.doe@example.com");
        user.setPassword("encodedPassword");
    }

    //  Test Load User by Username (Success)
    @Test
    void testLoadUserByUsername_Success() {
        when(userRepository.findByUsername("E20002")).thenReturn(user);

        UserDetails userDetails = myUserDetailsService.loadUserByUsername("E20002");

        assertNotNull(userDetails);
        assertEquals("E20002", userDetails.getUsername());
        assertEquals("encodedPassword", userDetails.getPassword());

        verify(userRepository, times(1)).findByUsername("E20002");
    }

    // Test Load User by Username (User Not Found)
    @Test
    void testLoadUserByUsername_UserNotFound() {
        when(userRepository.findByUsername("E20002")).thenReturn(null);

        Exception exception = assertThrows(UsernameNotFoundException.class, () -> {
            myUserDetailsService.loadUserByUsername("E20002");
        });

        assertEquals("user not foundE20002", exception.getMessage());

        verify(userRepository, times(1)).findByUsername("E20002");
    }
}
