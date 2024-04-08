//
//  BLEModelViewController.m
//  TuyaAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "BLEModelViewController.h"
#import <TuyaSmartBLEKit/TuyaSmartBLEKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "TYCacheManager.h"

@interface BLEModelViewController ()<TuyaSmartBLEManagerDelegate>

@property (nonatomic, assign) BOOL isSuccess;

@end

@implementation BLEModelViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)stopScan{
    TuyaSmartBLEManager.sharedInstance.delegate = nil;
    [TuyaSmartBLEManager.sharedInstance stopListening:YES];
    if (!self.isSuccess) {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)searchClicked:(id)sender {
    TuyaSmartBLEManager.sharedInstance.delegate = self;
    [TuyaSmartBLEManager.sharedInstance startListening:YES];
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Searching", @"")];
}

#pragma mark - TuyaSmartBLEManagerDelegate

- (void)didDiscoveryDeviceWithDeviceInfo:(TYBLEAdvModel *)deviceInfo{
    long long projectId = TYCacheManager.sharedInstance.projectId;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Configuring", @"")];
    [TuyaSmartBLEManager.sharedInstance activeBLE:deviceInfo homeId:projectId success:^(TuyaSmartDeviceModel * _Nonnull deviceModel) {
        self.isSuccess = YES;
        NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"Successfully Added", @"") ,name]];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^{
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to configuration", "")];
    }];
}

@end
