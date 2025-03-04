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
