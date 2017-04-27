debug = require('debug')('octoblu-demo-service:controller')

class OctobluDemoController
  constructor: ({@octobluDemoService}) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  bootstrap: (request, response) =>
    { meshbluAuth } = request
    debug 'bootstrap', { meshbluAuth }
    return response.sendStatus(401) unless meshbluAuth?
    @octobluDemoService.bootstrap { meshbluAuth }, (error) =>
      return response.sendError(error) if error?
      response.redirect('https://app.octoblu.com/')

module.exports = OctobluDemoController
