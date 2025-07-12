import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import Locker from './Locker';
import { getLockerData } from '../../Services/lockerAPI';

jest.mock('../../Services/lockerAPI');

describe('Locker Component', () => {
  test('renders Locker component', () => {
    render(<Locker />);
    expect(screen.getByText('Lockers')).toBeInTheDocument();
  });

  test('fetches and displays locker data', async () => {
    const mockLockers = [
      { lockerId: 1, displayNumber: 'L001', lockerStatus: 'Active', lockerLogs: 'Log1', lockerCluster: { id: 101 } }
    ];
    getLockerData.mockResolvedValue({ data: mockLockers });

    render(<Locker />);

    await waitFor(() => {
      expect(screen.getByText('L001')).toBeInTheDocument();
      expect(screen.getByText('Active')).toBeInTheDocument();
      expect(screen.getByText('Log1')).toBeInTheDocument();
      expect(screen.getByText('101')).toBeInTheDocument();
      expect(screen.getByText('Edit')).toBeInTheDocument();
      expect(screen.getByText('Unlock')).toBeInTheDocument();
      expect(screen.getByText('Delet')).toBeInTheDocument();
    });
  });

  test('displays error message on failed fetch', async () => {
    getLockerData.mockRejectedValue(new Error('Network Error'));

    render(<Locker />);

    await waitFor(() => {
      expect(screen.getByText(/Invalid Request:/)).toBeInTheDocument();
    });
  });
});
