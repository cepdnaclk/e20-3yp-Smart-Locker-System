import React, { useState } from "react";
import "./Loginsignup.css";
import { login } from "../Services/api.js"; // Import login API
import { useNavigate } from "react-router-dom";

const Loginsignup = () => {
  const [isLogin, setIsLogin] = useState(true);
  const navigate = useNavigate();
  const [username, setUsername] = useState(""); // Username instead of email
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");

  // Handle Login
  const handleLogin = async (e) => {
    e.preventDefault();
    try { 
      const response =  await login(username, password); // Use username here
      localStorage.setItem("token", response.data);
      alert("Login Successful!");
      navigate("/success");
    } catch (error) {
      console.error("Login failed:", error);
      alert("Invalid credentials");
    }
  };

  // Handle Signup
  const handleSignup = async (e) => {
    e.preventDefault();
    if (password !== confirmPassword) {
      alert("Passwords do not match!");
      return;
    }
    try {
      // Call your backend signup API
      const response = await fetch("http://localhost:8080/auth/signup", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ username, password }), // Send username instead of email
      });

      if (response.ok) {
        alert("Account created successfully! You can now log in.");
        setIsLogin(true); // Switch to login mode
      } else {
        alert("Signup failed. Try again.");
      }
    } catch (error) {
      console.error("Signup error:", error);
      alert("Error creating account.");
    }
  };

  // Toggle Login/Signup Form
  const toggleForm = () => {
    setIsLogin(!isLogin);
  };

  return (
    <div className="container">
      <div className="form-box">
        <h2>{isLogin ? "Login" : "Sign Up"}</h2>

        <form onSubmit={isLogin ? handleLogin : handleSignup}>
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

          {!isLogin && (
            <div className="input-group">
              <label>Confirm Password</label>
              <input
                type="password"
                placeholder="Re-enter Password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
              />
            </div>
          )}

          <button type="submit">{isLogin ? "Login" : "Sign Up"}</button>
        </form>

        <p className="toggle-text">
          {isLogin ? "Don't have an account?" : "Already have an account?"}
          <button className="toggle-btn" onClick={toggleForm}>
            {isLogin ? "Sign Up" : "Login"}
          </button>
        </p>
      </div>
    </div>
  );
};

export default Loginsignup;
