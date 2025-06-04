import axios from "axios";
import * as api from "../Services/api";

// Mock axios
jest.mock("axios", () => ({
  create: jest.fn(() => ({
    get: jest.fn(),
    post: jest.fn(),
    put: jest.fn(),
    delete: jest.fn(),
    patch: jest.fn(),
  })),
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
  delete: jest.fn(),
  patch: jest.fn(),
}));

const mockedAxios = axios;

describe("API Service Functions", () => {
  let mockAxiosInstance;

  beforeEach(() => {
    // Clear localStorage
    localStorage.clear();
    jest.clearAllMocks();

    // Create mock axios instance
    mockAxiosInstance = {
      get: jest.fn(),
      post: jest.fn(),
      put: jest.fn(),
      delete: jest.fn(),
      patch: jest.fn(),
    };

    // Mock axios.create to return our mock instance
    mockedAxios.create.mockReturnValue(mockAxiosInstance);

    // Mock localStorage
    Object.defineProperty(window, "localStorage", {
      value: {
        getItem: jest.fn(),
        setItem: jest.fn(),
        removeItem: jest.fn(),
        clear: jest.fn(),
      },
      writable: true,
    });
  });

  test("login() sends correct POST request", async () => {
    const mockResponse = { data: { token: "abc123" } };
    mockAxiosInstance.post.mockResolvedValue(mockResponse);

    const result = await api.login("user", "pass");

    expect(mockAxiosInstance.post).toHaveBeenCalledWith("/login", {
      username: "user",
      password: "pass",
    });
    expect(result.data.token).toBe("abc123");
  });

  test("signup() sends correct POST request", async () => {
    const mockData = {
      regNo: "EX123",
      firstName: "John",
      lastName: "Doe",
      contactNumber: "1234567890",
      email: "john@example.com",
      password: "password123",
    };

    const mockResponse = { data: { success: true } };
    mockAxiosInstance.post.mockResolvedValue(mockResponse);

    const result = await api.signup(
      mockData.regNo,
      mockData.firstName,
      mockData.lastName,
      mockData.contactNumber,
      mockData.email,
      mockData.password
    );

    expect(mockAxiosInstance.post).toHaveBeenCalledWith(
      "/newUsers/register",
      mockData
    );
    expect(result.data.success).toBe(true);
  });

  test("getProtectedData() uses token from localStorage", async () => {
    const mockToken = "test_token";
    localStorage.getItem = jest.fn().mockReturnValue(` ${mockToken} `);

    const mockResponse = { data: { msg: "OK" } };
    mockAxiosInstance.get.mockResolvedValue(mockResponse);

    const result = await api.getProtectedData();

    expect(mockAxiosInstance.get).toHaveBeenCalledWith("/protected", {
      headers: { Authorization: `Bearer ${mockToken}` },
    });
    expect(result.data.msg).toBe("OK");
  });

  test("getPendingUsresData() uses correct endpoint and headers", async () => {
    const mockToken = "test_token";
    localStorage.getItem = jest.fn().mockReturnValue(mockToken);

    const mockResponse = { data: { users: [] } };
    mockAxiosInstance.get.mockResolvedValue(mockResponse);

    await api.getPendingUsresData();

    expect(mockAxiosInstance.get).toHaveBeenCalledWith("/admin/pending", {
      headers: { Authorization: `Bearer ${mockToken}` },
    });
  });

  test("putLockeUsresData() fails gracefully when token is missing", async () => {
    localStorage.getItem = jest.fn().mockReturnValue(null);
    console.error = jest.fn();

    const result = await api.putLockeUsresData("user123");

    expect(console.error).toHaveBeenCalledWith(
      "JWT Token is missing! Check localStorage."
    );
    expect(result).toBeUndefined();
    expect(mockAxiosInstance.put).not.toHaveBeenCalled();
  });

  test("putLockeUsresData() sends PUT request with auth header when token exists", async () => {
    const mockToken = "test_token";
    localStorage.getItem = jest.fn().mockReturnValue(mockToken);

    const mockResponse = { data: { success: true } };
    mockAxiosInstance.put.mockResolvedValue(mockResponse);

    const result = await api.putLockeUsresData("user123");

    expect(mockAxiosInstance.put).toHaveBeenCalledWith(
      "/admin/approve/user123",
      {},
      {
        headers: {
          Authorization: `Bearer ${mockToken}`,
          "Content-Type": "application/json",
        },
      }
    );
    expect(result.data.success).toBe(true);
  });

  test("rejectPendingUser() sends DELETE request with auth header", async () => {
    const mockToken = "tok123";
    localStorage.getItem = jest.fn().mockReturnValue(mockToken);

    const mockResponse = { data: { msg: "Deleted" } };
    mockAxiosInstance.delete.mockResolvedValue(mockResponse);

    const result = await api.rejectPendingUser("user456");

    expect(mockAxiosInstance.delete).toHaveBeenCalledWith(
      "/admin/reject/user456",
      {
        headers: {
          Authorization: `Bearer ${mockToken}`,
          "Content-Type": "application/json",
        },
      }
    );
    expect(result.data.msg).toBe("Deleted");
  });

  test("getLockerUsresData() uses correct endpoint and headers", async () => {
    const mockToken = "test_token";
    localStorage.getItem = jest.fn().mockReturnValue(mockToken);

    const mockResponse = { data: { users: [] } };
    mockAxiosInstance.get.mockResolvedValue(mockResponse);

    await api.getLockerUsresData();

    expect(mockAxiosInstance.get).toHaveBeenCalledWith("/admin/getAllUsers", {
      headers: { Authorization: `Bearer ${mockToken}` },
    });
  });

  test("deletLockeUsresData() requires token", async () => {
    localStorage.getItem = jest.fn().mockReturnValue(null);
    console.error = jest.fn();

    const result = await api.deletLockeUsresData("user123");

    expect(console.error).toHaveBeenCalledWith(
      "JWT Token is missing! Check localStorage."
    );
    expect(result).toBeUndefined();
  });

  test("findUserByID() requires token", async () => {
    localStorage.getItem = jest.fn().mockReturnValue(null);
    console.error = jest.fn();

    const result = await api.findUserByID("user123");

    expect(console.error).toHaveBeenCalledWith(
      "JWT Token is missing! Check localStorage.sesion expire "
    );
    expect(result).toBeUndefined();
  });

  test("updateLockerUser() requires token", async () => {
    localStorage.getItem = jest.fn().mockReturnValue(null);
    console.error = jest.fn();

    const result = await api.updateLockerUser("user123", { name: "John" });

    expect(console.error).toHaveBeenCalledWith(
      "JWT Token is missing! Check localStorage.sesion expire "
    );
    expect(result).toBeUndefined();
  });
});
