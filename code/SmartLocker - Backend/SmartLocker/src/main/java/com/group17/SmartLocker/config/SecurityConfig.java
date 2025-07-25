package com.group17.SmartLocker.config;

import com.group17.SmartLocker.filter.JwtAuthenticationFilter;
import com.group17.SmartLocker.service.MyUserDetailsService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final MyUserDetailsService userDetailsService;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    public SecurityConfig(MyUserDetailsService userDetailsService, JwtAuthenticationFilter jwtAuthenticationFilter) {
        this.userDetailsService = userDetailsService;
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        return http
                .csrf(AbstractHttpConfigurer::disable)
                .cors(Customizer.withDefaults()) // Enables CORS
                .authorizeHttpRequests(auth -> auth

                        // Public (unauthenticated) endpoints
                        .requestMatchers(
                                "/api/v1/login",
                                "/api/v1/newUsers/**", // <-- allows all sub-paths like /debug-get, /register
                                "/api/v1/forgotPassword/**", // allow forgot password in for all users
                                "/publish",
                                "/subscribe",
                                "/latest",
                                "/debug-get" ,// Optional, if still needed
                                "/ws/**" // WebSocket endpoint, if applicable
                        ).permitAll()

                        // Allow pre-flight CORS OPTIONS requests
                        .requestMatchers(HttpMethod.OPTIONS, "/api/v1/**").permitAll()

                        // Role-based access
                        .requestMatchers("/api/v1/superAdmin/**").hasRole("SUPER_ADMIN")
                        .requestMatchers("/api/v1/admin/**").hasAnyRole("ADMIN", "SUPER_ADMIN")
                        .requestMatchers("/api/v1/user/**").hasRole("USER")

                    
                        // Everything else requires authentication
                        .anyRequest().authenticated()
                )
                .userDetailsService(userDetailsService)
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .build();
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }
}









//package com.group17.SmartLocker.config;
//
//import com.group17.SmartLocker.filter.JwtAuthenticationFilter;
//import com.group17.SmartLocker.service.MyUserDetailsService;
//import org.springframework.context.annotation.Bean;
//import org.springframework.context.annotation.Configuration;
//import org.springframework.http.HttpMethod;
//import org.springframework.security.authentication.AuthenticationManager;
//import org.springframework.security.config.Customizer;
//import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
//import org.springframework.security.config.annotation.web.builders.HttpSecurity;
//import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
//import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
//import org.springframework.security.config.http.SessionCreationPolicy;
//import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
//import org.springframework.security.crypto.password.PasswordEncoder;
//import org.springframework.security.web.SecurityFilterChain;
//import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
//
//@Configuration
//@EnableWebSecurity
//public class SecurityConfig {
//
//    private final MyUserDetailsService userDetailsService;
//    private final JwtAuthenticationFilter jwtAuthenticationFilter;
//
//    public SecurityConfig(MyUserDetailsService userDetailsService, JwtAuthenticationFilter jwtAuthenticationFilter) {
//        this.userDetailsService = userDetailsService;
//        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
//    }
//
//    @Bean
//    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
//        return http
//                .csrf(AbstractHttpConfigurer::disable)
//                .cors(Customizer.withDefaults()) //This enables Spring Security to allow CORS
//                .authorizeHttpRequests(auth -> auth
//                        .requestMatchers("/api/v1/login", "/api/v1/newUsers/register", "/publish", "/subscribe" ,"/latest", "/api/v1/newUsers/debug-get").permitAll()
//
////                        .requestMatchers("/login", "/api/**").permitAll() // this line used to manually create an admin for the system
////
//                        .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()  // This line was added due to an error in the deployment
//
//
//                        .requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
//                        .requestMatchers("/api/v1/user/**").hasRole("USER")
//                        .anyRequest().authenticated()
//                )
//                .userDetailsService(userDetailsService)
//                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
//                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
//                .build();
//    }
//
//    @Bean
//    public PasswordEncoder passwordEncoder() {
//        return new BCryptPasswordEncoder();
//    }
//
//    @Bean
//    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
//        return configuration.getAuthenticationManager();
//    }
//
//}
//
//
//
//// spring security architecture: https://www.youtube.com/watch?v=qoYcmw43mdU
//// spring jwt authentication and authorization https://www.youtube.com/watch?v=RnZmeczS_DI