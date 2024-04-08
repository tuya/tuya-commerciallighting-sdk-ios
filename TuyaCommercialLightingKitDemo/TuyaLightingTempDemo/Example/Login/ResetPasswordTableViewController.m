//
//  ResetPasswordTableViewController.m
//  ThingAppSDKSample-iOS-ObjC
//
//  Copyright (c) 2014-2021 Thing Inc. (https://developer.tuya.com/)

#import "ResetPasswordTableViewController.h"
#import <ThingSmartUserToBKit/ThingSmartUserToBKit.h>
#import "Alert.h"

@interface ResetPasswordTableViewController ()
@property (weak, nonatomic) IBOutlet UITextField *countryCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@end
@implementation ResetPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark - IBAction

- (IBAction)sendVerificationCode:(UIButton *)sender {

    [ThingSmartUser.sharedInstance sendMerchantVerifyCodeWithCountryCode:self.countryCodeTextField.text
                                                                username:self.accountTextField.text
                                                                codeType:ThingMerchantCodeModifyOrFindPasswordOrQuery
                                                            merchantCode:nil
                                                                 success:^{
        [Alert showBasicAlertOnVC:self withTitle:@"Verification Code Sent Successfully" message:@"Please check your email for the code."];
        
        
        
        
        
        
    } failure:^(NSError *error) {
        [Alert showBasicAlertOnVC:self withTitle:@"Failed to Sent Verification Code" message:error.localizedDescription];
    }];
}

- (IBAction)resetPassword:(UIButton *)sender {
    
    [ThingSmartUser.sharedInstance queryMerchantInfosByVerificationCode:self.verificationCodeTextField.text
                                                               username:self.accountTextField.text 
                                                            countryCode:self.countryCodeTextField.text
                                                                success:^(NSArray<ThingSmartMerchantModel *> * _Nullable merchantInfos) {
        NSString *merchantCode = merchantInfos.firstObject.merchantCode;
        [ThingSmartUser.sharedInstance getBackMerchantPasswordByVerificationCode:self.verificationCodeTextField.text
                                                                        username:self.accountTextField.text
                                                                     countryCode:self.countryCodeTextField.text
                                                                     newPassword:self.passwordTextField.text
                                                                    merchantCode:merchantCode
                                                                         success:^{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Password Reset Successfully"
                                                                                     message:@"Please navigate back to login your account."
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:NULL];
            }];
            [alertController addAction:action];
            
            [self presentViewController:alertController animated:true completion:nil];
            
            
        } failure:^(NSError *error) {
            [Alert showBasicAlertOnVC:self withTitle:@"Failed to Reset Password" message:error.localizedDescription];
        }];
    } failure:^(NSError *error) {
        [Alert showBasicAlertOnVC:self withTitle:@"Failed to Reset Password" message:error.localizedDescription];
    }];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        [self sendVerificationCode:nil];
    } else if (indexPath.section == 2) {
        [self resetPassword:nil];
    }
}


@end
