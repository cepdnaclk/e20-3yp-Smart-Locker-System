import React, { useState, useEffect } from "react";
import { getLockerUsresData } from "../../Services/api";
import "../../TableStyle/Table.css";
import "../../Button/Button.css";
import { SquarePen, Trash2 } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";

const Adminusre = () => {
  const [admins, setAdmin] = useState([]);
  // Default to empty object

  const handleLockerAdmin = async () => {
    // No event parameter (e)
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
    handleLockerAdmin(); // Fetch admin data on component mount
  }, []);

  return (
    <div>
      <h2>Admin Users</h2>
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
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {admins.map((user) => (
            <tr key={user.id}>
              <td>{user.id}</td>
              <td>{user.regNo}</td>
              <td>{user.firstName}</td>
              <td>{user.lastName}</td>
              <td>{user.contactNumber}</td>
              <td>{user.email}</td>
              <td>Locker {user.role}</td>
              <td className="ActionB">
                <Tooltip
                  title="Edit"
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
                  <button className="EDITB" onClick>
                    <SquarePen size={16} />
                  </button>
                </Tooltip>
                <Tooltip
                  title="Delet"
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
                  <button className="DELETB">
                    <Trash2 size={16} />
                  </button>
                </Tooltip>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default Adminusre;
