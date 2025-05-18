import { render, screen, fireEvent } from "@testing-library/react";
import Navbar from "./Navigationbar";
import { BrowserRouter as Router } from "react-router-dom"; // Use Router for Link to work

describe("Navbar", () => {
  test("renders Navbar links", () => {
    render(
      <Router>
        <Navbar />
      </Router>
    );

    // Check if the important links are rendered
    expect(screen.getByText("Dashboard")).toBeInTheDocument();
    expect(screen.getByText("User Management")).toBeInTheDocument();
    expect(screen.getByText("Locker Monitoring")).toBeInTheDocument();
    expect(screen.getByText("Map")).toBeInTheDocument();
    expect(screen.getByText("Reports & Analytics")).toBeInTheDocument();
    expect(screen.getByText("Admin Management")).toBeInTheDocument();
    expect(screen.getByText("Log Out")).toBeInTheDocument();
  });

  test("Log Out button works correctly", () => {
    // Mocking the window.location to test redirect
    delete window.location;
    window.location = { href: "" };

    render(
      <Router>
        <Navbar />
      </Router>
    );

    // Trigger the Log Out button
    const logoutButton = screen.getByText("Log Out");
    fireEvent.click(logoutButton);

    // Check if the window location changes (i.e., redirects to "/home")
    expect(window.location.href).toBe("/home");
  });
});
