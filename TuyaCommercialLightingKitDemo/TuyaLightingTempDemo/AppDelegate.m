//
//  AppDelegate.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "AppDelegate.h"
#import <TuyaSmartBaseKit/TuyaSmartBaseKit.h>


NSString *const TY_APP_KEY = @"";
NSString *const TY_SECRET_KEY = @"";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Please add security image
    [[TuyaSmartSDK sharedInstance] startWithAppKey:TY_APP_KEY secretKey:TY_SECRET_KEY];
    
    // Please turn on debug mode if necessary
//    TuyaSmartSDK.sharedInstance.env = TYEnvPrepare;
//    TuyaSmartSDK.sharedInstance.debugMode = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
    if (TuyaSmartUser.sharedInstance.isLogin) {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
    } else {
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
    }
    return YES;
}


@end
