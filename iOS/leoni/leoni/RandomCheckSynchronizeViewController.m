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

@interface RandomCheckSynchronizeViewController ()
@property (nonatomic, strong) UIAlertView *downloadAlert;
@property (nonatomic, strong) UIAlertView *uploadAlert;
@property NSInteger integerCount;
@property (nonatomic, strong) NSString *page_size;
@property (nonatomic, retain) InventoryModel *model;
@property NSInteger totalInventories;
@property NSInteger countInventories;
@property (nonatomic, strong) NSMutableArray *downloadDataArray;
@property (nonatomic, strong) NSMutableArray *uploadDataArray;
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
    //    self.progressView.hidden = YES;
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    
    self.progressView.center = self.view.center;
    [self.view addSubview:self.progressView];
    [self.progressView setHidden:YES];
    self.integerCount = 0;
    self.model = [[InventoryModel alloc]init];
    
    self.totalInventories = 0;
    self.countInventories = 0;
    self.page_size = [NSString stringWithFormat:@"2"];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView == self.uploadAlert) {
        if(buttonIndex == 0){
            NSLog(@"0");
//            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadUpdateUI: ) userInfo:nil repeats:YES];
//            [self.progressView setHidden: NO];
            [self validateUser];
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



//- (void)uploadUpdateUI:(NSTimer *)timer
//{
//    InventoryModel *model = [[InventoryModel alloc] init];
//    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
//    tableArray = [model localGetRandomCheckData: @""];
//    
//    //    static int count =0; count++;
//    
//    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
//    NSInteger countInt = 0;
//    countInt = [tableArray count];
//    
//    if (countInt > 0) {
//       [hud hide:YES];
//        for (int i=0; i< [tableArray count]; i++) {
//            InventoryEntity *entity = tableArray[i];
//            [model webUploadRandomCheckData: entity];
//            self.progressView.progress = (float)i/countInt;
//        }
//    } else {
//        hud.labelText = @"当前无合适数据上传";
//
//        [hud hide:YES afterDelay:1.5f];
//    }
//    [self.myTimer invalidate];
//    self.myTimer = nil;
//    [self.progressView setHidden:YES];
//}

/*
 下载抽盘数据页数，以及总量
 Ryan 2015.10.27
 */

- (void)downloadRandomCheckData {
    
    [self.model getRandomTotal: self.page_size block:^(NSInteger intCount, NSError *error)  {
        if (intCount > 0) {
            self.integerCount = intCount;
            
            self.totalInventories = intCount * [self.page_size intValue];
            NSLog(@"total data is %d", self.totalInventories);
            [self.model localDeleteData:@""];
            if (self.integerCount >0) {
                [self.progressView setHidden: NO];
                for (int i=1; i<= self.integerCount; i++) {
                    [self updateRandomCheckDataPage:i withPageSize:self.page_size];
                }
                
            } else {
                NSLog(@"当前无下载数据更新");
            }
        }
        else {
            NSLog(@"testing ===   count < 0");
        }
    }];
}

/*
 下载抽盘数据
 Ryan 2015.10.27
 */
- (void)updateRandomCheckDataPage: (NSInteger)page withPageSize: (NSString *)pageSize {
    [self.model webGetRandomCheckData:page withPageSize:pageSize block:^(NSMutableArray *tableArray, NSError *error) {
        if ([tableArray count] > 0) {
            
            for (int i=0; i< [tableArray count]; i++) {
                //                InventoryEntity *entity = [[InventoryEntity alloc] initWithObject:tableArray[i]];
                InventoryEntity *entity = [[InventoryEntity alloc] init];
                entity = tableArray[i];
                //                NSLog(@"log === updateCheckDataPage entity.id %@", entity.inventory_id);
                [self.model localCreateCheckData:entity];
                self.countInventories++;
                self.progressView.progress = (float)self.countInventories/self.totalInventories;
                
                NSLog(@"log=============current count%d insert data%@ and page %d", self.countInventories, entity.inventory_id, page );
            }
        }
    }];
}

- (IBAction)downloadAction:(id)sender {
    [self.downloadAlert show];
}

- (IBAction)uploadAction:(id)sender {
    [self.uploadAlert show];

}

/*
 上传抽盘数据
 */
- (void)uploadRandomCheckData {
    self.uploadDataArray = [[NSMutableArray alloc] init];
    self.uploadDataArray = [self.model getLocalRandomCheckDataListWithPosition:@""];
//    NSLog(@"upload data %d", [self.uploadDataArray count]);
    [self.progressView setHidden: NO];
    self.progressView.progress = 0;
    if ([self.uploadDataArray count] >0) {
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(uploadUpdateUI:) userInfo:nil repeats:YES];
    } else {
        [self MessageShowTitle: @"系统提示" Content: @"当前无上载数据"];
        NSLog(@"当前无上载数据");
        [self.progressView setHidden: YES];
    }
}

/*
 上传更新进度条
 */
- (void)uploadUpdateUI:(NSTimer *)timer
{
    static int count = 0;
    InventoryEntity *entity = [[InventoryEntity alloc] init];
    entity = self.uploadDataArray[count];
    [self.model webUploadRandomCheckData:entity];
    count++;
    NSLog(@"the count is %d, the amout is %d", count, [self.uploadDataArray count]);
    
    self.progressView.progress = (float)count /[self.uploadDataArray count];
    if (count == [self.uploadDataArray count]) {
        NSString *messageString = [NSString stringWithFormat:@"已上传数据量为：%d", [self.uploadDataArray count]];
        [self.progressView setHidden:YES];
        count = 0;
        [self MessageShowTitle: @"系统提示" Content: messageString];
        [timer invalidate];
        
    }
}



/*
 下载抽盘数据
 */
- (void)downloadAllRandomCheckData {
    [self.model webDownloadRandomCheckDatablock:^(NSMutableArray *tableArray, NSError *error) {
        if (tableArray) {
            if ([tableArray count] > 0) {
                self.downloadDataArray = [[NSMutableArray alloc]init];
                [self.model localDeleteData:@""];
                [self.progressView setHidden: NO];
                for (int i = 0; i < [tableArray count]; i++) {
                    [self.downloadDataArray addObject:tableArray[i]];
                }
                [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(downloadUpdateUI:) userInfo:nil repeats:YES];
                
            }else{
                [self MessageShowTitle: @"系统提示" Content: @"当前无下载数据更新"];
                NSLog(@"当前无下载数据更新");
                
            }
        }else{
            [self MessageShowTitle: @"系统提示" Content: @"网络异常，请联系管理员"];
            NSLog(@"网络异常");
        }
        
    }];
}


/*
 下载更新进度条
 
 */
-(void)downloadUpdateUI:(NSTimer *) aTimer  {
    
    static int count = 0;
    InventoryEntity *entity = [[InventoryEntity alloc] init];
    entity = self.downloadDataArray[count];
    [self.model localCreateCheckData:entity];
    count++;
    NSLog(@"the count is %d, the amout is %d", count, [self.downloadDataArray count]);
    
    self.progressView.progress = (float)count /[self.downloadDataArray count];
    if (count == [self.downloadDataArray count]) {
        
        NSInteger counInteger = [[self.model localGetData] count];
        NSString *messageString = [NSString stringWithFormat:@"已下载数据量为：%d", counInteger];
        
        [self.progressView setHidden:YES];
        
        count = 0;
        [self MessageShowTitle: @"系统提示" Content: messageString];
        [aTimer invalidate];
        
    }
}

/*
 alert 提示方法
 */
- (void)MessageShowTitle: (NSString *)title Content: (NSString *)content {
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
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
    [user loginWithNr:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(UserEntity *user_entity, NSError *error) {
        
        if (user_entity) {
            [self uploadRandomCheckData];
        }else {
            [self MessageShowTitle: @"系统提示" Content: @"网络异常，请联系管理员"];
        }
    }];
    
}


@end
