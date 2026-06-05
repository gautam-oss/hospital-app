import { useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import client from '../api/client';

export default function Register() {
  const [form, setForm] = useState({ email: '', full_name: '', password: '', role: 'patient' });
  const [error, setError] = useState('');
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      await client.post('/api/auth/register', form);
      navigate('/login');
    } catch {
      setError('Registration failed. Email may already exist.');
    }
  };

  return (
    <div className="min-h-screen bg-blue-50 flex items-center justify-center">
      <div className="bg-white p-8 rounded-xl shadow-md w-full max-w-md">
        <h1 className="text-2xl font-bold text-blue-700 mb-2">Create Account</h1>
        <p className="text-gray-500 mb-6">Join our hospital system</p>
        {error && <div className="bg-red-50 text-red-600 p-3 rounded mb-4 text-sm">{error}</div>}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
            <input type="text" value={form.full_name}
              onChange={e => setForm({...form, full_name: e.target.value})}
              className="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="John Doe" required />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Email</label>
            <input type="email" value={form.email}
              onChange={e => setForm({...form, email: e.target.value})}
              className="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              required />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Password</label>
            <input type="password" value={form.password}
              onChange={e => setForm({...form, password: e.target.value})}
              className="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500"
              required />
          </div>
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Role</label>
            <select value={form.role} onChange={e => setForm({...form, role: e.target.value})}
              className="w-full border rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-blue-500">
              <option value="patient">Patient</option>
              <option value="doctor">Doctor</option>
            </select>
          </div>
          <button type="submit"
            className="w-full bg-blue-600 text-white py-2 rounded-lg hover:bg-blue-700 font-medium">
            Register
          </button>
        </form>
        <p className="text-center text-sm text-gray-500 mt-4">
          Have account? <Link to="/login" className="text-blue-600 hover:underline">Sign in</Link>
        </p>
      </div>
    </div>
  );
}
