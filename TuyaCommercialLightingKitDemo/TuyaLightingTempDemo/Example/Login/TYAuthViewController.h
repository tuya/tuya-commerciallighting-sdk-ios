//
//  TYAuthViewController.h
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYAuthType) {
    TYAuthForgetPassword,
    TYAuthLogin
};

NS_ASSUME_NONNULL_BEGIN

@interface TYAuthViewController : UIViewController

/// 验证码类型，默认忘记密码
@property(nonatomic, assign) TYAuthType type;

@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *countryCode;

@end

NS_ASSUME_NONNULL_END
