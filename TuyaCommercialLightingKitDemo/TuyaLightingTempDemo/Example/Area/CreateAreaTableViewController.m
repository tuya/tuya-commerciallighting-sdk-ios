//
//  TYCreateAreaTableViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "CreateAreaTableViewController.h"
#import <Masonry/Masonry.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>


#import "CacheManager.h"

@interface CreateAreaTableViewController ()

@property (nonatomic, strong) IBOutlet UITextField *nameTextField;

@end

@implementation CreateAreaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // ⚠️Before creating an area, you need to obtain the configuration information of the area
    
    [SVProgressHUD show];
    ThingLightingProjectManager *manager = [ThingLightingProjectManager new];
    [manager getProjectConfigListWithSuccess:^(NSArray<ThingLightingProjectConfigModel *> * _Nonnull configList) {
        [SVProgressHUD dismiss];
    } failure:NULL];
}

- (IBAction)rightButtonAction:(id)sender {
    
    long long projectId = CacheManager.sharedInstance.projectId;
    
    if (self.areaId == 0) {
        NSArray<ThingLightingProjectSpaceItemModel *> *attributes = [[ThingLightingProjectManager new] getSpaceAttributesWithProjectId:projectId];

        // Create a new area
        [SVProgressHUD show];
        // currentAreaId is fixed to 0, roomLevel represents the level of the new area
        [ThingLightingAreaManager createAreaWithProjectId:projectId
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
        ThingLightingArea *area = [[ThingLightingArea alloc] initWithAreaId:self.areaId projectId:projectId];
        [area createSubAreaWithName:self.nameTextField.text success:^(ThingLightingAreaModel * _Nonnull areaModel) {
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
