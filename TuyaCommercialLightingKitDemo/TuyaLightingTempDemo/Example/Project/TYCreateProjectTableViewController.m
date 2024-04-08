//
//  TYCreateProjectTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYCreateProjectTableViewController.h"
#import <Masonry/Masonry.h>
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface TYCreateProjectTableViewController ()

@property (nonatomic, strong) IBOutlet UITextField *projectNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *leaderNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *leaderMobileTextField;
@property (nonatomic, strong) IBOutlet UITextField *detailAddressTextField;
@property (nonatomic, strong) IBOutlet UITextField *regionLocationIdTextField;

@end

@implementation TYCreateProjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)rightButtonAction:(id)sender {
    
    // Create an indoor project regionLocationId can not be passed
    [SVProgressHUD show];
    [[TuyaLightingProjectManager new] createProjectWithProjectType:TuyaLightingProjectTypeIndoor
                                                       projectName:self.projectNameTextField.text
                                                        leaderName:self.leaderNameTextField.text
                                                      leaderMobile:self.leaderMobileTextField.text
                                                     detailAddress:self.detailAddressTextField.text
                                                  regionLocationId:@""
                                                           success:^(id  _Nonnull result) {
        [SVProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:NULL];
    } failure:NULL];
}


- (IBAction)leftButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
