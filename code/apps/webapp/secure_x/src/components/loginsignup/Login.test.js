// Login.test.js
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import Login from './Login'; // Adjust the path if needed
import { login } from '../Services/api'; // Adjust the path if needed
import { BrowserRouter as Router } from 'react-router-dom';

// Mock the login API
jest.mock('../Services/api.js', () => ({
  login: jest.fn(),
}));

// Mock localStorage
beforeAll(() => {
  Storage.prototype.setItem = jest.fn();
});

describe('Login Component', () => {
  test('renders login form', () => {
    render(
      <Router>
        <Login />
      </Router>
    );

    expect(screen.getByLabelText(/username/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /sign in/i })).toBeInTheDocument();
  });

  test('shows error message if login fails', async () => {
    login.mockRejectedValueOnce(new Error('Invalid credentials'));

    render(
      <Router>
        <Login />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/username/i), { target: { value: 'testuser' } });
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'wrongpassword' } });
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(screen.getByText(/invalid credentials/i)).toBeInTheDocument();
    });
  });

  test('logs in successfully and redirects to dashboard', async () => {
    login.mockResolvedValueOnce({ data: { token: 'fake-token' } });

    render(
      <Router>
        <Login />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/username/i), { target: { value: 'testuser' } });
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'password123' } });
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(localStorage.setItem).toHaveBeenCalledWith('token', 'fake-token');
      expect(localStorage.setItem).toHaveBeenCalledWith('User', 'testuser');
      expect(window.location.pathname).toBe('/dashboard');
    });
  });

  test('should call localStorage.setItem on successful login', async () => {
    login.mockResolvedValueOnce({ data: { token: 'fake-token' } });

    render(
      <Router>
        <Login />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/username/i), { target: { value: 'testuser' } });
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'password123' } });
    fireEvent.click(screen.getByRole('button', { name: /sign in/i }));

    await waitFor(() => {
      expect(localStorage.setItem).toHaveBeenCalledWith('token', 'fake-token');
      expect(localStorage.setItem).toHaveBeenCalledWith('User', 'testuser');
    });
  });
});
