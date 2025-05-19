import React, { useState, useEffect } from 'react';
import { getLockerData } from '../../Services/lockerAPI';
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
    <div>
      <h2>Lockers</h2>
      <table border="1" style={{ width: '100%', marginTop: '10px', borderCollapse: 'collapse' }}>
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
              <td>
                <button onClick>Edit</button>
                <button onClick style={{ marginLeft: '10px', backgroundColor: 'blue', color: 'white' }}>Unlock</button>
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

export default Locker;