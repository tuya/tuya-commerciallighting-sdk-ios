//
//  TYPasswordViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYPasswordViewController.h"
#import "TYLoginViewController.h"

#import <Masonry/Masonry.h>


@interface TYPasswordViewController ()
@property(nonatomic, strong) UITextField *passwordField;
@property(nonatomic, strong) UIButton  *nextButton;
@end

@implementation TYPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Reset password";
    self.view.backgroundColor = UIColor.whiteColor;
    [self makeConstrans];
}

- (void)makeConstrans {
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.nextButton];
    self.nextButton.enabled = NO;
    self.nextButton.alpha = 0.5f;
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
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
        make.left.right.equalTo(self.passwordField);
        make.height.equalTo(self.passwordField);
        make.top.equalTo(self.passwordField.mas_bottom).offset(20.f);
    }];
    
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [UITextField new];
        _passwordField.placeholder = @"Please enter new password";
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordField.secureTextEntry = YES;
        _passwordField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordField.font = [UIFont systemFontOfSize:14.f];
        [_passwordField addTarget:self action:@selector(validateButtonEnaled) forControlEvents: UIControlEventEditingChanged];
    }
    return _passwordField;
}

- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"NEXT" forState: UIControlStateNormal];
        [_nextButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        _nextButton.backgroundColor = [UIColor orangeColor];
        _nextButton.layer.cornerRadius = 8.f;
        [_nextButton addTarget:self action:@selector(nextSender) forControlEvents: UIControlEventTouchUpInside];
    }
    return _nextButton;
}

#pragma mark - actions
- (void)nextSender {
        
//    TYLoginViewController *login = (TYLoginViewController *)self.navigationController.viewControllers.firstObject;
//    [login resetWithAccount:self.account password:self.passwordField.text];
//    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)validateButtonEnaled {
    
    BOOL isEnabled = self.passwordField.text && self.passwordField.text.length > 0;
    self.nextButton.enabled = isEnabled;
    self.nextButton.alpha = isEnabled ? 1.f : 0.5f;
    
}

@end
