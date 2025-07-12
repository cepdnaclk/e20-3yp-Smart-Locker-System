import { render, screen, waitFor } from '@testing-library/react';
import '@testing-library/jest-dom';
import Lcluster from './Lcluster';
import { getLockerClusterData } from '../../Services/lockerAPI';

jest.mock('../../Services/lockerAPI');

describe('Lcluster Component', () => {
  test('renders Lcluster component', () => {
    render(<Lcluster />);
    expect(screen.getByText('Locker Clusters')).toBeInTheDocument();
  });

  test('fetches and displays locker clusters', async () => {
    const mockClusters = [
      { id: 1, totalNumberOfLockers: 10, availableNumberOfLockers: 5, clusterName: 'Cluster A', lockerClusterDescription: 'Active' }
    ];
    getLockerClusterData.mockResolvedValue({ data: mockClusters });

    render(<Lcluster />);

    await waitFor(() => {
      expect(screen.getByText('Cluster A')).toBeInTheDocument();
      expect(screen.getByText('10')).toBeInTheDocument();
      expect(screen.getByText('5')).toBeInTheDocument();
      expect(screen.getByText('Active')).toBeInTheDocument();
      expect(screen.getByText('Edit')).toBeInTheDocument();
      expect(screen.getByText('Delet')).toBeInTheDocument();
    });
  });

  test('displays error message on failed fetch', async () => {
    getLockerClusterData.mockRejectedValue(new Error('Network Error'));

    render(<Lcluster />);

    await waitFor(() => {
      expect(screen.getByText(/Invalid Request:/)).toBeInTheDocument();
    });
  });
});
