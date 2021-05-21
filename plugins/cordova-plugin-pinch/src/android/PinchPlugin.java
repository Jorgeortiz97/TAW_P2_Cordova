package cordova.plugins;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import java.util.ArrayList;
import java.util.List;

import com.fluxloop.pinch.common.model.DemographicProfile;
import com.fluxloop.pinch.sdk.Pinch;
import com.fluxloop.pinch.sdk.PinchMessagingCenter;

public class PinchPlugin extends CordovaPlugin {

    private static final String ACTION_GRANT = "grant";
    private static final String ACTION_REVOKE = "revoke";
    private static final String ACTION_START = "start";
    private static final String ACTION_START_LOCATION = "startLocationProvider";
    private static final String ACTION_START_BLUETOOTH = "startBluetoothProvider";
    private static final String ACTION_STOP = "stop";
    private static final String ACTION_STOP_LOCATION = "stopLocationProvider";
    private static final String ACTION_STOP_BLUETOOTH = "stopBluetoothProvider";
    private static final String ACTION_SEND_DEMOGRAPHIC = "sendDemographicProfileWithBirthYear";
    private static final String ACTION_ADD_CUSTOMDATA = "addCustomDataWithType";
    private static final String ACTION_SET_METADATA = "setMetadataWithType";
    private static final String ACTION_SET_MESSAGINGID = "setMessagingId";
    private static final String ACTION_GET_DASHBOARDURL = "getPrivacyDashboardUrl";
    private static final String ACTION_DELETE_DATA = "deleteCollectedData";
    private static final String ACTION_GET_APPDATA = "getAppData";
    private static final String ACTION_SAVE_APPDATA = "saveAppData";
    private static final String ACTION_REMOVE_APPDATA = "removeAppData";
    private static final String ACTION_GET_MESSAGES = "getStringifiedMessages";
    private static final String ACTION_GET_CONSENTS = "grantedConsents";

    private static final String STORE_NAME = "com.fluxloop.pinch.core";

    protected Context applicationContext;
    protected CallbackContext currentContext;
    protected SharedPreferences sharedPref;

    public void initialize(CordovaInterface cordova, CordovaWebView webView) {
        applicationContext = this.cordova.getActivity().getApplicationContext();
        sharedPref = cordova.getActivity().getSharedPreferences(STORE_NAME, Activity.MODE_PRIVATE);
        super.initialize(cordova, webView);
    }

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {

        try {
            if (ACTION_START.equals(action)) {
                this.start(callbackContext, new Pinch.Provider[] { Pinch.Provider.LOCATION, Pinch.Provider.BLUETOOTH });
            } else if (ACTION_START_LOCATION.equals(action)) {
                this.start(callbackContext, new Pinch.Provider[] { Pinch.Provider.LOCATION });
            } else if (ACTION_START_BLUETOOTH.equals(action)) {
                this.start(callbackContext, new Pinch.Provider[] { Pinch.Provider.BLUETOOTH });
            } else if (ACTION_STOP.equals(action)) {
                this.stop(callbackContext, new Pinch.Provider[] { Pinch.Provider.LOCATION, Pinch.Provider.BLUETOOTH });
            } else if (ACTION_STOP_LOCATION.equals(action)) {
                this.stop(callbackContext, new Pinch.Provider[] { Pinch.Provider.LOCATION });
            } else if (ACTION_STOP_BLUETOOTH.equals(action)) {
                this.stop(callbackContext, new Pinch.Provider[] { Pinch.Provider.BLUETOOTH });
            } else if (ACTION_SEND_DEMOGRAPHIC.equals(action)) {
                this.sendDemographicProfileWithBirthYear(callbackContext, args);
            } else if (ACTION_GET_DASHBOARDURL.equals(action)) {
                this.getPrivacyDashboardUrl(callbackContext);
            } else if (ACTION_ADD_CUSTOMDATA.equals(action)) {
                this.addCustomDataWithType(callbackContext, args);
            } else if (ACTION_SET_METADATA.equals(action)) {
                this.setMetadataWithType(callbackContext, args);
            } else if (ACTION_GET_APPDATA.equals(action)) {
                this.getAppData(callbackContext, args);
            } else if (ACTION_SAVE_APPDATA.equals(action)) {
                this.saveAppData(callbackContext, args);
            } else if (ACTION_REMOVE_APPDATA.equals(action)) {
                this.removeAppData(callbackContext, args);
            } else if (ACTION_GRANT.equals(action)) {
                this.grant(callbackContext, args);
            } else if (ACTION_SET_MESSAGINGID.equals(action)) {
                this.setMessagingId(callbackContext, args);
            } else if (ACTION_DELETE_DATA.equals(action)) {
                this.deleteCollectedData(callbackContext, args);
            } else if (ACTION_GET_MESSAGES.equals(action)) {
                this.getStringifiedMessages(callbackContext, args);
            } else if (ACTION_REVOKE.equals(action)) {
                this.revoke(callbackContext, args);
            } else if (ACTION_GET_CONSENTS.equals(action)) {
                this.getGrantedConsents(callbackContext, args);
            } else
                return false;
        } catch (Exception ex) {
            callbackContext.error(ex.getMessage());
        }
        return true;
    }

    private void getGrantedConsents(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    currentContext.success(getJSONArrayFromConsents(Pinch.getGrantedConsents()));
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void getStringifiedMessages(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    PinchMessagingCenter.getStringifiedMessages(messages -> {
                        currentContext.success(messages);
                        return null;
                    });
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void deleteCollectedData(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.deleteCollectedData(didDelete -> {
                        currentContext.success(didDelete ? 1 : 0);
                        return null;
                    });
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void setMessagingId(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.setMessagingId(args.getString(0));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void grant(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.grant(getConsentsFromJSONArray(args));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void revoke(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.revoke(getConsentsFromJSONArray(args));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void setMetadataWithType(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.setMetadata(args.getString(0), args.getString(1));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void addCustomDataWithType(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.addCustomEvent(args.getString(0), args.getString(1));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void getPrivacyDashboardUrl(CallbackContext currentContext) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    String privacyDashboardUrl = Pinch.getPrivacyDashboard(Pinch.Consent.SURVEYS);
                    currentContext.success(privacyDashboardUrl);
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void sendDemographicProfileWithBirthYear(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    int birthYear = args.getInt(0);
                    int genderIndex = args.getInt(1);
                    DemographicProfile.Gender gender = DemographicProfile.Gender.values()[genderIndex];
                    Pinch.sendDemographicProfile(new DemographicProfile(birthYear, gender));
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void start(CallbackContext currentContext, Pinch.Provider[] providers) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.start(providers);
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void stop(CallbackContext currentContext, Pinch.Provider[] providers) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    Pinch.stop(providers);
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void getAppData(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    String key = args.getString(0);
                    String prefValue = sharedPref.getString(key, null);
                    currentContext.success(prefValue);
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void removeAppData(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    SharedPreferences.Editor editor = sharedPref.edit();
                    String key = args.getString(0);
                    editor.remove(key);
                    editor.apply();
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void saveAppData(CallbackContext currentContext, JSONArray args) {
        cordova.getActivity().runOnUiThread(new Runnable() {
            public void run() {
                try {
                    SharedPreferences.Editor editor = sharedPref.edit();
                    String key = args.getString(0);
                    String value = args.getString(1);
                    editor.putString(key, value);
                    editor.apply();
                    currentContext.success();
                } catch (Exception e) {
                    sendError(currentContext, e);
                }
            }
        });
    }

    private void sendError(CallbackContext callbackContext, Exception e) {
        callbackContext.error(e.getMessage());
    }

    private Pinch.Consent[] getConsentsFromJSONArray(JSONArray args) throws JSONException {
        Pinch.Consent[] consents = new Pinch.Consent[args.length()];
        for (int i = 0; i < args.length(); i++) {
            int v = args.getInt(i);
            if (v == 1001)
                consents[i] = Pinch.Consent.SURVEYS;
            else if (v == 1002)
                consents[i] = Pinch.Consent.ANALYTICS;
            else if (v == 1003)
                consents[i] = Pinch.Consent.CAMPAIGNS;
            else if (v == 1004)
                consents[i] = Pinch.Consent.ADS;
        }
        return consents;
    }

    private JSONArray getJSONArrayFromConsents(List<Pinch.Consent> consents) throws JSONException {
        JSONArray response = new JSONArray();
        for (int i = 0; i < consents.size(); i++) {
            if (consents.get(i) == Pinch.Consent.SURVEYS)
                response.put(i, 1001);
            else if (consents.get(i) == Pinch.Consent.ANALYTICS)
                response.put(i, 1002);
            else if (consents.get(i) == Pinch.Consent.CAMPAIGNS)
                response.put(i, 1003);
            else if (consents.get(i) == Pinch.Consent.ADS)
                response.put(i, 1004);
        }
        return response;
    }

}