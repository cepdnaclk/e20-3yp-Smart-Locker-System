package com.group17.SmartLocker.service.lockerCluster;

import com.group17.SmartLocker.dto.LockerClusterDto;
import com.group17.SmartLocker.exception.ResourceNotFoundException;
import com.group17.SmartLocker.model.LockerCluster;
import com.group17.SmartLocker.repository.LockerClusterRepository;
import com.group17.SmartLocker.service.locker.LockerService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
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
        newLockerCluster.setLatitude(lockerCluster.getLatitude());
        newLockerCluster.setLongitude(lockerCluster.getLongitude());

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
    public List<LockerClusterDto> getAllLockerClusters() {
        List<LockerCluster> lockerClusters =  lockerClusterRepository.findAll();
        List<LockerClusterDto> lockerClustersList = new ArrayList<>();

        for(int i = 0; i < lockerClusters.size(); i++){
            LockerClusterDto lockerCluster = new LockerClusterDto();

            lockerCluster.setId(lockerClusters.get(i).getId());
            lockerCluster.setClusterName(lockerClusters.get(i).getClusterName());
            lockerCluster.setLockerClusterDescription(lockerClusters.get(i).getLockerClusterDescription());
            lockerCluster.setTotalNumberOfLockers(lockerClusters.get(i).getTotalNumberOfLockers());
            lockerCluster.setAvailableNumberOfLockers(lockerClusters.get(i).getAvailableNumberOfLockers());

            // locker location
            lockerCluster.setLatitude(lockerClusters.get(i).getLatitude());
            lockerCluster.setLongitude(lockerClusters.get(i).getLongitude());

            lockerClustersList.add(lockerCluster);
        }

        return lockerClustersList;
    }

    @Override
    public LockerClusterDto updateLockerCluster(Long lockerClusterId, LockerClusterDto lockerCluster) {

        LockerCluster updatedLockerCluster = lockerClusterRepository.findById(lockerClusterId)
                .orElseThrow(() -> new ResourceNotFoundException("Invalid cluster Id!"));

        updatedLockerCluster.setClusterName(lockerCluster.getClusterName());
        updatedLockerCluster.setLockerClusterDescription(lockerCluster.getLockerClusterDescription());

        updatedLockerCluster.setTotalNumberOfLockers(lockerCluster.getTotalNumberOfLockers());
        updatedLockerCluster.setAvailableNumberOfLockers(lockerCluster.getTotalNumberOfLockers());

        // locker location
        updatedLockerCluster.setLatitude(lockerCluster.getLatitude());
        updatedLockerCluster.setLongitude(lockerCluster.getLongitude());

        lockerClusterRepository.save(updatedLockerCluster);

        // set the dto
        lockerCluster.setId(updatedLockerCluster.getId());
        lockerCluster.setClusterName(updatedLockerCluster.getClusterName());
        lockerCluster.setLockerClusterDescription(updatedLockerCluster.getLockerClusterDescription());
        lockerCluster.setTotalNumberOfLockers(updatedLockerCluster.getTotalNumberOfLockers());
        lockerCluster.setAvailableNumberOfLockers(updatedLockerCluster.getAvailableNumberOfLockers());
        lockerCluster.setLatitude(updatedLockerCluster.getLatitude());
        lockerCluster.setLongitude(updatedLockerCluster.getLongitude());

        return lockerCluster;
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
