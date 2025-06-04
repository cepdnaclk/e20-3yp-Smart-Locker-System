import React from "react";
import { render, screen } from "@testing-library/react";
import { BrowserRouter } from "react-router-dom";
import Navbar from "../Navigationbar/Navigationbar";
import "@testing-library/jest-dom/extend-expect";

describe("Navbar component", () => {
  const renderNavbar = () =>
    render(
      <BrowserRouter>
        <Navbar />
      </BrowserRouter>
    );

  test("renders navbar with all links and icons", () => {
    renderNavbar();

    expect(screen.getByText(/Secure X/i)).toBeInTheDocument();

    expect(
      screen.getByRole("link", { name: /Dashboard/i })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("link", { name: /User Management/i })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("link", { name: /Locker Monitoring/i })
    ).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /Map/i })).toBeInTheDocument();
    expect(
      screen.getByRole("link", { name: /Reports & Analytics/i })
    ).toBeInTheDocument();
    expect(
      screen.getByRole("link", { name: /Admin Management/i })
    ).toBeInTheDocument();
    expect(screen.getByRole("link", { name: /Log Out/i })).toBeInTheDocument();
  });

  test("log out link has correct style", () => {
    renderNavbar();
    const logoutLink = screen.getByRole("link", { name: /Log Out/i });
    const logoutLi = logoutLink.closest("li");

    expect(logoutLi).toHaveStyle("background-color: red");
    expect(logoutLi).toHaveStyle("color: white");
  });
});
