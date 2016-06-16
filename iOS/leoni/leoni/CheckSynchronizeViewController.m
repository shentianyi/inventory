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

@interface CheckSynchronizeViewController ()<NSURLSessionDownloadDelegate>
- (IBAction)downloadAction:(id)sender;
- (IBAction)uploadAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;


@property(nonatomic, strong) UIAlertView *downloadAlert;
@property(nonatomic, strong) UIAlertView *uploadAlert;

@property(nonatomic, strong) InventoryModel *inventoryModel;
@property(nonatomic) NSInteger *pageSize;
@property(nonatomic,strong) AFNetHelper *afnetHelper;

@property(nonatomic,retain) UIButton *currentButton;

@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;
@property (nonatomic, strong) NSURLSession* session;
@property (weak, nonatomic) IBOutlet UIProgressView *myPregress;
@property (weak, nonatomic) IBOutlet UILabel *pgLabel;
@property NSString *filePath;

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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little
preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickSetCurrentButton:(UIButton *)sender {
    self.currentButton=sender;
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView == self.uploadAlert) {
    if (buttonIndex == 0) {
      [self uploadCheckData];
    }
  } else if(alertView == self.downloadAlert) {
    if (buttonIndex == 0) {
        [self downloadCheckData];
    }
  }
}

- (void)uploadCheckData {
   NSMutableArray *uploadDataArray =[self.inventoryModel getLocalCheckOrCreateUnsyncDataListWithUserNr:[UserModel accountNr]];
    NSMutableArray *localCheckUnSyncDataArray =[self.inventoryModel getLocalCheckUnSyncDataListWithPosition:@"" WithUserNr:[UserModel accountNr]];
    
    NSMutableArray *localDataArray=[self.inventoryModel getLocalCheckDataListWithPosition:@"" WithUserNr:[UserModel accountNr]];
    NSMutableArray *locakCreateDataArray=[self.inventoryModel getLocalCreateCheckDataListWithPoistion:@"" WithUserNr:[UserModel accountNr]];
    int localDataCount=[localDataArray count]-[locakCreateDataArray count];

  if ([uploadDataArray count] > 0) {
      UserEntity *current_user=[[[UserModel alloc]init] findUserByNr:[UserModel accountNr]];
      if(localDataCount>=current_user.idSpanCount || ([localCheckUnSyncDataArray count]==0 && [locakCreateDataArray count]>0)){
          
          hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
          hud.delegate=self;
          
          //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
          
          hud.labelText=@"上传中...";
          [self callHttpUpload:0 WithData:uploadDataArray];
          
      }else{
          [self MessageShowTitle:@"系统提示" Content:@"未完成指定任务量，不可上传！"];
          NSLog(@"当前无上载数据");
      }
  } else {
    [self MessageShowTitle:@"系统提示" Content:@"当前无上载数据"];
    NSLog(@"当前无上载数据");
  }
}


- (void)callHttpUpload:(NSInteger)index WithData:(NSMutableArray *)inventories{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

     AFHTTPRequestOperationManager *manager = [self.afnetHelper basicManager];
      
        InventoryEntity *inventory=inventories[index];
        
    [manager POST:[self.afnetHelper uploadCheckData]
       parameters:@{@"id" : inventory.inventory_id,@"sn": [NSString stringWithFormat:@"%i",inventory.sn], @"department" : inventory.department, @"position" : inventory.position, @"part_nr" : inventory.part_nr,@"part_unit":inventory.part_unit, @"part_type" : inventory.part_type,@"wire_nr":inventory.wire_nr,@"process_nr":inventory.process_nr, @"check_qty" : inventory.check_qty, @"check_user" : inventory.check_user, @"check_time" :inventory.check_time, @"ios_created_id" : inventory.ios_created_id}
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"testing ========= checkWithPosition =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                 
                  inventory.is_check_synced=@"1";
                  [[[InventoryModel alloc] init] updateCheckSync:inventory];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      int total=[inventories count];
                      float progress=(index+1)/(float)total;
                      NSLog(@"process: %f",progress);
                      hud.progress=progress;
                      if (progress<=1.0f) {
                          hud.labelText=[NSString stringWithFormat:@"已上传 %i, 共 %i", index+1, total];
                      }
                      if((index+1)==total){
                          [hud hide:YES];
                          [self MessageShowTitle:@"上传提示" Content:[NSString stringWithFormat:@"共上传 %i",total]];
                      }else{
                          [self callHttpUpload:index+1 WithData:inventories];
                      }
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




-(void)downloadCheckData{
    
    AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
    //[manager.reachabilityManager startMonitoring];
   // manager.requestSerializer.timeoutInterval=3;
    //if ([manager.reachabilityManager isReachable]){
    
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:HUD];
//    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
        //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
    
    NSLog(@"下载中");
    NSLog(@"CheckSynchronizeViewController.m");
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
                 
//                 [self callHttpDownload:0 WithTotalPage:page WithTotal:total];
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
    

   
}
-(void)startDownload{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        AFHTTPRequestOperationManager *manager=[self.afnetHelper basicManager];
        [manager GET:[self.afnetHelper downloadUrl]
          parameters:@""
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
                         NSData* data = [NSData dataWithContentsOfFile:self.filePath];
                         //[self performSelectorOnMainThread:@selector(ReadFile:) withObject:data waitUntilDone:YES];
                         NSThread* fetchThread = [[NSThread alloc] initWithTarget:self
                                                                         selector:@selector(ReadFile:)
                                                                           object:data];
                         [fetchThread start];
                         hud.labelText = @"正在拼命加载数据...";
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
    }
    [self performSelectorOnMainThread:@selector(finishAlert) withObject:nil waitUntilDone:YES];
    
}
-(void)finishAlert{
    [hud hide:YES];
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"完成"
                                                        message:@"可以开始盘点"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    
    [alertView show];
}


- (void)MessageShowTitle:(NSString *)title Content:(NSString *)content {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:content
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:@"取消", nil];
    [message show];
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
            if(self.currentButton==self.downloadButton){
                [self.downloadAlert show];
            }else if(self.currentButton ==self.uploadButton){
                [self.uploadAlert show];
            }
        }
    }
}



- (NSURLSession *)session
{
    if (nil == _session) {
        
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

#pragma mark -- NSURLSessionDownloadDelegate
/**
 *  下载完毕会调用
 *
 *  @param location     文件临时地址
 */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//didFinishDownloadingToURL:(NSURL *)location
//{
//    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
//    // response.suggestedFilename ： 建议使用的文件名，一般跟服务器端的文件名一致
//    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
//    
//    // 将临时文件剪切或者复制Caches文件夹
//    NSFileManager *mgr = [NSFileManager defaultManager];
//    
//    // AtPath : 剪切前的文件路径
//    // ToPath : 剪切后的文件路径
//    [mgr moveItemAtPath:location.path toPath:file error:nil];
//    NSLog(@"4");
//    // 提示下载完成
//    [[[UIAlertView alloc] initWithTitle:@"下载完成"
//                                message:downloadTask.response.suggestedFilename
//                               delegate:self
//                      cancelButtonTitle:@"知道了"
//                      otherButtonTitles: nil] show];
//
//}
///**
// *  每次写入沙盒完毕调用
// *  在这里面监听下载进度，totalBytesWritten/totalBytesExpectedToWrite
// *
// *  @param bytesWritten              这次写入的大小
// *  @param totalBytesWritten         已经写入沙盒的大小
// *  @param totalBytesExpectedToWrite 文件总大小
// */
//- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
//      didWriteData:(int64_t)bytesWritten
// totalBytesWritten:(int64_t)totalBytesWritten
//totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
//{
//    NSLog(@"12345");
//    self.myPregress.progress = (double)totalBytesWritten/totalBytesExpectedToWrite;
//    self.pgLabel.text = [NSString stringWithFormat:@"下载进度:%f",(double)totalBytesWritten/totalBytesExpectedToWrite];
//}



@end
