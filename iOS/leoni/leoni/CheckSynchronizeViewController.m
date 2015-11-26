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

@interface CheckSynchronizeViewController ()
@property(nonatomic, strong) UIAlertView *downloadAlert;
@property(nonatomic, strong) UIAlertView *uploadAlert;
@property(nonatomic, strong) NSString *page_size;
@property(nonatomic, retain) InventoryModel *model;
@property NSInteger integerCount;
@property NSInteger totalInventories;
@property NSInteger countInventories;
@property NSMutableArray *requestDataArray;
@property NSMutableArray *uploadDataArray;
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
  self.integerCount = 0;
  self.totalInventories = 0;
  self.countInventories = 0;
  self.page_size = [NSString stringWithFormat:@"2"];
  self.model = [[InventoryModel alloc] init];
  self.requestDataArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

- (IBAction)downloadAction:(id)sender {
  [self.downloadAlert show];
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView == self.uploadAlert) {
    if (buttonIndex == 0) {
      [self validateUser];
    } else if (buttonIndex == 1) {
      NSLog(@"1");
    }
  } else if (alertView == self.downloadAlert) {
    if (buttonIndex == 0) {
      [self downloadAllCheckData];
    }
  } else {
  }
}
- (void)uploadCheckData {
  self.uploadDataArray = [[NSMutableArray alloc] init];
  self.uploadDataArray = [self.model getLocalCheckDataListWithPosition:@"" WithUserNr:[UserModel accountNr]];
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
  [self.model uploadCheckData:entity];
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

- (void)downloadUpdateUI:(NSTimer *)timer {
  [self downloadAllCheckData];
}

- (IBAction)uploadAction:(id)sender {
  [self.uploadAlert show];
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

- (void)downloadAllCheckData {
  [self.model webDownloadAllCheckDatablock:^(NSMutableArray *tableArray,
                                             NSError *error) {
    if (tableArray) {
      if ([tableArray count] > 0) {
          
          [self toggleButton:FALSE];
          [self.requestDataArray removeAllObjects];
          [self.model localDeleteData:@""];
          [self.progressView setHidden:NO];
          for (int i = 0; i < [tableArray count]; i++) {
              [self.requestDataArray addObject:tableArray[i]];
          }
          [NSTimer scheduledTimerWithTimeInterval:0.01
                                         target:self
                                       selector:@selector(countDown:)
                                       userInfo:nil
                                        repeats:YES];

      } else {
        [self MessageShowTitle:@"系统提示"
                       Content:@"当" @"前" @"无下载数据更" @"新"];
        NSLog(@"当前无下载数据更新");
      }
    } else {
      [self MessageShowTitle:@"系统提示"
                     Content:@"网" @"络" @"异常，请联系管理" @"员"];
      NSLog(@"网络异常");
    }

  }];
}

- (void)countDown:(NSTimer *)aTimer {

  static int count = 0;
  InventoryEntity *entity = [[InventoryEntity alloc] init];
  entity = self.requestDataArray[count];
  [self.model localCreateCheckData:entity];
  count++;
//  NSLog(@"the count is %d, the amout is %d", count,
//        [self.requestDataArray count]);

  self.progressView.progress = (float)count / [self.requestDataArray count];
  if (count == [self.requestDataArray count]) {
    //    if (count == [self.requestDataArray count]) {
    NSInteger counInteger = [[self.model localGetData] count];
    NSString *messageString =
        [NSString stringWithFormat:@"已下载数据量为：%ld", counInteger];
      [self toggleButton:TRUE];
    [self.progressView setHidden:YES];

    count = 0;
    [self MessageShowTitle:@"系统提示" Content:messageString];
    [aTimer invalidate];
  }
}

- (void)downloadCheckData {

  //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
  //    0),  ^{
  dispatch_group_t group = dispatch_group_create();
  dispatch_queue_t quene =
      dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

  dispatch_group_async(group, quene, ^{

    [self.model
        getTotal:self.page_size
           block:^(NSInteger intCount, NSError *error) {
             NSLog(@"group - %@", [NSThread currentThread]);
             if (error == nil) {
               if (intCount > 0) {
                 self.integerCount = intCount;
                 self.totalInventories = intCount * [self.page_size intValue];
                 [self.model localDeleteData:@""];
                 if (self.integerCount > 0) {
                   [self.progressView setHidden:NO];
                   for (int i = 1; i <= self.integerCount; i++) {
                     [self updateCheckDataPage:i withPageSize:self.page_size];
                   }

                 } else {
                   NSLog(@"当前无下载数据更新");
                 }
               }

             } else {
               [self MessageShowTitle:@"系统提示"
                              Content:@"网络异常，请联系管理员"];
               NSLog(@"网络异常");
             }

           }];
  });

  dispatch_group_notify(group, dispatch_get_main_queue(), ^{

    NSInteger counInteger = [[self.model localGetData] count];
    NSString *messageString =
        [NSString stringWithFormat:@"已下载数据量为：%d", counInteger];

    [self MessageShowTitle:@"系统提示" Content:messageString];
    NSLog(@"完成 - %@", [NSThread currentThread]);
  });

  //    });
}

- (void)MessageShowTitle:(NSString *)title Content:(NSString *)content {
  UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                    message:content
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
  [message show];
}

- (void)updateCheckDataPage:(NSInteger)page withPageSize:(NSString *)pageSize {
  [self.model webGetListWithPage:page
                    withPageSize:pageSize
                           block:^(NSMutableArray *tableArray, NSError *error) {
                             if ([tableArray count] > 0) {
                               for (int i = 0; i < [tableArray count]; i++) {
                                 InventoryEntity *entity =
                                     [[InventoryEntity alloc] init];
                                 entity = tableArray[i];
                                 [self.model localCreateCheckData:entity];
                                 self.countInventories++;
                                 self.progressView.progress =
                                     (float)self.countInventories /
                                     self.totalInventories;
                               }
                             }
                           }];
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

@end
