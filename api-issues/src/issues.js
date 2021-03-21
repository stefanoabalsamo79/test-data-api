const { getAllIssues } = require('../../data')

const issuesHandler = async event => {
  const { httpMethod, path } = event
  let response

  if (httpMethod === 'GET' && path.match(/^\/issues$/)) {
    const data = getAllIssues()
    response = { status: 200, data }
  }
  return response
}

module.exports = {
  issuesHandler,
}