//
//  CheckSynchronizeViewController.m
//  leoni
//
//  Created by ryan on 10/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckSynchronizeViewController.h"
#import "InventoryModel.h"
#import "MBProgressHUD.h"
#import "UserModel.h"
#import "CheckUserRoleViewController.h"
#import "AFNetHelper.h"

@interface CheckSynchronizeViewController ()
- (IBAction)downloadAction:(id)sender;
- (IBAction)uploadAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (nonatomic, strong ) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;

@property(nonatomic, strong) UIAlertView *downloadAlert;
@property(nonatomic, strong) UIAlertView *uploadAlert;
@property(nonatomic) NSInteger *pageSize;

@property(nonatomic, strong) InventoryModel *inventoryModel;
@property(nonatomic,strong) AFNetHelper *afnetHelper;


@property NSMutableArray *requestDataArray;
@property NSMutableArray *uploadDataArray;

//@property(strong,nonatomic) UIButton *currentButton;
@property(nonatomic,retain) UIButton *currentButton;

@end

@implementation CheckSynchronizeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.downloadAlert = [[UIAlertView alloc]
                          initWithTitle:@"下载提示"
                          message:@"下载将清空旧数据，确定下载？"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:@"取消", nil];
    
    self.uploadAlert = [[UIAlertView alloc]
                        initWithTitle:@"上传提示"
                        message:@"上传将数据传输到服务器，确定上传？"
                        delegate:self
                        cancelButtonTitle:@"确定"
                        otherButtonTitles:@"取消", nil];
    //    self.progressView.hidden = YES;
    self.progressView = [[UIProgressView alloc]
                         initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
    [self.progressView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.inventoryModel = [[InventoryModel alloc] init];
    self.afnetHelper=[[AFNetHelper alloc]init];
    self.requestDataArray = [[NSMutableArray alloc] init];
    
    self.pageSize=[self.afnetHelper getRequestQuantity];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)downloadAction:(id)sender {
//  [self.downloadAlert show];
//}
//- (IBAction)uploadAction:(id)sender {
//    [self.uploadAlert show];
//}


- (IBAction)clickSetCurrentButton:(UIButton *)sender {
    self.currentButton=sender;
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView == self.uploadAlert) {
    if (buttonIndex == 0) {
      [self validateUser];
    } else if (buttonIndex == 1) {
      NSLog(@"1");
    }
  } else if(alertView == self.downloadAlert) {
    if (buttonIndex == 0) {
        [self downloadCheckData];
    }
  } else {
  }
}

- (void)uploadCheckData {
  self.uploadDataArray = [[NSMutableArray alloc] init];
  self.uploadDataArray = [self.inventoryModel getLocalCheckDataListWithPosition:@"" WithUserNr:[UserModel accountNr]];
  [self.progressView setHidden:NO];
  self.progressView.progress = 0;
  if ([self.uploadDataArray count] > 0) {
      UserEntity *current_user=[[[UserModel alloc]init] findUserByNr:[UserModel accountNr]];
      if(self.uploadDataArray.count>=current_user.idSpanCount){
        [self toggleButton:FALSE];
        [NSTimer scheduledTimerWithTimeInterval:0.01
                                     target:self
                                   selector:@selector(uploadUpdateUI:)
                                   userInfo:nil
                                    repeats:YES];
      }else{
          [self MessageShowTitle:@"系统提示" Content:@"未完成指定任务量，不可上传！"];
          NSLog(@"当前无上载数据");
          [self.progressView setHidden:YES];
      }
  } else {
    [self MessageShowTitle:@"系统提示" Content:@"当前无上载数据"];
    NSLog(@"当前无上载数据");
    [self.progressView setHidden:YES];
  }
}

- (void)uploadUpdateUI:(NSTimer *)timer {
  static int count = 0;
  InventoryEntity *entity = [[InventoryEntity alloc] init];
  entity = self.uploadDataArray[count];
  [self.inventoryModel uploadCheckData:entity];
  count++;
  self.progressView.progress = (float)count / [self.uploadDataArray count];
  if (count == [self.uploadDataArray count]) {
    NSString *messageString =
        [NSString stringWithFormat:@"已上传数据量为：%ld",
        [self.uploadDataArray count]];
      [self toggleButton:TRUE];
      [self.progressView setHidden:YES];
      count = 0;
      [self MessageShowTitle:@"系统提示" Content:messageString];
      [timer invalidate];
  }
}




/**
 *  控制按钮的enable 2015.11.16
 *
 *  @param statusBool <#statusBool description#>
 */
- (void)toggleButton: (BOOL)statusBool {
    [self.downloadButton setEnabled:statusBool];
    [self.uploadButton setEnabled:statusBool];

}



- (void)MessageShowTitle:(NSString *)title Content:(NSString *)content {
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
  [message show];
}

/*
 简单验证服务器连接
 */
- (void)validateUser {
  UserModel *user = [[UserModel alloc] init];
  KeychainItemWrapper *keyChain =
      [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
  [user loginWithNr:[keyChain objectForKey:(__bridge id)kSecAttrAccount]
              block:^(UserEntity *user_entity, NSError *error) {
                if (user_entity) {
                  [self uploadCheckData];
                } else {
                  [self MessageShowTitle:@"系统提示"
                                 Content:@"网络异常，请联系管理员"];
                }
              }];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud=nil;
}

-(void) downloadCheckData{
    
    AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
    //[manager.reachabilityManager startMonitoring];
   // manager.requestSerializer.timeoutInterval=3;
    //if ([manager.reachabilityManager isReachable]){
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
        hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
        hud.labelText=@"下载中...";
        
        
        // get total data size
        [manager GET: [self.afnetHelper getTotal]
          parameters:nil
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 
                 [self.inventoryModel localDeleteData:@""];
                 
                 NSLog(@"success...:%@",responseObject);
                 
                 NSInteger total=[responseObject[@"content"] integerValue];
                 
                 int page=total/(int)self.pageSize;
                 
                 if(total%(int)self.pageSize!=0){
                     page+=1;
                 }
                 
                 [self callHttpDownload:0 WithTotalPage:page WithTotal:total];
             }
             failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 
                 NSLog(@"fail......%@,....%@.....%i...%@",error.description,error.class,error.code,error.domain
                       );
                 if([error.domain isEqualToString:NSURLErrorDomain]){
                     [self MessageShowTitle:@"系统提示"
                                            Content:@"未连接服务器，请联系管理员"];
                 }
                 [hud hide:YES];
             }];
    
//    }else{
//        [hud hide:YES];
//        [self MessageShowTitle:@"系统提示"
//                       Content:@"未连接网络，请联系管理员"];
//    }
   
}


-(void)callHttpDownload:(NSInteger)pageIndex WithTotalPage:(NSInteger)totalPage WithTotal:(NSInteger)total{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
        
        
        [manager GET:[self.afnetHelper downloadCheckData]
          parameters:@{@"page":[NSString stringWithFormat:@"%i" ,pageIndex ],@"per_page":[NSString stringWithFormat:@"%i" ,self.pageSize]}
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 NSLog(@"queue task:%i",pageIndex);
                 
                 if([responseObject[@"result"] integerValue]== 1 ){
                     NSArray *arrayResult = responseObject[@"content"];
                     
                     for(int i=0; i<arrayResult.count; i++){
                         InventoryEntity *inventory =[[InventoryEntity alloc] initWithObject:arrayResult[i]];
                         
                         [self.inventoryModel localCreateCheckData:inventory];
                     }
                     
                 }

                 
                 if(pageIndex<totalPage){
                     [self callHttpDownload:pageIndex+1 WithTotalPage:totalPage WithTotal:total];
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     float progress=(pageIndex+1)/(float)totalPage;
                     NSLog(@"process: %f",progress);
                     hud.progress=progress;
                     hud.labelText=[NSString stringWithFormat:@"已下载 %i ％", (int)round(progress*100)];
                     if(pageIndex==totalPage){
                         [hud hide:YES];
                     }
                 });
             } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 
             }];
    });
}


-(IBAction)Checked :(UIStoryboardSegue *)segue{
    
    if([segue.sourceViewController isKindOfClass:[CheckUserRoleViewController class]]){
        
        NSLog(@".................");
        
        CheckUserRoleViewController *check=(CheckUserRoleViewController*)segue.sourceViewController;
        
        if(check.pass){
            if(self.currentButton==self.downloadButton){
               [self.downloadAlert show];
            }else if(self.currentButton ==self.uploadButton){
                [self.uploadAlert show];
            }
        }
    }
}

@end
