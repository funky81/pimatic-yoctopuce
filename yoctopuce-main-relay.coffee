module.exports = (env) ->

  # Require the  bluebird promise library
  Promise = env.require 'bluebird'

  # Require the [cassert library](https://github.com/rhoot/cassert).
  assert = env.require 'cassert'

  # Yoctolib requirements
  yoctolib = require('yoctolib')
  YAPI = yoctolib.YAPI
  YRelay = yoctolib.YRelay

  class YoctoMainRelayPlugin extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      deviceConfigDef = require("./device-config-schema")
      @framework.deviceManager.registerDeviceClass("YoctoMainRelay",{
        configDef : deviceConfigDef.YoctoMainRelay,
        createCallback : (config) => new YoctoMainRelay(config)
      })

  class YoctoMainRelay extends env.devices.PowerSwitch
    # ####constructor()
     # Your constructor function must assign a name and id to the device.
    constructor: (@config) ->
      @name = @config.name
      @id = @config.id
      @relayName = @id.replace('YoctoPowerRelay-','')
      #env.logger.info @relayName
      super()

    # ####changeStateTo(state)
    # The `changeStateTo` function should change the state of the switch, when called by the 
    # framework.
    changeStateTo: (state) ->
      # If state is aleady set, just return a empty promise
      if @_state is state then return Promise.resolve()
      # else run the action and 
      return this.changeStatus(@relayName).then( =>
        # and calls `PowerSwitch::_setState` so that `_state` is set and 
        # a event is emitted.
        @_setState(state)
      )

    changeStatus: (relayName) ->
      YAPI.RegisterHub('http://192.168.1.205:4444/')
      relay  = YRelay.FindRelay(relayName)
      env.logger.info relay.get_state()
      env.logger.info YRelay.OUTPUT_ON
      if relay.get_state() then relay.set_output(YRelay.OUTPUT_OFF) else relay.set_output(YRelay.OUTPUT_ON)
      return Promise.resolve()

    getStatus: (relayName) ->
      YAPI.RegisterHub('http://192.168.1.205:4444/')
      anyrelay  = YRelay.FirstRelay();  
      relay  = YRelay.FindRelay(relayName)
      #env.logger.info relay.get_module().get_serialNumber();
      #env.logger.info relay.get_state()
      #env.logger.info YRelay.FirstRelay()
      return Promise.resolve(relay.get_state())

    # ####getState()
    # Should return a promise with the state of the switch.
    getState: () ->
      # If the state is cached then return it
      return if @_state? then Promise.resolve(@_state)
      # else et the state from somwhere
      return this.getStatus(@relayName).then( (state) =>
        @_state = state
        # and return it.
        return @_state
      )

  # ###Finally
  # Create a instance of my plugin
  myPlugin = new YoctoMainRelayPlugin
  # and return it to the framework.
  return myPlugin