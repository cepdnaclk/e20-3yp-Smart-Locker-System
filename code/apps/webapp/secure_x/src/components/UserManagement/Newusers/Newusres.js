import React, { useState, useEffect } from "react";
import {
  getPendingUsresData,
  putLockeUsresData,
  rejectPendingUser,
} from "../../Services/api.js";
import { Check, Ban, RefreshCw } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";

const Newusers = () => {
  const [users, setUsers] = useState([]);

  // Fetch pending users
  const fetchPendingUsers = async () => {
    try {
      const response = await getPendingUsresData();
      const data = response.data;
      setUsers(data);
      if (!data || data.length === 0) {
        alert("No pending users");
      }
    } catch (error) {
      console.error("Error fetching users:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Accept user function
  const acceptPendingUser = async (id) => {
    try {
      await putLockeUsresData(id);
      alert(`User accepted with ID: ${id}`);
      fetchPendingUsers(); // no need to fake Event
    } catch (error) {
      console.error(`Error accepting user: ${id}`, error);
      alert(`Error accepting user: ${id}`);
    }
  };

  // Reject user function
  const rejectPendingUsers = async (id) => {
    try {
      await rejectPendingUser(id);
      alert(`User rejected with ID: ${id}`);
      fetchPendingUsers();
    } catch (error) {
      console.error(`Error rejecting user: ${id}`, error);
      alert(`Error rejecting user: ${id}`);
    }
  };

  useEffect(() => {
    fetchPendingUsers();
  }, []); // no linter warning now

  return (
    <div className="WindowPU">
      <div className="WindowPU_t">
        <h2>Pending Users</h2>
        <div className="ActionB">
          <Tooltip
            title="Refresh"
            arrow
            componentsProps={{
              tooltip: {
                sx: {
                  fontSize: "12px",
                  backgroundcolor: "black",
                  color: "#fff",
                },
              },
            }}
          >
            <button className="ADDB" onClick={fetchPendingUsers}>
              <RefreshCw size={16} />
            </button>
          </Tooltip>
        </div>

        <table className="Ctable">
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
                      onClick={() => rejectPendingUsers(user.id)}
                    >
                      <Ban size={16} />
                    </button>
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
