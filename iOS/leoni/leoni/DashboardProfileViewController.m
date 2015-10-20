//
//  DashboardProfileViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "DashboardProfileViewController.h"
#import "KeychainItemWrapper.h"

@interface DashboardProfileViewController ()<UIAlertViewDelegate>

@end

@implementation DashboardProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
    if ([keyChain objectForKey:(__bridge id)kSecAttrAccount]) {
        self.nrLabel.text = [NSString stringWithFormat:@"员工号:%@", [keyChain objectForKey:(__bridge  id)kSecAttrAccount]];
    }
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)quitAction:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"leoni"
                                                    message:@"确定退出系统吗？"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消",nil];
    [alert show];
    }

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    // the user clicked OK
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }
}
@end
