import React, { useState } from "react";
import Navbar from "../Navigationbar/Navigationbar";
import "./UserManagement.css";
import Newusres from './Newusers/Newusres.js'

const UserManagement = () => {
  
  return ( 
    <div>
      <Navbar />
      <div className="Um1">
        <h1>User Management Page</h1>
        <div className="header">
          <Newusres/>
        </div>

        
              
      </div>
    </div>
  );
};

export default UserManagement;
