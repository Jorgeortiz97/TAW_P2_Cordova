# Pinch SDK Cordova Pinch Proximity Plugin implementation guide 

[![N|Solid](http://ganymede.blob.core.windows.net/upload/fluxloop-logo-wide-12001_small.jpg)](https://nodesource.com/products/nsolid)

Full implementation guide are available here: https://developers.pinch.no/cordova/


# Add PinchSDK

## Prerequisites

The following criterias must be fulfilled to implement the SDK:
- Minimum iOS target: 9.0
- Minimum Android SDK version: 15
- Minimum Android compile version: 28
- Java 8+

## Initialize SDK
::: warning
Privacy dashboard and other metadata collection may not work as expected if API key is missing.
:::

## Install Plugin
You can install packages from the command line with cordova:
``` bash
$ cordova plugins add cordova-plugin-pinch --variable API_KEY=[API_KEY]
```

If you need to change your `APP_KEY` after installation, it's recommended that you remove and then re-add the plugin as above. Note that changes to the `APP_KEY` value in your config.xml file will not be propagated to the individual platform builds.