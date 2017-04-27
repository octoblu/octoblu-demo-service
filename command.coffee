envalid        = require 'envalid'
MeshbluConfig  = require 'meshblu-config'
SigtermHandler = require 'sigterm-handler'
Server         = require './src/server'

envConfig = {
  PORT: envalid.num({ default: 80, devDefault: 3000 })
  OAUTH_CALLBACK_URL: envalid.url()
}

class Command
  constructor: ->
    env = envalid.cleanEnv process.env, envConfig
    @serverOptions = {
      meshbluConfig    : new MeshbluConfig().toJSON()
      port             : env.PORT
      oauthCallbackUrl : env.OAUTH_CALLBACK_URL
    }

  panic: (error) =>
    console.error error.stack
    process.exit 1

  run: =>
    server = new Server @serverOptions
    server.run (error) =>
      return @panic error if error?

      { port } = server.address()
      console.log "OctobluDemoService listening on port: #{port}"

    sigtermHandler = new SigtermHandler()
    sigtermHandler.register server.stop

command = new Command()
command.run()