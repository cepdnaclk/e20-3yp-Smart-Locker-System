import React, { useState, useEffect } from "react";
import Navbar from "../Navigationbar/Navigationbar";
import {
  getUserProfile,
  updateLockeradmin,
  changePassword,
  updateDP,
  dounlodDP,
  deleteDP,
  ChangePassword,
} from "../Services/api";
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
} from "@mui/material";
import { Save, KeyRound, X } from "lucide-react";
import "./User.css";

export default function User() {
  const [userD, setUserD] = useState({});
  const [openEdit, setOpenEdit] = useState(false);
  const [openPassword, setOpenPassword] = useState(false);
  const [openPicDialog, setOpenPicDialog] = useState(false);
  const [imageUrl, setImageUrl] = useState(null);
  const [editedUser, setEditedUser] = useState({});
  const [passwordData, setPasswordData] = useState({
    currentPassword: "",
    newPassword: "",
  });

  const [previewImg, setPreviewImg] = useState(null);
  const [imgFile, setImgFile] = useState(null);

  // Fetch user profile
  const handleUserData = async () => {
    try {
      const response = await getUserProfile();
      setUserD(response.data);
    } catch (error) {
      console.error("Error fetching data:", error);
      alert(`Invalid Request: Token ${localStorage.getItem("token")}`);
    }
  };

  // First: Fetch user profile
  useEffect(() => {
    handleUserData();
  }, []);

  // Second: Download image AFTER userD is available
  useEffect(() => {
    if (userD?.id) {
      handleImageDownlod(userD.id);
    }
  }, [userD]);

  // Handlers for Edit Dialog
  const handleEditOpen = () => {
    setEditedUser(userD);
    setOpenEdit(true);
  };

  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setEditedUser({ ...editedUser, [name]: value });
  };

  const handleEditSave = async () => {
    try {
      await updateLockeradmin(editedUser);
      setOpenEdit(false);
      handleUserData();
    } catch (error) {
      console.error("Full error object:", error);
      console.error("Response data:", error.response?.data);
      console.error("Response status:", error.response?.status);
    }
  };

  // Handlers for Password Dialog
  const handlePasswordOpen = () => {
    setPasswordData({ currentPassword: "", newPassword: "" });
    setOpenPassword(true);
  };

  const handlePasswordChange = (e) => {
    const { name, value } = e.target;
    setPasswordData({ ...passwordData, [name]: value });
  };

  const handlePasswordSave = async () => {
    try {
      await ChangePassword(
        passwordData.currentPassword,
        passwordData.newPassword
      );
      setOpenPassword(false);
      alert("Password changed successfully");
    } catch (error) {
      alert(
        "Password change failed: " + (error.response?.data || error.message)
      );
      console.error(error);
    }
  };

  // Handlers for Profile Picture Upload
  const handleImageSelect = (e) => {
    const file = e.target.files[0];
    if (file) {
      setImgFile(file);
      setPreviewImg(URL.createObjectURL(file));
    }
  };

  const handleImageUpload = async () => {
    if (!imgFile) return;

    const formData = new FormData();
    formData.append("file", imgFile);

    try {
      await deleteDP(userD.id);
      alert("Previous profile picture deleted.");
    } catch (err) {
      console.error("Failed to delete previous profile picture", err);
      // Decide whether to continue upload if deletion fails or stop here
      // If you want to stop:
      // alert("Failed to delete existing profile picture. Upload aborted.");
      // return;

      // If you want to continue anyway, just notify user:
      alert(
        "Warning: Failed to delete existing profile picture. Trying to upload new one."
      );
    }

    try {
      await updateDP(userD.id, formData);
      alert("Profile picture updated!");
      setOpenPicDialog(false);
      handleUserData();
    } catch (err) {
      console.error("Failed to upload new profile picture", err);
      alert("Failed to upload new profile picture.");
    }
  };

  const handleImageDownlod = async (id) => {
    try {
      const response = await dounlodDP(id);

      const imageBlob = new Blob([response.data], {
        type: response.headers["content-type"],
      });
      const imageObjectURL = URL.createObjectURL(imageBlob);
      setImageUrl(imageObjectURL);
    } catch (error) {
      console.error("Image load failed:", error);
    }
  };

  return (
    <div>
      <Navbar />
      <div className="UCP">
        <h2>My Profile</h2>
        <div className=" delailpalet">
          {/* Profile Picture */}
          <div className="user-details">
            <div className="profile-picture">
              <img src={imageUrl} alt="Profile" className="avatar" />
            </div>
            <button className="EDITB" onClick={() => setOpenPicDialog(true)}>
              Edit Profile Picture
            </button>
          </div>

          <div className="user-details">
            {userD.id && (
              <>
                <p>
                  <strong>ID:</strong> {userD.id}
                </p>
                <p>
                  <strong>Name:</strong> {userD.firstName} {userD.lastName}
                </p>
                <p>
                  <strong>Email:</strong> {userD.email}
                </p>
                <p>
                  <strong>Contact No:</strong> {userD.contactNumber}
                </p>
                <p>
                  <strong>Role:</strong> {userD.role}
                </p>
              </>
            )}
            <div className="action-buttons">
              <button className="EDITB" onClick={handleEditOpen}>
                Edit
              </button>
              <button className="UNLOCKB" onClick={handlePasswordOpen}>
                Change Password
              </button>
            </div>
          </div>
          {/* Profile Fields */}
        </div>

        {/* Action Buttons */}

        {/* === Edit Profile Dialog === */}
        <Dialog
          className="dialogbox"
          open={openEdit}
          onClose={() => setOpenEdit(false)}
        >
          <DialogTitle className="DTital">Edit Profile</DialogTitle>
          <DialogContent className="dialog-content">
            <TextField
              label="First Name"
              name="firstName"
              value={editedUser.firstName || ""}
              onChange={handleEditChange}
              fullWidth
              margin="dense"
            />
            <TextField
              label="Last Name"
              name="lastName"
              value={editedUser.lastName || ""}
              onChange={handleEditChange}
              fullWidth
              margin="dense"
            />
            <TextField
              label="Contact Number"
              name="contactNumber"
              value={editedUser.contactNumber || ""}
              onChange={handleEditChange}
              fullWidth
              margin="dense"
            />
            <TextField
              label="Email"
              name="email"
              value={editedUser.email || ""}
              onChange={handleEditChange}
              fullWidth
              margin="dense"
            />
          </DialogContent>
          <DialogActions>
            <button className="DELETB" onClick={() => setOpenEdit(false)}>
              <X size={18} />
            </button>
            <button className="UNLOCKB" onClick={handleEditSave}>
              <Save size={18} />
            </button>
          </DialogActions>
        </Dialog>

        {/* === Change Password Dialog === */}
        <Dialog
          className="dialogbox"
          open={openPassword}
          onClose={() => setOpenPassword(false)}
        >
          <DialogTitle className="DTital">Change Password</DialogTitle>
          <div className="trance"></div>
          <DialogContent className="dialog-content">
            <TextField
              label="Current Password"
              name="currentPassword"
              type="password"
              className="no-border"
              value={passwordData.currentPassword}
              onChange={handlePasswordChange}
              fullWidth
              margin="dense"
            />
            <TextField
              label="New Password"
              name="newPassword"
              type="password"
              className="no-border"
              value={passwordData.newPassword}
              onChange={handlePasswordChange}
              fullWidth
              margin="dense"
            />
          </DialogContent>
          <DialogActions>
            <button className="DELETB" onClick={() => setOpenPassword(false)}>
              <X size={18} />
            </button>
            <button className="UNLOCKB" onClick={handlePasswordSave}>
              <KeyRound size={18} />
            </button>
          </DialogActions>
        </Dialog>

        {/* === Edit Profile Picture Dialog === */}
        <Dialog
          className="dialogbox"
          open={openPicDialog}
          onClose={() => setOpenPicDialog(false)}
        >
          <DialogTitle className="DTital">Edit Profile Picture</DialogTitle>
          <div className="trance"></div>
          <DialogContent className="dialog-content">
            <input type="file" accept="image/*" onChange={handleImageSelect} />
            {previewImg && (
              <img
                src={previewImg}
                alt="Preview"
                style={{
                  marginTop: "10px",
                  width: "120px",
                  height: "120px",
                  objectFit: "cover",
                  borderRadius: "50%",
                }}
              />
            )}
          </DialogContent>
          <DialogActions>
            <button className="DELETB" onClick={() => setOpenPicDialog(false)}>
              <X size={18} />
            </button>
            <button className="UNLOCKB" onClick={handleImageUpload}>
              <Save size={18} />
            </button>
          </DialogActions>
        </Dialog>
      </div>
    </div>
  );
}
