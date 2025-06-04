import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import LockerUsers from "../UserManagement/Users/Lockerusers.js";

jest.mock("../../Services/api.js", () => ({
  getLockerUsresData: jest.fn(),
  deletLockeUsresData: jest.fn(),
  findUserByID: jest.fn(),
  updateLockerUser: jest.fn(),
}));

import {
  getLockerUsresData,
  deletLockeUsresData,
  findUserByID,
  updateLockerUser,
} from "../../Services/api.js";

describe("LockerUsers Component", () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test("fetches and displays locker users", async () => {
    // Mock API response for users
    getLockerUsresData.mockResolvedValue({
      data: [
        {
          id: 1,
          firstName: "Alice",
          lastName: "Wonderland",
          contactNumber: "1234567890",
          email: "alice@example.com",
          role: "USER",
        },
      ],
    });

    render(<LockerUsers />);

    // Wait and check if the user is displayed
    expect(await screen.findByText("Alice")).toBeInTheDocument();
    expect(screen.getByText("Wonderland")).toBeInTheDocument();
  });

  test("opens and closes delete dialog", async () => {
    getLockerUsresData.mockResolvedValue({
      data: [
        {
          id: 1,
          firstName: "Alice",
          lastName: "Wonderland",
          contactNumber: "1234567890",
          email: "alice@example.com",
          role: "USER",
        },
      ],
    });

    render(<LockerUsers />);

    // Wait for user row
    await screen.findByText("Alice");

    // Click Delete button
    fireEvent.click(screen.getByRole("button", { name: /Delete User/i }));

    // Dialog should open
    expect(screen.getByText(/Delete User!/i)).toBeInTheDocument();

    // Click Cancel button to close dialog
    fireEvent.click(screen.getByText(/Cancel/i));

    // Wait for dialog to close
    await waitFor(() =>
      expect(screen.queryByText(/Delete User!/i)).not.toBeInTheDocument()
    );
  });

  test("searches for a user", async () => {
    findUserByID.mockResolvedValue({
      data: {
        id: 2,
        firstName: "Bob",
        lastName: "Builder",
        contactNumber: "0987654321",
        email: "bob@example.com",
        role: "USER",
      },
    });

    render(<LockerUsers />);

    // Type username/id into search input
    fireEvent.change(screen.getByPlaceholderText(/Enter username/i), {
      target: { value: "2" },
    });

    // Click Search button
    fireEvent.click(screen.getByRole("button", { name: /Search user/i }));

    // Check if searched user appears
    expect(await screen.findByText("Bob")).toBeInTheDocument();
  });
});
