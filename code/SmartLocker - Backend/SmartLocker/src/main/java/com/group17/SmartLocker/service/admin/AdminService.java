package com.group17.SmartLocker.service.admin;

import com.group17.SmartLocker.enums.Role;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.exception.UnauthorizedActionException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Field;
import java.util.Map;
import java.util.Set;

@RequiredArgsConstructor
@Service
public class AdminService implements IAdminService{

    private final UserRepository userRepository;

    @Override
    public User updateUser(String id, User userDetails){

        User updateUser = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        updateUser.setUsername(userDetails.getUsername());
        updateUser.setFirstName(userDetails.getFirstName());
        updateUser.setLastName(userDetails.getLastName());
        updateUser.setContactNumber(userDetails.getContactNumber());
        updateUser.setEmail(userDetails.getEmail());

        return userRepository.save(updateUser);
    }

    @Override
    public User editUserDetails(String id, Map<String, Object> updates){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));

        Set<String> allowedFields = Set.of("firstName", "lastName", "email", "contactNumber");

        updates.forEach((key, value) -> {
            if (allowedFields.contains(key)){
                Field field = ReflectionUtils.findField(User.class, key);
                if (field != null) {
                    field.setAccessible(true);
                    ReflectionUtils.setField(field, user, value);
                }
            }
        });

        return userRepository.save(user);

    }

    @Override
    public void deleteUser(String id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        userRepository.delete(user);
    }
}
