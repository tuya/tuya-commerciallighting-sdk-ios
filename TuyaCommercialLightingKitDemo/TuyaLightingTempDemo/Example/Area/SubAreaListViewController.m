//
//  TYSubAreaListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "SubAreaListViewController.h"
#import <Masonry/Masonry.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <ThingActivatorPlugAPI/ThingActivatorPlugAPI.h>
#import <ThingSmartBizCore/ThingSmartBizCore.h>

#import "CacheManager.h"
#import "DeviceOrGroupTableViewController.h"
#import "DeviceListViewController.h"
#import "PackedGroupListViewController.h"
#import "CreateAreaTableViewController.h"

@interface SubAreaListViewController ()<UITableViewDelegate, UITableViewDataSource, ThingLightingProjectDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingLightingAreaModel *> *dataArray;
@property(nonatomic, strong) ThingLightingProject *project;

@end

@implementation SubAreaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
            
    long long projectId = CacheManager.sharedInstance.projectId;
    self.project = [[ThingLightingProject alloc] initWithProjectId:projectId];
    self.project.delegate = self;
    [self loadData];
}

- (void)loadData {
    
    [SVProgressHUD show];
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingLightingArea *area = [[ThingLightingArea alloc] initWithAreaId:self.areaId projectId:projectId];
    [area getSubAreaListWithSuccess:^(NSArray<ThingLightingAreaModel *> * _Nonnull areas) {
        [SVProgressHUD dismiss];
        self.dataArray = areas;
        [self.tableView reloadData];
    } failure:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


- (IBAction)addDeviceButtonAction:(id)sender {
    id<ThingActivatorProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(ThingActivatorProtocol)];
    [impl goActivatorRootViewWithConfig:nil];

    [impl activatorCompletion:ThingActivatorCompletionNodeNormal customJump:NO completionBlock:^(NSArray * _Nullable deviceList) {
        NSLog(@"deviceList: %@",deviceList);
    }];
}

- (void)controlAreaWithAreaId:(long long)areaId {
    
    long long projectId = CacheManager.sharedInstance.projectId;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"action", nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:NULL];
    
    UIAlertAction *onAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"on", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:projectId];
        [area getAreaSigMeshGroupsInfoWithSuccess:^{
            [area publishSwitchStatus:YES success:NULL failure:NULL];
        } failure:^(NSError *error) {
            
        }];

    }];

    UIAlertAction *offAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"off", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:projectId];
        [area getAreaSigMeshGroupsInfoWithSuccess:^{
            [area publishSwitchStatus:NO success:NULL failure:NULL];
        } failure:^(NSError *error) {
            
        }];

    }];


    [alertCon addAction:onAction];
    [alertCon addAction:offAction];
    [alertCon addAction:cancel];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}


- (void)deleteAreaWithAreaId:(long long)areaId {
    [SVProgressHUD show];
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:projectId];
    [area deleteWithSuccess:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)createSubAreaWithAreaId:(long long)areaId {
    NSString *title = NSLocalizedString(@"name", nil);
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    
    [alertC addTextFieldWithConfigurationHandler:NULL];
    
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // Create a sub area
        long long projectId = CacheManager.sharedInstance.projectId;
        [SVProgressHUD show];
        ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:projectId];
        [area createSubAreaWithName:alertC.textFields.firstObject.text
                            success:^(ThingLightingAreaModel * _Nonnull areaModel) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
    }];
    
    [alertC addAction:cancelAction];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
   
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row].name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"action", nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:NULL];

    long long areaId = self.dataArray[indexPath.row].areaId;
    UIAlertAction *controlAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"control", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        [self controlAreaWithAreaId:areaId];
    }];
    
   
    
    UIAlertAction *createAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"create_sub_area", nil)
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self createSubAreaWithAreaId:areaId];
    }];
    
    UIAlertAction *deleteAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"delete_area", nil)
                                                          style:UIAlertActionStyleDestructive
                                                        handler:^(UIAlertAction * _Nonnull action) {
        [self deleteAreaWithAreaId:areaId];
    }];
    
    [alertCon addAction:controlAction];
    [alertCon addAction:createAction];
    [alertCon addAction:deleteAction];
    [alertCon addAction:cancel];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ThingLightingAreaModel *areaModel = self.dataArray[indexPath.row];
    
    // ⚠️ Set the current area id
    CacheManager.sharedInstance.areaId = areaModel.areaId;
    
    if (areaModel.nextLevelAreaCount.integerValue) {
        
        SubAreaListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubAreaListViewController"];
        vc.areaId = areaModel.areaId;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        DeviceOrGroupTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceOrGroup"];
        viewController.areaId = areaModel.areaId;
        viewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

#pragma mark - ThingLightingProjectDelegate

- (void)project:(ThingLightingProject *)project didAddArea:(long long)areaId {
    [self loadData];
}

- (void)project:(ThingLightingProject *)project didRemoveArea:(long long)areaId {
    [self loadData];
}

- (void)project:(ThingLightingProject *)project areaId:(long long)areaId infoUpdate:(NSDictionary *)info {
    [self loadData];
}

@end
