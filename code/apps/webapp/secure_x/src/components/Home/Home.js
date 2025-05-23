import React from 'react'
import'./Home.css'
export default function Home() {
  return (
     <div className="container">
      {/* Header */}
      <div className='headflex'>
        <h2 className='logo'>Secure X</h2>
        <div className='hedbtnflex'>
            <button className='btnlogin'>LOG IN</button>
            <button className='btnJoin'>Join now</button>
        </div>
      </div>
      {/* Main Content */}
      <main className="main">
        
        <div className="text-box">
          <h2>Secure X - Smart Locker System</h2>
          <p>The Secure X Locker System is an IoT-based solution for secure storage in shared spaces like universities, gyms, and offices. Users can check real-time availability via a mobile or web app and get suggestions for nearby lockers when locations are full.</p>
          <p>Access is secured with a fingerprint sensor, and users can reserve lockers and receive notifications. Administrators can manage locker usage through a centralized dashboard, reducing theft risks and optimizing storage.</p>
        </div>
        
      </main>
    </div>
    
    
  )
}
