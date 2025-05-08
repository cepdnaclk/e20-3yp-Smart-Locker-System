package com.group17.SmartLocker.service.lockerCluster;

import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.repository.LockerClusterRepository;
import com.group17.SmartLocker.service.locker.LockerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@RequiredArgsConstructor
@Service
public class LockerClusterService implements ILockerClusterService{

    private final LockerService lockerService;
    private final LockerClusterRepository lockerClusterRepository;

    @Override
    public LockerCluster addLockerCluster(LockerClusterDto lockerCluster) {

        LockerCluster newLockerCluster = new LockerCluster();

        newLockerCluster.setClusterName(lockerCluster.getClusterName());
        newLockerCluster.setLockerClusterDescription(lockerCluster.getLockerClusterDescription());
        newLockerCluster.setTotalNumberOfLockers(lockerCluster.getTotalNumberOfLockers());
        newLockerCluster.setAvailableNumberOfLockers(lockerCluster.getTotalNumberOfLockers());

        newLockerCluster = lockerClusterRepository.save(newLockerCluster);

        for(int i = 0; i < (int) lockerCluster.getTotalNumberOfLockers(); i++){
            lockerService.addLockerToCluster(newLockerCluster.getId());
        }
        return newLockerCluster;
    }

    @Override
    public LockerCluster getLockerClusterById(Long clusterId) {
        return lockerClusterRepository.findById(clusterId)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid locker cluster ID!"));
    }

    @Override
    public List<LockerCluster> getAllLockerClusters() {
        return lockerClusterRepository.findAll();
    }

    @Override
    public LockerCluster updateLockerCluster(Long lockerClusterId, LockerClusterDto lockerCluster) {

        LockerCluster updatedLockerCluster = lockerClusterRepository.findById(lockerClusterId)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid cluster Id!"));

        updatedLockerCluster.setClusterName(lockerCluster.getClusterName());
        updatedLockerCluster.setLockerClusterDescription(lockerCluster.getLockerClusterDescription());
        updatedLockerCluster.setTotalNumberOfLockers(lockerCluster.getTotalNumberOfLockers());
        updatedLockerCluster.setAvailableNumberOfLockers(lockerCluster.getTotalNumberOfLockers());

        return lockerClusterRepository.save(updatedLockerCluster);
    }

    @Override
    public void deleteLockerClusterById(Long lockerClusterId) {
        lockerClusterRepository.findById(lockerClusterId)
                .ifPresentOrElse(lockerClusterRepository::delete,
                        () -> {
                            throw new ResourceNotFoundException("Invalid locker cluster id");
                        });
    }
}
