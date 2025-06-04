import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import Locker from "./../LockerMonitoring/Locker/Locker";
import * as lockerAPI from "../Services/lockerAPI.js";

// Mock the API functions
jest.mock("../Services/lockerAPI");

describe("Locker Component", () => {
  const mockLockers = [
    {
      lockerId: 1,
      displayNumber: "A1",
      lockerStatus: "AVAILABLE",
      lockerLogs: "None",
      lockerClusterId: 101,
    },
    {
      lockerId: 2,
      displayNumber: "B2",
      lockerStatus: "OCCUPIED",
      lockerLogs: "Used by user",
      lockerClusterId: 102,
    },
  ];

  const mockClusters = [
    {
      id: 101,
      clusterName: "Cluster Alpha",
    },
    {
      id: 102,
      clusterName: "Cluster Beta",
    },
  ];

  beforeEach(() => {
    lockerAPI.getLockerData.mockResolvedValue({ data: mockLockers });
    lockerAPI.getLockerClusterData.mockResolvedValue({ data: mockClusters });
  });

  test("renders locker component with heading", async () => {
    render(<Locker />);
    const heading = await screen.findByText("Lockers");
    expect(heading).toBeInTheDocument();
  });

  test("displays lockers after fetching", async () => {
    render(<Locker />);
    expect(await screen.findByText("A1")).toBeInTheDocument();
    expect(await screen.findByText("B2")).toBeInTheDocument();
  });

  test("filters lockers by status", async () => {
    render(<Locker />);
    await screen.findByText("A1");

    const availableRadio = screen.getByLabelText("AVAILABLE");
    fireEvent.click(availableRadio);

    await waitFor(() => {
      expect(screen.getByText("A1")).toBeInTheDocument();
      expect(screen.queryByText("B2")).not.toBeInTheDocument();
    });
  });

  test("opens Add Locker dialog", async () => {
    render(<Locker />);
    await screen.findByText("Lockers");

    const addButton = screen.getByRole("button", { name: /add locker/i });
    fireEvent.click(addButton);

    const dialogTitle = await screen.findByText(
      /Add Locker To Locker Cluster/i
    );
    expect(dialogTitle).toBeInTheDocument();
  });

  test("opens Edit Locker dialog", async () => {
    render(<Locker />);
    await screen.findByText("A1");

    const editButtons = screen.getAllByRole("button", { name: /edit/i });
    fireEvent.click(editButtons[0]);

    const dialog = await screen.findByText(/Edit Locker/i);
    expect(dialog).toBeInTheDocument();
  });
});
