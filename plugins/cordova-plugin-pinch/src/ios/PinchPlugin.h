#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import <Cordova/CDV.h>

@interface PinchPlugin : CDVPlugin

@property(nonatomic) BOOL debugEnabled;

- (void)start:(CDVInvokedUrlCommand *)command;
- (void)startLocationProvider:(CDVInvokedUrlCommand *)command;
- (void)startBluetoothProvider:(CDVInvokedUrlCommand *)command;
- (void)stop:(CDVInvokedUrlCommand *)command;
- (void)stopLocationProvider:(CDVInvokedUrlCommand *)command;
- (void)stopBluetoothProvider:(CDVInvokedUrlCommand *)command;

- (void)sendDemographicProfileWithBirthYear:(CDVInvokedUrlCommand *)command;
- (void)addCustomDataWithType:(CDVInvokedUrlCommand *)command;
- (void)setMetadataWithType:(CDVInvokedUrlCommand *)command;
- (void)setMessagingId:(CDVInvokedUrlCommand *)command;

- (void)getPrivacyDashboardUrl:(CDVInvokedUrlCommand *)command;

- (void)getAppData:(CDVInvokedUrlCommand *)command;
- (void)saveAppData:(CDVInvokedUrlCommand *)command;
- (void)removeAppData:(CDVInvokedUrlCommand *)command;

- (void)deleteCollectedData:(CDVInvokedUrlCommand *)command;
- (void)getStringifiedMessages:(CDVInvokedUrlCommand *)command;
- (void)requestBluetoothPermission:(CDVInvokedUrlCommand *)command;

- (void)grant:(CDVInvokedUrlCommand *)command;
- (void)revoke:(CDVInvokedUrlCommand *)command;
- (void)grantedConsents:(CDVInvokedUrlCommand *)command;
- (void)setAdid:(CDVInvokedUrlCommand *)command;

// Utilities
+ (id)getInstance;
- (void)runBackgroundSendPluginStringResult:(CDVInvokedUrlCommand *)command runBlock:(NSString * (^)(void))runBlock;
- (void)runBackgroundSendPluginOkResult:(CDVInvokedUrlCommand *)command runBlock:(void (^)(void))runBlock;

- (void)sendPluginResult:(CDVPluginResult *)result command:(CDVInvokedUrlCommand *)command;
- (void)sendPluginResultBool:(BOOL)result command:(CDVInvokedUrlCommand *)command;
- (void)sendPluginResultString:(NSString *)result command:(CDVInvokedUrlCommand *)command;
- (void)sendPluginError:(NSString *)errorMessage command:(CDVInvokedUrlCommand *)command;
- (void)handlePluginException:(NSException *)exception command:(CDVInvokedUrlCommand *)command;
- (void)executeGlobalJavascript:(NSString *)jsString;
- (NSString *)arrayToJsonString:(NSArray *)inputArray;
- (NSString *)objectToJsonString:(NSDictionary *)inputObject;
- (NSArray *)jsonStringToArray:(NSString *)jsonStr;
- (NSDictionary *)jsonStringToDictionary:(NSString *)jsonStr;
- (bool)isNull:(NSString *)str;
- (void)logDebug:(NSString *)msg;
- (void)logError:(NSString *)msg;
- (NSString *)escapeDoubleQuotes:(NSString *)str;
- (void)setSetting:(NSString *)key forValue:(id)value;
- (id)getSetting:(NSString *)key;

@end
