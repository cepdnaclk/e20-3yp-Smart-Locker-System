import React from "react";
import { render, screen, waitFor } from "@testing-library/react";
import Map_page from "../Map/Map_page";
import { BrowserRouter } from "react-router-dom";
import * as lockerAPI from "../Services/lockerAPI";
import "@testing-library/jest-dom/extend-expect";

// Mock Leaflet and related dependencies
jest.mock("react-leaflet", () => {
  const MapContainer = ({ children }) => (
    <div data-testid="map-container">{children}</div>
  );
  const Marker = ({ children }) => <div data-testid="marker">{children}</div>;
  const Popup = ({ children }) => <div data-testid="popup">{children}</div>;
  const TileLayer = () => <div data-testid="tile-layer" />;
  const useMapEvents = () => {};
  return { MapContainer, Marker, Popup, TileLayer, useMapEvents };
});

// Mock ClipLoader
jest.mock("react-spinners", () => ({
  ClipLoader: () => <div data-testid="loader">Loading...</div>,
}));

// Mock Navbar
jest.mock("../Navigationbar/Navigationbar", () => () => (
  <div data-testid="navbar">Navbar</div>
));

describe("Map_page component", () => {
  const mockClusters = [
    {
      id: 1,
      clusterName: "Cluster A",
      latitude: 7.25,
      longitude: 80.59,
      availableNumberOfLockers: 5,
      totalNumberOfLockers: 10,
      lockerClusterDescription: "Near Main Library",
    },
  ];

  beforeEach(() => {
    jest.spyOn(lockerAPI, "getLockerClusterData").mockResolvedValue({
      data: mockClusters,
    });
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  const renderWithRouter = () =>
    render(
      <BrowserRouter>
        <Map_page />
      </BrowserRouter>
    );

  test("renders map page and fetches data", async () => {
    renderWithRouter();

    expect(screen.getByTestId("navbar")).toBeInTheDocument();
    expect(screen.getByText(/Locker Clusters Map/i)).toBeInTheDocument();
    expect(screen.getByTestId("loader")).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByTestId("map-container")).toBeInTheDocument();
    });

    expect(screen.getAllByTestId("marker")).toHaveLength(2); // One for user + one for cluster
    expect(screen.getByText(/Cluster A/i)).toBeInTheDocument();
    expect(screen.getByText(/Available Lockers/i)).toBeInTheDocument();
  });

  test("displays error alert if API fails", async () => {
    jest
      .spyOn(lockerAPI, "getLockerClusterData")
      .mockRejectedValue(new Error("API Error"));
    jest.spyOn(window, "alert").mockImplementation(() => {});

    renderWithRouter();

    await waitFor(() => {
      expect(window.alert).toHaveBeenCalledWith(
        `Invalid Request: Token ${localStorage.getItem("token")}`
      );
    });

    window.alert.mockRestore();
  });
});
