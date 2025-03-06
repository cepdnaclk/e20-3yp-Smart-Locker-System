import React from 'react';

const ShowUserData = ({ firstname, lastname, id, email, contacNo, role }) => {
  return (
    <div className="Admin_info">
      <table className="Tab_boxW">
        <tbody>
          <tr>
            <th>First Name</th>
            <th>:</th>
            <th className='trs'>{firstname}</th>
          </tr>
          <tr>
            <th>Last Name</th>
            <th>:</th>
            <th className='trs'>{lastname}</th>
          </tr>
          <tr>
            <th>User ID</th>
            <th>:</th>
            <th className='trs'>{id}</th>
          </tr>
          <tr>
            <th>Email</th>
            <th>:</th>
            <th className='trs'>{email}</th>
          </tr>
          <tr>
            <th>Contact No.</th>
            <th>:</th>
            <th className='trs'>{contacNo}</th>
          </tr>
          <tr>
            <th>Role</th>
            <th>:</th>
            <th className='trs'>{role}</th>
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default ShowUserData;
