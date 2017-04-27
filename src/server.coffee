enableDestroy      = require 'server-destroy'
octobluExpress     = require 'express-octoblu'
session            = require 'cookie-session'
cookieParser       = require 'cookie-parser'
passport           = require 'passport'
OctobluStrategy    = require './strategies/octoblu-strategy'
Router             = require './router'
OctobluDemoService = require './services/octoblu-demo-service'

class Server
  constructor: (options) ->
    { @logFn, @disableLogging, @port } = options
    { @meshbluConfig, @oauthCallbackUrl } = options
    throw new Error 'Server: requires meshbluConfig' unless @meshbluConfig?
    throw new Error 'Server: requires oauthCallbackUrl' unless @oauthCallbackUrl?

  address: =>
    @server.address()

  run: (callback) =>
    app = octobluExpress({ @logFn, @disableLogging })

    app.use cookieParser()
    app.use session @_sessionOptions()

    passport.serializeUser   (user, done) => done null, user
    passport.deserializeUser (user, done) => done null, user

    app.use passport.initialize()
    app.use passport.session()

    octobluStrategy = new OctobluStrategy { @meshbluConfig, @oauthCallbackUrl }
    octobluStrategy.use()
    octobluDemoService = new OctobluDemoService
    router = new Router {@meshbluConfig, octobluDemoService}

    router.route app

    @server = app.listen @port, callback
    enableDestroy @server

  stop: (callback) =>
    @server.close callback

  destroy: =>
    @server.destroy()

  _sessionOptions: =>
    return {
      name: 'octoblu-demo-service'
      secret: 'some-not-secret-token'
      maxAge: 60 * 60 * 1000
      sameSite: 'lax'
      overwrite: true
    }

module.exports = Server
