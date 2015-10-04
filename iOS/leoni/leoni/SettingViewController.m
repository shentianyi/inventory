//
//  SettingViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "SettingViewController.h"
#import "AFNetHelper.h"

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
    }
    
}
@end
