//
//  TYTicketLoginViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TicketLoginViewController.h"
#import "AppDelegate.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <ThingSmartUserToBKit/ThingSmartUserToBKit.h>

@interface TicketLoginViewController ()

@end

@implementation TicketLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)logintAction:(id)sender {
    [SVProgressHUD showWithStatus:@"Login..."];
    
    [ThingSmartUser.sharedInstance loginMerchantByTicket:@"" multiMerchantHanlder:^(NSArray<ThingSmartMerchantModel *> * _Nonnull merchantInfos) {
        
    } success:^{
        [SVProgressHUD showSuccessWithStatus:@"Login Success"];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        AppDelegate *delelgate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        delelgate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
}


@end
