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
@property (nonatomic,strong) UIAlertView *downloadAlert;
@property (nonatomic,strong) UIAlertView *settingAlert;
@property (strong, nonatomic) IBOutlet UIProgressView *processView;

@property (weak, nonatomic) IBOutlet UISwitch *listLimitUserSwitch;


@property (nonatomic,retain) UserModel *userModel;
@property (nonatomic,strong) NSMutableArray *users;
@property (weak, nonatomic) IBOutlet UITextField *deparmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partPrefixTextField;

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
    self.partPrefixTextField.delegate=self;
    
    _afnet_helper  = [[AFNetHelper alloc] init];

    
//    
//        [[self navigationController] setNavigationBarHidden:YES animated:YES];
//    
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.view addGestureRecognizer:tap];

//    self.processView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
//    
//    [self.view addSubview: self.processView];
 
    //self.processView.center=self.view.center;
  //  self.processView.frame=self.view.bounds;
    [self.processView setHidden: YES];
    
   // NSLog(@"start donloading");
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
    
    //NSString *serverString = [self.afnet_helper ServerURL];
    //NSArray *serverArray = [serverString componentsSeparatedByString:@":"];
   // self.ipTextField.text = [NSString stringWithFormat:@"%@:%@", serverArray[0], serverArray[1]];
    
    self.ipTextField.text=[self.afnet_helper ServerURL];
    
    //self.portTextField.text = [NSString stringWithFormat:@":%@", serverArray[2]];
    self.requestTextField.text = [self.afnet_helper getRequestQuantity];
    
    self.deparmentTextField.text=[self.afnet_helper defaultDepartment];
    
    self.partPrefixTextField.text=[self.afnet_helper partNrPrefix];
    
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

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveAction:(id)sender {
    if (self.ipTextField.text.length > 0 && self.requestTextField.text.length>0) {
        [self.afnet_helper UpdateServerURLwithIP:self.ipTextField.text withRequest:self.requestTextField.text withDeparment:self.deparmentTextField.text withPartPrefix:@"P" WithListLimitUser:self.listLimitUserSwitch.on];
        
        [self.settingAlert show];
    }
    else {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"设置失败,请填写所有＊配置项"];
        [hud hide:YES afterDelay:1.5f];
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
    NSLog(@"start donloading");
    if(!self.users){
        self.users=[[NSMutableArray alloc] init];
    }
    [self.users removeAllObjects];
    [self.userModel cleanLocalData];
    
    self.userModel=[[UserModel alloc] init];
    NSInteger page=1;
    NSInteger perPage=[[self.afnet_helper getRequestQuantity] integerValue];
    
    [self.processView setHidden:NO];
    
        [self.userModel getUserInPage:page PerPage:nil :^( NSMutableArray *userEntities,NSError *error) {
            if(userEntities && userEntities.count>0){
                
                NSLog(@"000::::%d", userEntities.count);
                
                [self.users addObjectsFromArray:userEntities];
                
                NSLog(@"----9999999-total: %d--count: %d", self.users.count,0);
                [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
            }else if(userEntities.count==0){
                [self MessageShowTitle:@"系统提示" Content:@"服务器无数据"];
            }
            
            if(error){
               [self MessageShowTitle:@"系统提示" Content:[error userInfo][NSLocalizedDescriptionKey]];
            }
        }
       ];

}

-(void) countDown:(NSTimer *)timer{
    static int count=0;
    UserEntity *userEntity=self.users[count];
    [self.userModel createLocalData:userEntity];
    count++;
    NSLog(@"-----total: %d--count: %d", self.users.count,count);
    self.processView.progress=(float)count/self.users.count;
    if(count==self.users.count){
        
        [self.processView setHidden:YES];
        NSString *message=[NSString stringWithFormat:@"已下载数据量: %d",count];
        [self MessageShowTitle:@"系统提示" Content:message];
        
        count=0;
        [timer invalidate];
    }
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
