// Layout.jsx
import { Outlet, Link, useNavigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';

export default function Layout() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = async () => {
    await logout();
    navigate('/login');
  };

  return (
    <div className="min-h-screen bg-gray-50 flex">
      {/* Sidebar */}
      <aside className="w-56 bg-white border-r border-gray-200 flex flex-col">
        <div className="p-4 border-b">
          <h1 className="font-bold text-blue-600 text-lg">TaskFlow</h1>
        </div>
        <nav className="flex-1 p-4 space-y-1">
          <Link to="/" className="flex items-center gap-2 px-3 py-2 rounded text-sm text-gray-700 hover:bg-gray-100 font-medium">
            Dashboard
          </Link>
          <Link to="/tasks/new" className="flex items-center gap-2 px-3 py-2 rounded text-sm text-gray-700 hover:bg-gray-100">
            + New Task
          </Link>
        </nav>
        <div className="p-4 border-t">
          <div className="text-sm text-gray-700 font-medium mb-1">{user?.name}</div>
          <div className="text-xs text-gray-400 capitalize mb-3">{user?.role?.replace('_', ' ')}</div>
          <button onClick={handleLogout} className="text-xs text-gray-500 hover:text-red-600">
            Sign out
          </button>
        </div>
      </aside>
      {/* Main content */}
      <main className="flex-1 overflow-auto">
        <Outlet />
      </main>
    </div>
  );
}
