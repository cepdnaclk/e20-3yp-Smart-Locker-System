import React, { useState } from "react";
import Navbar from "../Navigationbar/Navigationbar";
import "./UserManagement.css";

const UserManagement = () => {
  const [search, setSearch] = useState("");
  const [users, setUsers] = useState([
    { id: 1, name: "John D.", email: "john@email.com", role: "User", locker: "12" },
    { id: 2, name: "Sarah K.", email: "sarah@email.com", role: "Admin", locker: "-" },
  ]);

  const handleDelete = (id) => {
    setUsers(users.filter(user => user.id !== id));
  };

  const filteredUsers = users.filter(user =>
    user.name.toLowerCase().includes(search.toLowerCase()) ||
    user.email.toLowerCase().includes(search.toLowerCase()) ||
    user.role.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div>
      <Navbar />
      <div className="Um1">
        <h1>User Management Page</h1>
        <div className="header">
          <div><input
            type="text"
            placeholder="Search..."
            value={search}
            onChange={(e) => setSearch(e.target.value)}
          /></div>
          <div><button className="add-user">+ Add New User</button></div>

        </div>

        <table>
          <thead>
            <tr>
              <th>Name</th>
              <th>Email</th>
              <th>Role</th>
              <th>Locker</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            {filteredUsers.map((user) => (
              <tr key={user.id}>
                <td>{user.name}</td>
                <td>{user.email}</td>
                <td>{user.role}</td>
                <td>{user.locker}</td>
                <td>
                  <button className="edit">Edit</button>
                  <button className="delete" onClick={() => handleDelete(user.id)}>Delete</button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default UserManagement;
