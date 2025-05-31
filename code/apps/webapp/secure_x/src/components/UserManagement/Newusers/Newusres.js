import React, { useState, useEffect } from 'react';
import { getPendingUsresData, putLockeUsresData,rejectPendingUser } from '../../Services/api.js';
import { Check,Ban,RefreshCw } from 'lucide-react';
import Tooltip  from '@mui/material/Tooltip';
import'../../Button/Button.css'
import '../../TableStyle/Table.css'
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
    <div className='WindowPU'> 
     <div className='WindowPU_t'>
      <h2>Pending Users</h2>
      <div className='ActionB'>
        <Tooltip title = 'Refresh'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
          <button className='ADDB' onClick={handlePendingUsers}><RefreshCw size={16}/></button>
        </Tooltip>
      </div>

      <table className='Ctable'>
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
              <td className='ActionF'>
                <Tooltip title = 'Accept'arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='UNLOCKB' onClick={() => acceptPendingUser(user.id)}><Check size={16}/></button>
                </Tooltip>
                <Tooltip title = 'Reject' arrow componentsProps={{tooltip: {sx: {fontSize: '12px',backgroundcolor:'black',color: '#fff'},},}}>
                  <button className='DELETB' onClick={() => rejectPendingUsers(user.id)} ><Ban size={16}/></button>
                </Tooltip>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      </div>
    </div>
  );
};

export default Newusers;
