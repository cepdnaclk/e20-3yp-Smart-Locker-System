import axios from "axios";
import { Link } from "react-router-dom";
const API_URL =
  "https://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1/forgotPassword"; //"https://ec2-3-88-237-151.compute-1.amazonaws.com:9090/api/v1";
//"http://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1";
//"http://localhost:9090/api/v1/forgotPassword";
const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

export const getOTP = async (userId) => {
  try {
    const response = await api.post(
      `/generateOtpCode?identifier=${encodeURIComponent(userId)}`
    );
    return response.data;
  } catch (error) {
    console.error("getOTP failed:", error.response?.data || error.message);
    throw error;
  }
};

export const CheckOTP = async (username, otp) => {
  return api.post("/validateOtpCode", { username, otp });
};

export const ResetPassword = async (usernameOrEmail, otp, newPassword) => {
  try {
    const response = await api.post("/updatePassword", {
      usernameOrEmail,
      otp,
      newPassword,
    });
    return response.data;
  } catch (error) {
    console.error(
      "ResetPassword failed:",
      error.response?.data || error.message
    );
    throw error;
  }
};
