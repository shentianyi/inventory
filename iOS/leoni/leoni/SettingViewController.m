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
#import "UserModel.h"

@interface SettingViewController ()
- (IBAction)backAction:(id)sender;
- (IBAction)saveAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTextField;
@property (nonatomic, retain) AFNetHelper *afnetHelper;

@property (nonatomic,strong) UIAlertView *downloadAlert;
@property (nonatomic,strong) UIAlertView *settingAlert;
@property (strong, nonatomic) IBOutlet UIProgressView *processView;

@property (nonatomic,retain) UserModel *userModel;

@property (weak, nonatomic) IBOutlet UITextField *deparmentTextField;

- (IBAction)touchScreen:(id)sender;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingAlert=[[UIAlertView alloc] initWithTitle:@""
                                      message:@"设置成功"
                                     delegate:self
                            cancelButtonTitle:@"ok"
                            otherButtonTitles:nil];
    
    self.downloadAlert=[[UIAlertView alloc] initWithTitle:@"下载提示"
                                                         message:@"下载将清空旧数据，确定下载？"
                                                        delegate:self
                                               cancelButtonTitle:@"确定"
                                               otherButtonTitles:@"取消",nil];
    
    // Do any additional setup after loading the view.
    self.ipTextField.delegate = self;
    self.requestTextField.delegate = self;
    self.deparmentTextField.delegate=self;
    
    self.afnetHelper  = [[AFNetHelper alloc] init];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

- (void)loadData {
    self.userModel=[[UserModel alloc] init];
 
    self.ipTextField.text=[self.afnetHelper ServerURL];
    
    self.requestTextField.text = [NSString stringWithFormat:@"%i",  [self.afnetHelper getRequestQuantity]];
    
    self.deparmentTextField.text=[self.afnetHelper defaultDepartment];
    
   
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
    if (self.ipTextField.text.length > 0 && self.requestTextField.text.length>0) {
        [self.afnetHelper UpdateServerURLwithIP:self.ipTextField.text withRequest:self.requestTextField.text withDeparment:self.deparmentTextField.text withPartPrefix:@"P"];
        [self.settingAlert show];
    }
    else {
        [self MessageShowTitle:@"设置提示" Content:[NSString stringWithFormat:@"设置失败,请填写所有＊配置项"]];

    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"click download....");
    if(alertView==self.settingAlert){
    if (buttonIndex == 0)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    }else if(alertView==self.downloadAlert && buttonIndex==0){
        [self downloadUserData];
    }
}
- (IBAction)SaveDataToLocal:(UIButton *)sender {
    [self.downloadAlert show];
}

-(void)downloadUserData
{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
    
    hud.labelText=@"下载中1...";
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [self.afnetHelper basicManager];
        
        [manager GET:[self.afnetHelper downloadUserData]
           parameters:@{@"page":  [NSString stringWithFormat: @"%d", 0]}
              success:^(AFHTTPRequestOperation * operation, id responseObject) {
                   if([responseObject[@"result"] integerValue]== 1 ){
                      [self.userModel cleanLocalData];
                      
                      NSArray *users=responseObject[@"content"];
                      NSMutableArray *userEntities=[[NSMutableArray alloc] init];
                      for(int i=0;i<users.count;i++){
                          [self.userModel createLocalData: [[UserEntity alloc] initWithId:users[i][@"id"] andNr:users[i][@"nr"] andName:users[i][@"name"] andRole:users[i][@"role"] andIdSpan:users[i][@"id_span"]]];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          int total=[users count];
                          [hud hide:YES];
                          [self MessageShowTitle:@"下载提示" Content:[NSString stringWithFormat:@"共下载 %i 个用户",total]];
                          
                      });
                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  if([error.domain isEqualToString:NSURLErrorDomain]){
                      [self MessageShowTitle:@"系统提示"
                                     Content:@"未连接服务器，请联系管理员"];
                  }
                  [hud hide:YES];
              }];
    });

    

}


- (void)MessageShowTitle: (NSString *)title Content: (NSString *)content {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:content
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:@"取消", nil];
    [message show];
}



#pragma UITextField
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
   // [textField becomeFirstResponder];
    if(self.deparmentTextField==textField){
    CGRect frame=textField.frame;
     int offset=frame.origin.y-180;
     
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -    offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];}
}


- (IBAction)touchScreen:(id)sender {
    
     [self dismissKeyboard];
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud=nil;
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

@end
