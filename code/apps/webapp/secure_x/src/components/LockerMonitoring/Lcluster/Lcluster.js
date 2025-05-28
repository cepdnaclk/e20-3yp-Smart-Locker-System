import React, { useState, useEffect } from 'react';
import { getLockerClusterData } from '../../Services/lockerAPI';
import '../../Button/Button.css'
import '../../TableStyle/Table.css'
import { SquarePen,Trash2,Grid2x2Plus } from 'lucide-react';
import Tooltip from '@mui/material/Tooltip';
const Lcluster = () =>  {

  
    const [cluster, setClusters] = useState([]);
  
    // Fetch locker users
    const handleLockerCluster = async () => {
    console.log("Fetching locker cluster data");
    try {
      const response = await getLockerClusterData();
      // Adjust the filtering as needed
      const lockerClusters = response.data;
      setClusters(lockerClusters);
      console.log("Cluster Data:", lockerClusters);
    } catch (error) {
      console.error('Error fetching data:', error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Fetch data when the component mounts
  useEffect(() => {
    handleLockerCluster();
  }, []);

  return (
    <div>
      <h2>Locker Clusters</h2>
      <div className='ActionB'>
        <Tooltip title="Add Cluster" arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
          <button className='ADDB'>
          <Grid2x2Plus size={20}/>
         </button>
        </Tooltip>
         
         
      </div>
      
      <table className='Ctable'>
        <thead>
          <tr> 
            <th>ID</th>
            <th>Total locker count</th>
            <th>Avalable locker count</th>
            <th>Name</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {cluster.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.totalNumberOfLockers}</td>
              <td>{user.availableNumberOfLockers}</td>
              <td>{user.clusterName}</td>
              <td>{user.lockerClusterDescription}</td>
              <td  className='ActionF'arrow >
                <Tooltip title = 'Edit'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='EDITB' onClick> <SquarePen size={16}/></button>
                </Tooltip>
                <Tooltip title = 'Delet'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button onClick className='DELETB'><Trash2 size={16}/></button>
                </Tooltip>
                
                
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default Lcluster;