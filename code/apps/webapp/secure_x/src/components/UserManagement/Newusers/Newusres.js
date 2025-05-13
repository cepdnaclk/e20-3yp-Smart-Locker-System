import React, { useState, useEffect } from 'react';
import { getPendingUsresData, putLockeUsresData,rejectPendingUser } from '../../Services/api.js';

const Newusers = () => {
  const [users, setUsers] = useState([]);

  // Fetch pending users
  const handlePendingUsers = async (e) => {
    e.preventDefault();
    try {
      const response = await getPendingUsresData();
      setUsers(response.data);
      if(users == null){
        alert('No pending users');
      }
    } catch (error) {
      console.error('Error fetching users:', error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Accept user function
  const acceptPendingUser = async (id) => {
    try {
      await putLockeUsresData(id);
      alert(`User accepted with ID: ${id}`);
      // Refresh the list after accepting
      handlePendingUsers(new Event('fetch'));
    } catch (error) {
      console.error(`Error accepting user: ${id}`, error);
      alert(`Error accepting user: ${id}`);
    }
  };
  
  // reject user function
  const rejectPendingUsers = async (id) => {
    try {
      await rejectPendingUser(id);
      alert(`User reject with ID: ${id}`);
      // Refresh the list after accepting
      handlePendingUsers(new Event('fetch'));
    } catch (error) {
      console.error(`Error reject user: ${id}`, error);
      alert(`Error reject user: ${id}`);
    }
  };

  return (
    <div>
      <h2>Pending Users</h2>
      <button onClick={handlePendingUsers}>Get Data</button>

      <table border="1" style={{ width: '100%', marginTop: '10px', borderCollapse: 'collapse' }}>
        <thead>
          <tr> 
            <th>ID</th>
            <th>Reg No</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Contact Number</th>
            <th>Email</th>
            <th>Role</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.regNo}</td>
              <td>{user.firstName}</td>
              <td>{user.lastName}</td>
              <td>{user.contactNumber}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>
              <td>{user.status}</td>
              <td>
                <button onClick={() => acceptPendingUser(user.id)}>Accept</button>
                <button onClick={() => rejectPendingUsers(user.id)} style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }}>
                  Reject
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Newusers;
