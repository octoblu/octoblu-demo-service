class OctobluDemoService
  bootstrap: ({ }, callback) =>
    callback()

  _createError: (message='Internal Service Error', code=500) =>
    error = new Error message
    error.code = code
    return error

module.exports = OctobluDemoService
