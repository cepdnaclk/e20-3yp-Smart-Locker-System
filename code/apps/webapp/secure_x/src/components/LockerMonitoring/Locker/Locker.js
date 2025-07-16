import React, { useState, useEffect } from "react";
import {
  getLockerData,
  addLockerTOLockerCluster,
  getLockerClusterData,
  deleteLocker,
  updateLockers,
  unlockLocker,
} from "../../Services/lockerAPI";
import {
  SquarePen,
  Trash2,
  SquarePlus,
  KeyRound,
  Funnel,
  X,
  Save,
} from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";
import "./Locker.css";
import {
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  FormControl,
  InputLabel,
  Select,
  MenuItem,
} from "@mui/material";

const Locker = () => {
  const [locker, setLocker] = useState([]);
  const [AllLocker, setAllLocker] = useState([]);
  const [LCluster, setClusters] = useState([]);
  const [openAdd, setOpenAdd] = useState(false);
  const [ClussterId, setClustersId] = useState(null);
  const [selectedCluster, setSelectedCluster] = useState("null");
  const [loading, setLoading] = useState(true);
  const [selectedStatus, setSelectedStatus] = useState("ALL");
  const [openDelet, setOpenDelet] = useState(false);
  const [selecteLocker, setSelectedLocker] = useState(null);
  const [openEdit, setOpenEdit] = useState(false);
  const [openUnlock, setOpenUnlock] = useState(false);
  const [unlockPassword, setUnlockPassword] = useState("");

  // Fetch locker data
  const handleLocker = async () => {
    try {
      const response = await getLockerData();
      const lockerData = response.data;
      setLocker(lockerData);
      setAllLocker(lockerData);
    } catch (error) {
      setLocker([]);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // Fetch cluster data
  const handleClasters = async () => {
    try {
      setLoading(true);
      const response = await getLockerClusterData();
      setClusters(response.data);
    } catch (error) {
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    } finally {
      setLoading(false);
    }
  };

  // Add locker
  const handleAddLocker = async () => {
    try {
      await addLockerTOLockerCluster(ClussterId);
      setOpenAdd(false);
      handleLocker();
    } catch (error) {
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  const handleAddClick = () => setOpenAdd(true);
  const handleAddChange = (e) => setClustersId(e.target.value);

  useEffect(() => {
    handleLocker();
    handleClasters();
  }, []);

  // Filter logic
  const handleStatusChange = (e) => {
    const status = e.target.value;
    setSelectedStatus(status);
    filterLockers(status, selectedCluster);
  };
  const handleChange = (e) => {
    const clusterId = e.target.value;
    setSelectedCluster(clusterId);
    filterLockers(selectedStatus, clusterId);
  };
  const filterLockers = (status, clusterId) => {
    let filtered = AllLocker;
    if (status !== "ALL") {
      filtered = filtered.filter((l) => l.lockerStatus === status);
    }
    if (clusterId !== "null") {
      filtered = filtered.filter(
        (l) => String(l.lockerClusterId) === String(clusterId)
      );
    }
    setLocker(filtered);
  };

  // Delete
  const handleDeleteClick = (locker) => {
    setSelectedLocker(locker);
    setOpenDelet(true);
  };
  const deleteLockerByID = async (id) => {
    try {
      await deleteLocker(id);
      alert(`Locker deleted with ID: ${id}`);
      setOpenDelet(false);
      handleLocker();
    } catch (error) {
      alert(`Error deleting locker: ${id}`);
    }
  };

  // Edit
  const handleEditClick = (locker) => {
    setSelectedLocker(locker);
    setOpenEdit(true);
  };
  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setSelectedLocker({ ...selecteLocker, [name]: value });
  };
  const handleEditSave = async () => {
    try {
      await updateLockers(selecteLocker.lockerId, selecteLocker);
      setOpenEdit(false);
      handleLocker();
    } catch (error) {
      alert("Failed to save locker data");
    }
  };

  // Unlock
  const handleUnlockClick = (locker) => {
    setSelectedLocker(locker);
    setOpenUnlock(true);
  };
  const unlockLockerByID = async () => {
    const dto = {
      lockerClusterId: selecteLocker?.lockerClusterId,
      lockerId: selecteLocker?.lockerId,
      password: unlockPassword,
    };

    try {
      await unlockeLocker(dto);
      alert(`Locker unlocked: ${dto.lockerId}`);
      setOpenUnlock(false);
      setUnlockPassword("");
      handleLocker();
    } catch (error) {
      alert("Unlock failed: " + (error.response?.data || "Try again"));
      setUnlockPassword("");
    }
  };

  return (
    <div className="WindowPU">
      <div className="WindowPU_t">
        <h2>Lockers</h2>

        <div className="ActionB">
          <Tooltip title="Add locker" arrow>
            <button className="ADDB" onClick={handleAddClick}>
              <SquarePlus size={20} />
            </button>
          </Tooltip>

          <div className="LFilter">
            <Funnel /> Filter:
            <div className="filter-occupency">
              <label>
                <input
                  type="radio"
                  name="radio-occ"
                  value="ALL"
                  defaultChecked
                  onChange={handleStatusChange}
                />
                <span className="name">ALL</span>
              </label>
              <label>
                <input
                  type="radio"
                  name="radio-occ"
                  value="AVAILABLE"
                  onChange={handleStatusChange}
                />
                <span className="name">AVAILABLE</span>
              </label>
              <label>
                <input
                  type="radio"
                  name="radio-occ"
                  value="OCCUPIED"
                  onChange={handleStatusChange}
                />
                <span className="name">OCCUPIED</span>
              </label>
            </div>
            <div className="select-container">
              <select onChange={handleChange} disabled={loading}>
                <option value="null">
                  {loading ? "Loading..." : "All Cluster"}
                </option>
                {LCluster.map((cluster) => (
                  <option key={cluster.id} value={cluster.id}>
                    {cluster.id} - {cluster.clusterName}
                  </option>
                ))}
              </select>
            </div>
          </div>
        </div>

        <table className="Ctable">
          <thead>
            <tr>
              <th>LockerID</th>
              <th>Display Number</th>
              <th>Status</th>
              <th>Locker Log</th>
              <th>Locker Cluster</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {locker.map((l) => (
              <tr key={l.lockerId}>
                <td>{l.lockerId}</td>
                <td>{l.displayNumber}</td>
                <td>{l.lockerStatus}</td>
                <td>{l.lockerLogs}</td>
                <td>{l.lockerClusterId}</td>
                <td className="ActionF">
                  <Tooltip title="Edit" arrow>
                    <button
                      className="EDITB"
                      onClick={() => handleEditClick(l)}
                    >
                      <SquarePen size={16} />
                    </button>
                  </Tooltip>

                  <Tooltip title="Unlock" arrow>
                    <button
                      className="UNLOCKB"
                      onClick={() => handleUnlockClick(l)}
                    >
                      <KeyRound size={16} />
                    </button>
                  </Tooltip>

                  <Tooltip title="Delete" arrow>
                    <button
                      className="DELETB"
                      onClick={() => handleDeleteClick(l)}
                    >
                      <Trash2 size={16} />
                    </button>
                  </Tooltip>
                </td>
              </tr>
            ))}
          </tbody>
        </table>

        {/* Unlock Dialog */}
        <Dialog
          className="DileteDialog"
          open={openUnlock}
          onClose={() => {
            setOpenUnlock(false);
            setUnlockPassword("");
          }}
        >
          <DialogTitle className="DTital">Unlock Locker</DialogTitle>
          <DialogContent>
            <p>
              Locker ID: <i>{selecteLocker?.lockerId}</i>
            </p>
            <p>
              Cluster ID: <i>{selecteLocker?.lockerClusterId}</i>
            </p>
            <TextField
              label="Admin Password"
              type="password"
              fullWidth
              value={unlockPassword}
              onChange={(e) => setUnlockPassword(e.target.value)}
            />
          </DialogContent>
          <DialogActions>
            <button className="CANCELB" onClick={() => setOpenUnlock(false)}>
              Cancel
            </button>
            <button className="UNLOCKB2" onClick={unlockLockerByID}>
              Unlock Locker
            </button>
          </DialogActions>
        </Dialog>

        {/* Other dialogs (Add/Edit/Delete) remain unchanged */}
        {/* ... [You can reuse your existing code here] */}
      </div>
    </div>
  );
};

export default Locker;
