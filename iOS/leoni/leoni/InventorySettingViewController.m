//
//  InventorySettingViewController.m
//  Inventory
//
//  Created by Charlot on 15/11/26.
//  Copyright © 2015年 IF. All rights reserved.
//

#import "InventorySettingViewController.h"
#import "AFNetHelper.h"

@interface InventorySettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *listLimitUserSwitch;
@property (nonatomic, retain) AFNetHelper *afnet_helper;

@property (nonatomic,strong) UIAlertView *settingAlert;

@end

@implementation InventorySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    self.settingAlert=[[UIAlertView alloc] initWithTitle:@""
                                                 message:@"设置成功"
                                                delegate:self
                                       cancelButtonTitle:@"ok"
                                       otherButtonTitles:nil];

    self.afnet_helper  = [[AFNetHelper alloc] init];
    [self loadData];
    
}


- (void)loadData {
    self.listLimitUserSwitch.on=[self.afnet_helper listLimitUser];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
   
        [self.afnet_helper updateInventorySettingWithListLimitUser:self.listLimitUserSwitch.on];
        
        [self.settingAlert show];
   }

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
