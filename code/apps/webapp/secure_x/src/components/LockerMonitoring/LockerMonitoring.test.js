import { render, screen } from '@testing-library/react';
import '@testing-library/jest-dom';
import LockerMonitoring from './LockerMonitoring';
import Navbar from '../Navigationbar/Navigationbar';
import Lcluster from './Lcluster/Lcluster';
import Locker from './Locker/Locker';

jest.mock('../Navigationbar/Navigationbar', () => () => <div>Mock Navbar</div>);
jest.mock('./Lcluster/Lcluster', () => () => <div>Mock Lcluster</div>);
jest.mock('./Locker/Locker', () => () => <div>Mock Locker</div>);

describe('LockerMonitoring Component', () => {
  test('renders LockerMonitoring component', () => {
    render(<LockerMonitoring />);
    expect(screen.getByText('Locker Monitoring page')).toBeInTheDocument();
  });

  test('renders Navbar component', () => {
    render(<LockerMonitoring />);
    expect(screen.getByText('Mock Navbar')).toBeInTheDocument();
  });

  test('renders Lcluster and Locker components', () => {
    render(<LockerMonitoring />);
    expect(screen.getByText('Mock Lcluster')).toBeInTheDocument();
    expect(screen.getByText('Mock Locker')).toBeInTheDocument();
  });
});
