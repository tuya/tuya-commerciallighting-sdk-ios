//
//  APModeTableViewController.m
//  TuyaAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "APModeTableViewController.h"
#import <ThingSmartActivatorCoreKit/ThingSmartActivatorCoreKit.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
//#import <ThingSmartBizCore/ThingSmartBizCore.h>
//#import <TYModuleServices/TYModuleServices.h>

#import "CacheManager.h"

@interface APModeTableViewController () <ThingSmartActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) bool isSuccess;
@end

@implementation APModeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestToken];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopConfigWifi];
}

- (IBAction)searchTapped:(UIBarButtonItem *)sender {
//    [self startConfiguration];
//    id<TYActivatorProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TYActivatorProtocol)];
//    [impl gotoCategoryViewController];
//      
//    // 获取配网结果
//    [impl activatorCompletion:TYActivatorCompletionNodeNormal customJump:NO completionBlock:^(NSArray * _Nullable deviceList) {
//        NSLog(@"deviceList: %@",deviceList);
//    }];
}

- (void)addDeviceAction {
//    id<TYActivatorProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TYActivatorProtocol)];
//    [impl gotoCategoryViewController];
//
//    // 获取配网结果
//    [impl activatorCompletion:TYActivatorCompletionNodeNormal customJump:NO completionBlock:^(NSArray * _Nullable deviceList) {
//        NSLog(@"deviceList: %@",deviceList);
//    }];
}


- (void)requestToken {
    long long projectId = CacheManager.sharedInstance.projectId;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Requesting for Token", @"")];
//    [[ThingSmartActivator sharedInstance] getTokenWithProjectId:projectId success:^(NSString *result) {
//        if (result && result.length > 0) {
//            self.token = result;
//        }
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    }];
}

- (void)startConfiguration {
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Configuring", @"")];
    NSString *ssid = self.ssidTextField.text;
    NSString *password = self.passwordTextField.text;
    [ThingSmartActivator sharedInstance].delegate = self;
//    [[ThingSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeAP ssid:ssid password:password token:self.token timeout:100];
}

- (void)stopConfigWifi {
    if (!self.isSuccess) {
        [SVProgressHUD dismiss];
    }
    [ThingSmartActivator sharedInstance].delegate = nil;
    [[ThingSmartActivator sharedInstance] stopConfigWiFi];
}

- (void)activator:(ThingSmartActivator *)activator didReceiveDevice:(ThingSmartDeviceModel *)deviceModel error:(NSError *)error {
    if (deviceModel && error == nil) {
        NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"Successfully Added", @"") ,name]];
        self.isSuccess = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
}

@end
