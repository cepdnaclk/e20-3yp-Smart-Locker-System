import React, { useState, useEffect } from "react";
import {
  getLockerClusterData,
  updateLockerCluster,
  deleteLockerCluster,
  addLockerCluster,
} from "../../Services/lockerAPI";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";
import "./Lcluster.css";
import { SquarePen, Trash2, Grid2x2Plus, X, Save } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import {
  //Button,
  TextField,
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  // FormControl,
  // InputLabel,
  // Select,
  // MenuItem,
} from "@mui/material";
const Lcluster = () => {
  const [clusters, setClusters] = useState([]);
  const [openAdd, setOpenAdd] = useState(false);
  const [openEdit, setOpenEdit] = useState(false);
  const [openDelet, setOpenDelet] = useState(false);
  const [selectedCluster, setSelectedCluster] = useState(null);
  const [newCluster, setNewCluster] = useState({});

  // Fetch locker users
  const handleLockerCluster = async () => {
    console.log("Fetching locker cluster data");
    try {
      const response = await getLockerClusterData();
      // Adjust the filtering as needed
      const lockerClusters = response.data;
      setClusters(lockerClusters);
      console.log("Cluster Data:", lockerClusters);
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };
  // add locker cluster
  const handleAddLockerCluster = async () => {
    console.log("Fetching locker cluster data");
    try {
      await addLockerCluster(newCluster);
      setOpenAdd(false);
      handleLockerCluster();
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  const handleAddClick = (e) => {
    setOpenAdd(true);
  };
  const handleAddChange = (e) => {
    const { name, value } = e.target;
    setNewCluster({ ...newCluster, [name]: value });
  };

  // Edit dialog and data handaling
  const handleEditClick = (cluster) => {
    setSelectedCluster(cluster);
    setOpenEdit(true);
  };
  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setSelectedCluster({ ...selectedCluster, [name]: value });
  };

  const handleEditSave = async () => {
    try {
      await updateLockerCluster(selectedCluster.id, selectedCluster);
      setOpenEdit(false);
      handleLockerCluster(); // Refresh data
    } catch (error) {
      console.error("Update error:", error);
      alert("Failed to update cluster");
    }
  };
  // delet dialog and data handaling
  const handaleDeletClick = (cluster) => {
    setSelectedCluster(cluster);
    setOpenDelet(true);
  };

  const handleDeletCluster = async () => {
    try {
      await deleteLockerCluster(selectedCluster.id);
      setOpenDelet(false);
      handleLockerCluster(); // Refresh data
    } catch (error) {
      console.error("Delet error:", error);
      alert("Failed to delete cluster");
    }
  };

  // Fetch data when the component mounts
  useEffect(() => {
    handleLockerCluster();
  }, []);

  // manin return part
  return (
    <div>
      <h2>Locker Clusters</h2>
      <div className="ActionB">
        <Tooltip
          title="Add Cluster"
          arrow
          componentsProps={{
            tooltip: {
              sx: { fontSize: "12px", backgroundcolor: "black", color: "#fff" },
            },
          }}
        >
          <button className="ADDB" onClick={() => handleAddClick()}>
            <Grid2x2Plus size={20} />
          </button>
        </Tooltip>
      </div>

      <table className="Ctable">
        <thead>
          <tr>
            <th>ID</th>
            <th>Total locker count</th>
            <th>Avalable locker count</th>
            <th>Name</th>
            <th>Info.</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {clusters.map((cluster) => (
            <tr key={cluster.id}>
              <td>{cluster.id}</td>
              <td>{cluster.totalNumberOfLockers}</td>
              <td>{cluster.availableNumberOfLockers}</td>
              <td>{cluster.clusterName}</td>
              <td>{cluster.lockerClusterDescription}</td>
              <td className="ActionF" arrow>
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
                    onClick={() => handleEditClick(cluster)}
                  >
                    {" "}
                    <SquarePen size={16} />
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
                    onClick={() => handaleDeletClick(cluster)}
                    className="DELETB"
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
        {/* ADD new cluster dialog */}
        <Dialog
          className="AddDialog"
          open={openAdd}
          onClose={() => setOpenAdd(false)}
        >
          <DialogTitle className="DTital">Add Locker Cluster </DialogTitle>
          <div className="trance"></div>
          <DialogContent className="dialog-content">
            <p>
              <b>
                <i>Cluster id will auto genarate </i>
              </b>
            </p>
            <TextField
              label="Total Locker Count"
              name="totalNumberOfLockers"
              variant="outlined"
              className="no-border"
              onChange={handleAddChange}
            />
            <TextField
              label="Name"
              name="clusterName"
              variant="outlined"
              className="no-border"
              onChange={handleAddChange}
            />
            <TextField
              label="Description"
              name="lockerClusterDescription"
              variant="outlined"
              className="no-border"
              onChange={handleAddChange}
            />
          </DialogContent>
          <DialogActions className="dialog-actions">
            <button className="DELETEB" onClick={() => setOpenAdd(false)}>
              Cancel
            </button>
            <button
              className="CANCELB"
              onClick={() => handleAddLockerCluster()}
              variant="contained"
            >
              Add Clusster
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
          <DialogTitle className="DTital">Edit User </DialogTitle>
          <div className="trance"></div>
          <DialogContent className="dialog-content">
            <TextField
              label="Clusster id"
              name="id"
              variant="outlined"
              className="no-border"
              value={selectedCluster?.id + "     can't change"}
              disabled
              InputProps={{
                style: { fontStyle: "italic" },
              }}
            />
            <TextField
              label="Total number of locker"
              name="totalNumberOfLockers"
              variant="outlined"
              className="no-border"
              value={
                selectedCluster?.totalNumberOfLockers + "     can't change"
              }
              disabled
              InputProps={{
                style: { fontStyle: "italic" },
              }}
            />
            <TextField
              label="Cluster name"
              name="clusterName"
              variant="outlined"
              className="no-border"
              value={selectedCluster?.clusterName || ""}
              onChange={handleEditChange}
            />
            <TextField
              label="Discription"
              name="lockerClusterDescription"
              variant="outlined"
              className="no-border"
              value={selectedCluster?.lockerClusterDescription || ""}
              onChange={handleEditChange}
            />
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
      <div>
        {/* DELET DIALOG */}
        <Dialog
          className="DileteDialog"
          open={openDelet}
          onClose={() => setOpenDelet(false)}
        >
          <DialogTitle className="DTital">Delet Locker Cluster! </DialogTitle>
          <DialogContent>
            <p> Are you sure delet this locker cluster?</p>
            <div>
              <div>
                Cluster ID - <b>{selectedCluster?.id}</b>
              </div>
              <div>Name - {selectedCluster?.clusterName}</div>
              <div>Info - {selectedCluster?.lockerClusterDescription}</div>
            </div>
          </DialogContent>
          <DialogActions className="dialog-actions">
            <button className="CANCELB" onClick={() => setOpenDelet(false)}>
              Cancel
            </button>
            <button
              className="DELETEB"
              onClick={() => handleDeletCluster(selectedCluster.id)}
              variant="contained"
            >
              Delete Cluster
            </button>
          </DialogActions>
        </Dialog>
      </div>
    </div>
  );
};

export default Lcluster;
