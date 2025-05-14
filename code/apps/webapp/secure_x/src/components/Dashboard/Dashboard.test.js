import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import Dashboard from './Dashboard';
import { getLockerUsresData } from '../Services/api';
import { getLockerData, getLockerClusterData } from '../Services/lockerAPI';
import Navbar from '../Navigationbar/Navigationbar.js';

jest.mock('../Services/api');
jest.mock('../Services/lockerAPI');
jest.mock('../Navigationbar/Navigationbar', () => () => <div>Mocked Navbar</div>);

beforeEach(() => {
  localStorage.clear();
});

describe('Dashboard Component', () => {
  test('renders Dashboard component with Navbar', () => {
    render(<Dashboard />);
    expect(screen.getByText('Dashboard')).toBeInTheDocument();
    expect(screen.getByText('Mocked Navbar')).toBeInTheDocument();
  });

  test('shows welcome alert on first visit', () => {
    jest.spyOn(window, 'alert').mockImplementation(() => {});
    render(<Dashboard />);
    expect(window.alert).toHaveBeenCalledWith(
      'Welcome to the Dashboard! \nThis is your main dashboard area.'
    );
  });

  test('fetches and displays user and locker data', async () => {
    const mockUsers = [
      { id: 1, regNo: 'A001', firstName: 'John', lastName: 'Doe', contactNumber: '123456789', email: 'john@example.com', role: 'ADMIN' }
    ];
    const mockLockers = [{ id: 1 }, { id: 2 }];
    const mockClusters = [{ id: 1 }];

    getLockerUsresData.mockResolvedValue({ data: mockUsers });
    getLockerData.mockResolvedValue({ data: mockLockers });
    getLockerClusterData.mockResolvedValue({ data: mockClusters });

    render(<Dashboard />);

    await waitFor(() => {
      expect(screen.getByText('Total users')).toBeInTheDocument();
      expect(screen.getByText('1')).toBeInTheDocument();
      expect(screen.getByText('Locker clusters')).toBeInTheDocument();
      expect(screen.getByText('1')).toBeInTheDocument();
      expect(screen.getByText('Total lockers')).toBeInTheDocument();
      expect(screen.getByText('2')).toBeInTheDocument();
    });
  });

  test('handles errors during data fetching', async () => {
    getLockerUsresData.mockRejectedValue(new Error('Network Error'));

    render(<Dashboard />);

    await waitFor(() => {
      expect(screen.getByText(/Invalid Request:/)).toBeInTheDocument();
    });
  });
});
