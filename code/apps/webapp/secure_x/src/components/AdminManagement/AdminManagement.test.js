import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import AdminManagement from './AdminManagement';
import { getLockerUsresData } from '../Services/api';
import Navbar from '../Navigationbar/Navigationbar';
import ShowUserData from '../Tabs/Width/WidthFullUserData.js';

jest.mock('../Services/api');
jest.mock('../Navigationbar/Navigationbar', () => () => <div>Mocked Navbar</div>);
jest.mock('../Tabs/Width/WidthFullUserData.js', () => () => <div>Mocked ShowUserData</div>);

describe('AdminManagement Component', () => {
  test('renders AdminManagement component', () => {
    render(<AdminManagement />);
    expect(screen.getByText('Admin Management Page')).toBeInTheDocument();
    expect(screen.getByText('Mocked Navbar')).toBeInTheDocument();
  });

  test('fetches and displays admin users', async () => {
    const mockAdmins = [
      { id: 1, regNo: 'A001', firstName: 'John', lastName: 'Doe', contactNumber: '123456789', email: 'john@example.com', role: 'ADMIN' }
    ];
    getLockerUsresData.mockResolvedValue({ data: mockAdmins });
    localStorage.setItem('User', '1');

    render(<AdminManagement />);

    await waitFor(() => {
      expect(screen.getByText('Mocked ShowUserData')).toBeInTheDocument();
      expect(screen.getByText('Admin Management Page')).toBeInTheDocument();
    });
  });

  test('displays error message on failed fetch', async () => {
    getLockerUsresData.mockRejectedValue(new Error('Network Error'));

    render(<AdminManagement />);

    await waitFor(() => {
      expect(screen.getByText(/Invalid Request:/)).toBeInTheDocument();
    });
  });
});
