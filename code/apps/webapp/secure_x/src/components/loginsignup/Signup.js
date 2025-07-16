import React, { useState } from "react";
import "./Signup.css";
import { signup } from "../Services/api.js";
import { useNavigate, Link } from "react-router-dom";

const Signup = () => {
  const [regNo, setRegNo] = useState("");
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");
  const [contactNumber, setContactNumber] = useState("");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordError, setPasswordError] = useState(""); // for inline error
  const navigate = useNavigate();

  const isStrongPassword = (pw) => {
    const regex = /^(?=.*[A-Z])(?=.*[@#$%&()?\/\\!]).{8,}$/;
    return regex.test(pw);
  };

  const handlePasswordChange = (e) => {
    const value = e.target.value;
    setPassword(value);

    // Check password strength live
    if (!isStrongPassword(value)) {
      setPasswordError(
        "ℹ️ Password must be ≥ 8 chars, 1 uppercase & 1 special (@#$%&()?/\\!)"
      );
    } else {
      setPasswordError("");
    }
  };

  const handleSignup = async (e) => {
    e.preventDefault();

    if (!isStrongPassword(password)) {
      setPasswordError(
        "ℹ️ Password must be ≥ 8 chars, 1 uppercase & 1 special (@#$%&()?/\\!)"
      );
      return;
    }

    if (password !== confirmPassword) {
      setPasswordError(""); // clear password error
      alert("Passwords do not match!");
      return;
    }

    try {
      await signup(regNo, firstName, lastName, contactNumber, email, password);
      alert("Signup Successful!");
      navigate("/success");
    } catch (error) {
      console.error("Signup failed:", error);
      alert("Invalid credentials");
    }
  };

  return (
    <div className="container_signup">
      <div className="form-box-s">
        <h2>SIGN UP</h2>
        <form onSubmit={handleSignup}>
          <div className="input-group">
            <label>Name</label>
            <input
              type="text"
              placeholder="First Name"
              value={firstName}
              onChange={(e) => setFirstName(e.target.value)}
              required
            />
            <input
              type="text"
              placeholder="Last Name"
              value={lastName}
              onChange={(e) => setLastName(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Registration Number</label>
            <input
              type="text"
              placeholder="Enter Reg. No (e.g., EXXYYY)"
              value={regNo}
              onChange={(e) => setRegNo(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Contact Number</label>
            <input
              type="text"
              placeholder="Enter your phone number"
              value={contactNumber}
              onChange={(e) => setContactNumber(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Email</label>
            <input
              type="email"
              placeholder="Enter your email"
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              required
            />
          </div>

          <div className="input-group">
            <label>Password</label>
            <input
              type="password"
              placeholder="Enter your password"
              value={password}
              onChange={handlePasswordChange}
              required
            />
            {/* Inline password error */}
            {passwordError && (
              <p className="error-msg">{passwordError}</p>
            )}
          </div>

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

          <button type="submit">Sign Up</button>

          <div className="dont-have-account">
            <span>Do you have an account? </span>
            <Link to="/login" className="signup-link">
              Sign in
            </Link>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Signup;
