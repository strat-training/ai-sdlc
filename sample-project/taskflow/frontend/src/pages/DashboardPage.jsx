import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import api from '../api/client';
import { useAuth } from '../context/AuthContext';
import TaskCard from '../components/TaskCard';
import Badge from '../components/Badge';

export default function DashboardPage() {
  const { user } = useAuth();
  const [tasks, setTasks] = useState([]);
  const [filter, setFilter] = useState('All');
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    try {
      const res = await api.get('/tasks');
      setTasks(res.data.data);
    } catch (err) {
      setError('Failed to load tasks.');
    } finally {
      setLoading(false);
    }
  };

  const handleStatusUpdate = (taskId, newStatus) => {
    const taskIndex = tasks.findIndex(t => t.id === taskId);
    if (taskIndex === -1) return;
    tasks[taskIndex].status = newStatus;
    setTasks(tasks);
  };

  const today = new Date().toISOString().split('T')[0];
  const isOverdue = (task) => task.due_date < today && task.status !== 'Done';
  const isDueToday = (task) => task.due_date === today && task.status !== 'Done';

  const summary = {
    total: tasks.length,
    overdue: tasks.filter(isOverdue).length,
    dueToday: tasks.filter(isDueToday).length,
    done: tasks.filter(t => t.status === 'Done').length,
  };

  const filtered = tasks.filter(t => filter === 'All' || t.status === filter);

  if (loading) return <div className="p-6 text-gray-500">Loading tasks...</div>;

  return (
    <div className="p-6 max-w-5xl mx-auto">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-gray-900">My Tasks</h1>
        <Link
          to="/tasks/new"
          className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 text-sm font-medium"
        >
          + New Task
        </Link>
      </div>

      {error && <div className="mb-4 p-3 bg-red-50 text-red-700 rounded text-sm">{error}</div>}

      {/* Summary counts */}
      <div className="grid grid-cols-4 gap-4 mb-6">
        {[
          { label: 'Total', value: summary.total, color: 'bg-gray-100 text-gray-700' },
          { label: 'Overdue', value: summary.overdue, color: 'bg-red-50 text-red-700' },
          { label: 'Due Today', value: summary.dueToday, color: 'bg-yellow-50 text-yellow-700' },
          { label: 'Done', value: summary.done, color: 'bg-green-50 text-green-700' },
        ].map(s => (
          <div key={s.label} className={`rounded-lg p-4 ${s.color}`}>
            <div className="text-2xl font-bold">{s.value}</div>
            <div className="text-sm mt-1">{s.label}</div>
          </div>
        ))}
      </div>

      {/* Filter tabs */}
      <div className="flex gap-2 mb-4">
        {['All', 'To Do', 'In Progress', 'Done'].map(f => (
          <button
            key={f}
            onClick={() => setFilter(f)}
            className={`px-3 py-1.5 rounded text-sm font-medium transition-colors ${
              filter === f ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600 hover:bg-gray-200'
            }`}
          >
            {f}
          </button>
        ))}
      </div>

      {/* Task list */}
      <div className="space-y-3">
        {filtered.length === 0 ? (
          <div className="text-center py-12 text-gray-400">
            No tasks found.{' '}
            <Link to="/tasks/new" className="text-blue-600 hover:underline">Create one?</Link>
          </div>
        ) : (
          filtered.map(task => (
            <TaskCard key={task.id} task={task} isOverdue={isOverdue(task)} isDueToday={isDueToday(task)} />
          ))
        )}
      </div>
    </div>
  );
}
