export default function Badge({ status }) {
  const styles = {
    'To Do': 'bg-gray-100 text-gray-600',
    'In Progress': 'bg-blue-100 text-blue-700',
    'Done': 'bg-green-100 text-green-700',
  };
  return (
    <span className={`text-xs px-2 py-1 rounded font-medium ${styles[status] || 'bg-gray-100 text-gray-600'}`}>
      {status}
    </span>
  );
}
