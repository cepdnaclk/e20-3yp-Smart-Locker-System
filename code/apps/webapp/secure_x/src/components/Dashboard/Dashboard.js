
import React,{ useEffect } from 'react';
//import Sidebar from '../SideBar/SideBar.js';
import Navbar from '../Navigationbar/Navigationbar.js';
import './Dashboard.css'; // Import a CSS file for layout styling

const Dashboard = () => {
  useEffect(() => {
    alert("Welcome to the Dashboard! \nThis is your main dashboard area.");
  }, [])
  return (
    <div className="dashboard-container">
      <Navbar />
      
      <div className="dashboard-content">
         
        <div className="main-content">
          <h1>Dahboard</h1>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
