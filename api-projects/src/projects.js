const { getProjectIdFromPath, getIssuesByProjectId, getCommentsByIssueIds, getIssueIds, invokeLambda } = require('../../utils')
const { getAllProjects, getProjectById } = require('../../data')

const projectsHandler = async event => {
  const { httpMethod, path } = event
  let response

  if (httpMethod === 'GET' && path.match(/^\/projects$/)) {
    const data = getAllProjects()
    response = { status: 200, data }
  } else if (httpMethod === 'GET' && path.match(/^\/projects\/(\d+)\/comments$/)) {
    let projectId = Number(getProjectIdFromPath(path))
    const project = getProjectById(projectId)
    console.log({ projectId, project })
    if (!project) return { status: 200, data: [] }

    const { status: issuesStatus, data: issuesData } = await invokeLambda(process.env.API_ISSUES_LAMBDA, { httpMethod: 'GET', path: '/issues' })
    console.log({ issuesStatus, issuesData })
    if (issuesStatus !== 200) {
      return { status: issuesStatus, data: issuesData }
    }

    const { status: commentsStatus, data: commentsData } = await invokeLambda(process.env.API_COMMENTS_LAMBDA, { httpMethod: 'GET', path: '/comments' })
    console.log({ commentsStatus, commentsData })
    if (commentsStatus !== 200) {
      return { status: commentsStatus, data: commentsData }
    }

    let issues = getIssuesByProjectId(issuesData, projectId)
    let issueIds = getIssueIds(issues)
    const data = getCommentsByIssueIds(commentsData, issueIds)
    response = { status: 200, data }
  }
  return response
}

module.exports = {
  projectsHandler,
}