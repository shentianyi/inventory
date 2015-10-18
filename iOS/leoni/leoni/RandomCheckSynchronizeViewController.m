//
//  RandomCheckSynchronizeViewController.m
//  leoni
//
//  Created by ryan on 10/17/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomCheckSynchronizeViewController.h"
#import "InventoryModel.h"

@interface RandomCheckSynchronizeViewController ()
@property (nonatomic, strong) UIAlertView *downloadAlert;
@property (nonatomic, strong) UIAlertView *uploadAlert;
@property NSInteger integerCount;
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
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(uploadUpdateUI: ) userInfo:nil repeats:YES];
            [self.progressView setHidden: NO];
        }
        else if(buttonIndex == 1){
            NSLog(@"1");
        }
    } else {
        if(buttonIndex == 0){
            
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(downloadUpdateUI:) userInfo:nil repeats:YES];
            [self.progressView setHidden: NO];
            
        }
    }
    
}



- (void)uploadUpdateUI:(NSTimer *)timer
{
    InventoryModel *model = [[InventoryModel alloc] init];
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    tableArray = [model localGetRandomCheckData: @""];
    
    //    static int count =0; count++;
    
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    NSInteger countInt = 0;
    countInt = [tableArray count];
    
    if (countInt > 0) {
       [hud hide:YES];
        for (int i=0; i< [tableArray count]; i++) {
            InventoryEntity *entity = tableArray[i];
            [model webUploadRandomCheckData: entity];
            self.progressView.progress = (float)i/countInt;
        }
    } else {
        hud.labelText = @"当前无合适数据上传";

        [hud hide:YES afterDelay:1.5f];
    }
    [self.myTimer invalidate];
    self.myTimer = nil;
    [self.progressView setHidden:YES];
}

- (IBAction)downloadAction:(id)sender {
}

- (IBAction)uploadAction:(id)sender {
    [self.uploadAlert show];

}
@end
