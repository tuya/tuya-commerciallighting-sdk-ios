//
//  CreateProjectTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "CreateProjectTableViewController.h"
#import <Masonry/Masonry.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CreateProjectTableViewController ()

@property (nonatomic, strong) IBOutlet UITextField *projectNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *leaderNameTextField;
@property (nonatomic, strong) IBOutlet UITextField *leaderMobileTextField;
@property (nonatomic, strong) IBOutlet UITextField *detailAddressTextField;
@property (nonatomic, strong) IBOutlet UITextField *regionLocationIdTextField;

@property (nonatomic, assign) ThingLightingProjectMeshMode meshMode;

@end

@implementation CreateProjectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (IBAction)rightButtonAction:(id)sender {
    
    if (self.meshMode == ThingLightingProjectMeshModeNone ||
        self.projectNameTextField.text.length == 0 ||
        self.leaderNameTextField.text.length == 0 ||
        self.leaderMobileTextField.text.length == 0 ||
        self.detailAddressTextField.text.length == 0) {
        return;
    }
    
//    ThingLightingProjectType projectType = self.configModel.projectType;
//    // 用户选择的 mesh 模式
//    ThingLightingProjectMeshMode selectMeshMode = [self.infoData[0][@"meshMode"] integerValue];
//    ThingLightingProjectMeshMode meshMode = ThingLightingProjectMeshModeSingle;
//    if ([self isMeshModeSwitchable]) {
//        meshMode = selectMeshMode;
//    } else if (self.configModel.projectType == ThingLightingProjectTypePark) {
//        // 停车场项目默认是多 mesh 项目
//        meshMode = ThingLightingProjectMeshModeMulti;
//    }
    
    [SVProgressHUD show];
    [[ThingLightingProjectManager new] createProjectWithProjectType:ThingLightingProjectTypeIndoor
                                                        networkType:self.meshMode
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

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:cell.textLabel.text
                                                                    message:nil
                                                             preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) 
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    
    UIAlertAction *singleMeshAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"single_mesh", nil)
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
        self.meshMode = ThingLightingProjectMeshModeSingle;
    }];
    
    UIAlertAction *multiMeshAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"multi-mesh", nil)
                                                               style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        self.meshMode = ThingLightingProjectMeshModeMulti;
    }];
    
    [alertC addAction:singleMeshAction];
    [alertC addAction:multiMeshAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

@end
