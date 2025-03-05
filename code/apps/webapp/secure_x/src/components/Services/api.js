import axios from "axios";

const API_URL = "http://localhost:8080";

const api = axios.create({
    baseURL: API_URL,
    headers: {
        "Content-Type": "application/json"
    }
});

export const login = async (username, password) => {
    return api.post("/login", { username, password });
};

export const signup = async (regNo,firstName,lastName,contactNumber,email,password) => {
    return api.post("/api/newUsers/register", { regNo,firstName,lastName,contactNumber,email,password});
};

export const getProtectedData = async () => {
    return api.get("/api/protected", {
        headers: { Authorization: `Bearer ${localStorage.getItem("token")}` }
    });
};

export const getPendingUsresData = async () => {
    return await api.get("/api/admin/pending", {
        headers: { Authorization: `Bearer${localStorage.getItem("token")}`,"Content-Type": "application/json", }
    });
};
export const putLockeUsresData = async (id) => {
    if (!localStorage.getItem("token")) {
        console.error("JWT Token is missing! Check localStorage.");
        return;
    }
    return await api.put(
        `api/admin/approve/${id}`, 
        {},  // Empty request body
        {
            headers: { 
                Authorization: `Bearer${localStorage.getItem("token")?.trim()}`, 
                "Content-Type": "application/json"
            }
        }
    );
};

export const getLockerUsresData = async () => {
    return await api.get("/api/admin/getAllUsers", {
        headers: { Authorization: `Bearer${localStorage.getItem("token")}`,"Content-Type": "application/json", }
    });
};
export const deletLockeUsresData = async (id) => {
    if (!localStorage.getItem("token")) {
        console.error("JWT Token is missing! Check localStorage.");
        return;
    }
    return await api.put(
        `api/admin/deleteUserByID/${id}`, 
        {},  // Empty request body
        {
            headers: { 
                Authorization: `Bearer${localStorage.getItem("token")?.trim()}`, 
                "Content-Type": "application/json"
            }
        }
    );
};