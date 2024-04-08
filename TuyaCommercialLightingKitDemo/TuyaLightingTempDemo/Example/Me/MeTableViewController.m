//
//  MeTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "MeTableViewController.h"
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ThingSmartUserToBKit/ThingSmartUserToBKit.h>

#import "AppDelegate.h"

@interface MeTableViewController ()

@property(nonatomic, strong) IBOutlet UILabel *nicknameLabel;
@property(nonatomic, strong) IBOutlet UILabel *adminNameLabel;
@property(nonatomic, strong) IBOutlet UILabel *emailLabel;

@end

@implementation MeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    [[ThingSmartUser sharedInstance] getMerchantUserInfoWithSuccess:^{
        [SVProgressHUD dismiss];
        self.nicknameLabel.text = ThingSmartUser.sharedInstance.nickname;
        self.emailLabel.text = ThingSmartUser.sharedInstance.email;
    } failure:NULL];
}


- (IBAction)logoutAction:(id)sender {
    [SVProgressHUD show];
    [[ThingSmartUser sharedInstance] loginOutMerchantWithSuccess:^{
        [SVProgressHUD dismiss];
        
        AppDelegate *delelgate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        delelgate.window.rootViewController = [UIStoryboard storyboardWithName:@"Login" bundle:NSBundle.mainBundle].instantiateInitialViewController;
    } failure:NULL];
}

@end
