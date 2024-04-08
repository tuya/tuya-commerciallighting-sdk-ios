//
//  DeviceOrGroupTableViewController.m
//  TuyaLightingTempDemo
//
//  Created by LingChen on 2024/1/26.
//

#import "DeviceOrGroupTableViewController.h"
#import "DeviceListViewController.h"
#import "PackedGroupListViewController.h"

@interface DeviceOrGroupTableViewController ()

@end

@implementation DeviceOrGroupTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:DeviceListViewController.class]) {
        ((DeviceListViewController *)vc).areaId = self.areaId;
    } else {
        ((PackedGroupListViewController *)vc).areaId = self.areaId;
    }
}

@end
