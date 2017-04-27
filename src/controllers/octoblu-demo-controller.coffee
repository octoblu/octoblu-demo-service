class OctobluDemoController
  constructor: ({@octobluDemoService}) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  bootstrap: (request, response) =>
    { meshbluAuth } = request.session
    @octobluDemoService.bootstrap { meshbluAuth }, (error) =>
      return response.sendError(error) if error?
      response.status(201).send meshbluAuth

module.exports = OctobluDemoController
