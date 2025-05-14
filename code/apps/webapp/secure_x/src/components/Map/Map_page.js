import React, { useState } from 'react';
import Navbar from '../Navigationbar/Navigationbar';
import { MapContainer, Marker, Popup, TileLayer, useMapEvents } from 'react-leaflet';
import { ClipLoader } from 'react-spinners';
import 'leaflet/dist/leaflet.css';  // Import Leaflet's CSS
import './Map.css';

export default function Map_page() {
  const [position, setPosition] = useState([7.25330, 80.59251]);
  const [loading, setLoading] = useState(true);

  function LocationMarker() {
    useMapEvents({
      click(e) {
        setPosition([e.latlng.lat, e.latlng.lng]);
      },
    });

    return (
      <Marker position={position}>
        <Popup>Dynamic Position: {position[0]}, {position[1]}</Popup>
      </Marker>
    );
  }

  return (
    <div>
      <Navbar />
      <div className='Map1'>
        <h1>Map</h1>
        {loading && <ClipLoader color="#000" size={50} />}
        <MapContainer 
          center={position} 
          zoom={14} 
          scrollWheelZoom={true} 
          whenCreated={() => setLoading(false)}
          style={{ height: "500px", width: "90%" }}>
          <TileLayer
            attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
          />
          <LocationMarker />
        </MapContainer>
      </div>
    </div>
  );
}
