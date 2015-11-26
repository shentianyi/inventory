//
//  DashboardProfileViewController.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "DashboardProfileViewController.h"
#import "KeychainItemWrapper.h"
#import "UserModel.h"
#import "UserEntity.h"
#import "CheckUserRoleViewController.h"

@interface DashboardProfileViewController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *idSpanLable;
@property (weak, nonatomic) IBOutlet UILabel *idSpanCountLabel;
@property (nonatomic) BOOL pass;
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
    [self initController];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.pass){
        [self performSegueWithIdentifier:@"toUserSetting" sender:self];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    self.pass=nil;
}

-(void) initController{
    KeychainItemWrapper *keyChain=[[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
    NSString *nr=[keyChain objectForKey:(__bridge id)kSecAttrAccount];
    UserModel *userModel=[[UserModel alloc]init];
    UserEntity *user=[userModel findUserByNr:nr];
    if(user){
        self.nrLabel.text=[NSString stringWithFormat:@"%@ # %@",user.nr,user.name];
        self.idSpanLable.text=user.idSpan;
        self.idSpanCountLabel.text=[NSString stringWithFormat:@"%i", user.idSpanCount];
    }
}





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
//        [self dismissViewControllerAnimated:YES completion:^{
//            [self performSegueWithIdentifier:@"loginVC" sender:self];
//            
//        }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(IBAction)Checked :(UIStoryboardSegue *)segue{
    NSLog(@"-------------%@",self.nrLabel.text);
    
    if([segue.sourceViewController isKindOfClass:[CheckUserRoleViewController class]]){
        
        NSLog(@".................");
        
        CheckUserRoleViewController *check=(CheckUserRoleViewController*)segue.sourceViewController;
        
        if(check.pass){
            self.pass=true;
              //  [self performSegueWithIdentifier:@"toUserSetting" sender:self];
        }
    }
}




/*
 #pragma mark - Navigation
 
 */
 // In a storyboard-based application, you will often want to do a little preparation before navigation
// - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// // Get the new view controller using [segue destinationViewController].
// // Pass the selected object to the new view controller.
// }

@end
