import axios from "axios";
import { Link } from "react-router-dom";
const API_URL = "http://localhost:8080/api/v1/admin";

const api = axios.create({
    baseURL: API_URL,
    headers: {
        "Content-Type": "application/json"
    }
});


export const getLockerClusterData = async () => {
    
    return await api.get("/getAllLockerClusters", {
        headers: { 
            Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
            //"Content-Type": "application/json"
        }
        
    });
    
};

export const getLockerData = async () => {
    
    return await api.get("/getAllLockers", {
        headers: { 
            Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
            //"Content-Type": "application/json"
        }
        
    });
    
};