import React, { useState, useEffect } from 'react';
import { getLockerUsresData, deletLockeUsresData,findUserByID,updateLockerUser } from '../../Services/api.js';
import { Button, TextField,  Dialog, DialogTitle, DialogContent,DialogActions,FormControl,
  InputLabel,
  Select,
  MenuItem} from '@mui/material';
import'./Lockerusers.css';
const LockerUsers = () => {
  const [users, setUsers] = useState([]);
  const [username, setUsername] = useState("");
  const [openEdit, setOpenEdit] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  // Fetch locker users
  const handleLockerUsers = async () => {
    console.log("Fetching all user data");
    try {
      const response = await getLockerUsresData();
      //const lockerUsers = response.data; // Adjust this line if you need to filter users
      const lockerUsers = response.data;//.filter(user => user.role === "USER");
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
  // find user function
  const findLockerUser = async (id) => {
    try {
      setUsers([]);
      const response = await findUserByID(id);
      const lockerUsers = Array.isArray(response.data) ? response.data : [response.data];
      setUsers(lockerUsers);
      console.log(response);
      alert(`User Finding with ID: ${id}`);
      
    } catch (error) {
      console.error(`Error Finding user: ${id}`, error);
      alert(`Error Finding user: ${id}`);
    }
  };
  // 
   const handleEditClick = (user) => {
    setSelectedUser(user);
    setOpenEdit(true);
  };

  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setSelectedUser({ ...selectedUser, [name]: value });
  };

  const handleEditSave = async () => {
    try {
      await updateLockerUser(selectedUser.id, selectedUser); // Replace with your actual update function
      setOpenEdit(false);
      handleLockerUsers(); // Refresh data
    } catch (error) {
      console.error('Update error:', error);
      alert("Failed to update user");
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
        <div>
          <input
              type="text"
              placeholder="Enter your username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          <button onClick={() => findLockerUser(username)}>Find user</button>  
        </div>
        
  
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
                  <Button onClick={() => handleEditClick(user)}>Edit</Button>
                  <button style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }} onClick={() => deleteLockerUser(user.id)}>
                    Delet
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
            <div className='dialogbox'>
              <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
  <DialogTitle>Edit User</DialogTitle>
  
  <DialogContent className="dialog-content">
    <TextField
      label="First Name" name="firstName" variant="outlined" className="no-border"
      value={selectedUser?.firstName || ""} onChange={handleEditChange}
    />
    <TextField
      label="Last Name" name="lastName" variant="outlined" className="no-border"
      value={selectedUser?.lastName || ""} onChange={handleEditChange}
    />
    <TextField
      label="Contact Number" name="contactNumber" variant="outlined" className="no-border"
      value={selectedUser?.contactNumber || ""} onChange={handleEditChange}
    />
    <TextField
      label="Email" name="email" variant="outlined" className="no-border"
      value={selectedUser?.email || ""} onChange={handleEditChange}
    />
    <FormControl>
      <InputLabel>Role</InputLabel>
      <Select
        name="role"
        value={selectedUser?.role || ""}
        onChange={handleEditChange}
        label="Role"
      >
        <MenuItem value="USER">USER</MenuItem>
        <MenuItem value="ADMIN">ADMIN</MenuItem>
        <MenuItem value="MANAGER">MANAGER</MenuItem>
      </Select>
    </FormControl>
  </DialogContent>

  <DialogActions className="dialog-actions">
    <Button onClick={() => setOpenEdit(false)}>Cancel</Button>
    <Button onClick={handleEditSave} variant="contained">Save</Button>
  </DialogActions>
</Dialog>


            </div>
        
      </div>);
}

export default LockerUsers
