//
//  ChecUserRoleViewController.m
//  Inventory
//
//  Created by Charlot on 15/11/24.
//  Copyright © 2015年 IF. All rights reserved.
//

#import "CheckUserRoleViewController.h"
#import "UserModel.h"
#import "AFNetHelper.h"
@interface CheckUserRoleViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNrTF;
@property (weak, nonatomic) IBOutlet UITextField *userKeyTF;
@property (strong,nonatomic) AFNetHelper *afnetHelper;
@property (strong, nonatomic) UITextField *firstResponder;
@end

@implementation CheckUserRoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];

    self.afnetHelper=[[AFNetHelper alloc] init];
    self.userNrTF.delegate=self;
    self.userKeyTF.delegate=self;
    self.userKeyTF.secureTextEntry=YES;
    self.pass=NO;
}

/*
#pragma mark - Navigation
*/
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
  //  if([segue.identifier isEqualToString:@"user_setting"]){
   
    
//        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *settingUser=[[UIViewController alloc] init];
//        settingUser=[storyboard instantiateViewControllerWithIdentifier:@"user_setting"];
//        [self presentViewController:settingUser
//                           animated:YES
//                         completion:nil];
    //
   // }
}


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{

    UserModel *userModel=[[UserModel alloc] init];
    UserEntity *userEntity=[userModel findUserByNr:self.userNrTF.text];
//    if(userEntity && [userEntity.role isEqualToString:@"组长"] && [self.userKeyTF.text isEqualToString:[self.afnetHelper secretKey]]){
//        self.pass=YES;
//        return  YES;
//    }else{
//        UIAlertView *alert= [[UIAlertView alloc] initWithTitle:@"验证消息"
//                                                       message:@"验证错误！"
//                                                      delegate:self
//                                             cancelButtonTitle:@"确定"
//                                             otherButtonTitles:NULL, nil];
//        [alert show];
//        return NO;
//    }
    self.pass=YES;
    return  YES;
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 消失输入框
- (IBAction)touchScreen:(id)sender {
    [self hideKeyboard];
    //[self.userNrTF becomeFirstResponder];
   if(self.firstResponder){
        [self.firstResponder resignFirstResponder];
       self.firstResponder=nil;
   }else{
       [self.userNrTF becomeFirstResponder];
   }
}

-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=[data copy];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField==self.userKeyTF){
        UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        textField.inputView = dummyView;
        [self hideKeyboard];
    }
    
    self.firstResponder=textField;
}

-(void)hideKeyboard{
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

@end
