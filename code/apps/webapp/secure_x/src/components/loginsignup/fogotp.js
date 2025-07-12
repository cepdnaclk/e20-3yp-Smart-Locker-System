import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import "./fogotp.css";

export default function FogOtp() {
  const [step, setStep] = useState(1);
  const [userId, setUserId] = useState("");
  const [otp, setOtp] = useState("");
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const navigate = useNavigate();

  const handleSendRecoveryMail = () => {
    if (userId.trim() === "") {
      alert("Please enter your user ID or email.");
      return;
    }
    console.log("Sending recovery mail to:", userId);
    setStep(2);
  };

  const handleVerifyOtp = () => {
    if (otp.trim() === "") {
      alert("Please enter the OTP code.");
      return;
    }
    console.log("Verifying OTP:", otp);
    setStep(3);
  };

  const handleResetPassword = () => {
    if (!newPassword || newPassword !== confirmPassword) {
      alert("Passwords do not match or are empty.");
      return;
    }
    console.log("Resetting password to:", newPassword);
    alert("Password changed successfully!");
    navigate("/login");
  };

  return (
    <div className="fogotp-container">
      <div className="form-box">
        <h2>Forgot Password</h2>
        {step === 1 && (
          <>
            <div className="input-group">
              <label className="fogotp-label">
                Enter your User ID or Email:
              </label>
              <input
                type="text"
                value={userId}
                onChange={(e) => setUserId(e.target.value)}
                placeholder="e.g. user@example.com"
                className="fogotp-input"
              />
              <button
                onClick={handleSendRecoveryMail}
                className="fogotp-button"
              >
                Send Recovery Mail
              </button>
            </div>
          </>
        )}

        {step === 2 && (
          <>
            <div className="input-group">
              <label className="fogotp-label">
                Enter the OTP sent to your email:
              </label>
              <input
                type="text"
                value={otp}
                onChange={(e) => setOtp(e.target.value)}
                placeholder="e.g. 123456"
                className="fogotp-input"
              />
              <button onClick={handleVerifyOtp} className="fogotp-button">
                Verify OTP
              </button>
            </div>
          </>
        )}

        {step === 3 && (
          <>
            <div className="input-group">
              <label className="fogotp-label">Enter New Password:</label>
              <input
                type="password"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                className="fogotp-input"
              />
              <label className="fogotp-label">Confirm New Password:</label>
              <input
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                className="fogotp-input"
              />
              <button onClick={handleResetPassword} className="fogotp-button">
                Save New Password
              </button>
            </div>
          </>
        )}
      </div>
    </div>
  );
}
