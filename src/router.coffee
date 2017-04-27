passport              = require 'passport'
OctobluDemoController = require './controllers/octoblu-demo-controller'

class Router
  constructor: ({ @octobluDemoService }) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  route: (app) =>
    octobluDemoController = new OctobluDemoController { @octobluDemoService }

    app.get '/', passport.authenticate('octoblu')
    app.get '/bootstrap/callback', passport.authenticate('octoblu'), (request, response) =>
      response.redirect('/bootstrap')
    app.get '/bootstrap', octobluDemoController.bootstrap

module.exports = Router
