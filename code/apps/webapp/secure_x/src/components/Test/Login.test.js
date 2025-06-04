import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import Login from "../loginsignup/Login";
import { BrowserRouter } from "react-router-dom";
import * as api from "../Services/api";

// Mock the `login` API function
jest.mock("../Services/api");

const renderWithRouter = (ui) => {
  return render(<BrowserRouter>{ui}</BrowserRouter>);
};

describe("Login Component", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  test("renders login form", () => {
    renderWithRouter(<Login />);
    expect(screen.getByText("SIGN IN")).toBeInTheDocument();
    expect(screen.getByLabelText(/username/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(
      screen.getByRole("button", { name: /sign in/i })
    ).toBeInTheDocument();
  });

  test("submits form with valid credentials", async () => {
    const mockToken = "mockedToken123";
    api.login.mockResolvedValue({ data: { token: mockToken } });

    renderWithRouter(<Login />);

    fireEvent.change(screen.getByPlaceholderText(/enter your username/i), {
      target: { value: "E20212" },
    });
    fireEvent.change(screen.getByPlaceholderText(/enter your password/i), {
      target: { value: "Sameera123" },
    });

    fireEvent.click(screen.getByRole("button", { name: /sign in/i }));

    await waitFor(() => {
      expect(api.login).toHaveBeenCalledWith("testuser", "password123");
      expect(localStorage.getItem("token")).toBe(mockToken);
      expect(localStorage.getItem("User")).toBe("testuser");
    });
  });

  test("shows alert and logs error on failed login", async () => {
    const error = new Error("Invalid credentials");
    api.login.mockRejectedValue(error);
    jest.spyOn(window, "alert").mockImplementation(() => {});

    renderWithRouter(<Login />);

    fireEvent.change(screen.getByPlaceholderText(/enter your username/i), {
      target: { value: "wronguser" },
    });
    fireEvent.change(screen.getByPlaceholderText(/enter your password/i), {
      target: { value: "wrongpass" },
    });

    fireEvent.click(screen.getByRole("button", { name: /sign in/i }));

    await waitFor(() => {
      expect(api.login).toHaveBeenCalled();
      expect(window.alert).toHaveBeenCalledWith("Invalid credentials");
    });

    window.alert.mockRestore();
  });
});
