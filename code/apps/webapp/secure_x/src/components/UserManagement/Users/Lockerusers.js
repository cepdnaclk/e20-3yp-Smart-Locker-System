import React, { useState, useEffect } from "react";
import { SquarePen, Trash2, RefreshCw, Search, X, Save } from "lucide-react";
import {
  getLockerUsresData,
  deletLockeUsresData,
  findUserByID,
  updateLockerUser,
} from "../../Services/api.js";
import {
  Button,
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from "@mui/material";
import Tooltip from "@mui/material/Tooltip";
import "./Lockerusers.css";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";
const LockerUsers = () => {
  const [users, setUsers] = useState([]);
  const [username, setUsername] = useState("");
  const [openEdit, setOpenEdit] = useState(false);
  const [openDelet, setOpenDelet] = useState(false);
  const [selectedUser, setSelectedUser] = useState(null);
  // Fetch locker users
  const handleLockerUsers = async () => {
    console.log("Fetching all user data");
    try {
      const response = await getLockerUsresData();
      //const lockerUsers = response.data; // Adjust this line if you need to filter users
      const lockerUsers = response.data.filter((user) => user.role === "USER");
      setUsers(lockerUsers);
      console.log(response);
    } catch (error) {
      console.error("Error fetching users:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Delete user function
  const deleteLockerUser = async (id) => {
    try {
      await deletLockeUsresData(id);
      alert(`User deleted with ID: ${id}`);
      setOpenDelet(false);
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
      const lockerUsers = Array.isArray(response.data)
        ? response.data
        : [response.data];
      setUsers(lockerUsers);
      console.log(response);
      // alert(`User Finding with ID: ${id}`);
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

  const handleDeleteClick = (user) => {
    setSelectedUser(user);
    setOpenDelet(true);
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
      console.error("Update error:", error);
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
      <div className="ActionB">
        <Tooltip
          title="Refresh"
          arrow
          componentsProps={{
            tooltip: {
              sx: { fontSize: "12px", backgroundcolor: "black", color: "#fff" },
            },
          }}
        >
          <button className="ADDB" onClick={handleLockerUsers}>
            <RefreshCw size={16} />
          </button>
        </Tooltip>
        <div className="SearchB">
          <input
            className="inputS"
            type="text"
            placeholder="Enter username...."
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
          <Tooltip
            title="Search user"
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
            <button className="ADDB" onClick={() => findLockerUser(username)}>
              <Search size={16} />
            </button>
          </Tooltip>
        </div>
      </div>

      <table className="Ctable">
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
              <td className="ActionF">
                <Tooltip
                  title="Edit User"
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
                  <button
                    className="EDITB"
                    onClick={() => handleEditClick(user)}
                  >
                    <SquarePen size={16} />
                  </button>
                </Tooltip>
                <Tooltip
                  title="Delete User"
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
                  <button
                    className="DELETB"
                    onClick={() => handleDeleteClick(user)}
                  >
                    <Trash2 size={16} />
                  </button>
                </Tooltip>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
      <div>
        {/* DELET DIALOG */}
        <Dialog
          className="DileteDialog"
          open={openDelet}
          onClose={() => setOpenDelet(false)}
        >
          <DialogTitle className="DTital">Delet User! </DialogTitle>
          <DialogContent>
            <p> Are you sure delet this user?</p>
            <p>
              ID - <i> {selectedUser?.id}</i>
            </p>
            <p>
              First Name - <i> {selectedUser?.firstName}</i>
            </p>
          </DialogContent>
          <DialogActions className="dialog-actions">
            <button className="CANCELB" onClick={() => setOpenDelet(false)}>
              Cancel
            </button>
            <button
              className="DELETEB"
              onClick={() => deleteLockerUser(selectedUser?.id)}
              variant="contained"
            >
              Delete User
            </button>
          </DialogActions>
        </Dialog>
      </div>
      <div>
        {/* EDIT DIALOG */}
        <Dialog
          className="dialogbox"
          open={openEdit}
          onClose={() => setOpenEdit(false)}
        >
          <DialogTitle className="DTital">Edit User </DialogTitle>
          <div className="trance"></div>
          <DialogContent className="dialog-content">
            <TextField
              label="User id"
              name="UserId"
              variant="outlined"
              className="no-border"
              value={selectedUser?.id + "     can't change"}
              disabled
              InputProps={{
                style: { fontStyle: "italic" },
              }}
            />
            <TextField
              label="First Name"
              name="firstName"
              variant="outlined"
              className="no-border"
              value={selectedUser?.firstName || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Last Name"
              name="lastName"
              variant="outlined"
              className="no-border"
              value={selectedUser?.lastName || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Contact Number"
              name="contactNumber"
              variant="outlined"
              className="no-border"
              value={selectedUser?.contactNumber || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Email"
              name="email"
              variant="outlined"
              className="no-border"
              value={selectedUser?.email || ""}
              onChange={handleEditChange}
            />
            {/* <FormControl>
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
    </FormControl> */}
          </DialogContent>

          <DialogActions className="dialog-actions">
            <button className="DELETB" onClick={() => setOpenEdit(false)}>
              <X size={20} />
            </button>
            <button
              className="UNLOCKB"
              onClick={handleEditSave}
              variant="contained"
            >
              <Save size={20} />
            </button>
          </DialogActions>
        </Dialog>
      </div>
    </div>
  );
};

export default LockerUsers;
