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


@interface CheckSynchronizeViewController ()
@property (nonatomic, strong) UIAlertView *downloadAlert;
@property (nonatomic, strong) UIAlertView *uploadAlert;
@property (nonatomic, strong) NSString *page_size;
@property (nonatomic, retain) InventoryModel *model;
@property NSInteger integerCount;
@property NSInteger totalInventories;
@property NSInteger countInventories;
@end

@implementation CheckSynchronizeViewController

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
    self.totalInventories = 0;
    self.countInventories = 0;
    self.page_size = [NSString stringWithFormat:@"2"];
    self.model = [[InventoryModel alloc] init];
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

- (IBAction)downloadAction:(id)sender {
    [self.downloadAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView == self.uploadAlert) {
        if(buttonIndex == 0){
            NSLog(@"0");
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadUpdateUI: ) userInfo:nil repeats:YES];
            [self.progressView setHidden: NO];
        }
        else if(buttonIndex == 1){
            NSLog(@"1");
        }
    } else {
        if(buttonIndex == 0){
            
//            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadUpdateUI:) userInfo:nil repeats:YES];
            [self downloadCheckData];
//            for (int i=0; i<100000; i++) {
//                [self.progressView setHidden: NO];
//                self.progressView.progress = (float)i/10;
//                NSLog(@"current is %d", i);
//            }
        }
    }
    
}



- (void)uploadUpdateUI:(NSTimer *)timer
{
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    tableArray = [self.model getListWithPosition:@""];

//    static int count =0; count++;
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    NSInteger countInt = 0;
    countInt = [tableArray count];
    if (countInt > 0) {
        [hud hide:YES afterDelay:1.5f];
        
        for (int i=0; i< [tableArray count]; i++) {
            InventoryEntity *entity =tableArray[i];
            [self.model uploadCheckData: entity];
            self.progressView.progress = (float)i/countInt;
        }
        [self.myTimer invalidate];
        self.myTimer = nil;

    }
    
}

- (void)downloadUpdateUI:(NSTimer *)timer
{
//    static int count =0; count++;
//    
//    if (count <=10)
//    {
//        self.progressView.progress = (float)count/10.0f;
//    } else
//    {
//        [self.myTimer invalidate];
//        self.myTimer = nil;
//    }
    
    [self downloadCheckData];
//    [self.myTimer invalidate];
//    self.myTimer = nil;
}

- (IBAction)uploadAction:(id)sender {
    [self.uploadAlert show];
}

- (void)downloadCheckData {
    
    [self.model getTotal: self.page_size block:^(NSInteger intCount, NSError *error) {
          if (intCount > 0) {
              self.integerCount = intCount;
              self.totalInventories = intCount * [self.page_size intValue];
              [self.model localDeleteData:@""];
//              NSLog(@"log === total is %d  self.integerCount %d", self.totalInventories, self.integerCount);
              if (self.integerCount >0) {
                  [self.progressView setHidden: NO];
                  for (int i=1; i<= self.integerCount; i++) {
                      [self updateCheckDataPage:i withPageSize:self.page_size];
//                      NSLog(@"current is %d", i);
                      
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

- (void)updateCheckDataPage: (NSInteger)page withPageSize: (NSString *)pageSize {
    [self.model webGetListWithPage:page withPageSize:pageSize block:^(NSMutableArray *tableArray, NSError *error) {
        if ([tableArray count] > 0) {
            for (int i=0; i< [tableArray count]; i++) {
                InventoryEntity *entity = [[InventoryEntity alloc] init];
                entity = tableArray[i];
                NSLog(@"log === updateCheckDataPage entity.id %@", entity.inventory_id);
                [self.model localCreateCheckData:entity];
                self.countInventories++;
                self.progressView.progress = (float)self.countInventories/self.totalInventories;
                
                NSLog(@"log=============current count%d insert data%@ and page %d", self.countInventories, entity.inventory_id, page );
            }
        }
    }];
}

@end
