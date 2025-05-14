import React, { useState, useEffect } from 'react';
import { getLockerClusterData } from '../../Services/lockerAPI';

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
      <table border="1" style={{ width: '100%', marginTop: '10px', borderCollapse: 'collapse' }}>
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
              <td>
                <button onClick>Edit</button>
                <button onClick style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }}>
                  Delet
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  )
}

export default Lcluster;