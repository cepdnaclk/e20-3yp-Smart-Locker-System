import React from "react";
import { render, screen, fireEvent, waitFor } from "@testing-library/react";
import Signup from "../loginsignup/Signup";
import { BrowserRouter } from "react-router-dom";
import * as api from "../Services/api";

// Mock the signup API
jest.mock("../Services/api");

const renderWithRouter = (ui) => {
  return render(<BrowserRouter>{ui}</BrowserRouter>);
};

describe("Signup Component", () => {
  beforeEach(() => {
    localStorage.clear();
  });

  test("renders signup form", () => {
    renderWithRouter(<Signup />);
    expect(screen.getByText(/sign up/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/first name/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/last name/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/reg/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/phone number/i)).toBeInTheDocument();
    expect(screen.getByPlaceholderText(/email/i)).toBeInTheDocument();
    expect(
      screen.getByPlaceholderText("Enter your password")
    ).toBeInTheDocument();
    expect(
      screen.getByPlaceholderText("Re-enter Password")
    ).toBeInTheDocument();
  });

  test("shows error if passwords do not match", async () => {
    jest.spyOn(window, "alert").mockImplementation(() => {});
    renderWithRouter(<Signup />);

    fireEvent.change(screen.getByPlaceholderText(/first name/i), {
      target: { value: "John" },
    });
    fireEvent.change(screen.getByPlaceholderText(/last name/i), {
      target: { value: "Doe" },
    });
    fireEvent.change(screen.getByPlaceholderText(/reg/i), {
      target: { value: "EX1234" },
    });
    fireEvent.change(screen.getByPlaceholderText(/phone number/i), {
      target: { value: "0771234567" },
    });
    fireEvent.change(screen.getByPlaceholderText(/email/i), {
      target: { value: "john@example.com" },
    });
    fireEvent.change(screen.getByPlaceholderText("Enter your password"), {
      target: { value: "password123" },
    });
    fireEvent.change(screen.getByPlaceholderText("Re-enter Password"), {
      target: { value: "differentPassword" },
    });

    fireEvent.click(screen.getByRole("button", { name: /sign up/i }));

    await waitFor(() => {
      expect(window.alert).toHaveBeenCalledWith("Passwords do not match!");
    });

    window.alert.mockRestore();
  });

  test("calls signup API on valid form submission", async () => {
    api.signup.mockResolvedValue({ data: { message: "success" } });
    jest.spyOn(window, "alert").mockImplementation(() => {});

    renderWithRouter(<Signup />);

    fireEvent.change(screen.getByPlaceholderText(/first name/i), {
      target: { value: "Alice" },
    });
    fireEvent.change(screen.getByPlaceholderText(/last name/i), {
      target: { value: "Smith" },
    });
    fireEvent.change(screen.getByPlaceholderText(/reg/i), {
      target: { value: "EX9999" },
    });
    fireEvent.change(screen.getByPlaceholderText(/phone number/i), {
      target: { value: "0712345678" },
    });
    fireEvent.change(screen.getByPlaceholderText(/email/i), {
      target: { value: "alice@example.com" },
    });
    fireEvent.change(screen.getByPlaceholderText("Enter your password"), {
      target: { value: "mypassword" },
    });
    fireEvent.change(screen.getByPlaceholderText("Re-enter Password"), {
      target: { value: "mypassword" },
    });

    fireEvent.click(screen.getByRole("button", { name: /sign up/i }));

    await waitFor(() => {
      expect(api.signup).toHaveBeenCalledWith(
        "EX9999",
        "Alice",
        "Smith",
        "0712345678",
        "alice@example.com",
        "mypassword"
      );
      expect(window.alert).toHaveBeenCalledWith("Signup Successful!");
    });

    window.alert.mockRestore();
  });

  test("shows error alert when signup API fails", async () => {
    api.signup.mockRejectedValue(new Error("Signup failed"));
    jest.spyOn(window, "alert").mockImplementation(() => {});

    renderWithRouter(<Signup />);

    fireEvent.change(screen.getByPlaceholderText(/first name/i), {
      target: { value: "Fail" },
    });
    fireEvent.change(screen.getByPlaceholderText(/last name/i), {
      target: { value: "Case" },
    });
    fireEvent.change(screen.getByPlaceholderText(/reg/i), {
      target: { value: "EX0000" },
    });
    fireEvent.change(screen.getByPlaceholderText(/phone number/i), {
      target: { value: "0700000000" },
    });
    fireEvent.change(screen.getByPlaceholderText(/email/i), {
      target: { value: "fail@example.com" },
    });
    fireEvent.change(screen.getByPlaceholderText("Enter your password"), {
      target: { value: "failpass" },
    });
    fireEvent.change(screen.getByPlaceholderText("Re-enter Password"), {
      target: { value: "failpass" },
    });

    fireEvent.click(screen.getByRole("button", { name: /sign up/i }));

    await waitFor(() => {
      expect(api.signup).toHaveBeenCalled();
      expect(window.alert).toHaveBeenCalledWith("Invalid credentials");
    });

    window.alert.mockRestore();
  });
});
