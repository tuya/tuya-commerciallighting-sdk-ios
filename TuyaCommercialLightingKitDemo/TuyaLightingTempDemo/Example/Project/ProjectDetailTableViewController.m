//
//  ProjectDetailTableViewController.m
//  TuyaLightingTempDemo
//
//  Created by LingChen on 2024/1/19.
//

#import "ProjectDetailTableViewController.h"

@interface ProjectDetailTableViewController ()

@property (nonatomic, strong) IBOutlet UILabel *projectTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *projectNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *leaderNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *leaderMobileLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailAddressLabel;
@property (nonatomic, strong) IBOutlet UILabel *projectMeshLabel;

@end

@implementation ProjectDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.projectTypeLabel.text = self.projectModel.projectTypeName;
    self.projectNameLabel.text = self.projectModel.name;
    self.leaderNameLabel.text = self.projectModel.leaderName;
    self.leaderMobileLabel.text = self.projectModel.leaderMobile;
    self.detailAddressLabel.text = self.projectModel.detail;
    
    switch (self.projectModel.networkType) {
        case ThingLightingProjectMeshModeNone:
            self.projectMeshLabel.text = @"";
            break;
        case ThingLightingProjectMeshModeSingle:
            self.projectMeshLabel.text = NSLocalizedString(@"single_mesh", nil);
            break;
        case ThingLightingProjectMeshModeMulti:
            self.projectMeshLabel.text = NSLocalizedString(@"multi-mesh", nil);
            break;
        default:
            break;
    }
    
}


@end
