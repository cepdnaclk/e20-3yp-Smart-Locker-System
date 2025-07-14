// Signup.test.js
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import Signup from './Signup'; // Adjust path if necessary
import { signup } from '../Services/api'; // Adjust path if necessary
import { BrowserRouter as Router } from 'react-router-dom';

// Mock the signup API
jest.mock('../Services/api.js', () => ({
  signup: jest.fn(),
}));

// Mock localStorage
beforeAll(() => {
  Storage.prototype.setItem = jest.fn();
});

describe('Signup Component', () => {
  test('renders signup form', () => {
    render(
      <Router>
        <Signup />
      </Router>
    );

    expect(screen.getByLabelText(/first name/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/last name/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/registration number/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/contact number/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/confirm password/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /sign up/i })).toBeInTheDocument();
  });

  test('shows error message if passwords do not match', () => {
    render(
      <Router>
        <Signup />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'password123' } });
    fireEvent.change(screen.getByLabelText(/confirm password/i), { target: { value: 'differentpassword' } });
    fireEvent.click(screen.getByRole('button', { name: /sign up/i }));

    expect(screen.getByText(/passwords do not match/i)).toBeInTheDocument();
  });

  test('signup success and redirects to success page', async () => {
    signup.mockResolvedValueOnce({ data: { token: 'fake-token' } });

    render(
      <Router>
        <Signup />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/first name/i), { target: { value: 'John' } });
    fireEvent.change(screen.getByLabelText(/last name/i), { target: { value: 'Doe' } });
    fireEvent.change(screen.getByLabelText(/registration number/i), { target: { value: 'EX12345' } });
    fireEvent.change(screen.getByLabelText(/contact number/i), { target: { value: '123456789' } });
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: 'john.doe@example.com' } });
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'password123' } });
    fireEvent.change(screen.getByLabelText(/confirm password/i), { target: { value: 'password123' } });

    fireEvent.click(screen.getByRole('button', { name: /sign up/i }));

    await waitFor(() => {
      expect(localStorage.setItem).toHaveBeenCalledWith('token', 'fake-token');
      expect(window.location.pathname).toBe('/success');
    });
  });

  test('shows error message if signup fails', async () => {
    signup.mockRejectedValueOnce(new Error('Signup failed'));

    render(
      <Router>
        <Signup />
      </Router>
    );

    fireEvent.change(screen.getByLabelText(/first name/i), { target: { value: 'John' } });
    fireEvent.change(screen.getByLabelText(/last name/i), { target: { value: 'Doe' } });
    fireEvent.change(screen.getByLabelText(/registration number/i), { target: { value: 'EX12345' } });
    fireEvent.change(screen.getByLabelText(/contact number/i), { target: { value: '123456789' } });
    fireEvent.change(screen.getByLabelText(/email/i), { target: { value: 'john.doe@example.com' } });
    fireEvent.change(screen.getByLabelText(/password/i), { target: { value: 'password123' } });
    fireEvent.change(screen.getByLabelText(/confirm password/i), { target: { value: 'password123' } });

    fireEvent.click(screen.getByRole('button', { name: /sign up/i }));

    await waitFor(() => {
      expect(screen.getByText(/invalid credentials/i)).toBeInTheDocument();
    });
  });
});
