//
//  TYMeTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYMeTableViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "AppDelegate.h"

@interface TYMeTableViewController ()

@property(nonatomic, strong) IBOutlet UIImageView *avatarImageView;
@property(nonatomic, strong) IBOutlet UILabel *nicknameLabel;

@end

@implementation TYMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    [[TuyaSmartUser sharedInstance] getMerchantUserInfoWithSuccess:^{
        [SVProgressHUD dismiss];
        [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:TuyaSmartUser.sharedInstance.headIconUrl]];
        self.nicknameLabel.text = TuyaSmartUser.sharedInstance.nickname;
    } failure:NULL];
}


- (IBAction)logoutAction:(id)sender {
    [SVProgressHUD show];
    [[TuyaSmartUser sharedInstance] loginOutMerchantWithSuccess:^{
        [SVProgressHUD dismiss];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
        AppDelegate *delelgate = (AppDelegate *)UIApplication.sharedApplication.delegate;
        delelgate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNav"];
    } failure:NULL];
}

@end
