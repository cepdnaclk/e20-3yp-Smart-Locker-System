import React, { useState, useEffect } from "react";
import {
  getLockerData,
  addLockerTOLockerCluster,
  getLockerClusterData,
  deleteLocker,
  updateLockers,
  unlockeLocker,
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

  // Fetch locker users
  const handleLocker = async () => {
    console.log("Fetching locker data");
    setLocker([]);
    try {
      const response = await getLockerData();
      // Adjust the filtering as needed
      const locker = response.data;
      setLocker(locker);
      setAllLocker(locker);
      console.log("Locker Data:", locker);
    } catch (error) {
      setLocker([]);
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // fetch cluster data
  const handleClasters = async () => {
    console.log("Fetching locker cluster data");
    try {
      setLoading(true);
      const response = await getLockerClusterData();
      // Adjust the filtering as needed
      const LCluster = response.data;
      setClusters(LCluster);
      console.log("Cluster Data:", LCluster);
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    } finally {
      setLoading(false);
    }
  };

  // add locker to cluster
  const handleAddLocker = async () => {
    console.log("Fetching locker cluster data");
    try {
      await addLockerTOLockerCluster(ClussterId);
      setOpenAdd(false);
      handleAddLocker();
      console.log("Locker Data:", locker);
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };
  const handleAddClick = (e) => {
    setOpenAdd(true);
  };
  const handleAddChange = (e) => {
    const { value } = e.target;
    setClustersId(value);
  };
  // handel avalability
  // const handleAvalablity = async () => {};
  // const handleAvalablityClick = (avd) => {};

  // Fetch data when the component mounts
  useEffect(() => {
    handleLocker();
    handleClasters();
  }, []);

  // handell all filtering method
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
      filtered = filtered.filter((locker) => locker.lockerStatus === status);
    }

    if (clusterId !== "null") {
      filtered = filtered.filter(
        (locker) => String(locker.lockerClusterId) === String(clusterId)
      );
    }

    setLocker(filtered);
  };
  // delet locker
  const handleDeleteClick = (locker) => {
    setSelectedLocker(locker);
    setOpenDelet(true);
  };

  const deleteLockerByID = async (id) => {
    try {
      await deleteLocker(id);
      alert(`Locker deleted with ID: ${id}`);
      setOpenDelet(false);
      // Refresh the list after deleting
      handleLocker();
    } catch (error) {
      console.error(`Error deleting locker: ${id}`, error);
      alert(`Error deleting locker: ${id}`);
    }
  };

  // edit locker
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
      handleLocker(); // Refresh data
    } catch (error) {
      console.error("data save error:", error);
      alert("Failed to save locker data");
    }
  };
  //unlock locker by id
  const handleUnlockClick = (locker) => {
    setSelectedLocker(locker);
    setOpenUnlock(true);
  };

  const unlockLockerByID = async (id) => {
    try {
      await unlockeLocker(id);
      alert(`Locker deleted with ID: ${id}`);
      setOpenUnlock(false);
      // Refresh the list after deleting
      handleLocker();
    } catch (error) {
      console.error(`Error unlock locker: ${id}`, error);
      alert(`Error unlock locker: ${id}`);
    }
  };
  return (
    <div className="WindowPU">
      <div className="WindowPU_t">
        <h2>Lockers</h2>

        <div className="ActionB">
          <Tooltip
            title="Add locker"
            arrow
            onClick={() => handleAddClick()}
            componentsProps={{
              tooltip: {
                sx: {
                  fontSize: "12px",
                  backgroundcolor: "black",
                  color: "#fff",
                },
              },
            }}
          >
            <button className="ADDB">
              <SquarePlus size={20} />
            </button>
          </Tooltip>
          <div className="LFilter">
            <Funnel /> Filter :
            <div class="filter-occupency">
              <label for="occ-1">
                <input
                  id="occ-1"
                  type="radio"
                  name="radio-occ"
                  value="ALL"
                  defaultChecked
                  onChange={handleStatusChange}
                  //onChange={}
                  //onClick={setStype(0)}
                />
                <span class="name">ALL</span>
              </label>
              <label for="occ-2">
                <input
                  id="occ-2"
                  type="radio"
                  name="radio-occ"
                  value="AVAILABLE"
                  onChange={handleStatusChange}
                  // onClick={setStype(1)}
                />
                <span class="name">AVAILABLE</span>
              </label>
              <label for="occ-3">
                <input
                  id="occ-3"
                  type="radio"
                  name="radio-occ"
                  value="OCCUPIED"
                  onChange={handleStatusChange}
                  //onClick={setStype(2)}
                />
                <span class="name">OCCUPIED</span>
              </label>
            </div>
            <div className="select-container">
              <select
                // value={selectedCluster}
                onChange={handleChange}
                disabled={loading}
              >
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
        {/* Locker detail section */}
        <table className="Ctable">
          <thead>
            <tr>
              <th>LockerID</th>
              <th>Disply Number</th>
              <th>Status</th>
              <th>Locker Log</th>
              <th>Locker Cluster</th>

              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {locker.map((lockers) => (
              <tr key={lockers.lockerId}>
                <td>{lockers.lockerId}</td>
                <td>{lockers.displayNumber}</td>
                <td>{lockers.lockerStatus}</td>
                <td>{lockers.lockerLogs}</td>
                <td>{lockers.lockerClusterId}</td>
                <td className="ActionF">
                  <Tooltip
                    title="Edit"
                    arrow
                    componentsProps={{
                      tooltip: {
                        sx: {
                          fontSize: "12px",
                          backgroundcolor: "black",
                          color: "#fff",
                        },
                      },
                    }}
                  >
                    <button
                      className="EDITB"
                      onClick={() => handleEditClick(lockers)}
                    >
                      <SquarePen size={16} />
                    </button>
                  </Tooltip>

                  <Tooltip
                    title="Unlock"
                    arrow
                    componentsProps={{
                      tooltip: {
                        sx: {
                          fontSize: "12px",
                          backgroundcolor: "black",
                          color: "#fff",
                        },
                      },
                    }}
                  >
                    <button
                      className="UNLOCKB"
                      onClick={() => handleUnlockClick(lockers)}
                    >
                      <KeyRound size={16} />
                    </button>
                  </Tooltip>

                  <Tooltip
                    title="Delet"
                    arrow
                    componentsProps={{
                      tooltip: {
                        sx: {
                          fontSize: "12px",
                          backgroundcolor: "black",
                          color: "#fff",
                        },
                      },
                    }}
                  >
                    <button
                      className="DELETB"
                      onClick={() => handleDeleteClick(lockers)}
                    >
                      <Trash2 size={16} />
                    </button>
                  </Tooltip>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
        <div>
          {/* ADD new locker dialog */}
          <Dialog
            className="AddDialog"
            open={openAdd}
            onClose={() => setOpenAdd(false)}
          >
            <DialogTitle className="DTital">
              Add Locker To Locker Cluster{" "}
            </DialogTitle>
            <div className="trance"></div>
            <DialogContent className="dialog-content">
              <TextField
                label="Cluster ID"
                name="id"
                variant="outlined"
                className="no-border"
                //value={newlocker.id || ""}
                onChange={handleAddChange}
              />
            </DialogContent>
            <DialogActions className="dialog-actions">
              <button className="DELETEB" onClick={() => setOpenAdd(false)}>
                Cancel
              </button>
              <button
                className="CANCELB"
                onClick={() => handleAddLocker()}
                variant="contained"
              >
                Add Locker
              </button>
            </DialogActions>
          </Dialog>
        </div>
        <div>
          {/* DELET DIALOG */}
          <Dialog
            className="DileteDialog"
            open={openDelet}
            onClose={() => setOpenDelet(false)}
          >
            <DialogTitle className="DTital">Delet Locker! </DialogTitle>
            <DialogContent>
              <p> Are you sure delet this locker?</p>
              <p>
                ID - <i> {selecteLocker?.lockerId}</i>
              </p>
              <p>
                cluster id - <i> {selecteLocker?.lockerClusterId}</i>
              </p>
            </DialogContent>
            <DialogActions className="dialog-actions">
              <button className="CANCELB" onClick={() => setOpenDelet(false)}>
                Cancel
              </button>
              <button
                className="DELETEB"
                onClick={() => deleteLockerByID(selecteLocker?.lockerId)}
                variant="contained"
              >
                Delete Locker
              </button>
            </DialogActions>
          </Dialog>
        </div>
        <div>
          {/* Unlock DIALOG */}
          <Dialog
            className="DileteDialog"
            open={openUnlock}
            onClose={() => setOpenUnlock(false)}
          >
            <DialogTitle className="DTital">Unlock Locker! </DialogTitle>
            <DialogContent>
              <p> Are you sure Unlock this locker?</p>
              <p>
                ID - <i> {selecteLocker?.lockerId}</i>
              </p>
              <p>
                cluster id - <i> {selecteLocker?.lockerClusterId}</i>
              </p>
            </DialogContent>
            <DialogActions className="dialog-actions">
              <button className="CANCELB" onClick={() => setOpenUnlock(false)}>
                Cancel
              </button>
              <button
                className="UNLOCKB2"
                onClick={() => unlockLockerByID(selecteLocker?.lockerId)}
                variant="contained"
              >
                Unlock Locker
              </button>
            </DialogActions>
          </Dialog>
        </div>
        <div>
          {/* EDIT DIALOG */}
          <Dialog
            className="dialogbox"
            open={openEdit}
            onClose={() => setOpenEdit(false)}
          >
            <DialogTitle className="DTital">Edit Locker </DialogTitle>
            <div className="trance"></div>
            <DialogContent className="dialog-content">
              <TextField
                label="Locker id"
                name="lockerId"
                variant="outlined"
                className="no-border"
                value={selecteLocker?.lockerId + "     can't change"}
                disabled
                InputProps={{
                  style: { fontStyle: "italic" },
                }}
              />
              <TextField
                label="Cluster id"
                name="lockerClusterId"
                variant="outlined"
                className="no-border"
                value={selecteLocker?.lockerClusterId || ""}
                onChange={handleEditChange}
                disabled
                InputProps={{
                  style: { fontStyle: "italic" },
                }}
              />
              <TextField
                label="Display Number"
                name="displayNumber"
                variant="outlined"
                className="no-border"
                value={selecteLocker?.displayNumber || ""}
                onChange={handleEditChange}
              />

              <FormControl>
                <InputLabel>Role</InputLabel>
                <Select
                  name="lockerStatus"
                  value={selecteLocker?.lockerStatus || ""}
                  onChange={handleEditChange}
                  label="Role"
                >
                  <MenuItem value="AVAILABLE">AVAILABLE</MenuItem>
                  <MenuItem value="OCCUPIED">OCCUPIED</MenuItem>
                  <MenuItem value="BLOCKED">BLOCKED</MenuItem>
                </Select>
              </FormControl>
            </DialogContent>

            <DialogActions className="dialog-actions">
              <button className="DELETB" onClick={() => setOpenEdit(false)}>
                <X size={20} />
              </button>
              <button
                className="UNLOCKB"
                onClick={handleEditSave}
                variant="contained"
              >
                <Save size={20} />
              </button>
            </DialogActions>
          </Dialog>
        </div>
      </div>
    </div>
  );
};

export default Locker;
