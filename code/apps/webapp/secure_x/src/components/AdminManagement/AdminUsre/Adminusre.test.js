import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import Adminusre from './Adminusre';
import { getLockerUsresData } from '../../Services/api';

jest.mock('../../Services/api');

describe('Adminusre Component', () => {
  test('renders Adminusre component', () => {
    render(<Adminusre />);
    expect(screen.getByText('Admin Users')).toBeInTheDocument();
  });

  test('fetches and displays admin users', async () => {
    const mockAdmins = [
      { id: 1, regNo: 'A001', firstName: 'John', lastName: 'Doe', contactNumber: '123456789', email: 'john@example.com', role: 'ADMIN' }
    ];
    getLockerUsresData.mockResolvedValue({ data: mockAdmins });

    render(<Adminusre />);

    await waitFor(() => {
      expect(screen.getByText('John')).toBeInTheDocument();
      expect(screen.getByText('Doe')).toBeInTheDocument();
      expect(screen.getByText('123456789')).toBeInTheDocument();
      expect(screen.getByText('john@example.com')).toBeInTheDocument();
    });
  });

  test('displays error message on failed fetch', async () => {
    getLockerUsresData.mockRejectedValue(new Error('Network Error'));

    render(<Adminusre />);

    await waitFor(() => {
      expect(screen.getByText(/Invalid Request:/)).toBeInTheDocument();
    });
  });

  test('renders action buttons for each admin', async () => {
    const mockAdmins = [
      { id: 1, regNo: 'A001', firstName: 'John', lastName: 'Doe', contactNumber: '123456789', email: 'john@example.com', role: 'ADMIN' }
    ];
    getLockerUsresData.mockResolvedValue({ data: mockAdmins });

    render(<Adminusre />);

    await waitFor(() => {
      expect(screen.getByText('Edit')).toBeInTheDocument();
      expect(screen.getByText('Delet')).toBeInTheDocument();
    });
  });
});
