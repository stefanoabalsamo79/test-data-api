const { commentsHandler } = require('./comments')
const { buildPayload } = require('../../utils')

exports.handler = async event => {
  console.log(`event: ${JSON.stringify(event)}`)
  const { status, data } = await commentsHandler(event)
  return buildPayload(status, data, 'application/json')
}
