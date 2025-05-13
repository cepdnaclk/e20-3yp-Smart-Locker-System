import React, { useState, useEffect } from 'react';
import { getLockerUsresData, deletLockeUsresData } from '../../Services/api.js';

const LockerUsers = () => {
  const [users, setUsers] = useState([]);

  // Fetch locker users
  const handleLockerUsers = async () => {
    console.log("Fetching all user data");
    try {
      const response = await getLockerUsresData();
      const lockerUsers = response.data; // Adjust this line if you need to filter users
      setUsers(lockerUsers);
      console.log(response);
    } catch (error) {
      console.error('Error fetching users:', error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Delete user function
  const deleteLockerUser = async (id) => {
    try {
      await deletLockeUsresData(id);
      alert(`User deleted with ID: ${id}`);
      // Refresh the list after deleting
      handleLockerUsers();
    } catch (error) {
      console.error(`Error deleting user: ${id}`, error);
      alert(`Error deleting user: ${id}`);
    }
  };

  // Load users when the component mounts
  useEffect(() => {
    handleLockerUsers();
  }, []);

  
    return (
      <div>
        <h2>Locker Users</h2>
        <button onClick={handleLockerUsers}>Get Data</button>
  
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
                  <button style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }} onClick={() => deleteLockerUser(user.id)}>
                    Delet
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>);
}

export default LockerUsers
