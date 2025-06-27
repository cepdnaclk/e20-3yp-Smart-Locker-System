import React from "react";
import { render, screen } from "@testing-library/react";
import LockerMonitoring from "./../LockerMonitoring/LockerMonitoring";

// Mock child components to isolate the test
jest.mock("../Navigationbar/Navigationbar", () => () => (
  <div data-testid="navbar">Navbar</div>
));
jest.mock("./Lcluster/Lcluster", () => () => (
  <div data-testid="lcluster">Lcluster</div>
));
jest.mock("./Locker/Locker", () => () => (
  <div data-testid="locker">Locker</div>
));

describe("LockerMonitoring Component", () => {
  test("renders without crashing and displays all components", () => {
    render(<LockerMonitoring />);

    expect(screen.getByTestId("navbar")).toBeInTheDocument();
    expect(screen.getByText(/Locker Monitoring page/i)).toBeInTheDocument();
    expect(screen.getByTestId("lcluster")).toBeInTheDocument();
    expect(screen.getByTestId("locker")).toBeInTheDocument();
  });
});
