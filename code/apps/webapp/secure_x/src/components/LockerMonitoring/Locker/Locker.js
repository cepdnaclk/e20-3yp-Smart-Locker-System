import React, { useState, useEffect } from 'react';
import { getLockerData } from '../../Services/lockerAPI';
import { SquarePen,Trash2,SquarePlus,KeyRound } from 'lucide-react';
import Tooltip from '@mui/material/Tooltip';
import '../../Button/Button.css'
import '../../TableStyle/Table.css'
const Locker = () =>  {

    const [locker, setLocker] = useState([]);
      
        // Fetch locker users
        const handleLocker = async () => {
        console.log("Fetching locker cluster data");
        try {
          const response = await getLockerData();
          // Adjust the filtering as needed
          const locker = response.data;
          setLocker(locker);
          console.log("Locker Data:", locker);
        } catch (error) {
          console.error('Error fetching data:', error);
          alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
        }
      };
    
      // Fetch data when the component mounts
      useEffect(() => {
        handleLocker();
      }, []);

  return (
    <div >
      <h2>Lockers</h2>
      <div className='ActionB'>
          <Tooltip title = 'Add locker'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
            <button className='ADDB'><SquarePlus size={20}/></button>
          </Tooltip>
      </div>
      <table className='Ctable'>
        <thead>
          <tr> 
            <th>LockerID</th>
            <th>Disply Number</th>
            <th>Status</th>
            <th>Locker Log</th>
            <th>Locker Cluster</th>
            
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {locker.map((user) => (
            <tr key={user.lockerId}>
              <td>{user.lockerId}</td>
              <td>{user.displayNumber}</td>
              <td>{user.lockerStatus}</td>
              <td>{user.lockerLogs}</td>
              <td>{user.lockerCluster.id}</td>
              <td className='ActionF'>
                <Tooltip title = 'Edit'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='EDITB'><SquarePen size={16} /></button>
                </Tooltip>
                
                <Tooltip title = 'Unlock'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='UNLOCKB'><KeyRound size={16} /></button>
                </Tooltip>
                
                <Tooltip title = 'Delet'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='DELETB'><Trash2 size={16}/></button>
                </Tooltip>
                
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default Locker;