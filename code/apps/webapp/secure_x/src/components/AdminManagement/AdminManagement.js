import React, { useState, useEffect } from "react";
import { getLockerUsresData, findUserByID } from "../Services/api";
import { updateLockerUserS } from "../Services/SupperAdminAPI.js";
import { useNavigate } from "react-router-dom";
import Navbar from "../Navigationbar/Navigationbar";
import "./AdminManagement.css";
import { FormControl, InputLabel, Select, MenuItem } from "@mui/material";

import ShowUserData from "../Tabs/Width/WidthFullUserData.js";
import Adminusre from "./AdminUsre/Adminusre.js";

const AdminManagement = () => {
  const [admins, setAdmin] = useState([]);

  const [adminU, setAdminU] = useState({}); // Default to empty object
  const [adminP, setAdminP] = useState({}); // pending admin data
  const [adminPID, setAdminPID] = useState(); // pending admin data

  const handleLockerAdmin = async () => {
    // No event parameter (e)
    try {
      const response = await getLockerUsresData();
      const adminUsers = response.data.filter((user) => user.role === "ADMIN");
      setAdmin(adminUsers);

      const currentUser = response.data.find(
        (user) => String(user.id) === localStorage.getItem("User")
      );
      setAdminU(currentUser || {}); // Store object or empty if not found
    } catch (error) {
      console.error("Error fetching users:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  const handleSearchingUser = async () => {
    try {
      const response = await findUserByID(adminPID);
      setAdminP(response.data);
    } catch (error) {
      console.error("Error fetching searched user:", error);
      alert("User not found or invalid request.");
    }
  };

  // Add searched user as admin (dummy logic – no API call yet)
  const handleAddAdmin = async () => {
    if (adminU.role !== "SUPER_ADMIN") {
      alert("You do not have permission to add a new admin.");
      return;
    }

    if (!adminP || !adminP.id) {
      alert("Please search and select a valid user first.");
      return;
    }

    try {
      const response = await updateLockerUserS(adminPID, adminP);
      console.log("Adding new admin:", adminP.id);
      alert(
        `Admin privileges granted to ${adminP.firstName} ${adminP.lastName}`
      );
    } catch (error) {
      console.error("Error fetching searched user:", error);
      alert("User not found or invalid request.");
    }
  };

  useEffect(() => {
    handleLockerAdmin(); // Fetch admin data on component mount
  }, []);
  const navigate = useNavigate();

  return (
    <div>
      <Navbar />
      <div className="Am1">
        <h1>Admin Management </h1>
        <div className="Adminrow">
          <div className="admin-profile-container">
            {adminU.id && (
              <>
                <h2 className="admin-profile-title">Admin Profile</h2>
                <p>
                  <strong>ID:</strong> {adminU.id}
                </p>
                <p>
                  <strong>Name:</strong> {adminU.firstName} {adminU.lastName}
                </p>
                <p>
                  <strong>Email:</strong> {adminU.email}
                </p>
                <p>
                  <strong>Contact No:</strong> {adminU.contactNumber}
                </p>
                <p>
                  <strong>Role:</strong> {adminU.role}
                </p>
              </>
            )}

            <div className="flex-right">
              <button
                className="Admin-caontol-Btn2"
                onClick={() => navigate("/usercontrol")}
              >
                edit
              </button>
            </div>
          </div>

          <div className="admin-profile-container">
            <h2 className="admin-profile-title">Add Admin</h2>

            <p>
              <strong>Search ID:</strong>
            </p>
            <input
              type="text"
              className="admin-search-input"
              onChange={(e) => setAdminPID(e.target.value)}
              placeholder="Ex: XYYZZZ"
            />
            <button className="Admin-caontol-Btn" onClick={handleSearchingUser}>
              Search
            </button>

            {adminP && adminP.id && (
              <>
                <p>
                  <strong>Name:</strong> {adminP.firstName} {adminP.lastName}
                </p>
                <p>
                  <strong>Email:</strong> {adminP.email}
                </p>

                <FormControl
                  fullWidth
                  size="small"
                  style={{ marginTop: "10px" }}
                >
                  <InputLabel id="role-select-label">Role</InputLabel>
                  <Select
                    labelId="role-select-label"
                    name="role"
                    value={adminP.role || ""}
                    onChange={(e) =>
                      setAdminP((prev) => ({ ...prev, role: e.target.value }))
                    }
                    label="Role"
                  >
                    <MenuItem value="USER">USER</MenuItem>
                    <MenuItem value="ADMIN">ADMIN</MenuItem>
                  </Select>
                </FormControl>
              </>
            )}

            <p>
              <strong>Status: </strong>
              {adminU.role === "SUPER_ADMIN"
                ? "You have access"
                : "You are not eligible"}
            </p>
            <div className="flex-right">
              <button className="Admin-caontol-Btn2" onClick={handleAddAdmin}>
                Add
              </button>
            </div>
          </div>
        </div>

        {/* {adminU.id && ( // Only render if adminU has a valid ID
          <ShowUserData
            firstname={adminU.firstName}
            lastname={adminU.lastName}
            id={adminU.id}
            email={adminU.email}
            contacNo={adminU.contactNumber}
            role={adminU.role}
          />
        )} */}

        <Adminusre user={admins} />
      </div>
    </div>
  );
};

export default AdminManagement;
