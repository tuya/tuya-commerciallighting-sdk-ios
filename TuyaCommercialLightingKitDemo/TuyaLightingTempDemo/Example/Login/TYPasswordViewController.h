//
//  TYPasswordViewController.h
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYPasswordViewController : UIViewController


/// verification code for last controller
@property(nonatomic, strong) NSString *verificationCode;
@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *countryCode;

@end

NS_ASSUME_NONNULL_END
