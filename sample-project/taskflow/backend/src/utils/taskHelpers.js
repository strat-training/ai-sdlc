function isTaskOverdue(task) {
  const today = new Date();
  const dueDate = new Date(task.due_date);
  return dueDate < today && task.status !== 'Done';
}

module.exports = { isTaskOverdue };
