//
//  CheckCreateViewController.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckCreateViewController.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"

@interface CheckCreateViewController ()

@end

@implementation CheckCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    [self initController];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
}


-(void)decoderDataReceived:(NSString *)data
{
        NSArray *subviews = [self.view subviews];
        for (id objInput in subviews) {
            if ([objInput isKindOfClass:[UITextField class]]) {
                UITextField *tmpTextFile = objInput;
                if ([objInput isFirstResponder]) {
                    tmpTextFile.text = data;
                    [tmpTextFile resignFirstResponder];
    //                [tmpTextFile.nextTextField becomeFirstResponder];
                    break;
                }
            }
        }
}

- (void)initController {
    self.positionTextField.delegate =self;
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.checkQtyTextField.delegate = self;
    _inventory = [[InventoryModel alloc] init];
}

- (BOOL)validPosition:(UITextField *)textField
{
    __block BOOL validateStatus = FALSE;
    __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    [self.inventory queryWithPosition:textField.text block:^(InventoryEntity *inventory_entity, NSError *error) {
        if (inventory_entity) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"库位已存在，不可以手动录入"];
            [hud hide:YES afterDelay:1.5f];
            NSArray *subviews = [self.view subviews];
            for (id objInput in subviews) {
                if ([objInput isKindOfClass:[UITextField class]]) {
                    UITextField *theTextField = objInput;
                    theTextField.text = @"";
                }
            }
            
        }
        else {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"%@", error.userInfo];
            [hud hide:YES afterDelay:1.5f];
            validateStatus = TRUE;
        }
        
    }];
    return validateStatus;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.positionTextField) {
        [self validPosition:textField];
    }
    [textField resignFirstResponder];
    return NO;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveAction:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    if ([self isPureFloat:self.checkQtyTextField.text] || [self isPureInt:self.checkQtyTextField.text]){
//        if ([self validPosition:self.positionTextField]) {
            InventoryModel *inventory = [[InventoryModel alloc] init];
            KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
            [inventory createWithPosition:self.positionTextField.text WithPart:self.partTextField.text WithDepartment:self.departmentTextField.text WithPartType:self.partTypeTextField.text WithChcekQty:self.checkQtyTextField.text WithCheckUser: [keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(NSString *msgString, NSError *error){
                
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"%@", msgString];
                [hud hide:YES afterDelay:1.5f];
                if (error) {
                    
                }
                else {
                    NSArray *subviews = [self.view subviews];
                    for (id objInput in subviews) {
                        if ([objInput isKindOfClass:[UITextField class]]) {
                            UITextField *theTextField = objInput;
                            theTextField.text = @"";
                        }
                    }
                    [self.positionTextField isFirstResponder];
                }
            }];

//        }
//        else
//        {
//        
//        }
    }
    else {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"请输入全盘数量"];
        [hud hide:YES afterDelay:1.5f];
        
    }

}

- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

- (BOOL)isPureFloat:(NSString *)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
@end
