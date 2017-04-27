passport              = require 'passport'
OctobluDemoController = require './controllers/octoblu-demo-controller'

class Router
  constructor: ({ @octobluDemoService }) ->
    throw new Error 'Missing octobluDemoService' unless @octobluDemoService?

  route: (app) =>
    octobluDemoController = new OctobluDemoController { @octobluDemoService }

    app.get '/', passport.authenticate('octoblu')
    app.get '/callback', passport.authenticate('octoblu', {
      failureRedirect: '/',
    }), octobluDemoController.bootstrap

module.exports = Router
