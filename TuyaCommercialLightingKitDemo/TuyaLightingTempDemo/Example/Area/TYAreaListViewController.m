//
//  TYAreaListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYAreaListViewController.h"
#import <Masonry/Masonry.h>
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <libextobjc/EXTScope.h>

#import "TYCacheManager.h"
#import "TYSubAreaListViewController.h"
#import "TYDeviceListViewController.h"
#import "TYPackedGroupListViewController.h"

@interface TYAreaListViewController ()<UITableViewDelegate, UITableViewDataSource, TuyaLightingProjectDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<TuyaLightingAreaModel *> *dataArray;
@property(nonatomic, strong) TuyaLightingProject *project;

@end

@implementation TYAreaListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.project.model.projectId != TYCacheManager.sharedInstance.projectId) {
        [self loadData];
    }
}

- (void)loadData {
    if (TYCacheManager.sharedInstance.projectId == 0) {
        return;
    }
    
    long long projectId = TYCacheManager.sharedInstance.projectId;
    
    if (!projectId) {
        return;
    }
    
    [SVProgressHUD show];
    
    self.project = [[TuyaLightingProject alloc] initWithProjectId:projectId];
    self.project.delegate = self;
    
    @weakify(self);
    [self.project getAreaListWithSuccess:^(NSArray<TuyaLightingAreaModel *> * _Nonnull areas) {
        @strongify(self);
        [SVProgressHUD dismiss];
        self.dataArray = areas;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    TuyaLightingAreaModel *areaModel = self.dataArray[indexPath.row];
    cell.textLabel.text = areaModel.name;
    cell.accessoryType = areaModel.roomSource == TuyaLightingAreaTypeUnZoned ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"control", nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel handler:NULL];
    UIAlertAction *onAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"on", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        long long projectId = TYCacheManager.sharedInstance.projectId;
        TuyaLightingArea *area = [TuyaLightingArea areaWithAreaId:self.dataArray[indexPath.row].areaId projectId:projectId];
        [area publishSwitchStatus:YES success:NULL failure:NULL];
        
    }];
    
    UIAlertAction *offAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"off", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        long long projectId = TYCacheManager.sharedInstance.projectId;
        TuyaLightingArea *area = [TuyaLightingArea areaWithAreaId:self.dataArray[indexPath.row].areaId projectId:projectId];
        [area publishSwitchStatus:NO success:NULL failure:NULL];
       
    }];

    [alertCon addAction:cancel];
    [alertCon addAction:onAction];
    [alertCon addAction:offAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // ⚠️ nextLevelAreaCount is NSNumber
    
    TuyaLightingAreaModel *areaModel = self.dataArray[indexPath.row];
    
    if (areaModel.nextLevelAreaCount.integerValue) {
        TYSubAreaListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TYSubAreaListViewController"];
        vc.areaId = areaModel.areaId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if (areaModel.roomSource == TuyaLightingAreaTypeUnZoned) {
            TYDeviceListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TYDeviceListViewController"];
            viewController.areaId = self.dataArray[indexPath.row].areaId;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            UITabBarController *tabbarVc = [self.storyboard instantiateViewControllerWithIdentifier:@"OtherTabbarController"];
            [tabbarVc.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([obj isKindOfClass:TYDeviceListViewController.class]) {
                    ((TYDeviceListViewController *)obj).areaId = areaModel.areaId;
                } else {
                    ((TYPackedGroupListViewController *)obj).areaId = areaModel.areaId;
                }
            }];
            
            tabbarVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:tabbarVc animated:YES];
        }
    }
}

#pragma mark - TuyaLightingProjectDelegate

- (void)project:(TuyaLightingProject *)project didAddArea:(long long)areaId {
    [self loadData];
}

- (void)project:(TuyaLightingProject *)project didRemoveArea:(long long)areaId {
    [self loadData];
}

- (void)project:(TuyaLightingProject *)project areaId:(long long)areaId infoUpdate:(NSDictionary *)info {
    [self loadData];
}

@end
