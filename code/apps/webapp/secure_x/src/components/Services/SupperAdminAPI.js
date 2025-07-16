import axios from "axios";
import { Link } from "react-router-dom";
const API_URL =
  "https://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1";
//; //"https://ec2-3-88-237-151.compute-1.amazonaws.com:9090/api/v1";
//"http://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1";
//"http://localhost:9090/api/v1";
const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

export const updateLockerUserS = async (id, data) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.patch(`/superAdmin/editUser/${id}`, data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const deletLockerAdminData = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.");
    return;
  }
  return await api.delete(`/superAdmin/deleteUser/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};
