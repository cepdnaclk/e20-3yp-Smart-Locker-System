// UserManagement.test.js
import React from "react";
import { render, screen } from "@testing-library/react";
import UserManagement from "./UserManagement";

jest.mock("../Navigationbar/Navigationbar", () => () => <div>Navbar</div>);
jest.mock("./Newusers/Newusres.js", () => () => <div>New Users Component</div>);
jest.mock("./Users/Lockerusers.js", () => () => (
  <div>Locker Users Component</div>
));

describe("UserManagement component", () => {
  test("renders User Management Page heading", () => {
    render(<UserManagement />);
    const heading = screen.getByText(/User Management Page/i);
    expect(heading).toBeInTheDocument();
  });

  test("renders Navbar component", () => {
    render(<UserManagement />);
    const navbar = screen.getByText(/Navbar/i);
    expect(navbar).toBeInTheDocument();
  });

  test("renders Newusres and Lockerusers components", () => {
    render(<UserManagement />);
    expect(screen.getByText(/New Users Component/i)).toBeInTheDocument();
    expect(screen.getByText(/Locker Users Component/i)).toBeInTheDocument();
  });
});
