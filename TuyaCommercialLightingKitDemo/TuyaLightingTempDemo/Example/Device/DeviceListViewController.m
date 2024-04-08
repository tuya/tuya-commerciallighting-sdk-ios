//
//  TYDeviceListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "DeviceListViewController.h"
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ThingSmartBizCore/ThingSmartBizCore.h>
#import <ThingModuleServices/ThingPanelProtocol.h>
#import <ThingActivatorPlugAPI/ThingActivatorPlugAPI.h>
#import <ThingSmartBizCore/ThingSmartBizCore.h>

#import "CacheManager.h"

@interface DeviceListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingSmartDeviceModel *> *dataArray;

@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingLightingArea *area = [[ThingLightingArea alloc] initWithAreaId:self.areaId projectId:projectId];
    
    [SVProgressHUD show];
    [area getDeviceListWithOffsetKey:@"1"
                                 tag:@""
                             success:^(NSArray<ThingSmartDeviceModel *> * _Nonnull devices, NSString * _Nonnull nextOffsetKey, BOOL end, NSUInteger total) {
        [SVProgressHUD dismiss];
        self.dataArray = devices;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.navigationItem.hidesBackButton = NO;
}

- (IBAction)addDeviceButtonAction:(id)sender {
    id<ThingActivatorProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(ThingActivatorProtocol)];
    [impl goActivatorRootViewWithConfig:nil];

    [impl activatorCompletion:ThingActivatorCompletionNodeNormal customJump:NO completionBlock:^(NSArray * _Nullable deviceList) {
        NSLog(@"deviceList: %@",deviceList);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row].name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: wmy 这里需要看下场景的数据是否进来了
    ThingSmartDeviceModel *deviceModel = self.dataArray[indexPath.row];
    id<ThingPanelProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(ThingPanelProtocol)];
    [impl gotoPanelViewControllerWithDevice:deviceModel group:nil
                               initialProps:nil
                               contextProps:nil
                            pushUntilLoaded:YES
                            waitAtLeastTime:0.2
                             maxLoadingTime:0.5];
}

@end
