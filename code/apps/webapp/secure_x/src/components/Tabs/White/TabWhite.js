import React from 'react'
import './TabWhite.css'
const TabWhite = ({ text, number }) => {
  const t = " : "
  return (
    <div className='TabWhite'>
        <div className='Tab_boxW'>
            <tr>
                <th>{text}</th>
                <th> {t} </th>
                <th>{number}</th>
            </tr>
        </div>
      
    </div>
  )
}

export default TabWhite
