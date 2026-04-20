import { useState, useEffect } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import api from '../api/client';

export default function TaskFormPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const isEditing = Boolean(id);

  const [form, setForm] = useState({
    title: '', description: '', assignee_id: '', due_date: '', priority: 'Medium'
  });
  const [users, setUsers] = useState([]);
  const [errors, setErrors] = useState({});
  const [loading, setLoading] = useState(false);
  const [dirty, setDirty] = useState(false);

  useEffect(() => {
    fetchUsers();
    if (isEditing) fetchTask();
    const handleBeforeUnload = (e) => { if (dirty) e.preventDefault(); };
    window.addEventListener('beforeunload', handleBeforeUnload);
    return () => window.removeEventListener('beforeunload', handleBeforeUnload);
  }, [id]);

  const fetchUsers = async () => {
    try {
      const res = await api.get('/users');
      setUsers(res.data.data.filter(u => u.is_active));
    } catch {
      // Non-admin users can't list all users — skip
    }
  };

  const fetchTask = async () => {
    try {
      const res = await api.get(`/tasks/${id}`);
      const t = res.data.data;
      setForm({ title: t.title, description: t.description || '', assignee_id: t.assignee_id, due_date: t.due_date, priority: t.priority });
    } catch (err) {
      alert('Failed to load task for editing.');
      navigate('/');
    }
  };

  const validate = () => {
    const errs = {};
    if (!form.title.trim()) errs.title = 'Title is required';
    if (form.title.length > 200) errs.title = 'Title must be 200 characters or less';
    if (!form.assignee_id) errs.assignee_id = 'Assignee is required';
    if (!form.due_date) errs.due_date = 'Due date is required';
    return errs;
  };

  const handleChange = (e) => {
    setForm(prev => ({ ...prev, [e.target.name]: e.target.value }));
    setDirty(true);
    if (errors[e.target.name]) setErrors(prev => ({ ...prev, [e.target.name]: '' }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const errs = validate();
    if (Object.keys(errs).length) { setErrors(errs); return; }

    setLoading(true);
    try {
      if (isEditing) {
        await api.patch(`/tasks/${id}`, form);
      } else {
        const res = await api.post('/tasks', form);
        navigate(`/tasks/${res.data.data.id}`);
        return;
      }
      setDirty(false);
      navigate(`/tasks/${id}`);
    } catch (err) {
      alert(err.response?.data?.error?.message || 'Failed to save task.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="p-6 max-w-2xl mx-auto">
      <h1 className="text-2xl font-bold text-gray-900 mb-6">{isEditing ? 'Edit Task' : 'New Task'}</h1>

      <form onSubmit={handleSubmit} className="bg-white rounded-lg shadow p-6 space-y-5">
        {/* Title */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Title <span className="text-red-500">*</span></label>
          <input
            name="title"
            value={form.title}
            onChange={handleChange}
            maxLength={200}
            className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.title ? 'border-red-400' : 'border-gray-300'}`}
            placeholder="What needs to be done?"
          />
          {errors.title && <p className="text-red-600 text-xs mt-1">{errors.title}</p>}
          <p className="text-gray-400 text-xs mt-1">{form.title.length}/200</p>
        </div>

        {/* Description */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
          <textarea
            name="description"
            value={form.description}
            onChange={handleChange}
            rows={4}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="Add more details..."
          />
        </div>

        <div className="grid grid-cols-2 gap-4">
          {/* Assignee */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Assignee <span className="text-red-500">*</span></label>
            <select
              name="assignee_id"
              value={form.assignee_id}
              onChange={handleChange}
              className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.assignee_id ? 'border-red-400' : 'border-gray-300'}`}
            >
              <option value="">Select assignee</option>
              {users.map(u => <option key={u.id} value={u.id}>{u.name}</option>)}
            </select>
            {errors.assignee_id && <p className="text-red-600 text-xs mt-1">{errors.assignee_id}</p>}
          </div>

          {/* Due date */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">Due Date <span className="text-red-500">*</span></label>
            <input
              type="date"
              name="due_date"
              value={form.due_date}
              onChange={handleChange}
              className={`w-full px-3 py-2 border rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 ${errors.due_date ? 'border-red-400' : 'border-gray-300'}`}
            />
            {errors.due_date && <p className="text-red-600 text-xs mt-1">{errors.due_date}</p>}
          </div>
        </div>

        {/* Priority */}
        <div>
          <label className="block text-sm font-medium text-gray-700 mb-1">Priority</label>
          <div className="flex gap-3">
            {['Low', 'Medium', 'High'].map(p => (
              <label key={p} className="flex items-center gap-1.5 cursor-pointer">
                <input type="radio" name="priority" value={p} checked={form.priority === p} onChange={handleChange} />
                <span className="text-sm">{p}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="flex gap-3 pt-2">
          <button
            type="submit"
            disabled={loading}
            className="px-5 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 disabled:opacity-50 font-medium text-sm"
          >
            {loading ? 'Saving...' : isEditing ? 'Save Changes' : 'Create Task'}
          </button>
          <button
            type="button"
            onClick={() => navigate(isEditing ? `/tasks/${id}` : '/')}
            className="px-5 py-2 border border-gray-300 rounded-md text-gray-700 hover:bg-gray-50 text-sm"
          >
            Cancel
          </button>
        </div>
      </form>
    </div>
  );
}
