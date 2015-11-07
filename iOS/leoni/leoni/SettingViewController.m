//
//  SettingViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "SettingViewController.h"
#import "AFNetHelper.h"
#import "MBProgressHUD.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.ipTextField.delegate = self;
    self.portTextField.delegate = self;
    self.requestTextField.delegate = self;
    _afnet_helper  = [[AFNetHelper alloc] init];

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

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)loadData {
    
    NSString *serverString = [self.afnet_helper ServerURL];
    NSArray *serverArray = [serverString componentsSeparatedByString:@":"];
    self.ipTextField.text = [NSString stringWithFormat:@"%@:%@", serverArray[0], serverArray[1]];
    self.portTextField.text = [NSString stringWithFormat:@":%@", serverArray[2]];
    self.requestTextField.text = [self.afnet_helper getRequestQuantity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)saveAction:(id)sender {
    if (self.ipTextField.text.length > 0 && self.portTextField.text.length > 0) {
        [self.afnet_helper UpdateServerURLwithIP:self.ipTextField.text withProt:self.portTextField.text];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                      message:@"设置成功"
                                                     delegate:self
                                            cancelButtonTitle:@"ok"
                                            otherButtonTitles:nil];
        [alert show];

        
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText = [NSString stringWithFormat:@"设置失败"];
        [hud hide:YES afterDelay:1.5f];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
@end
