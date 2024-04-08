//
//  TYCacheManager.h
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYCacheManager : NSObject

+ (TYCacheManager *)sharedInstance;

@property (nonatomic, assign) long long projectId;

@end

NS_ASSUME_NONNULL_END
