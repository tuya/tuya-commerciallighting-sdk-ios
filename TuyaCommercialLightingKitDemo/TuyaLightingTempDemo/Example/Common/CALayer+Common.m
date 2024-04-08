//
//  CALayer+Common.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "CALayer+Common.h"
#import <UIKit/UIKit.h>

@implementation CALayer (Common)

- (void)addDefaultShadow {
    self.cornerRadius = 10.f;
    self.shadowOpacity = 0.5f;
    self.shadowOffset = CGSizeMake(4.f, 1.f);
    self.shadowColor = UIColor.grayColor.CGColor;
    self.shadowRadius = 8.f;
}

@end
