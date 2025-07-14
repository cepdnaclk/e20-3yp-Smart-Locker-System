package com.group17.SmartLocker.service.admin;

import com.group17.SmartLocker.dto.LockerDto;
import com.group17.SmartLocker.model.User;

import java.util.List;
import java.util.Map;

public interface IAdminService {

    User updateUser(String id, User userDetails);

    User editUserDetails(String id, Map<String, Object> updates);

    void deleteUser(String id);

    List<LockerDto> getBlockedLockersByCluster();
}
