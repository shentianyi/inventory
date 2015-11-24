//
//  SetUserViewController.m
//  Inventory
//
//  Created by Charlot on 15/11/24.
//  Copyright © 2015年 IF. All rights reserved.
//

#import "SetUserViewController.h"
#import "KeychainItemWrapper.h"
#import "UserModel.h"
#import "UserEntity.h"

@interface SetUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userSpanIdTF;
@property (nonatomic,strong) NSString *nr;
@property (nonatomic,strong) UserModel *userModel;
@property (nonatomic,strong) UserEntity *user;
@end

@implementation SetUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initController];
}

-(void) initController{
    KeychainItemWrapper *keyChain=[[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
    NSString *nr=[keyChain objectForKey:(__bridge id)kSecAttrAccount];
      self.userModel=[[UserModel alloc]init];
      self.user=[self.userModel findUserByNr:nr];
    if(self.user){
        self.nr=self.user.nr;
        self.userSpanIdTF.text=self.user.idSpan;
    }
}

- (IBAction)saveUserSet:(id)sender {
    if(self.user){
        self.user.idSpan=self.userSpanIdTF.text;
        [self.userModel save:self.user];
    }
    
    [self backAction:sender];
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
