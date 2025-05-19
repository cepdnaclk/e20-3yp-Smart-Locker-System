import React from 'react'
import Navbar from '../Navigationbar/Navigationbar'
import './LockerMonitoring.css'
import Lcluster from './Lcluster/Lcluster'
import Locker from './Locker/Locker'
const LockerMonitoring = () => {
  return (
    <div>
      <Navbar />
      <div className='Lm1'>
        <h1>Locker Monitoring page</h1>
        <Lcluster/>
        <Locker/>
      </div>
    </div>
    
  )
}

export default LockerMonitoring
