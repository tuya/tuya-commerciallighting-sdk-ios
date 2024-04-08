//
//  TYProjectViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "ProjectViewController.h"
#import <Masonry/Masonry.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "ProjectDetailTableViewController.h"

#import "CacheManager.h"

@interface ProjectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray<ThingLightingProjectModel *> *dataArray;
@property(nonatomic, assign) NSInteger seleceIndex;
@property(nonatomic, strong) ThingLightingProject *project;


@end

@implementation ProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
}

- (void)loadData {
    [SVProgressHUD show];
    ThingLightingProjectManager *manager = [[ThingLightingProjectManager alloc] init];
    [manager getProjectListWithSuccess:^(NSArray<ThingLightingProjectModel *> * _Nonnull projectList) {
        [SVProgressHUD dismiss];
        self.dataArray = projectList;
        
        if (CacheManager.sharedInstance.projectId == 0) {
            self.seleceIndex = 0;
            
            long long projectId = self.dataArray.firstObject.projectId;
            CacheManager.sharedInstance.projectId = projectId;
            // ❗️Obtaining project details is required
            [SVProgressHUD show];
            self.project = [ThingLightingProject projectWithProjectId:projectId];
            [self.project getProjectDetailWithSuccess:^{
                [SVProgressHUD dismiss];
            } failure:^(NSError * _Nonnull error) {
                [SVProgressHUD dismiss];
            }];
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}


#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSString *name = self.dataArray[indexPath.row].name;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if(indexPath.row == self.seleceIndex){
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.textLabel.text = [@"✅ " stringByAppendingString:name];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = name;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.seleceIndex = indexPath.row;
    [self.tableView reloadData];
    
    long long projectId = self.dataArray[indexPath.row].projectId;
    
    CacheManager.sharedInstance.projectId = projectId;
    
    // ❗️Obtaining project details is required
    [SVProgressHUD show];
    self.project = [ThingLightingProject projectWithProjectId:projectId];
    [self.project getProjectDetailWithSuccess:^{
        [SVProgressHUD dismiss];
    } failure:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:ProjectDetailTableViewController.class]) {
        ProjectDetailTableViewController *vc = segue.destinationViewController;
        vc.projectModel = self.dataArray[self.seleceIndex];
    }
}

@end
