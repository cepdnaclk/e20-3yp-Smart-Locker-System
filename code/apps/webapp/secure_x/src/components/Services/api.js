import axios from "axios";
import { Link } from "react-router-dom";
const API_URL =
  "https://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1"; //"https://ec2-3-88-237-151.compute-1.amazonaws.com:9090/api/v1";
//"http://smartlocker-backend-bkf3bydrfbfjf4g8.southindia-01.azurewebsites.net/api/v1";"http://localhost:9090/api/v1";
//"http://localhost:9090/api/v1";
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

export const getUserProfile = async () => {
  return api.get("/admin/profile", {
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

export const getUsresLogData = async () => {
  return await api.get("/admin/getAllLogs", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const putLockeUsresData = async (id) => {
  const token = localStorage.getItem("token")?.trim();
  if (!token) {
    console.error("JWT Token is missing! Check localStorage.");
    return;
  }

  try {
    const response = await api.put(
      `/admin/approve/${id}`,
      {}, // empty body (if backend expects no data)
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response;
  } catch (error) {
    console.error("Error in putLockeUsresData:", error);
    throw error;
  }
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

export const updateUserProfile = async (data) => {
  return await api.patch("/admin/editProfile", data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};

export const changePassword = async (passwordData) => {
  return await api.post("/admin/change-password", passwordData, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};

export const updateDP = async (username, formData) => {
  return await api.post(`/admin/image/upload/${username}`, formData, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      "Content-Type": "multipart/form-data",
    },
  });
};

export const dounlodDP = async (id) => {
  return await api.get(`/admin/image/download/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};
export const deleteDP = async (id) => {
  return await api.delete(`/admin/image/delete/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};

export const updateLockeradmin = async (data) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.patch(`/admin/editProfile`, data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};
export const ChangePassword = async (currentPassword, newPassword) => {
  try {
    const token = localStorage.getItem("token");
    const response = await api.patch(
      "/admin/changePassword",
      {
        currentPassword,
        newPassword,
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    return response.data;
  } catch (error) {
    console.error(
      "ChangePassword failed:",
      error.response?.data || error.message
    );
    throw error;
  }
};
