const aws = require('aws-sdk')

const buildPayload = (statusCode, body, headers) => ({
  statusCode: statusCode,
  body: JSON.stringify(body),
  headers: {
    'Content-Type': headers,
  },
})

const getProjectIdFromPath = path => path.match(/^\/projects\/(\d+)\/comments$/).pop()

const getIssuesByProjectId = (issues, projectId) => issues.filter(issue => issue.projectId === projectId)

const getIssueIds = issues => issues.map(issue => issue.id)

const getCommentsByIssueIds = (comments, issueIds) => {
  return comments.reduce((acc, comment) => {
    if(issueIds.includes(comment.issueId)) acc.push(comment)
    return acc
  }, [])
}

const getAwsRegion = () => process.env.AWS_REGION || null

const composeLambdaInvocationPayload = (lambdaName, payload) => {
  return {
    FunctionName: lambdaName,
    InvocationType: 'RequestResponse',
    LogType: 'Tail',
    Payload: JSON.stringify(payload)
  }
}

const invokeLambda = async (lambdaName, payload) => {
  aws.config.update({ region: getAwsRegion() })
  const lambda = new aws.Lambda()
  const params = composeLambdaInvocationPayload(lambdaName, payload)
  let response
  let responseData
  try {
    console.log('lambda invocation parameters: ', JSON.stringify(params))
    response = await lambda.invoke(params).promise()
    responseData = JSON.parse(response.Payload).body

    if (response.StatusCode !== 200) return { status: response.StatusCode, data: `lambda ${lambdaName} invocation error ` }

    console.log(`lambda ${lambdaName} response:`, JSON.stringify(response))
  } catch (error) {
    console.log(error)
    return { status: response.StatusCode, data: error }
  }
  return { status: 200, data: JSON.parse(responseData) }
}

module.exports = {
  buildPayload,
  getProjectIdFromPath,
  getIssuesByProjectId,
  getIssueIds,
  getCommentsByIssueIds,
  invokeLambda,
}