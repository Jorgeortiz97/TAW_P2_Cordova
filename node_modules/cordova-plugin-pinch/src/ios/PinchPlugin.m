

#import "PinchPlugin.h"
#import <Cordova/CDVViewController.h>
#import <Cordova/CDVScreenOrientationDelegate.h>
#import <AdSupport/ASIdentifierManager.h>
#import <CoreLocation/CoreLocation.h>
#import <UserNotifications/UserNotifications.h>

#import <PinchSDKLegacy/Pinch.h>
#import <PinchSDK/PinchSDK.h>
#import <PinchSDK/PinchSDK-Swift.h>


@implementation PinchPlugin

static NSString*const LOG_TAG = @"[PinchPlugin] ";


static PinchPlugin* PluginPinch = nil;

/********************************/
#pragma mark - Public static functions
/********************************/
+ (id) getInstance{
    return PluginPinch;
}

- (void)pluginInitialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pageDidLoad) name:CDVPageDidLoadNotification object:self.webView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidResume:) name: UIApplicationDidBecomeActiveNotification object: nil];
    
    [super pluginInitialize];
    PluginPinch = self;
}

- (void)finishLaunching:(NSNotification *)notification
{
    [PluginPinch logDebug:@"finishLaunching"];
}


- (void)applicationDidResume:(UIApplication *)application
{
    [PluginPinch logDebug:@"applicationDidResume"];
}

- (void)pageDidLoad
{
    [PluginPinch logDebug:@"pageDidLoad"];
}

- (void) runBackgroundSendPluginOkResult: (CDVInvokedUrlCommand*)command runBlock:(void(^)(void))runBlock {
    [self.commandDelegate runInBackground:^{
        @try {
            runBlock();
            [PluginPinch sendPluginResultBool:YES command:command];
        }
        @catch (NSException *exception) {
            [PluginPinch handlePluginException:exception command:command];
        }
    }];
}

- (void) runBackgroundSendPluginStringResult: (CDVInvokedUrlCommand*)command runBlock:(NSString*(^)(void))runBlock {
    [self.commandDelegate runInBackground:^{
        @try {
            NSString* result = runBlock();
            [PluginPinch sendPluginResultString:result command:command];
        }
        @catch (NSException *exception) {
            [PluginPinch handlePluginException:exception command:command];
        }
    }];
}

- (void) start: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"start"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX start];
    }];
}

- (void) startLocationProvider: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"startLocationProvider"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX startLocationProvider];
    }];
}

- (void) startBluetoothProvider: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"startBluetoothProvider"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX startBluetoothProvider];
    }];
}

- (void) stop: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"stop"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX stop];
    }];
}

- (void) stopLocationProvider: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"stopLocationProvider"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX stopLocationProvider];
    }];
}

- (void) stopBluetoothProvider: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"stopBluetoothProvider"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX stopBluetoothProvider];
    }];
}

- (void) getPrivacyDashboardUrl: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"getPrivacyDashboardUrl"];
    [self runBackgroundSendPluginStringResult:command runBlock:^NSString *{
        [PluginPinch logDebug:[NSString stringWithFormat:@"URL: %@",[PinchX privaryDashboardUrl]]];
        return [PinchX privaryDashboardUrl];
    }];
}

- (void)getAppData:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"getAppData"];
    [self runBackgroundSendPluginStringResult:command runBlock:^NSString *{
        NSString *key = [command.arguments objectAtIndex:0];
        NSString *value = [PluginPinch getSetting:key];
        [PluginPinch logDebug:[NSString stringWithFormat:@"KEY: %@ - VALUE: %@",key, value]];
        return value;
    }];
}

- (void)saveAppData:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"saveAppData"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        NSString *key = [command.arguments objectAtIndex:0];
        NSString *value = [command.arguments objectAtIndex:1];
        [PluginPinch logDebug:[NSString stringWithFormat:@"KEY: %@ - VALUE: %@",key,value]];
        [PluginPinch setSetting:key forValue:value];
    }];
}

- (void)removeAppData:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"removeAppData"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        NSString *key = [command.arguments objectAtIndex:0];
        [PluginPinch logDebug:[NSString stringWithFormat:@"KEY: %@",key]];
        [PluginPinch removeSetting:key];
    }];
}

- (void) isTracking: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"isTracking"];
    [self.commandDelegate runInBackground:^{
         @try {
             [PinchX isTracking:^(BOOL sdkTracking) {
                 [PluginPinch logDebug:[NSString stringWithFormat:@"RETURN: %@",sdkTracking?@"YES":@"NO"]];
                 [PluginPinch sendPluginResultBool:sdkTracking command:command];
             }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
     }];
}

- (void)setAdid:(CDVInvokedUrlCommand *)command {    
    [PluginPinch logDebug:@"setAdid"];
    [self.commandDelegate runInBackground:^{
         @try {
             if([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                 [PinchX setAdid:ASIdentifierManager.sharedManager.advertisingIdentifier];
                 [PluginPinch sendPluginResultBool:YES command:command];
             } else {
                 [PluginPinch sendPluginResultBool:NO command:command];
             }
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
     }];
}

- (void)grant:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"grant"];
    [self.commandDelegate runInBackground:^{
        @try {
            [PinchX grantWithConsents:[command arguments] onSuccess:^(BOOL success) {
                [PluginPinch sendPluginResultBool:success command:command];
            }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}

- (void)revoke:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"revoke"];
    [self.commandDelegate runInBackground:^{
        @try {
            [PinchX revokeWithConsents:[command arguments] onSuccess:^(BOOL success) {
                [PluginPinch sendPluginResultBool:success command:command];
            }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}

- (void)grantedConsents:(CDVInvokedUrlCommand *)command {
    [PluginPinch logDebug:@"grantedConsents"];
    [self.commandDelegate runInBackground:^{
        @try {
            NSArray<NSNumber*> *consents = [PinchX grantedConsents];
            NSString *jsonConsents = [self arrayToJsonString:consents];
            [PluginPinch sendPluginResultString:jsonConsents command:command];            
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}

-(void) sendDemographicProfileWithBirthYear: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"sendDemographicProfileWithBirthYear"];
    [self.commandDelegate runInBackground:^{
        @try {
            NSInteger birthYear = [[command argumentAtIndex:0] integerValue];
            NSInteger gender = [[command argumentAtIndex:1] integerValue];
            [PluginPinch logDebug:[NSString stringWithFormat:@"BirthYear:%ld, Gender: %ld",birthYear, gender]];
            [PinchX sendDemographicProfileWithBirthYear:birthYear gender:gender onSuccess:^(BOOL success) {
                [PluginPinch sendPluginResultBool:success command:command];
            }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}

-(void) addCustomDataWithType: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"addCustomDataWithType"];
    [self.commandDelegate runInBackground:^{
        @try {
            NSString* type = [command.arguments objectAtIndex:0];
            NSString* data = [command.arguments objectAtIndex:1];

            // Check if both parameters is defined with correct type and not null
            if (type && data) {
                // Parse json string to dicationary
                NSError *jsonError;
                NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
                [PluginPinch logDebug:[NSString stringWithFormat:@"Type: %@",type]];
                [PluginPinch logDebug:[NSString stringWithFormat:@"Data: %@",dataDictionary]];
                [PinchX addCustomDataWithType:type json:dataDictionary onSuccess:^(BOOL success) {
                    [PluginPinch sendPluginResultBool:success command:command];
                }];
            }
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}


-(void) setMetadataWithType: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"setMetadataWithType"];
    [self.commandDelegate runInBackground:^{
        @try {
            NSString* type = [command.arguments objectAtIndex:0];
            NSString* data = [command.arguments objectAtIndex:1];

            // Check if both parameters is defined with correct type and not null
            if (type && data) {
                // Parse json string to dicationary
                NSError *jsonError;
                NSData *objectData = [data dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&jsonError];
                [PluginPinch logDebug:[NSString stringWithFormat:@"Type: %@",type]];
                [PluginPinch logDebug:[NSString stringWithFormat:@"Data: %@",dataDictionary]];
                [PinchX setMetadataWithType:type json:dataDictionary onSuccess:^(BOOL success) {
                    [PluginPinch sendPluginResultBool:success command:command];
                }];
            }
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
    }];
}


- (void) setMessagingId: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"setMessagingId"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        NSString *messageId = [command.arguments objectAtIndex:0];
        [PluginPinch logDebug:[NSString stringWithFormat:@"INPUT: %@",messageId]];
        [PinchX setMessagingId:messageId];
    }];
}

- (void) deleteCollectedData: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"deleteCollectedData"];
    [self.commandDelegate runInBackground:^{
         @try {
             [PinchX deleteCollectedDataOnSuccess:^(BOOL success) {
                 [PluginPinch sendPluginResultBool:success command:command];
             }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
     }];
}


- (void) getStringifiedMessages: (CDVInvokedUrlCommand*)command {
    [PluginPinch logDebug:@"getStringifiedMessages"];
    [self.commandDelegate runInBackground:^{
         @try {
             [PinchMessagingCenter getStringifiedMessagesOnSuccess:^(NSString * _Nullable jsonString) {
                 [PluginPinch logDebug:[NSString stringWithFormat:@"RETURN: %@",jsonString]];
                 [PluginPinch sendPluginResultString:jsonString command:command];
             }];
         }
         @catch (NSException *exception) {
             [PluginPinch handlePluginException:exception command:command];
         }
     }];
}

- (void) requestBluetoothPermission: (CDVInvokedUrlCommand*)command  {
    [PluginPinch logDebug:@"requestBluetoothPermission"];
    [self runBackgroundSendPluginOkResult:command runBlock:^{
        [PinchX requestBluetoothPermission];
    }];
}


/********************************/
#pragma mark - Send results
/********************************/

- (void)sendPluginResult:(CDVPluginResult *)result command:(CDVInvokedUrlCommand *)command
{
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)sendPluginResultBool:(BOOL)result command:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult;
    if(result) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:1];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:0];
    }
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendPluginResultString:(NSString *)result command:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)sendPluginError:(NSString *)errorMessage command:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:errorMessage];
    [self logError:errorMessage];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)handlePluginException:(NSException *)exception command:(CDVInvokedUrlCommand *)command
{
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:exception.reason];
    [self logError:[NSString stringWithFormat:@"EXCEPTION: %@", exception.reason]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)executeGlobalJavascript: (NSString*)jsString
{
    [self.commandDelegate evalJs:jsString];
}

- (NSString*) arrayToJsonString:(NSArray*)inputArray
{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:inputArray options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSString*) objectToJsonString:(NSDictionary*)inputObject
{
    NSError* error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:inputObject options:NSJSONWritingPrettyPrinted error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

- (NSArray*) jsonStringToArray:(NSString*)jsonStr
{
    NSError* error = nil;
    NSArray* array = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if (error != nil){
        array = nil;
    }
    return array;
}

- (NSDictionary*) jsonStringToDictionary:(NSString*)jsonStr
{
    return (NSDictionary*) [self jsonStringToArray:jsonStr];
}

- (bool)isNull: (NSString*)str
{
    return str == nil || str == (id)[NSNull null] || str.length == 0 || [str isEqual: @"<null>"];
}


/********************************/
#pragma mark - utility functions
/********************************/

- (void)logDebug: (NSString*)msg
{
    if(self.debugEnabled){
        NSLog(@"%@: %@", LOG_TAG, msg);
        NSString* jsString = [NSString stringWithFormat:@"console.log(\"%@: %@\")", LOG_TAG, [self escapeDoubleQuotes:msg]];
        [self executeGlobalJavascript:jsString];
    }
}

- (void)logError: (NSString*)msg
{
    NSLog(@"%@ ERROR: %@", LOG_TAG, msg);
    if(self.debugEnabled){
        NSString* jsString = [NSString stringWithFormat:@"console.error(\"%@: %@\")", LOG_TAG, [self escapeDoubleQuotes:msg]];
        [self executeGlobalJavascript:jsString];
    }
}

- (NSString*)escapeDoubleQuotes: (NSString*)str
{
    NSString *result =[str stringByReplacingOccurrencesOfString: @"\"" withString: @"\\\""];
    return result;
}

- (void) setSetting: (NSString*)key forValue:(id)value
{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id) getSetting: (NSString*) key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void) removeSetting: (NSString*) key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
