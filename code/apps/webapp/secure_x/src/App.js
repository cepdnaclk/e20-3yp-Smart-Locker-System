import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import logo from './img/logo.png';
import './App.css';
import Loginsignup from './components/loginsignup/Loginsignup.js'; // Capitalize component names
import NavigateButton from './components/Button/NavigateButton.js';
import Success from './components/loginsignup/Success.js';
import Dashboard from './components/Dashboard/Dashboard.js';
import LockerConfiguration from "./components/LockerConfiguration/LockerConfiguration.js";
import UserManagement from "./components/UserManagement/UserManagement.js";
import LockerMonitoring from "./components/LockerMonitoring/LockerMonitoring.js";
import ReportAnaytics from "./components/ReportandAnaytics/ReportandAnaytics.js";
import AdminManagement from "./components/AdminManagement/AdminManagement.js";
function Home() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h3>Secure X - Smart Locker System</h3>
        <NavigateButton to="/login" text="LOG IN >" />
      </header>
    </div>
  );
}

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/login" element={<Loginsignup />} />
        <Route path="/success" element={<Success />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/usermanage" element={<UserManagement />} />
        <Route path="/lockermonitoring" element={<LockerMonitoring />} />
        <Route path="lockerconfig" element={<LockerConfiguration />} />
        <Route path="/randa" element={<ReportAnaytics />} />
        <Route path="/adminmanage" element={<AdminManagement />} />
      </Routes>
    </Router>
  );
}

export default App;
