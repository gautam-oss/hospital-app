import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import client from '../api/client';

interface Appointment {
  id: number;
  doctor_id: number;
  slot_id: number;
  status: string;
  reason: string;
  created_at: string;
}

export default function Appointments() {
  const [appointments, setAppointments] = useState<Appointment[]>([]);
  const navigate = useNavigate();

  useEffect(() => {
    client.get('/api/appointments/').then(r => setAppointments(r.data));
  }, []);

  const cancel = async (id: number) => {
    await client.patch(`/api/appointments/${id}/cancel`);
    setAppointments(prev => prev.map(a => a.id === id ? {...a, status: 'cancelled'} : a));
  };

  const statusColor: Record<string, string> = {
    pending: 'bg-yellow-100 text-yellow-700',
    confirmed: 'bg-green-100 text-green-700',
    cancelled: 'bg-red-100 text-red-700',
    completed: 'bg-blue-100 text-blue-700',
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow px-6 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold text-blue-700">Hospital Appointments</h1>
        <button onClick={() => navigate('/doctors')}
          className="text-gray-600 hover:text-blue-600 font-medium">← Doctors</button>
      </nav>
      <div className="max-w-4xl mx-auto p-6">
        <h2 className="text-2xl font-bold text-gray-800 mb-6">My Appointments</h2>
        {appointments.length === 0 ? (
          <div className="text-center text-gray-500 py-12">No appointments yet.</div>
        ) : (
          <div className="grid gap-4">
            {appointments.map(apt => (
              <div key={apt.id} className="bg-white rounded-xl shadow-sm p-6 flex justify-between items-center">
                <div>
                  <p className="font-medium text-gray-800">Appointment #{apt.id}</p>
                  <p className="text-sm text-gray-500">{apt.reason}</p>
                  <p className="text-xs text-gray-400 mt-1">{new Date(apt.created_at).toLocaleDateString()}</p>
                </div>
                <div className="flex items-center gap-3">
                  <span className={`px-3 py-1 rounded-full text-xs font-medium ${statusColor[apt.status]}`}>
                    {apt.status}
                  </span>
                  {apt.status === 'pending' && (
                    <button onClick={() => cancel(apt.id)}
                      className="text-red-500 hover:text-red-700 text-sm font-medium">
                      Cancel
                    </button>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
