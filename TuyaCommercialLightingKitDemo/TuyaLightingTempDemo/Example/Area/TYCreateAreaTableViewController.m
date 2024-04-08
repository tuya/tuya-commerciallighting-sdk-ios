//
//  TYCreateAreaTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYCreateAreaTableViewController.h"
#import <Masonry/Masonry.h>
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>


#import "TYCacheManager.h"

@interface TYCreateAreaTableViewController ()

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

@end

@implementation TYCreateAreaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // ⚠️Before creating an area, you need to obtain the configuration information of the area
    
    [SVProgressHUD show];
    TuyaLightingProjectManager *manager = [TuyaLightingProjectManager new];
    [manager getProjectConfigListWithSuccess:^(NSArray<TuyaLightingProjectConfigModel *> * _Nonnull configList) {
        [SVProgressHUD dismiss];
    } failure:NULL];
}

- (IBAction)rightButtonAction:(id)sender {
    
    long long projectId = TYCacheManager.sharedInstance.projectId;
    
    if (self.areaId == 0) {
        NSArray<TuyaLightingProjectSpaceItemModel *> *attributes = [[TuyaLightingProjectManager new] getSpaceAttributesWithProjectId:projectId];

        // Create a new area
        [SVProgressHUD show];
        // currentAreaId is fixed to 0, roomLevel represents the level of the new area
        [TuyaLightingAreaManager createAreaWithProjectId:projectId
                                           currentAreaId:0
                                                    name:self.nameTextField.text
                                               roomLevel:attributes.firstObject.roomLevel
                                                 success:^(id result) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:NULL];
    } else {
        // Create a new sub area
        [SVProgressHUD show];
        TuyaLightingArea *area = [[TuyaLightingArea alloc] initWithAreaId:self.areaId projectId:projectId];
        [area createSubAreaWithName:self.nameTextField.text success:^(TuyaLightingAreaModel * _Nonnull areaModel) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
    }
}


- (IBAction)leftButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
