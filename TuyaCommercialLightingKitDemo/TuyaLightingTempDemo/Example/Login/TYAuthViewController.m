//
//  TYAuthViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYAuthViewController.h"
#import "TYPasswordViewController.h"

#import <Masonry/Masonry.h>

@interface TYAuthViewController ()
@property(nonatomic, strong) UITextField *verificationCodeField;
@property(nonatomic, strong) UIButton *nextButton;
@end

@implementation TYAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Validate verification code";
    self.view.backgroundColor = UIColor.whiteColor;
    [self makeConstrans];
}

- (void)makeConstrans {
    [self.view addSubview:self.verificationCodeField];
    [self.view addSubview:self.nextButton];
    self.nextButton.alpha = 0.5f;
    self.nextButton.enabled = NO;
    
    [self.verificationCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.right.mas_equalTo(-16.f);
        make.height.mas_equalTo(46.f);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(32.f);
        } else {
            make.top.mas_equalTo(32.f);
        }
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.verificationCodeField);
        make.height.equalTo(self.verificationCodeField);
        make.top.equalTo(self.verificationCodeField.mas_bottom).offset(20.f);
    }];
}

- (UITextField *)verificationCodeField {
    if (!_verificationCodeField) {
        _verificationCodeField = [UITextField new];
        _verificationCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _verificationCodeField.placeholder = @"Please enter verification code(6 length)";
        _verificationCodeField.font = [UIFont systemFontOfSize:14.f];
        [_verificationCodeField addTarget:self action:@selector(didChangeForField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _verificationCodeField;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *btnTitle = @"next";
        if (self.type == TYAuthLogin) {
            btnTitle = @"Login";
        } else if (self.type == TYAuthForgetPassword) {
            btnTitle = @"next";
        }
        [_nextButton setTitle:btnTitle forState: UIControlStateNormal];
        [_nextButton setTitleColor:UIColor.whiteColor forState: UIControlStateNormal];
        _nextButton.backgroundColor = UIColor.orangeColor;
        [_nextButton addTarget:self action:@selector(nextSender) forControlEvents: UIControlEventTouchUpInside];
        _nextButton.layer.cornerRadius = 8.f;
    }
    return _nextButton;
}

- (void)nextSender {
    
    if (self.type == TYAuthLogin) {
        
    }
    
    if (self.type == TYAuthForgetPassword) {
        TYPasswordViewController *password = [TYPasswordViewController new];
        [self.navigationController pushViewController:password animated:YES];
    }
}


#pragma mark - business
- (void)didChangeForField:(UITextField *)field {
    
    if (field == self.verificationCodeField) {
        
        BOOL validatePassed = self.verificationCodeField.text.length == 6;
        self.nextButton.enabled = validatePassed;
        self.nextButton.alpha = validatePassed ? 1.0f : 0.5f;
    }
}

@end
