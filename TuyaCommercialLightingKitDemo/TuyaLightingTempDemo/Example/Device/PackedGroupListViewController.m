//
//  TYPackedGroupListViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "PackedGroupListViewController.h"
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
//#import <ThingSmartBizCore/ThingSmartBizCore.h>
//#import <TYModuleServices/TYPanelProtocol.h>

#import "CreatePackedGroupViewController.h"
#import "CacheManager.h"

@interface PackedGroupListViewController ()<UITableViewDelegate, UITableViewDataSource, ThingLightingProjectDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingSmartPackedGroupModel *> *dataArray;
@property(nonatomic, strong) ThingLightingProject *project;

@end

@implementation PackedGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long long projectId = CacheManager.sharedInstance.projectId;
    self.project = [[ThingLightingProject alloc] initWithProjectId:projectId];
    self.project.delegate = self;
    
    
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [rightButton setTitle:NSLocalizedString(@"create_group", nil) forState:UIControlStateNormal];
//    rightButton.frame = CGRectMake(0 , 0, 44, 44);
//    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    self.navigationController.visibleViewController.navigationItem.rightBarButtonItem = rightItem;
    
    [self loadData];
}

- (void)loadData {
    long long projectId = CacheManager.sharedInstance.projectId;
    [SVProgressHUD show];
   
    [ThingSmartPackedGroupManager getPackedGroupListWithProjectId:projectId
                                                          areaId:self.areaId
                                                           limit:20
                                                       offsetKey:@""
                                                         success:^(NSArray<ThingSmartPackedGroupModel *> * _Nonnull groups, NSString * _Nonnull nextOffsetKey, NSInteger total, BOOL end) {
        [SVProgressHUD dismiss];
        
        self.dataArray = groups;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
    }];
}

- (void)switchGroupWithGroupId:(NSString *)groupId andIsTurnON:(BOOL)on {
    
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingSmartPackedGroup *group = [ThingSmartPackedGroup groupWithGroupId:groupId projectId:projectId];
    [group getPackedGroupInfoWithSuccess:^{
        [group publishSwitchStatus:on success:NULL failure:NULL];
    } failure:NULL];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CreatePackedGroupViewController *vc = (CreatePackedGroupViewController *)((UINavigationController *)segue.destinationViewController).topViewController;
    vc.areaId = self.areaId;
}


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
                                                   handler:NULL];
    
    NSString *groupId = self.dataArray[indexPath.row].groupPackageId;
    UIAlertAction *onAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"on", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        
        [self switchGroupWithGroupId:groupId andIsTurnON:YES];
        
    }];
    
    UIAlertAction *offAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"off", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
        [self switchGroupWithGroupId:groupId andIsTurnON:NO];
       
    }];

    [alertCon addAction:cancel];
    [alertCon addAction:onAction];
    [alertCon addAction:offAction];
    
    [self presentViewController:alertCon animated:YES completion:nil];
}



#pragma mark - ThingLightingProjectDelegate

- (void)project:(ThingLightingProject *)project didAddPackedGroup:(ThingSmartPackedGroupModel *)packedGroup {
    [self loadData];
}

- (void)project:(ThingLightingProject *)project didRemovePackedGroup:(NSString *)packedGroupId {
    [self loadData];
}

- (void)project:(ThingLightingProject *)project packedGroupInfoUpdate:(ThingSmartPackedGroupModel *)group {
    [self loadData];
}

@end
