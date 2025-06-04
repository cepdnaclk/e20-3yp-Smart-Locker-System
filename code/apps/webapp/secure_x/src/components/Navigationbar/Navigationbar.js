import React from "react";
import { Link } from "react-router-dom";
import {LayoutDashboard , UserCog ,Binoculars,MapPinned,ChartColumn,ShieldUser,LogOut } from 'lucide-react';
import "./Navigationbar.css"; 
// <li><Link to="/lockerconfig">Locker Configuration</Link></li> 
const Navbar = () => {
  return (
    <nav className="navbar">
      <div className="logo">Secure X</div>
      <ul className="nav-links">
        <li> <Link to="/dashboard"><LayoutDashboard/>  Dashboard</Link></li>
        <li>  <Link to="/usermanage"><UserCog />  User Management</Link></li>
        <li> <Link to="/lockermonitoring"><Binoculars />  Locker Monitoring</Link></li>
        
        <li><Link to="/map"><MapPinned/>  Map</Link></li>
        <li><Link to="/randa"><ChartColumn />  Reports & Analytics</Link></li>
        <li><Link to="/adminmanage"><ShieldUser />  Admin Management</Link></li>
        <li style={{backgroundColor :'red', color:'white'} }><Link to="/home"><LogOut />  Log Out</Link></li>
      </ul>
    </nav>
  );
};

export default Navbar;
