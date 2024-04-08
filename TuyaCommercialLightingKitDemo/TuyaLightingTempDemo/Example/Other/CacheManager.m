//
//  TYCacheManager.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)
//

#import "CacheManager.h"
//#import <ThingSmartBizCore/ThingSmartBizCore.h>
//#import <TYBizbundleModuleService/TYBizbundleModuleService.h>
//#import <TYModuleServices/TYModuleServices.h>
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
//#import <TYLampModuleServices/TYLampModuleServices.h>

@interface CacheManager ()

@property (nonatomic, strong) NSUserDefaults *groupUserdefault;

@end

@implementation CacheManager


+ (CacheManager *)sharedInstance {
    static CacheManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
        [_sharedInstance initCurrentProject];
    });
    return _sharedInstance;
}

- (void)initCurrentProject {
    // 注册要实现的协议
//    [[ThingSmartBizCore sharedInstance] registerService:@protocol(TYLampProjectDataProtocol) withInstance:self];
}

// 实现对应的协议方法
//- (ThingSmartHome *)getCurrentHome {
//    ThingSmartHome *home = [ThingSmartHome homeWithHomeId:@"当前家庭id"];
//    return home;
//}





- (ThingLightingProject *)getCurrentProject {
//    long long projectId = [[self.groupUserdefault objectForKey:kCurrentHomeIdKey] longLongValue];
    ThingLightingProject *project = [ThingLightingProject projectWithProjectId:self.projectId];
    return project;
}

//- (void)updateCurrentProjectId:(long long)projectId {
//    if (projectId > 0) {
//        [self.groupUserdefault setObject:@(projectId) forKey:kCurrentHomeIdKey];
//        [self.groupUserdefault synchronize];
//    }
//}

- (long long)currentProjectId {
//    long long projectId = [[self.groupUserdefault objectForKey:kCurrentHomeIdKey] longLongValue];
//    return projectId;
    return self.projectId;
}

//- (void)setProjectId:(long long)projectId {
//    _projectId = projectId;
//    [self updateCurrentProjectId:projectId];
//}

@end
