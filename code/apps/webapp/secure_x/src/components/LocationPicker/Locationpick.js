import React, { useState, useEffect } from "react";
import { MapContainer, TileLayer, Marker, useMapEvents } from "react-leaflet";
import L from "leaflet";
import "leaflet/dist/leaflet.css";

// Fix missing marker icons in Leaflet for React
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require("leaflet/dist/images/marker-icon-2x.png"),
  iconUrl: require("leaflet/dist/images/marker-icon.png"),
  shadowUrl: require("leaflet/dist/images/marker-shadow.png"),
});

// Component to manage and update marker on map click and drag
function LocationMarker({ position, setPosition }) {
  useMapEvents({
    click(e) {
      setPosition(e.latlng);
    },
  });

  return position ? (
    <Marker
      position={position}
      draggable={true}
      eventHandlers={{
        dragend: (e) => {
          setPosition(e.target.getLatLng());
        },
      }}
    />
  ) : null;
}

// Main Location Picker Component
function Locationpick({ onChange }) {
  const [position, setPosition] = useState({ lat: 7.2906, lng: 80.6337 });

  // Call parent callback whenever position updates
  React.useEffect(() => {
    if (onChange) {
      onChange(position);
    }
  }, [position, onChange]);

  return (
    <div>
      <MapContainer
        center={position}
        zoom={13}
        scrollWheelZoom={true}
        style={{ height: "400px", width: "100%" }}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        <LocationMarker position={position} setPosition={setPosition} />
      </MapContainer>

      <div style={{ marginTop: "10px" }}>
        <strong>Selected Coordinates:</strong>
        <p>Latitude: {position.lat.toFixed(6)}</p>
        <p>Longitude: {position.lng.toFixed(6)}</p>
      </div>
    </div>
  );
}

function Locationpickwithcurrentval({ value, onChange }) {
  const [position, setPosition] = useState(
    value || { lat: 7.2906, lng: 80.6337 }
  );

  // Sync with parent value when it changes
  useEffect(() => {
    if (value && (value.lat !== position.lat || value.lng !== position.lng)) {
      setPosition(value);
    }
  }, [value]);

  // Notify parent on position change
  useEffect(() => {
    if (onChange) {
      onChange(position);
    }
  }, [position]);

  return (
    <div>
      <MapContainer
        center={position}
        zoom={13}
        scrollWheelZoom={true}
        style={{ height: "400px", width: "100%" }}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        <LocationMarker position={position} setPosition={setPosition} />
      </MapContainer>

      <div style={{ marginTop: "10px" }}>
        <strong>Selected Coordinates:</strong>
        <p>Latitude: {position.lat.toFixed(6)}</p>
        <p>Longitude: {position.lng.toFixed(6)}</p>
      </div>
    </div>
  );
}

export { Locationpick, Locationpickwithcurrentval };
