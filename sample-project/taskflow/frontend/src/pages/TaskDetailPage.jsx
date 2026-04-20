import { useState, useEffect } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import api from '../api/client';
import { useAuth } from '../context/AuthContext';
import Badge from '../components/Badge';
import CommentSection from '../components/CommentSection';

export default function TaskDetailPage() {
  const { id } = useParams();
  const { user } = useAuth();
  const navigate = useNavigate();
  const [task, setTask] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [updatingStatus, setUpdatingStatus] = useState(false);

  useEffect(() => { fetchTask(); }, [id]);

  const fetchTask = async () => {
    try {
      const res = await api.get(`/tasks/${id}`);
      setTask(res.data.data);
    } catch (err) {
      setError(err.response?.status === 404 ? 'Task not found.' : 'Failed to load task.');
    } finally {
      setLoading(false);
    }
  };

  const handleStatusChange = async (newStatus) => {
    setUpdatingStatus(true);
    try {
      await api.patch(`/tasks/${id}/status`, { status: newStatus });
      setTask(prev => ({ ...prev, status: newStatus }));
    } catch (err) {
      alert(err.response?.data?.error?.message || 'Failed to update status.');
    } finally {
      setUpdatingStatus(false);
    }
  };

  const handleDelete = async () => {
    if (!confirm('Are you sure you want to delete this task?')) return;
    try {
      await api.delete(`/tasks/${id}`);
      navigate('/');
    } catch (err) {
      alert(err.response?.data?.error?.message || 'Failed to delete task.');
    }
  };

  if (loading) return <div className="p-6 text-gray-500">Loading...</div>;
  if (error) return <div className="p-6 text-red-600">{error}</div>;
  if (!task) return null;

  const canEdit = task.creator_id === user.id || user.role === 'admin';
  const canDelete = task.creator_id === user.id || user.role === 'admin';
  const canUpdateStatus = task.assignee_id === user.id || user.role === 'admin';
  const today = new Date().toISOString().split('T')[0];
  const isOverdue = task.due_date < today && task.status !== 'Done';

  return (
    <div className="p-6 max-w-3xl mx-auto">
      <div className="mb-4">
        <Link to="/" className="text-sm text-blue-600 hover:underline">← Back to Dashboard</Link>
      </div>

      <div className="bg-white rounded-lg shadow p-6 mb-6">
        <div className="flex items-start justify-between mb-4">
          <div className="flex-1">
            <h1 className="text-xl font-bold text-gray-900 mb-2">{task.title}</h1>
            <div className="flex flex-wrap gap-2">
              <Badge status={task.status} />
              <span className={`text-xs px-2 py-1 rounded font-medium ${
                task.priority === 'High' ? 'bg-red-100 text-red-700' :
                task.priority === 'Medium' ? 'bg-yellow-100 text-yellow-700' :
                'bg-gray-100 text-gray-600'
              }`}>{task.priority} Priority</span>
              {isOverdue && <span className="text-xs px-2 py-1 rounded bg-red-100 text-red-700 font-medium">OVERDUE</span>}
            </div>
          </div>
          <div className="flex gap-2 ml-4">
            {canEdit && task.status !== 'Done' && (
              <Link to={`/tasks/${id}/edit`} className="px-3 py-1.5 text-sm border border-gray-300 rounded hover:bg-gray-50">
                Edit
              </Link>
            )}
            {canDelete && (
              <button onClick={handleDelete} className="px-3 py-1.5 text-sm bg-red-50 text-red-600 border border-red-200 rounded hover:bg-red-100">
                Delete
              </button>
            )}
          </div>
        </div>

        {task.description && (
          <p className="text-gray-700 mb-4 whitespace-pre-wrap">{task.description}</p>
        )}

        <div className="grid grid-cols-2 gap-4 text-sm border-t pt-4">
          <div><span className="text-gray-500">Assignee:</span> <span className="font-medium">{task.assignee_name}</span></div>
          <div><span className="text-gray-500">Created by:</span> <span className="font-medium">{task.creator_name}</span></div>
          <div>
            <span className="text-gray-500">Due date:</span>{' '}
            <span className={`font-medium ${isOverdue ? 'text-red-600' : ''}`}>{task.due_date}</span>
          </div>
          <div><span className="text-gray-500">Created:</span> <span className="font-medium">{new Date(task.created_at).toLocaleDateString()}</span></div>
        </div>

        {/* Status update */}
        {canUpdateStatus && task.status !== 'Done' && (
          <div className="mt-4 pt-4 border-t">
            <p className="text-sm text-gray-500 mb-2">Update status:</p>
            <div className="flex gap-2">
              {['To Do', 'In Progress', 'Done'].filter(s => s !== task.status).map(s => (
                <button
                  key={s}
                  onClick={() => handleStatusChange(s)}
                  disabled={updatingStatus}
                  className="px-3 py-1.5 text-sm bg-blue-50 text-blue-700 border border-blue-200 rounded hover:bg-blue-100 disabled:opacity-50"
                >
                  Mark as {s}
                </button>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Activity log */}
      {task.activity && task.activity.length > 0 && (
        <div className="bg-white rounded-lg shadow p-6 mb-6">
          <h2 className="font-semibold text-gray-900 mb-3">Activity</h2>
          <div className="space-y-2">
            {task.activity.map(a => (
              <div key={a.id} className="text-sm text-gray-600 flex gap-2">
                <span className="text-gray-400">{new Date(a.created_at).toLocaleString()}</span>
                <span><strong>{a.user_name}</strong> {a.action.replace('_', ' ')}</span>
              </div>
            ))}
          </div>
        </div>
      )}

      <CommentSection taskId={id} />
    </div>
  );
}
