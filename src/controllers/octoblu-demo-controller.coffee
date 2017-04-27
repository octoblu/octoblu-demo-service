class OctobluDemoController
  constructor: ({@octobluDemoService}) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  bootstrap: (request, response) =>
    @octobluDemoService.bootstrap { }, (error) =>
      return response.sendError(error) if error?
      response.sendStatus(200)

module.exports = OctobluDemoController
