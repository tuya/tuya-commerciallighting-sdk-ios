//
//  CacheManager.h
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheManager : NSObject

+ (CacheManager *)sharedInstance;

@property (nonatomic, assign) long long projectId;
@property (nonatomic, assign) long long areaId;

@end

NS_ASSUME_NONNULL_END
