package com.group17.SmartLocker.service.lockerLog;

import com.group17.SmartLocker.enums.LockerLogStatus;
import com.group17.SmartLocker.model.LockerLog;
import com.group17.SmartLocker.repository.LockerLogRepository;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.Mockito;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Collections;
import java.util.List;
import java.util.Optional;

@ExtendWith(MockitoExtension.class)
public class LockerLogServiceImplTest {

    @Mock
    private LockerLogRepository lockerLogRepository;

    @InjectMocks
    private LockerLogService lockerLogService;

    private final String userId = "E20567";

    @Test
    void shouldReturnFirstActiveLogWhenPresent(){
        // Arrange
        LockerLog expectedLog = new LockerLog();
        List<LockerLog> logs = List.of(expectedLog, new LockerLog());

        Mockito.when(lockerLogRepository.findByUserIdAndStatus(userId, LockerLogStatus.ACTIVE))
                .thenReturn(logs);

        // Act
        LockerLog result = lockerLogService.findActiveLog(userId);

        // Assert
        Assertions.assertNotNull(result);
        Assertions.assertEquals(expectedLog, result);

    }

    @Test
    void shouldReturnNullWhenNoActiveLogs(){
        Mockito.when(lockerLogRepository.findByUserIdAndStatus(userId, LockerLogStatus.ACTIVE))
                .thenReturn(Collections.emptyList());

        LockerLog result = lockerLogService.findActiveLog(userId);
        Assertions.assertNull(result);
    }

    @Test
    void shouldReturnNullWhenOptionalIsEmpty(){
        Mockito.when(lockerLogRepository.findByUserIdAndStatus(userId, LockerLogStatus.ACTIVE))
                .thenReturn(null);

        LockerLog result = lockerLogService.findActiveLog(userId);
        Assertions.assertNull(result);
    }


}
