//
//  TYLoginViewController.m
//  TuyaLightingTempDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/) 
//

#import "TYLoginViewController.h"
#import "TYAuthViewController.h"
#import "CALayer+Common.h"
#import "AppDelegate.h"

#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <TuyaCommercialLightingKit/TuyaCommercialLightingKit.h>

@interface TYLoginViewController ()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *accountField;
@property(nonatomic, strong) UITextField *passwordField;
@property(nonatomic, strong) UITextField *countryCodeField;
@property(nonatomic, strong) UITextField *companyNameField;
@property(nonatomic, strong) UIButton *loginButton;
@property(nonatomic, strong) UISegmentedControl *segmentControl;
@property(nonatomic, strong) UIStackView *stackView;
@end

@implementation TYLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Tuya";
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeConstrans];
    [self updateLoginButton];
}

- (void)makeConstrans {
    
    UIView *backgroundView = [UIView new];
    backgroundView.backgroundColor = UIColor.whiteColor;
    [backgroundView.layer addDefaultShadow];
    [self.view addSubview:backgroundView];
    
    [backgroundView addSubview:self.stackView];
    [self.view addSubview:self.segmentControl];
    [self.stackView addArrangedSubview:self.countryCodeField];
    [self.stackView addArrangedSubview:self.companyNameField];
    [self.stackView addArrangedSubview:self.accountField];
    [self.stackView addArrangedSubview:self.passwordField];
    [self.stackView addArrangedSubview:self.loginButton];
    
    self.companyNameField.hidden = YES;
    
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20.f);
        } else {
            make.top.mas_equalTo(20.f);
        }
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo(8.f);
        make.right.mas_equalTo(-8.f);
    }];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16.f);
        make.right.mas_equalTo(-16.f);
        make.top.equalTo(self.segmentControl.mas_bottom).offset(16.f);
    }];
    
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(4.f);
        make.right.mas_equalTo(-4.f);
        make.top.mas_equalTo(4.f);
        make.bottom.mas_equalTo(-4.f);
    }];
    
    [self.countryCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(46.f);
    }];
    
    [self.companyNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.countryCodeField);
    }];
    
    [self.accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.countryCodeField);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.countryCodeField);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.countryCodeField);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - getter
- (UITextField *)accountField {
    if (!_accountField) {
        _accountField = [UITextField new];
        _accountField.borderStyle = UITextBorderStyleRoundedRect;
        _accountField.placeholder = @"Please enter account(email/phone)";
        _accountField.backgroundColor = UIColor.whiteColor;
        _accountField.font = [UIFont systemFontOfSize:14.f];
        _accountField.text = @"";
        [_accountField addTarget:self action:@selector(updateLoginButton) forControlEvents: UIControlEventEditingChanged];
    }
    return _accountField;
}

- (UITextField *)passwordField {
    if (!_passwordField) {
        _passwordField = [UITextField new];
        _passwordField.placeholder = @"Please enter password";
        _passwordField.secureTextEntry = YES;
        _passwordField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordField.backgroundColor = UIColor.whiteColor;
        _passwordField.font = [UIFont systemFontOfSize:14.f];
        _passwordField.text = @"";
        [_passwordField addTarget:self action:@selector(updateLoginButton) forControlEvents: UIControlEventEditingChanged];

    }
    return _passwordField;
}

- (UITextField *)countryCodeField {
    if (!_countryCodeField) {
        _countryCodeField = [UITextField new];
        _countryCodeField.placeholder = @"Please enter countryCode";
        _countryCodeField.keyboardType = UIKeyboardTypeNumberPad;
        _countryCodeField.borderStyle = UITextBorderStyleRoundedRect;
        _countryCodeField.text = @"86";
        _countryCodeField.font = [UIFont systemFontOfSize:14.f];
        [_countryCodeField addTarget:self action:@selector(updateLoginButton) forControlEvents: UIControlEventEditingChanged];

    }
    return _countryCodeField;
}

- (UITextField *)companyNameField {
    if (!_companyNameField) {
        _companyNameField = [UITextField new];
        _companyNameField.borderStyle = UITextBorderStyleRoundedRect;
        _companyNameField.placeholder = @"Please enter company name";
        _companyNameField.font = [UIFont systemFontOfSize:14.f];
        [_companyNameField addTarget:self action:@selector(updateLoginButton) forControlEvents: UIControlEventEditingChanged];
    }
    return _companyNameField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"Login" forState: UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor orangeColor];
        [_loginButton setTitleColor:UIColor.whiteColor forState: UIControlStateNormal];
        _loginButton.layer.cornerRadius = 8.f;
        [_loginButton addTarget:self action:@selector(loginSender) forControlEvents: UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UISegmentedControl *)segmentControl {
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:@[
            NSLocalizedString(@"password_login", nil),
            @"CAPTCHA",
            @"Register",
            @"Forget"
        ]];
        _segmentControl.selectedSegmentIndex = 0;
        [_segmentControl addTarget:self action:@selector(segmentValueChange:) forControlEvents: UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [UIStackView new];
        _stackView.axis = UILayoutConstraintAxisVertical;
        _stackView.spacing = 16.f;
        _stackView.distribution = UIStackViewDistributionFillProportionally;
    }
    return _stackView;
}

#pragma mark - Login
- (BOOL)validateButtonEnable {
    
    if (!self.countryCodeField.text || [self.countryCodeField.text length] < 1) {
        return NO;
    }
    
    if (!self.accountField.text || [self.accountField.text length] < 1) {
        return NO;
    }
    
    if ((!self.passwordField.text || [self.passwordField.text length] < 1) && self.segmentControl.selectedSegmentIndex == 0) {
        return NO;
    }
    
    if ((!self.companyNameField.text || [self.companyNameField.text length] < 1) && self.segmentControl.selectedSegmentIndex == 2) {
        return NO;
    }
    
    return YES;
}

- (void)updateLoginButton {
    BOOL enabled = [self validateButtonEnable];
    self.loginButton.enabled = enabled;
    self.loginButton.alpha = enabled ? 1.f : 0.5f;
}

#pragma mark - button sender
- (void)loginSender {
    
    if (self.segmentControl.selectedSegmentIndex == 0) {
        
        [SVProgressHUD showWithStatus:@"Login..."];
        
        [[TuyaSmartUser sharedInstance] loginMerchantByPassword:self.passwordField.text
                                                    countryCode:self.countryCodeField.text
                                                       username:self.accountField.text
                                                   merchantCode:nil
                                           multiMerchantHanlder:NULL
                                                        success:^{

            [SVProgressHUD showSuccessWithStatus:@"Login Success"];
            


            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:NSBundle.mainBundle];
            AppDelegate *delelgate = (AppDelegate *)UIApplication.sharedApplication.delegate;
            delelgate.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
            
            
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [SVProgressHUD showErrorWithStatus:error.localizedFailureReason];
            
        }];
        
    } else {
        
        TYAuthViewController *authController = [TYAuthViewController new];
        authController.type = self.segmentControl.selectedSegmentIndex == 0 ? TYAuthLogin : TYAuthForgetPassword;
        [self.navigationController pushViewController:authController animated:YES];
    }
}


- (void)segmentValueChange:(UISegmentedControl *)seg {
    
    
    BOOL isPassword = seg.selectedSegmentIndex == 0;
    self.passwordField.hidden = !isPassword;
    NSString *title = isPassword ? @"Login" : @"Next";
    [self.loginButton setTitle:title forState: UIControlStateNormal];
    BOOL isRegister = seg.selectedSegmentIndex == 2;
    self.companyNameField.hidden = !isRegister;
    [self updateLoginButton];
}

#pragma mark - Reset password come back
- (void)resetWithAccount:(NSString *)acccount password:(NSString *)password {
    self.accountField.text = acccount;
    self.passwordField.text = password;
    self.segmentControl.selectedSegmentIndex = 0;
}

@end
