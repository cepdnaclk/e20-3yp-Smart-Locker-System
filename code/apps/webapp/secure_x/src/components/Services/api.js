import axios from "axios";
import { Link } from "react-router-dom";
const API_URL = "http://localhost:9090/api/v1";

const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
});

export const login = async (username, password) => {
  return api.post("/login", { username, password });
};

export const signup = async (
  regNo,
  firstName,
  lastName,
  contactNumber,
  email,
  password
) => {
  return api.post("/newUsers/register", {
    regNo,
    firstName,
    lastName,
    contactNumber,
    email,
    password,
  });
};

export const getProtectedData = async () => {
  return api.get("/protected", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};

export const getPendingUsresData = async () => {
  return await api.get("/admin/pending", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const putLockeUsresData = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.");
    return;
  }
  return await api.put(
    `/admin/approve/${id}`,
    {}, // Empty request body
    {
      headers: {
        Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
        "Content-Type": "application/json",
      },
    }
  );
};
export const rejectPendingUser = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.");
    return;
  }
  return await api.delete(`/admin/reject/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      "Content-Type": "application/json",
    },
  });
};

export const getLockerUsresData = async () => {
  return await api.get("/admin/getAllUsers", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const deletLockeUsresData = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.");
    return;
  }
  return await api.delete(`/admin/deleteUser/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const findUserByID = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.get(`/admin/findUserById/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const updateLockerUser = async (id, data) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.patch(`/admin/editUser/${id}`, data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};
