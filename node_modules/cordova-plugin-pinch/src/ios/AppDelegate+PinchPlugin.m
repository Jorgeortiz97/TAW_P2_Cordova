#import "AppDelegate+PinchPlugin.h"
#import "PinchPlugin.h"
#import <objc/runtime.h>
#import <PinchSDKLegacy/Pinch.h>
#import <PinchSDK/PinchSDK.h>
#import <PinchSDK/PinchSDK-Swift.h>

@implementation AppDelegate (PinchPlugin)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledSelector = @selector(PinchPlugin_application:didFinishLaunchingWithOptions:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (BOOL)PinchPlugin_application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    NSLog(@"Pinch:openURL");
    return NO;
}

- (BOOL)PinchPlugin_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"Pinch:didFinishLaunchingWithOptions");
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString* pinchApiKey = [infoDict objectForKey:@"PURPublisherId"];    
    [PinchX initializeWith:launchOptions apiKey:pinchApiKey];
    return [self PinchPlugin_application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)PinchPlugin_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
}

- (void)PinchPlugin_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)PinchPlugin_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
}

- (void)PinchPlugin_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
}

@end
