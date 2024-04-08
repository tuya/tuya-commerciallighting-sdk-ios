//
//  TYCreatePackedGroupViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "CreatePackedGroupViewController.h"
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import "CacheManager.h"

@interface CreatePackedGroupViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingSmartDeviceModel *> *dataArray;
@property (nonatomic, strong) NSMutableArray<NSString *> *selectDevices;

@end

@implementation CreatePackedGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    long long projectId = CacheManager.sharedInstance.projectId;
    ThingSmartPackedGroup *group = [[ThingSmartPackedGroup alloc] initWithGroupId:@"" projectId:projectId];
    self.selectDevices = [NSMutableArray array];
    
    [SVProgressHUD show];
    [group getAvailableDevices2JoinPackedGroupWithAreaId:self.areaId
                                             topCategory:ThingSmartTopCategoryZM
                                                   limit:20
                                               offsetKey:@"1"
                                                 success:^(NSArray<ThingSmartDeviceModel *> * _Nonnull devices, NSString * _Nonnull nextOffsetKey, BOOL end) {
        [SVProgressHUD dismiss];
        
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"checked == %@", @YES];
        NSArray<ThingSmartDeviceModel *> *targetArray = [devices filteredArrayUsingPredicate:pre];
        [self.selectDevices addObjectsFromArray:[targetArray valueForKeyPath:@"devId"]];
        
        self.dataArray = devices;
        [self.tableView reloadData];
        
    } failure:NULL];
    
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:NSLocalizedString(@"submit", nil) forState:UIControlStateNormal];
    rightButton.frame = CGRectMake(0 , 0, 44, 44);
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationController.visibleViewController.navigationItem.rightBarButtonItem = rightItem;

}

- (void)rightButtonAction:(id)sender {
    
    
    NSString *title = NSLocalizedString(@"group_name", nil);
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"cancel", nil) style:UIAlertActionStyleCancel

    handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addTextFieldWithConfigurationHandler:NULL];
    
    
    UIAlertAction *confirmAction =[UIAlertAction actionWithTitle:NSLocalizedString(@"Done", nil)
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
        
        [SVProgressHUD show];
        long long projectId = CacheManager.sharedInstance.projectId;
        [ThingSmartPackedGroupManager createPackedGroupWithProjectId:projectId
                                                             areaId:self.areaId
                                                      groupPackName:alertC.textFields.firstObject.text
                                                         addDevices:self.selectDevices
                                                        topCategory:ThingSmartTopCategoryZM 
                                                             success:^(ThingSmartPackedGroupModel * _Nonnull groupModel, NSArray<NSString *> * _Nonnull successDevIds, NSDictionary<NSString *,NSNumber *> * _Nonnull failedInfos) {
            [SVProgressHUD dismiss];
            [self dismissViewControllerAnimated:YES completion:NULL];
        } failure:^(NSError *error) {
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
        }];
        
    }];
    
    [alertC addAction:cancelAction];
    [alertC addAction:confirmAction];
    [self presentViewController:alertC animated:YES completion:nil];
   
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ThingSmartDeviceModel *model = self.dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    cell.accessoryType = [self.selectDevices containsObject:model.devId] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ThingSmartDeviceModel *model = self.dataArray[indexPath.row];
    
    if (model.isOnline) {
        if ([self.selectDevices containsObject:model.devId]) {
            [self.selectDevices removeObject:model.devId];
        } else {
            [self.selectDevices addObject:model.devId];
        }
        [self.tableView reloadData];
    } else {
        
        UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"device_offline", nil)
                                                                          message:nil
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            
        UIAlertAction *confrim = [UIAlertAction actionWithTitle:NSLocalizedString(@"confrim", nil)
                                                         style:UIAlertActionStyleDefault
                                                       handler:NULL];
        

        [alertCon addAction:confrim];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
}

@end
