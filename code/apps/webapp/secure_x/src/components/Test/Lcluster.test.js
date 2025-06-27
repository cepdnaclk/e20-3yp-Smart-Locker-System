import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import Lcluster from "./../LockerMonitoring/Lcluster/Lcluster";
import * as lockerAPI from "../Services/lockerAPI";

// Mock child components
jest.mock("../LocationPicker/Locationpick.js", () => ({
  Locationpick: ({ onChange }) => (
    <div
      data-testid="locationpick"
      onClick={() => onChange({ lat: 7.0, lng: 80.0 })}
    >
      Mock Location Picker
    </div>
  ),
  Locationpickwithcurrentval: ({ onChange }) => (
    <div
      data-testid="locationeditpick"
      onClick={() => onChange({ lat: 8.0, lng: 81.0 })}
    >
      Mock Location Edit Picker
    </div>
  ),
}));

// Mock API functions
jest.mock("../Services/lockerAPI");

describe("Lcluster component", () => {
  const mockCluster = {
    id: 1,
    totalNumberOfLockers: 10,
    availableNumberOfLockers: 5,
    clusterName: "Test Cluster",
    lockerClusterDescription: "Test Description",
    latitude: 6.0,
    longitude: 80.0,
  };

  beforeEach(() => {
    lockerAPI.getLockerClusterData.mockResolvedValue({ data: [mockCluster] });
    lockerAPI.addLockerCluster.mockResolvedValue({});
    lockerAPI.updateLockerCluster.mockResolvedValue({});
    lockerAPI.deleteLockerCluster.mockResolvedValue({});
  });

  it("renders cluster data from API", async () => {
    render(<Lcluster />);
    expect(await screen.findByText("Test Cluster")).toBeInTheDocument();
    expect(screen.getByText(/Locker Clusters/i)).toBeInTheDocument();
  });

  it("opens and submits add cluster dialog", async () => {
    render(<Lcluster />);
    fireEvent.click(screen.getByRole("button", { name: /add cluster/i }));
    expect(screen.getByText(/Add Locker Cluster/i)).toBeInTheDocument();

    fireEvent.change(screen.getByLabelText(/Total Locker Count/i), {
      target: { value: "15", name: "totalNumberOfLockers" },
    });
    fireEvent.change(screen.getByLabelText(/Name/i), {
      target: { value: "New Cluster", name: "clusterName" },
    });
    fireEvent.change(screen.getByLabelText(/Description/i), {
      target: { value: "Some desc", name: "lockerClusterDescription" },
    });

    fireEvent.click(screen.getByTestId("locationpick")); // trigger location picker
    fireEvent.click(screen.getByRole("button", { name: /add clusster/i }));

    await waitFor(() => {
      expect(lockerAPI.addLockerCluster).toHaveBeenCalledWith(
        expect.objectContaining({
          clusterName: "New Cluster",
          lockerClusterDescription: "Some desc",
          latitude: 7.0,
          longitude: 80.0,
        })
      );
    });
  });
});
