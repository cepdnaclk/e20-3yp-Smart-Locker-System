import React from "react";
import { render, screen, waitFor, fireEvent } from "@testing-library/react";
import Newusers from "../UserManagement/Newusers/Newusres.js";

jest.mock("../../Services/api.js", () => ({
  getPendingUsresData: jest.fn(),
  putLockeUsresData: jest.fn(),
  rejectPendingUser: jest.fn(),
}));

import {
  getPendingUsresData,
  putLockeUsresData,
  rejectPendingUser,
} from "../../Services/api.js";

describe("Newusers Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("renders pending users and allows accepting a user", async () => {
    getPendingUsresData.mockResolvedValue({
      data: [
        {
          id: 1,
          regNo: "REG123",
          firstName: "John",
          lastName: "Doe",
          contactNumber: "1234567890",
          email: "john@example.com",
          role: "User",
          status: "Pending",
        },
      ],
    });

    putLockeUsresData.mockResolvedValue({});

    render(<Newusers />);

    expect(await screen.findByText(/Pending Users/i)).toBeInTheDocument();

    // Check that user info is rendered
    expect(await screen.findByText("John")).toBeInTheDocument();

    // Click accept button
    fireEvent.click(screen.getByRole("button", { name: /Accept/i }));

    await waitFor(() => {
      expect(putLockeUsresData).toHaveBeenCalledWith(1);
    });
  });

  test("opens and closes reject dialog", async () => {
    getPendingUsresData.mockResolvedValue({
      data: [
        {
          id: 2,
          regNo: "REG456",
          firstName: "Jane",
          lastName: "Smith",
          contactNumber: "9876543210",
          email: "jane@example.com",
          role: "User",
          status: "Pending",
        },
      ],
    });

    rejectPendingUser.mockResolvedValue({});

    render(<Newusers />);

    // Click reject button
    fireEvent.click(screen.getByRole("button", { name: /Reject/i }));

    // Dialog should open
    expect(screen.getByText(/Reject Pending User!/i)).toBeInTheDocument();

    // Click cancel button to close dialog
    fireEvent.click(screen.getByText(/Cancel/i));

    await waitFor(() => {
      expect(
        screen.queryByText(/Reject Pending User!/i)
      ).not.toBeInTheDocument();
    });
  });
});
