//
//  TYDeviceListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYDeviceListViewController.h"
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
//#import <TuyaSmartBizCore/TuyaSmartBizCore.h>
//#import <TYModuleServices/TYPanelProtocol.h>

#import "TYCacheManager.h"

@interface TYDeviceListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<TuyaSmartDeviceModel *> *dataArray;

@end

@implementation TYDeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long long projectId = TYCacheManager.sharedInstance.projectId;
    TuyaLightingArea *area = [[TuyaLightingArea alloc] initWithAreaId:self.areaId projectId:projectId];
    
    [SVProgressHUD show];
    [area getDeviceListWithOffsetKey:@"1"
                                 tag:@""
                             success:^(NSArray<TuyaSmartDeviceModel *> * _Nonnull devices, NSString * _Nonnull nextOffsetKey, BOOL end, NSUInteger total) {
        [SVProgressHUD dismiss];
        self.dataArray = devices;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
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
    
}

@end
