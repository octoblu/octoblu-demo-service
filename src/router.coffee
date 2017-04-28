passport              = require 'passport'
OctobluDemoController = require './controllers/octoblu-demo-controller'

class Router
  constructor: ({ @octobluDemoService }) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  route: (app) =>
    octobluDemoController = new OctobluDemoController { @octobluDemoService }

    app.get '/', passport.authenticate('octoblu', {
      failureRedirect: '/auth/failed',
    })
    app.get '/callback', passport.authenticate('octoblu', {
      failureRedirect: '/auth/failed',
    }), octobluDemoController.bootstrap
    app.get '/auth/failed', (request, response) =>
      response.status(403).send({ message: 'Unable to authenticate' })

module.exports = Router
