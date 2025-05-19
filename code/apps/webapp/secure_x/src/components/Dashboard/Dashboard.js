
import React,{ useEffect ,useState } from 'react';
//import Sidebar from '../SideBar/SideBar.js';
import Navbar from '../Navigationbar/Navigationbar.js';
import './Dashboard.css'; // Import a CSS file for layout styling
import TabBlack from '../Tabs/Black/TabBlack.js';
import TabWhite from '../Tabs/White/TabWhite.js';
import { getLockerUsresData, } from '../Services/api.js';
import { getLockerData,getLockerClusterData } from '../Services/lockerAPI.js';

const Dashboard = () => {
  const [users, setUsers] = useState([]);
  const [admins, setAdmin] = useState([]);
    // Fetch locker users
    const handleLockerUsers = async () => {
      console.log("Fetching all user data");
      try {
        const response = await getLockerUsresData();
        //const lockerUsers = response.data; // Adjust this line if you need to filter users
        const lockerUsers = response.data;//.filter(user => user.role === "USER");
        const lockerAdmin = response.data.filter(user => user.role === "ADMIN");
        setUsers(lockerUsers);
        setAdmin(admins)
        console.log(response);
      } catch (error) {
        console.error('Error fetching users:', error);
        alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
      }
    };

    const [locker, setLocker] = useState([]);
    const [clus, setClus] = useState([]);
    const handleLocker = async () => {
            console.log("Fetching locker cluster data");
            try {
              const response = await getLockerData();
              const response2 = await getLockerClusterData();
              // Adjust the filtering as needed
              const locker = response.data;
              setLocker(locker);
              const cluster =response2.data;
              setClus(cluster);
              console.log("Locker Data:", locker);
            } catch (error) {
              console.error('Error fetching data:', error);
              alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
            }
          };





    useEffect(() => {
      
      const hasVisited = localStorage.getItem("hasVisited");
  
      if (!hasVisited) {
        alert("Welcome to the Dashboard! \nThis is your main dashboard area.");
        localStorage.setItem("hasVisited", "true");
      }
      handleLockerUsers();
      handleLocker();
    }, []);
  return (
    <div className="dashboard-container">
      
      <div className="dashboard-content">
        <Navbar/>
        <div className="main-content">
          <h1>Dashboard</h1>
          <div className='Tablist'>
            <TabBlack text={"Active users "} number={1} />
            <TabBlack text={"Total users "} number={users.length} />
            <TabBlack text={"Locker clusters "} number={clus.length} />
            <TabBlack text={"Total lockers "} number={locker.length} />
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
