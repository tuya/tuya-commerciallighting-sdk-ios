//
//  AppDelegate.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "AppDelegate.h"
#import <ThingSmartBaseKit/ThingSmartBaseKit.h>
#import <ThingSmartBizCore/ThingSmartBizCore.h>
#import <ThingModuleServices/ThingModuleServices.h>
#import "LampProjectDataProtocolImpl.h"

NSString *const TY_APP_KEY = @"";
NSString *const TY_SECRET_KEY = @"";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [ThingSmartSDK.sharedInstance startWithAppKey:TY_APP_KEY secretKey:TY_SECRET_KEY];
    ThingSmartSDK.sharedInstance.debugMode = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    if (ThingSmartUser.sharedInstance.isLogin) {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle].instantiateInitialViewController;
    } else {
        self.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:NSBundle.mainBundle].instantiateInitialViewController;
    }
    
    //Register
    [[ThingSmartBizCore sharedInstance] registerService:@protocol(ThingLampProjectDataProtocol)
                                              withClass:LampProjectDataProtocolImpl.class];
    return YES;
}


@end
