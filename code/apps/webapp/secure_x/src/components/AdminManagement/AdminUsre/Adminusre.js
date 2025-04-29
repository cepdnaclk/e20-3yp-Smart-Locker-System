import React, { useState, useEffect } from "react";
import { getLockerUsresData } from "../../Services/api";

const Adminusre = () => {
   const [admins, setAdmin] = useState([]);
     // Default to empty object
  
    const handleLockerAdmin = async () => {  // No event parameter (e)
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
        <table border="1" style={{ width: '100%', marginTop: '10px', borderCollapse: 'collapse' }}>
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
                <td>
                  <button onClick>Edit</button>
                  <button style={{ marginLeft: '10px', backgroundColor: 'red', color: 'white' }}>
                    Delet
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>);
}

export default Adminusre
