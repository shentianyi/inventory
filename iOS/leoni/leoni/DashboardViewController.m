//
//  DashboardViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
}
*/

-(void)loginSameAction:(NSString *)identifier
{
    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabbarStock=[[UIViewController alloc] init];
    tabbarStock=[storyboard instantiateViewControllerWithIdentifier:identifier];
    [self presentViewController:tabbarStock
                       animated:YES
                     completion:nil];
}

- (IBAction)quanpanAction:(id)sender {
    [self loginSameAction:@"quan_pan"];
}
@end
