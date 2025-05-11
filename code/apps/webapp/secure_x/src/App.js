import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import logo from './img/logo.png';
import './App.css';
import Login from './components/loginsignup/Login.js'; 
import Signup from './components/loginsignup/Signup.js'; 
import NavigateButton from './components/Button/NavigateButton.js';
import NavigateButtonWhite from './components/Button/NavigateButtonWhite.js';
import Success from './components/loginsignup/Success.js';
import Dashboard from './components/Dashboard/Dashboard.js';
import LockerConfiguration from "./components/LockerConfiguration/LockerConfiguration.js";
import UserManagement from "./components/UserManagement/UserManagement.js";
import LockerMonitoring from "./components/LockerMonitoring/LockerMonitoring.js";
import ReportAnaytics from "./components/ReportandAnaytics/ReportandAnaytics.js";
import AdminManagement from "./components/AdminManagement/AdminManagement.js";
import Map from "./components/Map/Map_page.js";
function Home() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h3>Secure X - Smart Locker System</h3>
      </header>
      <div className="Home_buttons">
        <NavigateButton to="/login" text="Sign In" />
        <NavigateButtonWhite to="/signup" text="Sign Up" />
      </div>
    </div>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/success" element={<Success />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/usermanage" element={<UserManagement />} />
        <Route path="/lockermonitoring" element={<LockerMonitoring />} />
        <Route path="lockerconfig" element={<LockerConfiguration />} />
        <Route path="/map" element={<Map />} />
        <Route path="/randa" element={<ReportAnaytics />} />
        <Route path="/adminmanage" element={<AdminManagement />} />
        <Route path="/home" element={<Home />} />
      </Routes>
    </Router>
  );
}

export default App;
