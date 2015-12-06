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
#import "UserModel.h"



@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *settingButton;
@property (weak, nonatomic) IBOutlet UILabel *vesrionLabel;


- (IBAction)SettingAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)touchScreen:(id)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.delegate = self;
    _user = [[UserModel alloc] init];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    self.vesrionLabel.text=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//textField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y-180;
    
    
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    return YES;
}

- (IBAction)SettingAction:(id)sender
{
    
    [self performSegueWithIdentifier:@"toSetting" sender:self];
}

- (IBAction)loginAction:(id)sender {
    
    KeychainItemWrapper *keychain=[[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni"                                                                    accessGroup:nil];
    
    NSString *nr = self.nameTextField.text;
    if (nr.length > 0){
        if([self.user findUserByNr:nr]){
        [keychain setObject:nr forKey:(__bridge id)kSecAttrAccount];
        self.nameTextField.text =@"";
        [self performSegueWithIdentifier:@"toDashboard" sender:self];

        }else{
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                          message:@"请填写正确员工号"
                                                         delegate:self
                                                cancelButtonTitle:@"ok"
                                                otherButtonTitles:nil];
            [alert show];

        
        }
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

// 消失输入框
- (IBAction)touchScreen:(id)sender {
    [self.nameTextField resignFirstResponder];
    
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

@end
