import React, { useState, useEffect } from "react";
import { getLockerUsresData } from "../Services/api";
import { useNavigate } from "react-router-dom";
import Navbar from "../Navigationbar/Navigationbar";
import "./AdminManagement.css";

import ShowUserData from "../Tabs/Width/WidthFullUserData.js";
import Adminusre from "./AdminUsre/Adminusre.js";

const AdminManagement = () => {
  const [admins, setAdmin] = useState([]);
  const [adminU, setAdminU] = useState({}); // Default to empty object

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

  useEffect(() => {
    handleLockerAdmin(); // Fetch admin data on component mount
  }, []);
  const navigate = useNavigate();

  return (
    <div>
      <Navbar />
      <div className="Am1">
        <h1>Admin Management </h1>

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
          <button className="" onClick={() => navigate("/usercontrol")}>
            edit
          </button>
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
