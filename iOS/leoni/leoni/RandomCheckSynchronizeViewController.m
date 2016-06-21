//
//  RandomCheckSynchronizeViewController.m
//  leoni
//
//  Created by ryan on 10/17/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomCheckSynchronizeViewController.h"
#import "InventoryModel.h"
#import "UserModel.h"
#import "CheckUserRoleViewController.h"



@interface RandomCheckSynchronizeViewController ()
@property (nonatomic, strong) UIAlertView *downloadAlert;
@property (nonatomic, strong) UIAlertView *uploadAlert;
@property (nonatomic, retain) InventoryModel *inventoryModel;

@property (strong, nonatomic) IBOutlet UIButton *randomDownloadButton;
@property (strong, nonatomic) IBOutlet UIButton *randomuploadButton;
@property(nonatomic,retain) UIButton *currentButton;



@property(nonatomic) NSInteger *pageSize;
@property(nonatomic,strong) AFNetHelper *afnetHelper;

@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic, strong) NSURLSession* session;
@property NSString *filePath;

@property (weak, nonatomic) IBOutlet UILabel *pgLabel;
@property (weak, nonatomic) IBOutlet UILabel *reminder;

@end

@implementation RandomCheckSynchronizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.downloadAlert = [[UIAlertView alloc] initWithTitle:@"下载提示"
                                                    message:@"下载将清空旧数据，确定下载？"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    
    self.uploadAlert = [[UIAlertView alloc] initWithTitle:@"上传提示"
                                                  message:@"上传将数据传输到服务器，确定上传？"
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:@"取消", nil];
   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.inventoryModel = [[InventoryModel alloc] init];
    self.afnetHelper=[[AFNetHelper alloc]init];
    
    self.pageSize=[self.afnetHelper getRequestQuantity];
}

 

- (IBAction)clickSetCurrentButton:(UIButton *)sender {
    self.currentButton=sender;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == self.uploadAlert) {
        if(buttonIndex == 0){
            [self uploadRandomCheckData];
        }
        else if(buttonIndex == 1){
            NSLog(@"1");
        }
    } else if(alertView == self.downloadAlert){
        if(buttonIndex == 0){
            [self downloadAllRandomCheckData];
        }
    }else{
        
    }
    
}



- (void)uploadRandomCheckData {
    NSMutableArray *uploadDataArray =[self.inventoryModel getLocalRandomCheckUnSyncDataListWithPosition:@""];
    
    if ([uploadDataArray count] > 0) {
           hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.delegate=self;
            //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
            
            hud.labelText=@"上传中...";
        self.pgLabel.hidden=NO;
        self.reminder.hidden=NO;
        self.pgLabel.text=@"上传数据时请确保网络连接，此过程大约需要一分钟";
            [self callHttpUpload:0 WithData:uploadDataArray];
     } else {
        [self MessageShowTitle:@"系统提示" Content:@"当前无上载数据"];
        NSLog(@"当前无上载数据");
         
         
                     }
}


- (void)callHttpUpload:(NSInteger)index WithData:(NSMutableArray *)inventories{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        AFHTTPRequestOperationManager *manager = [self.afnetHelper basicManager];
        
        InventoryEntity *inventory=inventories[index];
         NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
        for (int i= 0; i<[inventories count]; i++) {
            inventory=inventories[i];
            NSString *string = [NSString stringWithFormat:@"{\"id\":\"%@\",\"random_check_qty\":\"%@\",\"random_check_user\":\"%@\",\"random_check_time\":\"%@\"},",inventory.inventory_id,inventory.random_check_qty,inventory.random_check_user,inventory.random_check_time];

            [jsonString appendString:string];
        }
        NSUInteger location = [jsonString length]-1;
        NSRange range       = NSMakeRange(location, 1);
        [jsonString replaceCharactersInRange:range withString:@"]"];
        

        
        [manager POST:[self.afnetHelper uploadloadUrl]
           parameters:@{@"user_id":inventory.check_user,@"type":@200,@"data":jsonString}

              success:^(AFHTTPRequestOperation * operation, id responseObject) {
                  NSLog(@"testing ========= checkWithPosition =======%@", responseObject);
                  if([responseObject[@"result"] integerValue]== 1 ){
                      InventoryEntity *inventoryUpdata = [[InventoryEntity alloc]init];
                      for (int i= 0; i<[inventories count]; i++) {
                          inventoryUpdata = inventories[i];
                          inventoryUpdata.is_random_check_synced=@"1";
                          [self.inventoryModel updateRandomCheckSync:inventoryUpdata];
                      }
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          int total=[inventories count];
                          NSLog(@"jsonString :%@",jsonString);
                          [hud hide:YES];
                          self.pgLabel.hidden=YES;
                          self.reminder.hidden=YES;
                          self.reminder.text=@"提 示";
                          [self MessageShowTitle:@"上传提示" Content:[NSString stringWithFormat:@"共上传 %i",total]];
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


-(void) downloadAllRandomCheckData{
    
    AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
    //[manager.reachabilityManager startMonitoring];
    // manager.requestSerializer.timeoutInterval=3;
    //if ([manager.reachabilityManager isReachable]){
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
    NSLog(@"下载中");
    NSLog(@"RandomCheckSynchronizeViewController.m");
    hud.labelText=@"下载中...";
    self.pgLabel.hidden=NO;
    self.reminder.hidden=NO;
    self.reminder.text=@"提 示";
    self.pgLabel.text=@"若1分钟未下载成功，请返回主菜单后重新下载";

    
    
    // get total data size
    [manager GET: [self.afnetHelper getRandomTotal]
      parameters:nil
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             
             [self.inventoryModel localDeleteData:@""];
             
             NSLog(@"success...:%@",responseObject);
             
             NSInteger total=[responseObject[@"content"] integerValue];
             
             int page=total/(int)self.pageSize;
             
             if(total%(int)self.pageSize!=0){
                 page+=1;
             }
             
//             [self callHttpDownload:0 WithTotalPage:page WithTotal:total];
             [self startDownload];
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

-(void)startDownload{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
        [manager GET:[self.afnetHelper downloadUrl]
          parameters:@{@"type":@200}
             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                 if([responseObject[@"result"] integerValue]== 1 ){
                     NSString *UrlReturn = responseObject[@"content"];
                     //                     NSString *UrlReturn = @"http://img4.imgtn.bdimg.com/it/u=783533256,80770954&fm=21&gp=0.jpg";
                     
                     NSURL* url = [NSURL URLWithString:UrlReturn];
                     NSDate *begin =[NSDate date];
                     NSLog(@"begin :%@",begin);
                     
                     // 得到session对象
                     self.session = [NSURLSession sharedSession];
                     
                     // 创建任务
                     self.downloadTask = [self.session downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                         // location : 临时文件的路径（下载好的文件）
                         
                         NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
                         // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
                         NSString *file = [caches stringByAppendingPathComponent:response.suggestedFilename];
                         
                         // 将临时文件剪切或者复制Caches文件夹
                         NSFileManager *mgr = [NSFileManager defaultManager];
                         NSLog(@"3");
                         // AtPath : 剪切前的文件路径
                         // ToPath : 剪切后的文件路径
                         
                         NSError *errorformoveitem;
                         @try {
                             [mgr moveItemAtPath:location.path toPath:file error:&errorformoveitem];
                             
                         }
                         @catch (NSException *exception) {
                             [hud hide:YES];
                             if (errorformoveitem) {
                                 UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"未知错误"
                                                                                     message:@"请检测网络连接或联系管理员"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"知道了"
                                                                           otherButtonTitles:nil];
                                 
                                 [alertView show];
                                 return;
                             }
                         } @finally{
                             
                         }
                         
                         if(error){
                             dispatch_async(dispatch_get_main_queue(), ^{
                                 [hud hide:YES];
                                 NSLog(@"Error is not null , Has Error== %@" ,error);
                                 
                                 UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"下载出错"
                                                                                     message:@"请重新下载或联系管理员"
                                                                                    delegate:nil
                                                                           cancelButtonTitle:@"知道了"
                                                                           otherButtonTitles:nil];
                                 
                                 [alertView show];
                             });
                         }else{
                             NSDate *finish =[NSDate date];
                             NSLog(@"finish :%@",finish);
                         }
                     }];
                     // 开始任务
                     [self.downloadTask resume];
                     
                     
                     //处理数据
                     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
                     NSString *cachesDir = [paths objectAtIndex:0];
                     self.filePath =[cachesDir stringByAppendingPathComponent:@"data.json"];
                     NSFileManager *fileManager = [NSFileManager defaultManager];
                     
                     if ([fileManager fileExistsAtPath:self.filePath]==YES) {
                         hud.labelText = @"下载完成，正在拼命解析...";
                         self.pgLabel.hidden=NO;
                         self.reminder.hidden=NO;
                         self.reminder.text=@"提 示";
                         self.pgLabel.text=@"解析数据大约需要五分钟，请耐心等待";
                         NSData* data = [NSData dataWithContentsOfFile:self.filePath];
                         NSThread* fetchThread = [[NSThread alloc] initWithTarget:self
                                                                         selector:@selector(ReadFile:)
                                                                           object:data];
                         [fetchThread start];
                         
                     }
                 }
             }
             failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"失败"
                                                                     message:@"网络连接失败，请联系管理员"
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 [hud hide:YES];
                 
             }];
    });
    
}

-(void)ReadFile:(NSData *)responseData{
    NSError *error;
    NSMutableArray *json = [[NSMutableArray alloc]init];
    json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    for (NSDictionary *item in json)
    {
        
        InventoryEntity *inventory = [[InventoryEntity alloc] initWithObject:item];
        [self.inventoryModel localCreateCheckData:inventory];
        NSLog(@"sn:%ld and is_random_check:%@",(long)inventory.sn,inventory.is_random_check);
    }
    [self performSelectorOnMainThread:@selector(finishAlert) withObject:nil waitUntilDone:YES];
    
}
-(void)finishAlert{
    [hud hide:YES];
    self.pgLabel.hidden=YES;
    self.reminder.hidden=YES;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"完成"
                                                        message:@"可以开始盘点"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    
    [alertView show];
    [self deleteFile];
}
-(void)deleteFile {
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"data.json"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}


- (void)MessageShowTitle:(NSString *)title Content:(NSString *)content {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:content
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:@"取消", nil];
    [message show];
}
- (NSURLSession *)session
{
    if (nil == _session) {
        
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud=nil;
}





-(IBAction)Checked :(UIStoryboardSegue *)segue{
    
    if([segue.sourceViewController isKindOfClass:[CheckUserRoleViewController class]]){
        
        NSLog(@".................");
        
        CheckUserRoleViewController *check=(CheckUserRoleViewController*)segue.sourceViewController;
        
        if(check.pass){
            if(self.currentButton==self.randomDownloadButton){
                [self.downloadAlert show];
            }else if(self.currentButton ==self.randomuploadButton){
                [self.uploadAlert show];
            }
        }
    }
}


@end
