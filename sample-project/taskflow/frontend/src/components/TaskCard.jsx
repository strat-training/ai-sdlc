// TaskCard.jsx
import { Link } from 'react-router-dom';
import Badge from './Badge';

export default function TaskCard({ task, isOverdue, isDueToday }) {
  return (
    <Link to={`/tasks/${task.id}`} className="block">
      <div className={`bg-white rounded-lg border p-4 hover:shadow-sm transition-shadow ${isOverdue ? 'border-red-200 bg-red-50' : 'border-gray-200'}`}>
        <div className="flex items-start justify-between gap-4">
          <div className="flex-1 min-w-0">
            <p className={`font-medium text-sm truncate ${isOverdue ? 'text-red-800' : 'text-gray-900'}`}>
              {task.title}
            </p>
            <p className="text-xs text-gray-500 mt-1">
              Assigned to: {task.assignee_name}
            </p>
          </div>
          <div className="flex items-center gap-2 flex-shrink-0">
            <span className={`text-xs ${isOverdue ? 'text-red-600 font-medium' : isDueToday ? 'text-yellow-600 font-medium' : 'text-gray-400'}`}>
              {isOverdue ? '⚠ ' : ''}{task.due_date}
            </span>
            <Badge status={task.status} />
          </div>
        </div>
      </div>
    </Link>
  );
}
