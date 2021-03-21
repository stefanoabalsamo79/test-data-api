const { issuesHandler } = require('./issues')
const { buildPayload } = require('../../utils')

exports.handler = async event => {
  console.log(`event: ${JSON.stringify(event)}`)
  const { status, data } = await issuesHandler(event)
  return buildPayload(status, data, 'application/json')
}
