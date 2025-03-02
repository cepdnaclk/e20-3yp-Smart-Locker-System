import React from "react";
import { Link } from "react-router-dom";
import "./Navigationbar.css"; 

const Navbar = () => {
  return (
    <nav className="navbar">
      <div className="logo">Secure X</div>
      <ul className="nav-links">
        <li><Link to="/dashboard">Dashboard</Link></li>
        <li><Link to="/usermanage">User Management</Link></li>
        <li><Link to="/lockermonitoring">Locker Monitoring</Link></li>
        <li><Link to="/lockerconfig">Locker Configuration</Link></li>
        <li><Link to="/randa">Reports & Analytics</Link></li>
        <li><Link to="/adminmanage">Admin Management</Link></li>
      </ul>
    </nav>
  );
};

export default Navbar;
