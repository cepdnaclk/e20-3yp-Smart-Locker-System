import axios from "axios";
import { getLockerClusterData, addLockerCluster } from "../Services/lockerAPI";

jest.mock("axios");

describe("Locker Cluster API", () => {
  beforeEach(() => {
    localStorage.setItem("token", "mocked-token");
  });

  afterEach(() => {
    jest.clearAllMocks();
    localStorage.clear();
  });

  test("getLockerClusterData should call API and return data", async () => {
    const mockData = [{ id: 1, clusterName: "Test Cluster" }];
    axios.get.mockResolvedValue({ data: mockData });

    const response = await getLockerClusterData();

    expect(axios.get).toHaveBeenCalledWith(
      "/getAllLockerClusters",
      expect.objectContaining({
        headers: expect.objectContaining({
          Authorization: "Bearer mocked-token",
        }),
      })
    );
    expect(response.data).toEqual(mockData);
  });

  test("addLockerCluster should call API with data", async () => {
    const newCluster = { clusterName: "New Cluster" };
    axios.post.mockResolvedValue({ data: { success: true } });

    const response = await addLockerCluster(newCluster);

    expect(axios.post).toHaveBeenCalledWith(
      "/addLockerCluster",
      newCluster,
      expect.objectContaining({
        headers: expect.objectContaining({
          Authorization: "Bearer mocked-token",
        }),
      })
    );
    expect(response.data).toEqual({ success: true });
  });

  test("addLockerCluster should not call API if no token", async () => {
    localStorage.removeItem("token");
    const consoleSpy = jest.spyOn(console, "error").mockImplementation();

    const result = await addLockerCluster({ clusterName: "Fail Cluster" });

    expect(consoleSpy).toHaveBeenCalledWith(
      "JWT Token is missing! Check localStorage.sesion expire "
    );
    expect(result).toBeUndefined();

    consoleSpy.mockRestore();
  });
});
