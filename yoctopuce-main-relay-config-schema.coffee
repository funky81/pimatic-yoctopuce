# #my-plugin configuration options
# Declare your config option for your plugin here. 
module.exports = {
  title: "Yoctopuce PowerMaxiRelay options"
  type: "object"
  properties:
    YoctoHub:
      description: "Url Address for YoctoHub"
      type: "string"
      default: "http://192.168.1.205:4444/"
}