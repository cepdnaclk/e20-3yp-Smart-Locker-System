package com.group17.SmartLocker.service.user;

import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import io.micrometer.common.util.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Field;
import java.util.*;

@RequiredArgsConstructor
@Service
public class UserService implements IUserService {

    private final UserRepository userRepository;

    @Override
    public List<UserDetailsDto> getAllUsers(){
        List<User> users = userRepository.findAll();
        List<UserDetailsDto> userDetailsDtoList = new ArrayList<>();
        for(User user : users){

            UserDetailsDto userDetailsDto = new UserDetailsDto();

            userDetailsDto.setId(user.getId());
            userDetailsDto.setUsername(user.getUsername());
            userDetailsDto.setFirstName(user.getFirstName());
            userDetailsDto.setLastName(user.getLastName());
            userDetailsDto.setContactNumber(user.getContactNumber());
            userDetailsDto.setEmail(user.getEmail());
            userDetailsDto.setFingerPrintExists(StringUtils.isNotBlank(user.getUsername()));
            userDetailsDto.setLockerLogs(user.getLockerLogs());

            userDetailsDtoList.add(userDetailsDto);
        }

        return userDetailsDtoList;
    }

    @Override
    public User createUser(User user){
        return userRepository.save(user);
    }

    @Override
    public UserDetailsDto getUserById(String id){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not exist with id: " + id));

        UserDetailsDto userDetailsDto = new UserDetailsDto();

        userDetailsDto.setId(user.getId());
        userDetailsDto.setUsername(user.getUsername());
        userDetailsDto.setFirstName(user.getFirstName());
        userDetailsDto.setLastName(user.getLastName());
        userDetailsDto.setContactNumber(user.getContactNumber());
        userDetailsDto.setEmail(user.getEmail());
        userDetailsDto.setFingerPrintExists(StringUtils.isNotBlank(user.getUsername()));
        userDetailsDto.setLockerLogs(user.getLockerLogs());
        

        return userDetailsDto;
    }

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

    @Override
    public String getUserIdByUsername(String username){
        User user = userRepository.findByUsername(username);
        return user.getId();
    }

}
