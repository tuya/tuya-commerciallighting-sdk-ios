//
//  ProjectDetailTableViewController.h
//  TuyaLightingTempDemo
//
//  Created by LingChen on 2024/1/19.
//

#import <UIKit/UIKit.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ProjectDetailTableViewController : UITableViewController

@property (nonatomic, strong) ThingLightingProjectModel *projectModel;

@end

NS_ASSUME_NONNULL_END
