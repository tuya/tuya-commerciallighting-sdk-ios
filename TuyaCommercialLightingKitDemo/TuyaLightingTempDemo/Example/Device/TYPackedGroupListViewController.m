//
//  TYPackedGroupListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYPackedGroupListViewController.h"
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
//#import <TuyaSmartBizCore/TuyaSmartBizCore.h>
//#import <TYModuleServices/TYPanelProtocol.h>

#import "TYCreatePackedGroupViewController.h"
#import "TYCacheManager.h"

@interface TYPackedGroupListViewController ()<UITableViewDelegate, UITableViewDataSource, TuyaLightingProjectDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<TuyaSmartPackedGroupModel *> *dataArray;
@property(nonatomic, strong) TuyaLightingProject *project;

@end

@implementation TYPackedGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long long projectId = TYCacheManager.sharedInstance.projectId;
    self.project = [[TuyaLightingProject alloc] initWithProjectId:projectId];
    self.project.delegate = self;
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:NSLocalizedString(@"create_group", nil) forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0 , 0, 44, 44);
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationController.visibleViewController.navigationItem.rightBarButtonItem = rightItem;
    
    [self loadData];
}

- (void)loadData {
    long long projectId = TYCacheManager.sharedInstance.projectId;
    [SVProgressHUD show];
   
    [TuyaSmartPackedGroupManager getPackedGroupListWithProjectId:projectId
                                                          areaId:self.areaId
                                                           limit:20
                                                       offsetKey:@""
                                                         success:^(NSArray<TuyaSmartPackedGroupModel *> * _Nonnull groups, NSString * _Nonnull nextOffsetKey, NSInteger total, BOOL end) {
        [SVProgressHUD dismiss];
        
        self.dataArray = groups;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
}

- (void)rightButtonAction:(id)sender {
    UINavigationController *nav = [self.storyboard instantiateViewControllerWithIdentifier:@"TYCreatePackedGroupNav"];
    TYCreatePackedGroupViewController *vc = (TYCreatePackedGroupViewController *)nav.topViewController;
    vc.areaId = self.areaId;
    [self presentViewController:nav animated:YES completion:NULL];
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    TYCreatePackedGroupViewController *vc = (TYCreatePackedGroupViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
//    vc.areaId = self.areaId;
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row].name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}


- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"control", nil)
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil)
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
        
        
        
    }];
    UIAlertAction *onAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"on", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        
        long long projectId = TYCacheManager.sharedInstance.projectId;
        TuyaSmartPackedGroup *group = [TuyaSmartPackedGroup groupWithGroupId:self.dataArray[indexPath.row].groupPackageId projectId:projectId];
        [group publishSwitchStatus:YES success:NULL failure:NULL];
        
    }];
    
    UIAlertAction *offAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"off", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        long long projectId = TYCacheManager.sharedInstance.projectId;
        TuyaSmartPackedGroup *group = [TuyaSmartPackedGroup groupWithGroupId:self.dataArray[indexPath.row].groupPackageId projectId:projectId];
        [group publishSwitchStatus:NO success:NULL failure:NULL];
       
    }];

    [alertCon addAction:cancel];
    [alertCon addAction:onAction];
    [alertCon addAction:offAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}

#pragma mark - TuyaLightingProjectDelegate

- (void)project:(TuyaLightingProject *)project didAddPackedGroup:(TuyaSmartPackedGroupModel *)packedGroup {
    [self loadData];
}

- (void)project:(TuyaLightingProject *)project didRemovePackedGroup:(NSString *)packedGroupId {
    [self loadData];
}

- (void)project:(TuyaLightingProject *)project packedGroupInfoUpdate:(TuyaSmartPackedGroupModel *)group {
    [self loadData];
}

@end
