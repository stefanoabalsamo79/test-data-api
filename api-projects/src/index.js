const { projectsHandler } = require('./projects')

const { buildPayload } = require('../../utils')

exports.handler = async event => {
  console.log(`event: ${JSON.stringify(event)}`)
  const { status, data } = await projectsHandler(event)
  return buildPayload(status, data, 'application/json')
}
