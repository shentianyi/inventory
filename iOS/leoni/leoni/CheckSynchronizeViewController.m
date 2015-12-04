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


@property(nonatomic, strong) UIAlertView *downloadAlert;
@property(nonatomic, strong) UIAlertView *uploadAlert;

@property(nonatomic, strong) InventoryModel *inventoryModel;
@property(nonatomic) NSInteger *pageSize;
@property(nonatomic,strong) AFNetHelper *afnetHelper;

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
                          [self MessageShowTitle:@"下载提示" Content:[NSString stringWithFormat:@"共上传 %i",total]];
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
        hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate=self;
        //hud.mode =MBProgressHUDModeDeterminateHorizontalBar;
    
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
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         float progress=(pageIndex+1)/(float)totalPage;
                         NSLog(@"process: %f",progress);
                         hud.progress=progress;
                         if (progress<=1.0f) {
                             hud.labelText=[NSString stringWithFormat:@"已下载 %i%%    ", (int)round(progress*100)];
                         }
                         if((pageIndex+1)==totalPage){
                             [hud hide:YES];
                             [self MessageShowTitle:@"下载提示" Content:[NSString stringWithFormat:@"共下载 %i",total]];
                         }else{
                             [self callHttpDownload:pageIndex+1 WithTotalPage:totalPage WithTotal:total];
                         }
                     });
                 }
             } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
                 if([error.domain isEqualToString:NSURLErrorDomain]){
                     [self MessageShowTitle:@"系统提示"
                                    Content:@"未连接服务器，请联系管理员"];
                 }
                 [hud hide:YES];
             }];
    });
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

@end
