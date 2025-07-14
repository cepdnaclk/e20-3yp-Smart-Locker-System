import React, { useState, useEffect } from "react";
import Navbar from "../Navigationbar/Navigationbar";
import { getUserProfile } from "../Services/api";
import { useFormState } from "react-dom";
import "./User.css";

export default function User() {
  const [UserD, setuserD] = useState([]);

  const handelUserData = async () => {
    setuserD([]);
    try {
      const responce = await getUserProfile();
      const userd = responce.data;
      setuserD(userd);
      console.log(userd);
    } catch (error) {
      setuserD([]);
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };
  useEffect(() => {
    handelUserData();
  }, []);
  return (
    <div>
      <Navbar />
      <div className="UCP">
        <h2> My profile </h2>
        <div className="user-details">
          {UserD.id && (
            <>
              <p>
                <strong>ID:</strong> {UserD.id}
              </p>
              <p>
                <strong>Name:</strong> {UserD.firstName} {UserD.lastName}
              </p>
              <p>
                <strong>Email:</strong> {UserD.email}
              </p>
              <p>
                <strong>Contact No:</strong> {UserD.contactNumber}
              </p>
              <p>
                <strong>Role:</strong> {UserD.role}
              </p>
            </>
          )}
        </div>
        <div>
          <button> Edit </button>
          <button> Change password </button>
        </div>
      </div>
    </div>
  );
}
