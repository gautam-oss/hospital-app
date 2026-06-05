import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import client from '../api/client';

interface Doctor {
  id: number;
  specialization: string;
  qualification: string;
  experience_years: number;
  bio: string;
}

export default function Doctors() {
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  useEffect(() => {
    client.get('/api/doctors/').then(r => {
      setDoctors(r.data);
      setLoading(false);
    }).catch(() => setLoading(false));
  }, []);

  const logout = () => { localStorage.removeItem('token'); navigate('/login'); };

  return (
    <div className="min-h-screen bg-gray-50">
      <nav className="bg-white shadow px-6 py-4 flex justify-between items-center">
        <h1 className="text-xl font-bold text-blue-700">Hospital Appointments</h1>
        <div className="flex gap-4">
          <button onClick={() => navigate('/appointments')}
            className="text-gray-600 hover:text-blue-600 font-medium">My Appointments</button>
          <button onClick={logout}
            className="bg-red-50 text-red-600 px-4 py-1.5 rounded-lg hover:bg-red-100 text-sm font-medium">
            Logout
          </button>
        </div>
      </nav>
      <div className="max-w-4xl mx-auto p-6">
        <h2 className="text-2xl font-bold text-gray-800 mb-6">Available Doctors</h2>
        {loading ? (
          <div className="text-center text-gray-500 py-12">Loading doctors...</div>
        ) : doctors.length === 0 ? (
          <div className="text-center text-gray-500 py-12">No doctors available yet.</div>
        ) : (
          <div className="grid gap-4">
            {doctors.map(doc => (
              <div key={doc.id} className="bg-white rounded-xl shadow-sm p-6 flex justify-between items-center">
                <div>
                  <h3 className="font-bold text-gray-800 text-lg">{doc.specialization}</h3>
                  <p className="text-gray-500 text-sm">{doc.qualification} · {doc.experience_years} years exp</p>
                  {doc.bio && <p className="text-gray-600 text-sm mt-1">{doc.bio}</p>}
                </div>
                <button onClick={() => navigate(`/book/${doc.id}`)}
                  className="bg-blue-600 text-white px-5 py-2 rounded-lg hover:bg-blue-700 font-medium">
                  Book
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
