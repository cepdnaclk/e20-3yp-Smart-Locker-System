import React, { useState, useEffect } from "react";
import {
  getLockerData,
  addLockerTOLockerCluster,
} from "../../Services/lockerAPI";
import { SquarePen, Trash2, SquarePlus, KeyRound } from "lucide-react";
import Tooltip from "@mui/material/Tooltip";
import "../../Button/Button.css";
import "../../TableStyle/Table.css";
import "./Locker.css";
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

const Locker = () => {
  const [locker, setLocker] = useState([]);
  const [openAdd, setOpenAdd] = useState(false);
  const [ClussterId, setClustersId] = useState(null);

  // Fetch locker users
  const handleLocker = async () => {
    console.log("Fetching locker cluster data");
    try {
      const response = await getLockerData();
      // Adjust the filtering as needed
      const locker = response.data;
      setLocker(locker);
      console.log("Locker Data:", locker);
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
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

  // Fetch data when the component mounts
  useEffect(() => {
    handleLocker();
  }, []);

  return (
    <div>
      <h2>Lockers</h2>
      <div className="ActionB">
        <Tooltip
          title="Add locker"
          arrow
          onClick={() => handleAddClick()}
          componentsProps={{
            tooltip: {
              sx: { fontSize: "12px", backgroundcolor: "black", color: "#fff" },
            },
          }}
        >
          <button className="ADDB">
            <SquarePlus size={20} />
          </button>
        </Tooltip>
      </div>
      <table className="Ctable">
        <thead>
          <tr>
            <th>LockerID</th>
            <th>Disply Number</th>
            <th>Status</th>
            {/* <th>Locker Log</th> */}
            <th>Locker Cluster</th>

            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {locker.map((user) => (
            <tr key={user.lockerId}>
              <td>{user.lockerId}</td>
              <td>{user.displayNumber}</td>
              <td>{user.lockerStatus}</td>
              {/* <td>{user.lockerLogs}</td> */}
              <td>{user.lockerClusterId}</td>
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
                  <button className="EDITB">
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
                  <button className="UNLOCKB">
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
                  <button className="DELETB">
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
    </div>
  );
};

export default Locker;
