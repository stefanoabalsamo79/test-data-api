const { getAllComments } = require('../../data')

const commentsHandler = async event => {
  const { httpMethod, path } = event
  let response

  if (httpMethod === 'GET' && path.match(/^\/comments$/)) {
    const data = getAllComments()
    response = { status: 200, data }
  }
  return response
}

module.exports = {
  commentsHandler,
}