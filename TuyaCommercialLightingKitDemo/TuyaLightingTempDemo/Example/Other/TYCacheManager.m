//
//  TYCacheManager.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYCacheManager.h"

@implementation TYCacheManager


+ (TYCacheManager *)sharedInstance {
    static TYCacheManager *_sharedInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc]init];
    });
    return _sharedInstance;
}

@end
