//
//  LoginViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "LoginViewController.h"
#import "SettingViewController.h"

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
    [self performSegueWithIdentifier:@"toDashboard" sender:self];
}

@end
