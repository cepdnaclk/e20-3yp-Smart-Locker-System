import React, { useEffect } from 'react';
import './Success.css';
import { useNavigate } from "react-router-dom";


const Success = () =>{
  const navigate = useNavigate();
  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/dashboard"); // Redirect to home after 5 seconds
    }, 5000);

    return () => clearTimeout(timer); // Cleanup timeout on unmount
  }, [navigate]);


  return (
    <div className='sucses'>
      <div className='s_box'>
        <h1>Login Successful! </h1>
      <p>Welcome to Secure X - Smart Locker System.</p>
      </div>
      
    </div>
  )
}
export default Success;