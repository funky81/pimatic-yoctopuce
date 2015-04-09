module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'


  class YoctoMainRelayPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass("YoctoMainRelay",{
        configDef : deviceConfigDef.YoctoMainRelay,
        createCallback : (config) => new YoctoMainRelay(config)
      })

  class YoctoMainRelay extends env.devices.Device
    attributes:
      message:
        description: "The message to display"
        type: "string"
    constructor: (@config) ->
      env.logger.info(@config)
      @id = @config.id
      @name = @config.name
      super()
    getMessage : -> Promise.resolve(@message)

  # ###Finally
  # Create a instance of my plugin
  myPlugin = new YoctoMainRelayPlugin
  # and return it to the framework.
  return myPlugin