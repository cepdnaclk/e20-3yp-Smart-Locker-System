import React, { useState } from "react";
import "./Login.css";
import { login } from "../Services/api.js"; 
import { useNavigate } from "react-router-dom";

const Login = () => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const response = await login(username, password);
      localStorage.setItem("token", response.data);
      alert(`Login succsess: Token ${localStorage.getItem("token")}`);
      navigate("/dashboard");
      localStorage.setItem("hasVisited", 0);
      localStorage.setItem("User", username);
    } catch (error) {
      console.error("Login failed:", error);
      alert("Invalid credentials");
    }
  };

  return (
    <div className="container_login">
      <div className="form-box">
        <h2>SIGN IN</h2>
        <form onSubmit={handleLogin}>
          

          <div className="input-group">
            <label>Username</label>
            <input
              type="text"
              placeholder="Enter your username"
              value={username}
              onChange={(e) => setUsername(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              required
            />
          </div>
          

          <button type="submit">Sign In</button>
        </form>
      </div>
    </div>
  );
};

export default Login;
