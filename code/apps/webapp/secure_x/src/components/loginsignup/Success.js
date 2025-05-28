import React, { useEffect } from 'react';
import './Success.css';
import { useNavigate } from "react-router-dom";


const Success = () =>{
  const navigate = useNavigate();
  useEffect(() => {
    const timer = setTimeout(() => {
      navigate("/admin/login"); // Redirect to home after 5 seconds
    }, 5000);

    return () => clearTimeout(timer); // Cleanup timeout on unmount
  }, [navigate]);


  return (
    <div className='sucses'>
      <div className='s_box'>
      <h1>Signup Successful!</h1>
      <p>Wait for admin approval of your request. Then you can log into the admin system.</p>

      </div>
      
    </div>
  )
}
export default Success;