import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import logo from './img/logo.png';
import './App.css';
import Loginsignup from './components/loginsignup/Loginsignup.js'; // Capitalize component names
import NavigateButton from './components/Button/NavigateButton.js';

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
      </Routes>
    </Router>
  );
}

export default App;
