_                = require 'lodash'
async            = require 'async'
MeshbluHttp      = require 'meshblu-http'
hueLightTemplate = require '../templates/hue-light.json'
debug            = require('debug')('octoblu-demo-service:service')

class OctobluDemoService
  bootstrap: ({ meshbluAuth }, callback) =>
    @_createDevices { meshbluAuth }, callback

  _createDevices: ({ meshbluAuth }, callback) =>
    async.parallel [
      async.apply @_createHueDevice, { meshbluAuth }
    ], callback

  _createHueDevice: ({ meshbluAuth }, callback) =>
    debug { meshbluAuth }
    meshbluHttp = new MeshbluHttp _.cloneDeep meshbluAuth
    properties = {
      type: 'synergy:hue-light'
      owner: meshbluAuth.uuid
    }
    meshbluHttp.register properties, (error, device) =>
      return callback error if error?
      meshbluHttp.updateDangerously device.uuid, { $set: hueLightTemplate }, callback

  _createError: (message='Internal Service Error', code=500) =>
    error = new Error message
    error.code = code
    return error

module.exports = OctobluDemoService
