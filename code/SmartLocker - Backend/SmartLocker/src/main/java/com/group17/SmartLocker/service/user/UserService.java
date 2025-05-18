package com.group17.SmartLocker.service.user;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.group17.SmartLocker.dto.UserDetailsDto;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.User;
import com.group17.SmartLocker.repository.UserRepository;
import com.group17.SmartLocker.service.locker.LockerService;
import com.group17.SmartLocker.service.mqtt.MqttPublisher;
import io.micrometer.common.util.StringUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.util.ReflectionUtils;

import java.lang.reflect.Field;
import java.util.*;
import java.util.concurrent.ThreadLocalRandom;

@RequiredArgsConstructor
@Service
public class UserService implements IUserService {

    private final UserRepository userRepository;
    private final LockerService lockerService;
    private final MqttPublisher mqttPublisher;

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

    // this method is to send the otp code via mqtt publish to the topic
    @Override
    public void sendOtpCode(String message){

        //get the user Id from the message
        String registrationId = "";

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(message);
            registrationId = root.get("registrationID").asText();  // spelling preserved as is
            registrationId = "E" + registrationId;
//            System.out.println(registrationId);

        } catch (Exception e) {
            System.err.println("Failed to parse MQTT message: " + e.getMessage());
        }

        User user = userRepository.findById(registrationId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        String otp = user.getOtp();

        try {
            mqttPublisher.publish("esp32/password", "{\"password\":\"" + otp + "\"}" );
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    // save fingerprint id to the database
    public void saveFingerPrint(String message){
        //get the user Id from the message
        String registrationId = "";
        String fingerPrintId = "";

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(message);
            registrationId = root.get("registrationID").asText();  // spelling preserved as is
            registrationId = "E" + registrationId;
//            System.out.println(registrationId);

        } catch (Exception e) {
            System.err.println("Failed to parse MQTT message: " + e.getMessage());
        }


        User user = userRepository.findById(registrationId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        user.setFingerPrintId(fingerPrintId);
        userRepository.save(user);
        System.out.println("Fingerprint id saved successfully");
    }

    // unlock a locker using fingerprint
    public void unlockLockerUsingFingerprint(String message){

        System.out.println("user service");

        // extract the fields from the mqtt message
        String userFingerPrintId = "";
        String clusterIdString = "";

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode root = mapper.readTree(message);
            userFingerPrintId = root.get("fingerprintID").asText();  // spelling preserved as is
            clusterIdString = root.get("clusterID").asText();
//            System.out.println(registrationId);

        } catch (Exception e) {
            System.err.println("Failed to parse MQTT message: " + e.getMessage());
        }
//        System.out.println("userFingerprintId: " + userFingerPrintId);
//        System.out.println("cluster id in string: " + clusterIdString);
        // parse the input cluster id into a long
        Long clusterId = Long.parseLong(clusterIdString);

//        System.out.println("Long cluster id: " + clusterId);


        // get the username
        String username = userRepository.findByFingerPrintId(userFingerPrintId).getId();
        System.out.println("username " + username);
        System.out.println(lockerService.unlockLocker(username, clusterId));
    }


    /*
    * This method generates the otp code.
    * Otp code should not have duplicates.
    * user should be able to generate otp codes from the mobile app
    * In case : Someone has stolen the otp code
    */
    @Override
    public String generateOtpCode(String id){

        String otpCode =  "";

        //generate a random number
        int randomNumber = ThreadLocalRandom.current().nextInt(1000, 10000);
        otpCode = Integer.toString(randomNumber);

        // get the current otp codes exists in the repository
        List<String> otpList = userRepository.findAllOtps();

        while(otpList.contains(otpCode)){
            otpCode = generateOtpCode();
        }

        User user = userRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        user.setFingerPrintId(otpCode);
        userRepository.save(user);

        return Integer.toString(randomNumber);
    }

    // Method overloading to avoid the duplicate otp codes
    public String generateOtpCode() {
        int randomNumber = ThreadLocalRandom.current().nextInt(1000, 10000);
        return Integer.toString(randomNumber);
    }

}
