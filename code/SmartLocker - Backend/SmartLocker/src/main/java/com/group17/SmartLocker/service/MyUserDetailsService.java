package com.group17.SmartLocker.service;

import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.principal.UserPrincipal;
import com.group17.SmartLocker.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

@Service
public class MyUserDetailsService implements UserDetailsService {

    @Autowired
    private UserRepository repo;

    @Override
    public UserDetails loadUserByUsername(String username) throws UsernameNotFoundException {
        User user = repo.findByUsername(username);

        if(user == null){
            System.out.println("User Not Found");
            throw new UsernameNotFoundException("user not found" + username);
        }
        return new UserPrincipal(user);
    }
}
