
import React,{ useEffect } from 'react';
//import Sidebar from '../SideBar/SideBar.js';
import Navbar from '../Navigationbar/Navigationbar.js';
import './Dashboard.css'; // Import a CSS file for layout styling
import TabBlack from '../Tabs/Black/TabBlack.js';
import TabWhite from '../Tabs/White/TabWhite.js';


const Dashboard = () => {
    useEffect(() => {
      const hasVisited = localStorage.getItem("hasVisited");
  
      if (!hasVisited) {
        alert("Welcome to the Dashboard! \nThis is your main dashboard area.");
        localStorage.setItem("hasVisited", "true");
      }
    }, []);
  return (
    <div className="dashboard-container">
      
      <div className="dashboard-content">
        <Navbar/>
        <div className="main-content">
          <h1>Dashboard</h1>
          <div className='Tablist'>
            <TabBlack text={"Active users "} number={"--"} />
            <TabBlack text={"Total users "} number={"--"} />
            <TabBlack text={"Active lockers "} number={1} />
            <TabBlack text={"Total lockers "} number={1} />
          </div>
          
            <h2>Alerts:</h2>
            <div className='Tablist' >
              <TabWhite text={"Issus"} number={"--"}/>
              <TabWhite text={"Attention need"} number={"--"}/>
              <TabWhite text={"Securety alearts"} number={"--"}/>
            </div>
            <h2> Recent Activity: </h2>
            <div className='TablistH' >
              <TabWhite text={"Check pending users "} number={"--"} />
            </div>
            
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
