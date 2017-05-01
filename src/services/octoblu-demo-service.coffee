_               = require 'lodash'
async           = require 'async'
MeshbluHttp     = require 'meshblu-http'
buttonTemplate  = require '../templates/button.json'
buttonsTemplate = require '../templates/buttons.json'
lightTemplate   = require '../templates/light.json'
debug           = require('debug')('octoblu-demo-service:service')

class OctobluDemoService
  bootstrap: ({ meshbluAuth }, callback) =>
    @_createDevices { meshbluAuth }, callback

  _createDevices: ({ meshbluAuth }, callback) =>
    async.parallel [
      async.apply @_createButtonDevice, { meshbluAuth }
      async.apply @_createButtonsDevice, { meshbluAuth }
      async.apply @_createLightDevice, { meshbluAuth }
    ], callback

  _createButtonDevice: ({ meshbluAuth }, callback) =>
    debug 'createButtonDevice', { meshbluAuth }
    meshbluHttp = new MeshbluHttp _.cloneDeep meshbluAuth
    owner = meshbluAuth.uuid
    options = {
      type: 'device:powermate'
      deviceTag: 'demo:button:v1.0.0'
      meshbluHttp
      owner
    }
    @_findOrCreate options, (error, device) =>
      return callback error if error?
      meshbluHttp.updateDangerously device.uuid, { $set: buttonTemplate }, callback

  _createButtonsDevice: ({ meshbluAuth }, callback) =>
    debug 'createButtonsDevice', { meshbluAuth }
    meshbluHttp = new MeshbluHttp _.cloneDeep meshbluAuth
    owner = meshbluAuth.uuid
    options = {
      type: 'device:buttons'
      deviceTag: 'demo:meeting-buttons:v1.0.0'
      meshbluHttp
      owner
    }
    @_findOrCreate options, (error, device) =>
      return callback error if error?
      meshbluHttp.updateDangerously device.uuid, { $set: buttonsTemplate }, callback

  _createLightDevice: ({ meshbluAuth }, callback) =>
    debug 'createLightDevice', { meshbluAuth }
    meshbluHttp = new MeshbluHttp _.cloneDeep meshbluAuth
    owner = meshbluAuth.uuid
    options = {
      type: 'device:hue-light'
      deviceTag: 'demo:light:v1.0.0'
      meshbluHttp
      owner
    }
    @_findOrCreate options, (error, device) =>
      return callback error if error?
      meshbluHttp.updateDangerously device.uuid, { $set: lightTemplate }, callback

  _findOrCreate: ({ type, deviceTag, owner, meshbluHttp }, callback) =>
    projection = { uuid: true }
    meshbluHttp.search { owner, type, deviceTag }, { projection }, (error, devices) =>
      return callback error if error?
      return callback null, _.first(devices) if _.size(devices)
      properties = {
        owner
        type
        deviceTag
      }
      meshbluHttp.register properties, (error, device) =>
        return callback error if error?
        callback null, device

  _createError: (message='Internal Service Error', code=500) =>
    error = new Error message
    error.code = code
    return error

module.exports = OctobluDemoService
