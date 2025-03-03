import React from 'react'
import './TabBlack.css'
const TabBlack = ({ text, number }) => {
  return (
    <div className='TabBlack'>
        <div className='Tab_box'>
            <tr>
                <th>{text}</th>
                <th>:</th>
                <th>{number}</th>
            </tr>
        </div>
      
    </div>
  )
}

export default TabBlack
