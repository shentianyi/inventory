//
//  LoginViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingViewController.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
- (IBAction)SettingAction:(id)sender;
- (IBAction)loginAction:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.delegate = self;
    _user = [[UserMoel alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)dismissKeyboard {
    NSArray *subviews = [self.view subviews];
    for (id objInput in subviews) {
        if ([objInput isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objInput;
            if ([objInput isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"toSetting"]) {
        SettingViewController *set = segue.destinationViewController;
    }
}
*/

- (IBAction)SettingAction:(id)sender
{
    
    [self performSegueWithIdentifier:@"toSetting" sender:self];
}

- (IBAction)loginAction:(id)sender {
    
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni"                                                                    accessGroup:nil];
    
    NSString *nr = self.nameTextField.text;
    if (nr.length > 0){
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";
    
        [self.user loginWithNr:nr block:^(UserEntity *user_entity, NSError *error) {
        
            if (user_entity) {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"登陆成功";
                [hud hide:YES afterDelay:1.5f];
                [keychain setObject:nr forKey:(__bridge id)kSecAttrAccount];
                self.nameTextField.text =@"";
                [self performSegueWithIdentifier:@"toDashboard" sender:self];
            }
            else {
                hud.mode = MBProgressHUDModeText;
                
                hud.labelText = [NSString stringWithFormat:@"%@", error.userInfo];
                [hud hide:YES afterDelay:1.5f];
            }
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"请填写员工号"
                                                     delegate:self
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
        [alert show];
    }
        
}

@end
