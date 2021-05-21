var exec = require('cordova/exec');

var pinch = {

    consents: Object.freeze({ "GENERIC": 1000, "SURVEYS": 1001, "ANALYTICS": 1002, "CAMPAIGNS": 1003, "ADS": 1004 }),
    gender: Object.freeze({ "UNKNOWN": 0, "MALE": 1, "FEAMLE": 2 }),

    grant: function (arrConsents, success, fail) {
        if (typeof arrConsents[0] == "undefined") console.error("Missing parameter with array of pinch.consents.", this.consents);
        else cordova.exec(success, fail, "PinchPlugin", "grant", arrConsents);
    },
    revoke: function (arrConsents, success, fail) {
        if (typeof arrConsents[0] == "undefined") console.error("Missing parameter with array of pinch.consents.", this.consents);
        else cordova.exec(success, fail, "PinchPlugin", "revoke", arrConsents);
    },
    getGrantedConsents: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "grantedConsents", []);
    },
    start: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "start", []);
    },
    isTracking: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "isTracking", []);
    },
    setAdid: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "setAdid", []);
    },
    startLocationProvider: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "startLocationProvider", []);
    },
    startBluetoothProvider: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "startBluetoothProvider", []);
    },
    stop: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "stop", []);
    },
    stopLocationProvider: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "stopLocationProvider", []);
    },
    stopBluetoothProvider: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "stopBluetoothProvider", []);
    },
    sendDemographicProfileWithBirthYear: function (birthYear, gender, success, fail) {
        if (!birthYear) {
            console.error("Missing first parameter birthYear.");
            return;
        }
        if (typeof gender != "number") {
            console.error("Missing second parameter pinch.gender.", this.gender);
            return;
        }
        cordova.exec(success, fail, "PinchPlugin", "stopBluetoothProvider", [birthYear, gender]);
    },
    addCustomDataWithType: function (type, jsonData, success, fail) {
        if (!type || typeof type != "string") {
            console.error("Missing first string parameter type.");
            return;
        }
        if (!jsonData || (typeof jsonData != "string" && typeof jsonData != "object")) {
            console.error("Missing second parameter jsonData.");
            return;
        }
        cordova.exec(success, fail, "PinchPlugin", "addCustomDataWithType", [type, typeof jsonData == "object" ? JSON.stringify(jsonData) : jsonData]);
    },
    setMetadataWithType: function (type, jsonData, success, fail) {
        if (!type || typeof type != "string") {
            console.error("Missing first string parameter type.");
            return;
        }
        if (!jsonData || (typeof jsonData != "string" && typeof jsonData != "object")) {
            console.error("Missing second parameter jsonData.");
            return;
        }
        cordova.exec(success, fail, "PinchPlugin", "setMetadataWithType", [type, typeof jsonData == "object" ? JSON.stringify(jsonData) : jsonData]);
    },
    getPrivacyDashboardUrl: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "getPrivacyDashboardUrl", []);
    },
    setMessagingId: function (messagingId, success, fail) {
        if (!messagingId || typeof messagingId != "string") console.error("Missing first string parameter messagingId.");
        else cordova.exec(success, fail, "PinchPlugin", "setMessagingId", [messagingId]);
    },
    getAppData: function (key, success, fail) {
        if (!key || typeof key != "string") console.error("Missing first string parameter key.");
        exec(success, null, "PinchPlugin", "getAppData", [key]);
    },
    saveAppData: function (key, value, success, fail) {
        if (!key || typeof key != "string") console.error("Missing first string parameter key.");
        if (!value || typeof value != "string") console.error("Missing second string parameter value.");
        exec(success, null, "PinchPlugin", "saveAppData", [key, value]);
    },
    removeAppData: function (key, success, fail) {
        if (!key || typeof key != "string") console.error("Missing first string parameter key.");
        exec(success, null, "PinchPlugin", "removeAppData", [key]);
    },
    deleteCollectedData: function (success, fail) {
        cordova.exec(success, fail, "PinchPlugin", "deleteCollectedData", []);
    },
    getMessages: function (success, fail) {
        cordova.exec(function (jsonMessages) {
            if (typeof jsonMessages == "string") success(JSON.parse(jsonMessages));
            else success(jsonMessages);
        }, fail, "PinchPlugin", "getStringifiedMessages", []);
    },


    /* Return with ERROR for old SDK Interfaces */
    initViews: function () {
        console.error("initViews no longer supported.");
    },

    requestNotificationAuthorization: function (callback) {
        console.error("requestNotificationAuthorization not longer supported.");
        if (callback) callback(true);
    },

    requestLocationAuthorization: function (callback) {
        console.error("requestLocationAuthorization no longer supported.");
        if (callback) callback(true);
    },

    requestLocationAlwaysAuthorization: function (callback) {
        console.error("requestLocationAlwaysAuthorization no longer supported.");
        if (callback) callback(true);
    },

    requestLocationWhenInUseAuthorization: function (callback) {
        console.error("requestLocationWhenInUseAuthorization no longer supported.");
        if (callback) callback(true);
    },

    hasNotificationPermission: function (callback) {
        console.error("hasNotificationPermission no longer supported.");
        if (callback) callback(true);
    },

    hasLocationPermission: function (callback) {
        console.error("hasLocationPermission no longer supported.");
        if (callback) callback(true);
    },

    getLocationRequested: function (callback) {
        console.error("getLocationRequested no longer supported.");
        if (callback) callback(true);
    },

    getNotificationRequested: function (callback) {
        console.error("getNotificationRequested no longer supported.");
        if (callback) callback(true);
    },

    getUserDefaults: function (key, callback) {
        console.error("getUserDefaults no longer supported.");
        if (callback) callback(localStorage.getItem(key));
    },

    saveUserDefaults: function (key, value, callback) {
        console.error("saveUserDefaults no longer supported.");
        localStorage.setItem(key, value);
        if (callback) callback();
    },

    removeUserDefaults: function (key) {
        console.error("removeUserDefaults no longer supported.");
        localStorage.removeItem(key);
    },

    simulateCampaign: function () {
        console.error("simulateCampaign no longer supported.");
    },

    closeCampaign: function () {
        console.error("closeCampaign no longer supported.");
    },

    deleteCampaign: function () {
        console.error("deleteCampaign no longer supported.");
    },

    openCampaign: function () {
        console.error("openCampaign no longer supported.");
    },

    openCampaignWithUrl: function () {
        console.error("openCampaignWithUrl no longer supported.");
    },

    getPinchID: function () {
        console.error("getPinchID no longer supported.");
        return "";
    },

    getAdvertisingIdentifier: function (callback) {
        console.error("getAdvertisingIdentifier no longer supported.");
        if (callback) callback("");
    },

    getLatestCampaign: function (callback) {
        console.error("getLatestCampaign no longer supported.");
        if (callback) callback(null);
    },

    registerUserName: function (userName) {
        console.error("registerUserName no longer supported.");
    },

    registerUserData: function (modelname, userdata) {
        console.error("registerUserData no longer supported.");
    },

    registerEvent: function (eventName) {
        console.error("registerEvent no longer supported.");
    },

    showDebugButtons: function (enabled) {
        console.error("showDebugButtons no longer supported.");
    },

    setPinchEnabled: function (enabled) {
        console.error("setPinchEnabled no longer supported.");
    },

    checkAuthorization: function () {
        console.error("checkAuthorization no longer supported.");
    },

    checkBluetoothStatus: function (callback) {
        console.error("checkBluetoothStatus no longer supported.");
        if (callback) callback(true);
    },

    checkNotificationSettings: function (callback) {
        console.error("checkBluetoothStatus no longer supported.");
        if (callback) callback(true);
    },

    checkLocationSettings: function (callback) {
        console.error("checkLocationSettings no longer supported.");
        if (callback) callback(true);
    },

    addEventListener: function (eventSelector, callback) {
        if (callback) console.error("addEventListener no longer supported.");
    }

};

module.exports = pinch;

