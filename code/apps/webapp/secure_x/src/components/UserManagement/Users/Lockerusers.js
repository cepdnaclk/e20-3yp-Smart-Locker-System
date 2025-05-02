import React, { useState, useEffect } from 'react';
import { getLockerUsresData, putLockeUsresData,deletLockeUsresData } from '../../Services/api.js';

const Lockerusers = () => {
  const [users, setUsers] = useState([]);
   
    // Fetch pending users
    const handLeockerUsers = async (e) => {
      e.preventDefault();
      try {
        const response = await getLockerUsresData();
        const lockerUsers = response.data.filter((user) => user.role === "USER");
        setUsers(lockerUsers);
      } catch (error) {
        console.error('Error fetching users:', error);
        alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
      }
    };
    
  
    // Accept user function
    const delettLockerUser = async (id) => {
      try {
        await deletLockeUsresData(id);
        alert(`User delet with ID: ${id}`);
        // Refresh the list after accepting
        handLeockerUsers(new Event('fetch'));
      } catch (error) {
        console.error(`Error delet user: ${id}`, error);
        alert(`Error delet user: ${id}`);
      }
    };
  
    return (
      <div>
        <h2>Locker Users</h2>
        <button onClick={handLeockerUsers}>Get Data</button>
  
        <table border="1" style={{ width: '100%', marginTop: '10px', borderCollapse: 'collapse' }}>
          <thead>
            <tr>
              <th>ID</th>
              <th>First Name</th>
              <th>Last Name</th>
              <th>Contact Number</th>
              <th>Email</th>
              <th>Role</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.id}</td>
                <td>{user.firstName}</td>
                <td>{user.lastName}</td>
                <td>{user.contactNumber}</td>
                <td>{user.email}</td>
                <td>Locker {user.role}</td>
                <td>
                  <button onClick>Edit</button>
                  <button style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }} onClick={delettLockerUser}>
                    Delet
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>);
}

export default Lockerusers
