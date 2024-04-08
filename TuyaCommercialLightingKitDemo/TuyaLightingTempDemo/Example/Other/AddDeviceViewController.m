//
//  TYAddDeviceViewController.m
//  TuyaLightingTempDemo
//
//  Created by 凌晨 on 2021/9/27.
//

#import "AddDeviceViewController.h"
//#import <ThingSmartBizCore/ThingSmartBizCore.h>
//#import <TYModuleServices/TYModuleServices.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
//#import <TYUIKit/TYUIKit.h>
#import <ThingActivatorPlugAPI/ThingActivatorPlugAPI.h>
#import <ThingSmartBizCore/ThingSmartBizCore.h>

@interface AddDeviceViewController ()

@end

@implementation AddDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)dealloc {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        
            id<ThingActivatorProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(ThingActivatorProtocol)];
            [impl goActivatorRootViewWithConfig:nil];

                // 获取配网结果
                [impl activatorCompletion:ThingActivatorCompletionNodeNormal customJump:NO completionBlock:^(NSArray * _Nullable deviceList) {
                    NSLog(@"deviceList: %@",deviceList);
                }];
            return;
        
    }
}

- (void)transferDevicesWithAreaId:(long long)areaId devIds:(NSArray<NSString *> *)devIds {
    [SVProgressHUD show];
//    id<TYLampProjectDataProtocol> impl = [[ThingSmartBizCore sharedInstance] serviceOfProtocol:@protocol(TYLampProjectDataProtocol)];
//    ThingLightingArea *area = [ThingLightingArea areaWithAreaId:areaId projectId:impl.currentProjectId];
//    __weak __typeof(self) weakSelf = self;
//    [area transferDevicesWithDeviceIds:devIds success:^(NSArray<NSString *> * _Nonnull successDevIds, NSArray<NSString *> * _Nonnull failedDevIds) {
//        __strong __typeof(weakSelf) strongSelf = weakSelf;
//        [strongSelf.navigationController popViewControllerAnimated:YES];
//        [SVProgressHUD dismiss];
//    } failure:^(NSError *error) {
//        [SVProgressHUD dismiss];
//    }];
}


@end
