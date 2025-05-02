package com.group17.SmartLocker.filter;

import com.group17.SmartLocker.service.jwt.JwtService;
import com.group17.SmartLocker.service.MyUserDetailsService;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.IOException;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class JwtAuthenticationFilterTest {

    @Mock
    private JwtService jwtService;

    @Mock
    private MyUserDetailsService userDetailsService;

    @Mock
    private HttpServletRequest request;

    @Mock
    private HttpServletResponse response;

    @Mock
    private FilterChain filterChain;

    @Mock
    private UserDetails userDetails;

    @InjectMocks
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    private final String validToken = "Bearer valid-token";
    private final String username = "E20002";

    @BeforeEach
    void setUp() {
        SecurityContextHolder.clearContext();
    }

    // Test When No Authorization Header Is Present
    @Test
    void testDoFilter_NoAuthHeader() throws ServletException, IOException {
        when(request.getHeader("Authorization")).thenReturn(null);

        jwtAuthenticationFilter.doFilterInternal(request, response, filterChain);

        verify(filterChain, times(1)).doFilter(request, response);
        assertNull(SecurityContextHolder.getContext().getAuthentication());
    }

    // Test When Token Does Not Start with 'Bearer '
    @Test
    void testDoFilter_InvalidBearerToken() throws ServletException, IOException {
        when(request.getHeader("Authorization")).thenReturn("InvalidToken");

        jwtAuthenticationFilter.doFilterInternal(request, response, filterChain);

        verify(filterChain, times(1)).doFilter(request, response);
        assertNull(SecurityContextHolder.getContext().getAuthentication());
    }

    // Test When Token Is Valid
    @Test
    void testDoFilter_ValidToken() throws ServletException, IOException {
        when(request.getHeader("Authorization")).thenReturn(validToken);
        when(jwtService.extractUsername("valid-token")).thenReturn(username);
        when(userDetailsService.loadUserByUsername(username)).thenReturn(userDetails);
        when(jwtService.isValid("valid-token", userDetails)).thenReturn(true);
        when(userDetails.getAuthorities()).thenReturn(null);

        jwtAuthenticationFilter.doFilterInternal(request, response, filterChain);

        verify(userDetailsService, times(1)).loadUserByUsername(username);
        verify(jwtService, times(1)).isValid("valid-token", userDetails);
        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
        assertTrue(SecurityContextHolder.getContext().getAuthentication() instanceof UsernamePasswordAuthenticationToken);
    }

    // Test When Token Is Invalid
    @Test
    void testDoFilter_InvalidToken() throws ServletException, IOException {
        when(request.getHeader("Authorization")).thenReturn(validToken);
        when(jwtService.extractUsername("valid-token")).thenReturn(username);
        when(userDetailsService.loadUserByUsername(username)).thenReturn(userDetails);
        when(jwtService.isValid("valid-token", userDetails)).thenReturn(false);

        jwtAuthenticationFilter.doFilterInternal(request, response, filterChain);

        verify(userDetailsService, times(1)).loadUserByUsername(username);
        verify(jwtService, times(1)).isValid("valid-token", userDetails);
        assertNull(SecurityContextHolder.getContext().getAuthentication());
    }
}
