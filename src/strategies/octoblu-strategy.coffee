_               = require 'lodash'
passport        = require 'passport'
PassportOctoblu = require 'passport-octoblu'
debug           = require('debug')('octoblu-demo-service:octoblu-strategy')

class OctobluStrategy
  constructor: ({ @meshbluConfig, @oauthCallbackUrl }) ->
    throw new Error 'OctobluStrategy: requires @meshbluConfig' unless @meshbluConfig?
    throw new Error 'OctobluStrategy: requires @oauthCallbackUrl' unless @oauthCallbackUrl?

  use: =>
    passportOctoblu = new PassportOctoblu {
      clientID:          @meshbluConfig.uuid
      clientSecret:      @meshbluConfig.token
      meshbluConfig:     @meshbluConfig
      callbackUrl:       @oauthCallbackUrl
      passReqToCallback: true
    }, (req, bearerToken, secret, profile, next) =>
      debug 'authenticated', { bearerToken, secret, profile }
      { uuid, token } = @_parseBearerToken bearerToken
      meshbluAuth = _.cloneDeep @meshbluConfig
      meshbluAuth.uuid = uuid
      meshbluAuth.token = token
      req.session.meshbluAuth = meshbluAuth
      next null, profile
    passport.use passportOctoblu

  _parseBearerToken: (bearerToken) =>
    decoded = new Buffer(bearerToken, 'base64').toString('utf8')
    [uuid,token] = decoded?.split(':') ? []
    return { uuid, token }

module.exports = OctobluStrategy
