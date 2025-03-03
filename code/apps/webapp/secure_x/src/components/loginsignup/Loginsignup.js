import React, { useState } from "react";
import "./Loginsignup.css";
import { useNavigate } from "react-router-dom";

const Loginsignup = () => {
  const [isLogin, setIsLogin] = useState(true);
  const navigate = useNavigate();

  const toggleForm = () => {
    setIsLogin(!isLogin);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (isLogin) {
      navigate("/success"); // Redirect to success page after login
    } else {
      alert("Account created successfully! You can now log in.");
      setIsLogin(true);
    }
  };

  return (
    <div className="container">
      <div className="form-box">
        <h2>{isLogin ? "Login" : "Sign Up"}</h2>

        <form onSubmit={handleSubmit}>
          {!isLogin && (
            <div className="input-group">
              <label>Full Name</label>
              <input type="text" placeholder="Enter your name" /*required*/ />
            </div>
          )}

          <div className="input-group">
            <label>Email</label>
            <input type="email" placeholder="Enter your email" /*required*/ />
          </div>

          <div className="input-group">
            <label>Password</label>
            <input type="password" placeholder="Enter your password" /*required*/ />
          </div>

          {!isLogin && (
            <div className="input-group">
              <label>Confirm Password</label>
              <input type="password" placeholder="Re-enter Password" /*required*/ />
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
