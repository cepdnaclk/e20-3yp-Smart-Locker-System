import React, { useState, useEffect } from "react";
import Navbar from "../Navigationbar/Navigationbar";
import {
  MapContainer,
  Marker,
  Popup,
  TileLayer,
  useMapEvents,
} from "react-leaflet";
import { getLockerClusterData } from "../Services/lockerAPI";
import { ClipLoader } from "react-spinners";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import "./Map.css";

// Fix default marker icon issue
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon-2x.png",
  iconUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-icon.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png",
});
//  most occupide
const redIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-red.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});
// most avalable
const greenIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-green.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});
// balance
const yellowIcon = new L.Icon({
  iconUrl:
    "https://raw.githubusercontent.com/pointhi/leaflet-color-markers/master/img/marker-icon-2x-yellow.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.7.1/images/marker-shadow.png",
  iconSize: [25, 41],
  iconAnchor: [12, 41],
  popupAnchor: [1, -34],
  shadowSize: [41, 41],
});

export default function Map_page() {
  const [position, setPosition] = useState([7.2533, 80.59251]);
  const [loading, setLoading] = useState(true);
  const [clusters, setClusters] = useState([]);

  useEffect(() => {
    handleLockerCluster();
  }, []);

  const handleLockerCluster = async () => {
    try {
      const response = await getLockerClusterData();
      setClusters(response.data);
      setLoading(false);
    } catch (error) {
      console.error("Error fetching cluster data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  function LocationMarker() {
    useMapEvents({
      click(e) {
        setPosition([e.latlng.lat, e.latlng.lng]);
      },
    });

    return (
      <Marker icon={redIcon} position={position}>
        <Popup>
          Dynamic Position: {position[0].toFixed(5)}, {position[1].toFixed(5)}
        </Popup>
      </Marker>
    );
  }

  return (
    <div>
      <Navbar />
      <div className="Map1">
        <h1>Locker Clusters Map</h1>
        {loading ? (
          <ClipLoader color="#000" size={50} />
        ) : (
          <MapContainer
            center={position}
            zoom={14}
            scrollWheelZoom={true}
            style={{ height: "500px", width: "90%" }}
          >
            <TileLayer
              attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
              url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
            />

            {/* User dynamic location marker */}
            <LocationMarker />

            {/* Cluster markers */}
            {clusters.map((cluster) => (
              <Marker
                key={cluster.id}
                position={[cluster.latitude, cluster.longitude]}
              >
                <Popup>
                  <strong>{cluster.clusterName}</strong>
                  <br />
                  Available Lockers: {cluster.availableNumberOfLockers}
                  <br />
                  Total Lockers: {cluster.totalNumberOfLockers}
                  <br />
                  Description: {cluster.lockerClusterDescription}
                </Popup>
              </Marker>
            ))}
          </MapContainer>
        )}
      </div>
    </div>
  );
}
