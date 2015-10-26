//
//  RandomCheckViewController.m
//  leoni
//
//  Created by ryan on 10/13/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "RandomCheckViewController.h"
#import "InventoryModel.h"

@interface RandomCheckViewController ()
@property (nonatomic, retain) InventoryModel *inventory;
@property (nonatomic, retain) InventoryEntity *entity;
@end

@implementation RandomCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    self.entity = [[InventoryEntity alloc] init];
    
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
    self.positionTextField.text = data;
}

- (void)initController {
    self.positionTextField.delegate =self;
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.checkQtyTextField.delegate = self;
    self.randomCheckQtyTextField.delegate = self;
    
    _inventory = [[InventoryModel alloc] init];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self validatePosition];
    
//    if (textField == self.positionTextField) {
//        NSLog(@"query asdf");
//        __block MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"加载中...";
//        
//        [self.inventory queryWithPosition:textField.text block:^(InventoryEntity *inventory_entity, NSError *error) {
//            if (inventory_entity) {
//                self.departmentTextField.text = inventory_entity.department;
//                [self.departmentTextField setEnabled: NO];
////                [self.departmentTextField resignFirstResponder];
//                
//                self.partTextField.text = inventory_entity.part;
//                [self.partTextField setEnabled: NO];
////                [self.partTextField resignFirstResponder];
//                
//                self.partTypeTextField.text = inventory_entity.part_type;
//                [self.partTypeTextField setEnabled: NO];
////                [self.partTypeTextField resignFirstResponder];
//                
//                self.checkQtyTextField.text = [NSString stringWithFormat:@"%@", (inventory_entity.check_qty == NULL)? @"0": inventory_entity.check_qty];
////                NSLog(@"testing %@", inventory_entity.check_qty);
//                [self.checkQtyTextField setEnabled: NO];
////                [self.checkQtyTextField resignFirstResponder];
//                self.entity = inventory_entity;
//                NSLog(@"current ios_created_id %@", self.entity.ios_created_id);
//                
//                [hud hide:YES];
//                
//            }
//            else {
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = [NSString stringWithFormat:@"%@", error.userInfo];
//                [hud hide:YES afterDelay:1.5f];
//            }
//            
//        }];
//    }
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

//- (IBAction)saveAtion:(id)sender {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"加载中...";
//    
//    if ([self isPureFloat:self.randomCheckQtyTextField.text] || [self isPureInt:self.randomCheckQtyTextField.text]){
//        InventoryModel *inventory = [[InventoryModel alloc] init];
//        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
//        NSString *nameString = [keyChain objectForKey:(__bridge  id)kSecAttrAccount];
//        
//        

        
//        ******************
//        upload to server
//        ******************
        
        
//        [inventory webRandomCheckWithPosition:self.positionTextField.text WithRandomCheckQty:self.randomCheckQtyTextField.text WithRandomCheckUser:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(NSString *msgString, NSError *error) {
//           
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = [NSString stringWithFormat:@"%@", msgString];
//            [hud hide:YES afterDelay:1.5f];
//            if (error) {
//                
//            }
//            else {
//                
//                //                self.positionTextField.text = self.departmentTextField.text = self.partTextField.text = self.
//                NSArray *subviews = [self.view subviews];
//                for (id objInput in subviews) {
//                    if ([objInput isKindOfClass:[UITextField class]]) {
//                        UITextField *theTextField = objInput;
//                        theTextField.text = @"";
//                    }
//                }
//                [self.positionTextField isFirstResponder];
//            }
//        }];
        
        
        //        ******************
        //        save to local
        //        ******************
        
//        [self saveLocalData:nameString];
//        hud.labelText = [NSString stringWithFormat:@"操作成功"];
//        [hud hide:YES afterDelay:1.5f];
//
//        NSArray *subviews = [self.view subviews];
//        for (id objInput in subviews) {
//            if ([objInput isKindOfClass:[UITextField class]]) {
//                UITextField *theTextField = objInput;
//                theTextField.text = @"";
//            }
//        }
//        [self.positionTextField isFirstResponder];
//        
//    }
//    else {
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = [NSString stringWithFormat:@"请输入抽盘数量"];
//        [hud hide:YES afterDelay:1.5f];
//    }
//}
//
- (void)saveLocalData: (NSString *)nameString {
//    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *randomCheckTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    
    InventoryEntity *entityNew = [[InventoryEntity alloc] init];
    entityNew.department = self.departmentTextField.text;
    entityNew.position = self.positionTextField.text;
    entityNew.part = self.partTextField.text;
    entityNew.part_type = self.partTypeTextField.text;
    entityNew.check_qty = self.checkQtyTextField.text;
    entityNew.check_user = self.entity.check_user;
    entityNew.check_time = self.entity.check_time;
//    entityNew.check_time = randomCheckTime;

    entityNew.random_check_qty = self.randomCheckQtyTextField.text;
    entityNew.random_check_user = nameString;
    entityNew.random_check_time = randomCheckTime;
    entityNew.inventory_id = self.entity.inventory_id;
    entityNew.ios_created_id = [NSString stringWithFormat:@"%@", (self.entity.ios_created_id == NULL)? @"": self.entity.ios_created_id];
    entityNew.is_random_check = @"true";

    [self.inventory localCreateCheckData:entityNew];
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

- (void)validateText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if ([self.positionTextField.text length] >0) {
        if ([self.partTextField.text length] >0) {
            if([self.partTypeTextField.text length] >0){
                if([self.departmentTextField.text length] >0){
                    if([self.checkQtyTextField.text length] >0){
                        [hud hide:YES afterDelay:1.5f];
                        
                        if([self validatePosition]){
                            [self updateRandomCheckData];
                        }
                    }else{
                        hud.labelText = @"请输入全盘数量";
                        [hud hide:YES afterDelay:1.5f];
                        
                    }
                }else{
                    hud.labelText = @"请输入部门";
                    [hud hide:YES afterDelay:1.5f];
                }
            }else{
                hud.labelText = @"请输入类型";
                [hud hide:YES afterDelay:1.5f];
            }
            
        }else{
            hud.labelText = @"请输入零件号";
            [hud hide:YES afterDelay:1.5f];
        }
    } else{
        hud.labelText = @"请输入库位";
        [hud hide:YES afterDelay:1.5f];
        
    }
    
}

- (BOOL)validatePosition
{
    BOOL msgBool = false;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    getData = [self.inventory localGetDataByPosition:self.positionTextField.text];
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"此库位包含多个零件，请核对库位输入"];
        [hud hide:YES afterDelay:1.5f];
    } else if (countGetData == 0) {
        hud.mode = MBProgressHUDModeText;
        
        hud.labelText = [NSString stringWithFormat:@"不存在库位信息，不可以抽盘"];
        [hud hide:YES afterDelay:1.5f];
    } else if(countGetData == 1) {
        
        InventoryEntity *inventory_entity = (InventoryEntity *)getData[0];
        self.departmentTextField.text = inventory_entity.department;
        [self.departmentTextField setEnabled: NO];
        [self.departmentTextField resignFirstResponder];
        
        self.partTextField.text = inventory_entity.part;
        [self.partTextField setEnabled: NO];
        [self.partTextField resignFirstResponder];
        
        self.partTypeTextField.text = inventory_entity.part_type;
        [self.partTypeTextField setEnabled: NO];
        [self.partTypeTextField resignFirstResponder];
        
        self.checkQtyTextField.text = inventory_entity.check_qty?inventory_entity.check_qty:@"";
        [self.checkQtyTextField setEnabled: NO];

        
        [hud hide:YES];
        msgBool = true;
    }
    
    return msgBool;
}

- (IBAction)saveAtion:(id)sender {
    [self validateText];
}

- (void)updateRandomCheckData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    if ([self isPureFloat:self.randomCheckQtyTextField.text] || [self isPureInt:self.randomCheckQtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
        InventoryEntity *entity = [[InventoryEntity alloc] initRandomCheckDataWithPosition:self.positionTextField.text withDepartment:self.departmentTextField.text withPart:self.partTextField.text withPartType:self.partTypeTextField.text WithRandomCheckQty:self.randomCheckQtyTextField.text WithRandomCheckUser:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] WithRandomCheckTime:checkTime WithiOSCreatedID:@"" WithID:@""];
        
        NSString *messageString = [inventory localUpdateRandomCheckDataByPosition:entity];
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"%@", messageString];
        [hud hide:YES afterDelay:1.5f];
        NSArray *subviews = [self.view subviews];
        for (id objInput in subviews) {
            if ([objInput isKindOfClass:[UITextField class]]) {
                UITextField *theTextField = objInput;
                theTextField.text = @"";
            }
        }
        [self.checkQtyTextField resignFirstResponder];
        [self.positionTextField becomeFirstResponder];
        
        
    }
    else {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"请输入抽盘数量"];
        [hud hide:YES afterDelay:1.5f];
    }
}

@end
