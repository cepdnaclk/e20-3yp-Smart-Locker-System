import axios from "axios";
import { Link } from "react-router-dom";

const API_URL = "http://localhost:9090/api/v1/admin";

const api = axios.create({
  baseURL: API_URL,
  headers: {
    "Content-Type": "application/json",
  },
});
// Locker cluster action get data , edit cluster , add cluster , and delet cluster
// get data api funtion
export const getLockerClusterData = async () => {
  return await api.get("/getAllLockerClusters", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};
// update locker cluster data
export const updateLockerCluster = async (id, data) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.put(`/updateLockerCluster/${id}`, data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};
//add cluster to system
export const addLockerCluster = async (id, data) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.post(`/addLockerCluster/${id}`, data, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

// delet locker cluster

export const deleteLockerCluster = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.delete(`/deleteLockerCluster/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};
//     //////  //////  // //   //////
//     //  //  //      ////    ////
/////  //////  //////  //  //  //////
export const getLockerData = async () => {
  return await api.get("/getAllLockers", {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
      //"Content-Type": "application/json"
    },
  });
};

export const addLockerTOLockerCluster = async (id) => {
  if (!localStorage.getItem("token")) {
    console.error("JWT Token is missing! Check localStorage.sesion expire ");
    <Link to="/home"></Link>;
    return;
  }
  return await api.post(`/addLockerToACluster/${id}`, {
    headers: {
      Authorization: `Bearer ${localStorage.getItem("token")?.trim()}`,
    },
  });
};
