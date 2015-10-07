//
//  CheckViewController.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "CheckViewController.h"
#import "MBProgressHUD.h"
#import "KeychainItemWrapper.h"

@interface CheckViewController ()

@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
//    NSArray *subviews = [self.view subviews];
//    for (id objInput in subviews) {
//        if ([objInput isKindOfClass:[UITextField class]]) {
//            UITextField *tmpTextFile = objInput;
//            if ([objInput isFirstResponder]) {
//                tmpTextFile.text = data;
//                [tmpTextFile resignFirstResponder];
////                [tmpTextFile.nextTextField becomeFirstResponder];
//                break;
//            }
//        }
//    }
    self.positionTextField.text = data;
}

- (void)initController {
    self.positionTextField.delegate =self;
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.qtyTextField.delegate = self;
    
    _inventory = [[InventoryModel alloc] init];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    if (textField == self.positionTextField) {
        NSLog(@"query asdf");
        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"加载中...";

        [self.inventory queryWithPosition:textField.text block:^(InventoryEntity *inventory_entity, NSError *error) {
            if (inventory_entity) {
                self.departmentTextField.text = inventory_entity.department;
                [self.departmentTextField setEnabled: NO];
                [self.departmentTextField resignFirstResponder];
                
                self.partTextField.text = inventory_entity.part;
                [self.partTextField setEnabled: NO];
                [self.partTextField resignFirstResponder];
                
                self.partTypeTextField.text = inventory_entity.part_type;
                [self.partTypeTextField setEnabled: NO];
                [self.partTypeTextField resignFirstResponder];

                [hud hide:YES];
                
            }
            else {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = [NSString stringWithFormat:@"%@", error.userInfo];
                [hud hide:YES afterDelay:1.5f];
            }

        }];
    }
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

- (IBAction)checkAction:(id)sender {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";

    if ([self isPureFloat:self.qtyTextField.text] || [self isPureInt:self.qtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        

        [inventory checkWithPosition:self.positionTextField.text WithCheckQty:self.qtyTextField.text WithCheckUser:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(NSString *msgString, NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"%@", msgString];
            [hud hide:YES afterDelay:1.5f];
            if (error) {
                
            }
            else {
                
                //                self.positionTextField.text = self.departmentTextField.text = self.partTextField.text = self.
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
