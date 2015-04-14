pimatic-yoctopuce
=================

Pimatic Plugin for Yoctopuce MaxiPowerRelay (https://www.yoctopuce.com/EN/products/usb-actuators/yocto-maxipowerrelay)

Configuration
-------------

You can load the plugin by editing your `config.json` to include the following in the `plugins` section. The property `
interval` specifies the time interval in seconds for polling the state information of the Smart Plugs.   

    { 
       "plugin": "interval"
       "YoctoHub" : "http://localhost:4444/"
    }
    
Then you need to add a Yoctopuce MaxiPowerRelay device in the `devices` section. 
Similiar like other device in Pimatic, you have to describe for below properties

    {
      "id": "YoctoPowerRelay-Lampu_depan",
      "class": "YoctoMainRelay",
      "name": "Lampu Depan",
    }   
    

Note that :

    ID should mention `YoctopowerRelay-` prefix while the rest of the ID will be your logical name in Yoctopuce MaxiPowerRelay.
    Name will be your label name in your Pimatic device