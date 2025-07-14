import {
  BrowserRouter as Router,
  Routes,
  Route,
  useNavigate,
} from "react-router-dom";
import "./App.css";
import Login from "./components/loginsignup/Login.js";
import Signup from "./components/loginsignup/Signup.js";
import Success from "./components/loginsignup/Success.js";
import Dashboard from "./components/Dashboard/Dashboard.js";
import LockerConfiguration from "./components/LockerConfiguration/LockerConfiguration.js";
import UserManagement from "./components/UserManagement/UserManagement.js";
import LockerMonitoring from "./components/LockerMonitoring/LockerMonitoring.js";
import ReportAnaytics from "./components/ReportandAnaytics/ReportandAnaytics.js";
import AdminManagement from "./components/AdminManagement/AdminManagement.js";
import Map from "./components/Map/Map_page.js";
import Hm from "./components/Home/Home.js";
import User from "./components/Usercontrol/User.js";
import Fogot from "./components/loginsignup/fogotp.js";
function Home() {
  const navigate = useNavigate();
  return (
    <div className="container">
      {/* Header */}
      <div className="headflex">
        <h2 className="logo">Secure X</h2>
        <div className="hedbtnflex">
          <button className="btnlogin" onClick={() => navigate("/login")}>
            LOG IN
          </button>
          <button className="btnJoin" onClick={() => navigate("/signup")}>
            Join now
          </button>
        </div>
      </div>
      {/* Main Content */}
      <main className="main">
        <div className="text-box">
          <h2>Secure X - Smart Locker System</h2>
          <p>
            The Secure X Locker System is an IoT-based solution for secure
            storage in shared spaces like universities, gyms, and offices. Users
            can check real-time availability via a mobile or web app and get
            suggestions for nearby lockers when locations are full.
          </p>
          <p>
            Access is secured with a fingerprint sensor, and users can reserve
            lockers and receive notifications. Administrators can manage locker
            usage through a centralized dashboard, reducing theft risks and
            optimizing storage.
          </p>
        </div>
      </main>
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
        <Route path="/hm" element={<Hm />} />
        <Route path="/usercontrol" element={<User />} />
        <Route path="/fogotpass" element={<Fogot />} />
      </Routes>
    </Router>
  );
}

export default App;
