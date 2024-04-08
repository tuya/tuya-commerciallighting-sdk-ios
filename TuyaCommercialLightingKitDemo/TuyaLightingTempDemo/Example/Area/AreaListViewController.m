//
//  TYAreaListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "AreaListViewController.h"
#import <Masonry/Masonry.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <libextobjc/EXTScope.h>

#import "CacheManager.h"
#import "SubAreaListViewController.h"
#import "DeviceListViewController.h"
#import "PackedGroupListViewController.h"
#import "DeviceOrGroupTableViewController.h"

@interface AreaListViewController ()<UITableViewDelegate, UITableViewDataSource, ThingLightingProjectDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingLightingAreaModel *> *dataArray;
@property(nonatomic, strong) ThingLightingProject *project;

@end

@implementation AreaListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    
    // ⚠️Before creating an area, you need to obtain the configuration information of the area
    ThingLightingProjectManager *manager = [ThingLightingProjectManager new];
    [manager getProjectConfigListWithSuccess:NULL failure:NULL];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.project.model.projectId != CacheManager.sharedInstance.projectId) {
        [self loadData];
    }
    CacheManager.sharedInstance.areaId = 0;
}

- (void)loadData {
    if (CacheManager.sharedInstance.projectId == 0) {
        return;
    }
    
    long long projectId = CacheManager.sharedInstance.projectId;
    
    if (!projectId) {
        return;
    }
    
    [SVProgressHUD show];
    
    self.project = [[ThingLightingProject alloc] initWithProjectId:projectId];
    self.project.delegate = self;
    
    @weakify(self);
    [self.project getAreaListWithSuccess:^(NSArray<ThingLightingAreaModel *> * _Nonnull areas) {
        @strongify(self);
        [SVProgressHUD dismiss];
        self.dataArray = areas;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.description];
    }];
}


- (IBAction)addDeviceButtonAction:(id)sender {
    NSString *title = NSLocalizedString(@"create_area", nil);
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    
    [alertC addTextFieldWithConfigurationHandler:NULL];
    
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"confirm", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        // Create a area
        long long projectId = CacheManager.sharedInstance.projectId;
        ThingLightingProjectManager *manager = [[ThingLightingProjectManager alloc] init];
        NSArray<ThingLightingProjectSpaceItemModel *> *attributes = [manager getSpaceAttributesWithProjectId:projectId];
        [SVProgressHUD show];
        [ThingLightingAreaManager createAreaWithProjectId:projectId
                                            currentAreaId:0
                                                     name:alertC.textFields.firstObject.text
                                                roomLevel:attributes.firstObject.roomLevel
                                                  success:^(id result) {
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
        } failure:NULL];

    }];

    UIAlertAction *offAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"off", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:projectId];
        [area getAreaSigMeshGroupsInfoWithSuccess:^{
            [area publishSwitchStatus:NO success:NULL failure:NULL];
        } failure:NULL];

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
    ThingLightingAreaModel *areaModel = self.dataArray[indexPath.row];
    cell.textLabel.text = areaModel.name;
    cell.accessoryType = areaModel.roomSource == ThingLightingAreaTypeUnZoned ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDetailDisclosureButton;
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
    // ⚠️ nextLevelAreaCount is NSNumber
    ThingLightingAreaModel *areaModel = self.dataArray[indexPath.row];
    
    // ⚠️ Set the current area id
    CacheManager.sharedInstance.areaId = areaModel.areaId;
    
    if (areaModel.nextLevelAreaCount.integerValue) {
        
        SubAreaListViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SubAreaListViewController"];
        vc.areaId = areaModel.areaId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
        if (areaModel.roomSource == ThingLightingAreaTypeUnZoned) {
            DeviceListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TYDeviceListViewController"];
            viewController.areaId = self.dataArray[indexPath.row].areaId;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        } else {
            DeviceOrGroupTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"DeviceOrGroup"];
            viewController.areaId = areaModel.areaId;
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
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
