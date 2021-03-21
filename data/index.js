const data = require('./db.json')

const _fetchData = () => data

const getAllProjects = () => {
  const { projects } = _fetchData()
  return projects || []
}

const getProjectById = projectId => {
  const projects = getAllProjects()
  return projects.find(project => project.id === projectId)
}

const getAllIssues = () => {
  const { issues } = _fetchData()
  return issues || []
}

const getAllComments = () => {
  const { comments } = _fetchData()
  return comments || []
}

module.exports = {
  getProjectById,
  getAllProjects,
  getAllIssues,
  getAllComments,
}