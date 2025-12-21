import React, { useState, useEffect } from "react";
import { getLockerUsresData } from "../../Services/api";
import {
  deletLockerAdminData,
  updateLockerUserS,
} from "../../Services/SupperAdminAPI";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
} from "@mui/material";
import { SquarePen, Trash2, X, Save } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import "./Adminusre.css";
import "../../TableStyle/Table.css";
import "../../Button/Button.css";

const Adminusre = () => {
  const [admins, setAdmin] = useState([]);
  const [selectedAdmin, setSelectedAdmin] = useState(null);
  const [openEdit, setOpenEdit] = useState(false);
  const [openDelete, setOpenDelete] = useState(false);

  const handleLockerAdmin = async () => {
    try {
      const response = await getLockerUsresData();
      const adminUsers = response.data.filter((user) => user.role === "ADMIN");
      setAdmin(adminUsers);
    } catch (error) {
      console.error("Error fetching Admins:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  useEffect(() => {
    handleLockerAdmin();
  }, []);

  const handleEditClick = (admin) => {
    setSelectedAdmin(admin);
    setOpenEdit(true);
  };

  const handleDeleteClick = (admin) => {
    setSelectedAdmin(admin);
    setOpenDelete(true);
  };

  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setSelectedAdmin({ ...selectedAdmin, [name]: value });
  };

  const handleEditSave = async () => {
    try {
      await updateLockerUserS(selectedAdmin.id, selectedAdmin);
      setOpenEdit(false);
      handleLockerAdmin();
    } catch (error) {
      console.error("Update error:", error);
      alert("Failed to update admin user");
    }
  };

  const handleDeleteConfirm = async () => {
    try {
      await deletLockerAdminData(selectedAdmin.id);
      setOpenDelete(false);
      handleLockerAdmin();
    } catch (error) {
      console.error("Delete error:", error);
      alert("Failed to delete admin user");
    }
  };

  return (
    <div className="WindowPU">
      <div className="WindowPU_t">
        <h2>Admin Users</h2>
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
            {admins.map((admin) => (
              <tr key={admin.id}>
                <td>{admin.id}</td>
                <td>{admin.firstName}</td>
                <td>{admin.lastName}</td>
                <td>{admin.contactNumber}</td>
                <td>{admin.email}</td>
                <td>Locker {admin.role}</td>
                <td className="ActionB">
                  <Tooltip title="Edit">
                    <button
                      className="EDITB"
                      onClick={() => handleEditClick(admin)}
                    >
                      <SquarePen size={16} />
                    </button>
                  </Tooltip>
                  <Tooltip title="Delete">
                    <button
                      className="DELETB"
                      onClick={() => handleDeleteClick(admin)}
                    >
                      <Trash2 size={16} />
                    </button>
                  </Tooltip>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {/* === Delete Dialog === */}
        <Dialog open={openDelete} onClose={() => setOpenDelete(false)}>
          <DialogTitle>Delete Admin User</DialogTitle>
          <DialogContent>
            <p>Are you sure you want to delete this admin?</p>
            <p>ID: {selectedAdmin?.id}</p>
            <p>
              Name: {selectedAdmin?.firstName} {selectedAdmin?.lastName}
            </p>
          </DialogContent>
          <DialogActions>
            <button className="CANCELB" onClick={() => setOpenDelete(false)}>
              Cancel
            </button>
            <button className="DELETEB" onClick={handleDeleteConfirm}>
              Delete
            </button>
          </DialogActions>
        </Dialog>

        {/* === Edit Dialog === */}
        <Dialog open={openEdit} onClose={() => setOpenEdit(false)}>
          <DialogTitle>Edit Admin User</DialogTitle>
          <DialogContent>
            <TextField
              label="First Name"
              name="firstName"
              fullWidth
              margin="dense"
              value={selectedAdmin?.firstName || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Last Name"
              name="lastName"
              fullWidth
              margin="dense"
              value={selectedAdmin?.lastName || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Contact Number"
              name="contactNumber"
              fullWidth
              margin="dense"
              value={selectedAdmin?.contactNumber || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Email"
              name="email"
              fullWidth
              margin="dense"
              value={selectedAdmin?.email || ""}
              onChange={handleEditChange}
            />
          </DialogContent>
          <DialogActions>
            <button className="DELETB" onClick={() => setOpenEdit(false)}>
              <X size={18} />
            </button>
            <button className="UNLOCKB" onClick={handleEditSave}>
              <Save size={18} />
            </button>
          </DialogActions>
        </Dialog>
      </div>
    </div>
  );
};

export default Adminusre;
