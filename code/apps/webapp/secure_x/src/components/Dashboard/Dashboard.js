
import React,{ useEffect } from 'react';
//import Sidebar from '../SideBar/SideBar.js';
import Navbar from '../Navigationbar/Navigationbar.js';
import './Dashboard.css'; // Import a CSS file for layout styling
import TabBlack from '../Tabs/Black/TabBlack.js';
import TabWhite from '../Tabs/White/TabWhite.js';

const Dashboard = () => {
  useEffect(() => {
    alert("Welcome to the Dashboard! \nThis is your main dashboard area.");
  }, [])
  return (
    <div className="dashboard-container">
      
      <div className="dashboard-content">
        <Navbar/>
        <div className="main-content">
          <h1>Dashboard</h1>
          <div className='Tablist'>
            <TabBlack text={"Active users "} number={25} />
            <TabBlack text={"Total users "} number={150} />
            <TabBlack text={"Active lockers "} number={40} />
            <TabBlack text={"Total lockers "} number={50} />
          </div>
          
            <h2>Alerts:</h2>
            <div className='Tablist' >
              <TabWhite text={"Issus"} number={2}/>
              <TabWhite text={"Attention need"} number={2}/>
              <TabWhite text={"Securety alearts"} number={2}/>
            </div>
            <h2> Recent Activity: </h2>
            // have to add table real time updated
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
