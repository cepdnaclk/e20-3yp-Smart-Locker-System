
import React, { useState, useEffect } from "react";
import {
  getPendingUsresData,
  putLockeUsresData,
  rejectPendingUser,
} from "../../Services/api.js";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
} from "@mui/material";
import { Check, Ban, RefreshCw } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";
import "./Newusers.css";


const Newusers = () => {
  const [users, setUsers] = useState([]);
  const [openReject, setOpenReject] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);

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

      alert(`User rejected with ID: ${id}`);
      setOpenReject(false);
      fetchPendingUsers();

    } catch (error) {
      console.error(`Error reject user: ${id}`, error);
      alert(`Error reject user: ${id}`);
    }
  };


  // handel reject btn dialog box
  const handleRejectClick = (user) => {
    setSelectedUser(user);
    setOpenReject(true);
  };

  // fech data whe page load or refesh
  useEffect(() => {
    fetchPendingUsers();
  }, []); // no linter warning now


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
                <td className="ActionF">
                  <Tooltip title="Accept" arrow>
                    <button
                      className="UNLOCKB"
                      onClick={() => acceptPendingUser(user.id)}
                    >
                      <Check size={16} />
                    </button>
                  </Tooltip>
                  <Tooltip title="Reject" arrow>
                    <button
                      className="DELETB"
                      onClick={() => handleRejectClick(user.id)}
                    >
                      <Ban size={16} />
                    </button>
                  </Tooltip>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <div>
          {/* reject DIALOG */}
          <Dialog
            className="PendingDialog"
            open={openReject}
            onClose={() => setOpenReject(false)}
          >
            <DialogTitle className="DTital">Reject Pending User! </DialogTitle>
            <DialogContent>
              <p> Are you sure reject this pending user?</p>
              <p>
                ID - <i> {selectedUser}</i>
              </p>
              {/* <p>
                First Name - <i> {selectedUser?.firstName}</i>
              </p> */}
            </DialogContent>
            <DialogActions className="dialog-actions">
              <button className="CANCELB" onClick={() => setOpenReject(false)}>
                Cancel
              </button>
              <button
                className="DELETEB"
                onClick={() => rejectPendingUsers(selectedUser)}
                variant="contained"
              >
                Reject
              </button>
            </DialogActions>
          </Dialog>
        </div>

      </div>
    </div>
  );
};

export default Newusers;
