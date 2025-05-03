package com.group17.SmartLocker.service.lockerLog;

import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.repository.LockerLogRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

import static com.group17.SmartLocker.enums.LockerLogStatus.ACTIVE;

@RequiredArgsConstructor
@Service
public class LockerLogService implements ILockerLogService{

    private final LockerLogRepository lockerLogRepository;

    @Override
    public LockerLog findActiveLog(String userId) {
        // 3 scenarios
        // activeLogs has only one element -> LockerUser is currently using a locker
        // no active logs -> User is not using a locker now
        // more than one active lockers -> Some error has occurred, fix it in here
        List<LockerLog> activeLogs = lockerLogRepository.findByUserIdAndStatus(userId, ACTIVE);
        Optional<List<LockerLog>> optionalActiveLogs = Optional.ofNullable(activeLogs.isEmpty() ? null : activeLogs);

        return optionalActiveLogs
                .filter(lists -> !lists.isEmpty())
                .map(list -> list.get(0))
                .orElse(null);
    }

}
