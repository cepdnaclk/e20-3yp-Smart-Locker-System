package com.group17.SmartLocker.service.lockerLog;

import com.group17.SmartLocker.dto.LockerLogDto;
import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.repository.LockerLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

import static com.group17.SmartLocker.enums.LockerLogStatus.ACTIVE;
import static com.group17.SmartLocker.enums.LockerLogStatus.UNSAFE;

@RequiredArgsConstructor
@Service
public class LockerLogService implements ILockerLogService{

    private final LockerLogRepository lockerLogRepository;


    @Override
    public List<LockerLogDto> getAllLockerLogs(){

        List<LockerLogDto> lockerLogs = new ArrayList<>();
        List<LockerLog> lockerLogsAll = lockerLogRepository.findAll();

        for(int i = 0; i < lockerLogsAll.size(); i++){

            LockerLogDto lockerLogDto = new LockerLogDto();

            lockerLogDto.setLogId(lockerLogsAll.get(i).getLogId());
            lockerLogDto.setAccessTime(lockerLogsAll.get(i).getAccessTime());
            lockerLogDto.setReleasedTime(lockerLogsAll.get(i).getReleasedTime());
            lockerLogDto.setStatus(lockerLogsAll.get(i).getStatus());
            lockerLogDto.setLocation(lockerLogsAll.get(i).getLocker().getLockerCluster().getClusterName());
            lockerLogDto.setLockerId(lockerLogsAll.get(i).getLocker().getLockerId());

            lockerLogs.add(lockerLogDto);

        }

        return lockerLogs;
    }

    @Override
    public LockerLog findActiveLog(String userId) {

        /*
        * assumed that there are no more than one active log to a user in a given instance
        */
        List<LockerLog> activeLogs = lockerLogRepository.findByUserIdAndStatus(userId, ACTIVE);

        if(activeLogs.size() == 1){
            return activeLogs.get(0);
        }

        // therefore this return method will never execute
        return null;
    }

    @Override
    public LockerLog findActiveOrUnsafeLog(String userId) {
        // 3 scenarios
        // activeLogs has only one element -> LockerUser is currently using a locker
        // no active logs -> User is not using a locker now
        // more than one active lockers -> Some error has occurred, fix it in here

        /*
         * assumed that there are no more than one active log or unsafe log to a user in a given instance
         */
        List<LockerLog> activeLogs = lockerLogRepository.findByUserIdAndStatus(userId, ACTIVE);
        List<LockerLog> unsafeLogs = lockerLogRepository.findByUserIdAndStatus(userId, UNSAFE);


        if(activeLogs.size() == 1 && unsafeLogs.isEmpty()){
            return activeLogs.get(0);
        }
        else if(activeLogs.isEmpty() && unsafeLogs.size() == 1) {
            return unsafeLogs.get(0);
        }
        else if(activeLogs.isEmpty() && unsafeLogs.isEmpty()) {
            return null;
        }

        // therefore this return method will never execute
        return null;

    }

}
