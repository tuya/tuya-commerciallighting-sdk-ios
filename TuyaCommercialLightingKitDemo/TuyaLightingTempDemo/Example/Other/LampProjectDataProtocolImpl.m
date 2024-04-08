//
//  LampProjectDataProtocolImpl.m
//  TuyaLightingTempDemo
//
//  Created by APPLE on 2024/1/10.
//

#import "LampProjectDataProtocolImpl.h"
#import <ThingCommercialLightingKit/ThingCommercialLightingKit.h>
#import "CacheManager.h"

@implementation LampProjectDataProtocolImpl

- (void)clearCurrentProject {
    NSLog(@"");
}

- (ThingLightingProject *)getCurrentProject {
    long long projectId = CacheManager.sharedInstance.projectId;
    return [ThingLightingProject projectWithProjectId:projectId];
}

- (void)updateCurrentProjectId:(NSInteger)projectId {
    CacheManager.sharedInstance.projectId = projectId;
}

/// 获取当前项目 ID
- (NSInteger)currentProjectId {
    return CacheManager.sharedInstance.projectId;
}

/// 返回当前空间 Id
- (NSInteger)currentAreaId {
    return CacheManager.sharedInstance.areaId;
}

/// 切换空间后，调用该接口以更新当前空间 Id。
- (void)setCurrentAreaId:(NSInteger)areaId {
    CacheManager.sharedInstance.areaId = areaId;
}

/// 切换至根空间。（根空间对应于未分区，其空间的 gId 与项目的 projectId 相同。）
- (void)resetCurrentAreaId {
    CacheManager.sharedInstance.areaId = 0;
}

/// 返回当前空间 Model
- (ThingLightingAreaModel *)currentArea {
    return [ThingLightingArea areaWithAreaId:[self currentAreaId] projectId:[self currentProjectId]].areaModel;
}

/// 返回当前空间 gId
- (NSInteger)currentGId {
    if (self.currentAreaId) {
        return self.currentArea.gId;
    }
    return CacheManager.sharedInstance.projectId;
}

@end
