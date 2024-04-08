//
//  SIGMeshTableViewController.m
//  TuyaAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "SIGMeshTableViewController.h"
#import <ThingSmartBLEMeshKit/ThingSmartBLEMeshKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>

#import "CacheManager.h"

@interface SIGMeshTableViewController ()<ThingSmartSIGMeshManagerDelegate>

@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, strong) NSMutableArray<ThingSmartSIGMeshDiscoverDeviceInfo *> *dataSource;

@end

@implementation SIGMeshTableViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopScan];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"SIGMeshCellID"];
}

- (void)stopScan{
    if (!self.isSuccess) {
        [SVProgressHUD dismiss];
    }
    [ThingSmartSIGMeshManager.sharedInstance stopActiveDevice];
    [ThingSmartSIGMeshManager.sharedInstance stopSerachDevice];
    ThingSmartSIGMeshManager.sharedInstance.delegate = nil;
}

- (IBAction)searchClicked:(id)sender {
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingSmartBleMeshModel *model = [ThingLightingProject projectWithProjectId:projectId].sigMeshModel;
    
    if (model == nil) {
        [SVProgressHUD show];
        [ThingSmartBleMesh createSIGMeshWithHomeId:projectId success:^(ThingSmartBleMeshModel * _Nonnull meshModel) {
            [SVProgressHUD dismiss];
            [ThingSmartSIGMeshManager.sharedInstance startScanWithScanType:ScanForUnprovision meshModel:meshModel];
            ThingSmartSIGMeshManager.sharedInstance.delegate = self;
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
        return;
    }
    
    [ThingSmartSIGMeshManager.sharedInstance startScanWithScanType:ScanForUnprovision meshModel:model];
    ThingSmartSIGMeshManager.sharedInstance.delegate = self;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SIGMeshCellID" forIndexPath:indexPath];
    ThingSmartSIGMeshDiscoverDeviceInfo *info = self.dataSource[indexPath.row];
    cell.textLabel.text = info.mac;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingSmartBleMeshModel *model = [ThingLightingProject projectWithProjectId:projectId].sigMeshModel;
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Configuring", @"")];
    [ThingSmartSIGMeshManager.sharedInstance startActive:self.dataSource meshModel:model];
}

#pragma mark - ThingSmartSIGMeshManagerDelegate

- (void)sigMeshManager:(ThingSmartSIGMeshManager *)manager didScanedDevice:(ThingSmartSIGMeshDiscoverDeviceInfo *)device{
    [self.dataSource addObject:device];
    [self.tableView reloadData];
}

- (void)sigMeshManager:(ThingSmartSIGMeshManager *)manager didActiveSubDevice:(ThingSmartSIGMeshDiscoverDeviceInfo *)device devId:(NSString *)devId error:(NSError *)error{
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingSmartBleMeshModel *model = [ThingLightingProject projectWithProjectId:projectId].sigMeshModel;
    [ThingSmartSIGMeshManager.sharedInstance startScanWithScanType:ScanForProxyed meshModel:model];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Configuring", @"")];
        self.isSuccess = YES;
        NSString *name = device.mac ?: NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"Successfully Added", @"") ,name]];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)sigMeshManager:(ThingSmartSIGMeshManager *)manager didFailToActiveDevice:(ThingSmartSIGMeshDiscoverDeviceInfo *)device error:(NSError *)error{
    [SVProgressHUD showErrorWithStatus:error.localizedDescription ?: NSLocalizedString(@"Failed to configuration", "")];
}

@end
