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

@property (strong, nonatomic) UITextField *firstResponder;

@property (strong,nonatomic) InventoryEntity *currentInventoryEntity;
@property (nonatomic,retain) InventoryModel *inventory;

@property (strong,nonatomic) AFNetHelper *afnet;

- (IBAction)touchScreen:(id)sender;

@end

@implementation RandomCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[Captuvo sharedCaptuvoDevice] addCaptuvoDelegate:self];
    
    self.afnet=[[AFNetHelper alloc] init];
    
    [self clearAllTextFields];
    
    [self initController];
    
}




-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
    
}


-(void)decoderDataReceived:(NSString *)data
{
    
    self.firstResponder.text=[data copy];
    
    if(self.firstResponder.text.length>0){
        [self textFieldShouldReturn:self.firstResponder];
    }
}

- (void)initController {
    self.positionTextField.delegate =self;
    [self.positionTextField becomeFirstResponder];

    
    self.partTextField.delegate = self;
    
    self.departmentTextField.delegate = self;
    
    self.checkQtyTextField.delegate = self;
    self.randomCheckQtyTextField.delegate = self;
    
    self.partTypeTextField.enabled = NO;
    self.checkQtyTextField.enabled = NO;

    self.inventory = [[InventoryModel alloc] init];
}


-(void)clearAllTextFields{
    NSMutableArray *textFields=[[NSMutableArray alloc] init];
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            
            [textFields addObject:input];
        }
    }
    
    [self clearTextFields: textFields];
    [self.positionTextField becomeFirstResponder];
}

-(void)clearTextFields:(NSArray *)textFields{
    for (int i=0; i<textFields.count; i++) {
        ((UITextField *)textFields[i]).text=@"";
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField!=self.randomCheckQtyTextField){
        self.currentInventoryEntity=nil;
    }
    
    if (textField == self.positionTextField) {
        [self validatePosition];
    }else if(textField==self.departmentTextField){
        [self validateDepartment];
    }else if(textField==self.partTextField){
         [self validatePart];
    }else if(textField==self.randomCheckQtyTextField){
        [self validateText];
    }
    
    return YES;
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
// if([self.partTypeTextField.text length] >0){
                if([self.departmentTextField.text length] >0){
                    if([self.randomCheckQtyTextField.text length] >0 && ([self isPureFloat:self.randomCheckQtyTextField.text] || [self isPureInt:self.randomCheckQtyTextField.text])){
                        [hud hide:YES];
                        
                        if([self currentInventoryEntity]){
                            [self updateRandomCheckData];
                            self.currentInventoryEntity=nil;
                        }
                    }else{
                        if(self.firstResponder==self.randomCheckQtyTextField){
                            hud.yOffset=100;
                        }
                        
                        hud.labelText = @"请输入正确抽盘数量";
                        [hud hide:YES afterDelay:1.0f];
                        
                    }
                }else{
                    hud.labelText = @"请输入部门";
                    [hud hide:YES afterDelay:1.0f];
                }
//            }else{
//                hud.labelText = @"请输入类型";
//                [hud hide:YES afterDelay:1.0f];
//            }
            
        }else{
            hud.labelText = @"请输入零件号";
            [hud hide:YES afterDelay:1.0f];
        }
    } else{
        hud.labelText = @"请输入库位";
        [hud hide:YES afterDelay:1.0f];
        
    }
    
}

- (BOOL)validatePosition
{
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.departmentTextField,self.partTextField,self.partTypeTextField,self.checkQtyTextField,self.randomCheckQtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    BOOL msgBool = false;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    getData = [self.inventory localGetDataByPosition:self.positionTextField.text];
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        if([self.afnet defaultDepartment].length==0){
            hud.labelText = [NSString stringWithFormat:@"库位包含多零件，输入部门"];
            [hud hide:YES afterDelay:1.0f];
            
            [self.departmentTextField becomeFirstResponder];
        }else{
            self.departmentTextField.text=[self.afnet defaultDepartment];
            
            [self textFieldShouldReturn:self.departmentTextField];
            [hud hide:YES];
        }
        
    } else if (countGetData == 0) {
        hud.labelText = [NSString stringWithFormat:@"不存在库位，不可抽盘"];
        [hud hide:YES afterDelay:1.0f];
        
        [self clearAllTextFields];
        
    } else if(countGetData == 1) {
        [self initTextFieldsWithInventoryEntity:getData.firstObject];
        [hud hide:YES];
        msgBool = true;
    }
    
    return msgBool;
}

-(BOOL)validateDepartment{
    BOOL msgBool=false;
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.partTextField,self.partTypeTextField,self.checkQtyTextField,self.randomCheckQtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    if(self.positionTextField.text.length==0){
        hud.labelText=@"请输入库位号！";
        [hud hide:YES afterDelay:1.0f];
    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text];
        
        if(inventories.count==0){
            
            hud.labelText = [NSString stringWithFormat:@"不存在库位和部门，不可抽盘"];
            [self clearAllTextFields];
            [hud hide:YES afterDelay:1.0f];
        }else if(inventories.count>1){
            hud.labelText = [NSString stringWithFormat:@"库位和部门多个零件，输入零件"];
            [hud hide:YES afterDelay:1.0];
            
            [self.partTextField becomeFirstResponder];
        }else{
            [self initTextFieldsWithInventoryEntity:inventories.firstObject];
            [hud hide:YES];
            msgBool = true;
        }
    }
    return  msgBool;
}





-(BOOL)validatePart{
    BOOL msgBool=false;
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.partTypeTextField,self.checkQtyTextField,self.randomCheckQtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    if(self.positionTextField.text.length==0 || self.departmentTextField.text==0){
        hud.labelText=@"请输入库位号和部门！";
        [hud hide:YES afterDelay:1.0f];
    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text andPart:self.partTextField.text];
        
        if(inventories.count==0){
            
            hud.labelText = [NSString stringWithFormat:@"不存在数据，不可抽盘"];
            [self clearAllTextFields];
            
            [hud hide:YES afterDelay:1.0f];
        }else if(inventories.count>1){
            hud.labelText = [NSString stringWithFormat:@"系统数据问题，请联系管理员！"];
            [hud hide:YES afterDelay:2.5f];
            
            [self.positionTextField becomeFirstResponder];
        }else{
            [self initTextFieldsWithInventoryEntity:inventories.firstObject];
            [hud hide:YES];
            msgBool = true;
        }
    }
    return  msgBool;
}



- (IBAction)saveAtion:(id)sender {
    [self validateText];
}

- (void)updateRandomCheckData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // hud.labelText = @"加载中...";
    
    if ([self isPureFloat:self.randomCheckQtyTextField.text] || [self isPureInt:self.randomCheckQtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *randomCheckTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        
        
    self.currentInventoryEntity.is_local_random_check=@"1";
        self.currentInventoryEntity.random_check_qty=self.randomCheckQtyTextField.text;
        self.currentInventoryEntity.random_check_time=randomCheckTime;
        self.currentInventoryEntity.random_check_user=[keyChain objectForKey:(__bridge  id)kSecAttrAccount];

        if([inventory updateRandomCheckFields:self.currentInventoryEntity]){
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"抽盘成功"];
            [hud hide:YES afterDelay:0.5f];
            
            [self clearAllTextFields];
        }
    }
    else {
        hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"请输入正确抽盘数量"];
        [hud hide:YES afterDelay:1.0f];
    }
}

-(void) initTextFieldsWithInventoryEntity:(InventoryEntity *)inventoryEntity{
    self.currentInventoryEntity=inventoryEntity;
    
    self.positionTextField.text=inventoryEntity.position;
    self.departmentTextField.text = inventoryEntity.department;
    self.partTextField.text = inventoryEntity.part;
    self.partTypeTextField.text = inventoryEntity.part_type;
    self.checkQtyTextField.text = inventoryEntity.check_qty;
    self.randomCheckQtyTextField.text=inventoryEntity.random_check_qty;
    
    if(self.randomCheckQtyTextField.text.length==0){
        [self.randomCheckQtyTextField becomeFirstResponder];
    }
}


#pragma UITextField
#pragma textField delegate
//disable keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField!=self.randomCheckQtyTextField){
        UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        textField.inputView = dummyView;
        [self hideKeyboard];
    }else{
        
        CGRect frame=textField.frame;
        int offset=frame.origin.y-270;
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
        
    }
    self.firstResponder=textField;
}



- (IBAction)touchScreen:(id)sender {
    [self hideKeyboard];
    //[self  dismissKeyboard];
    [self.positionTextField becomeFirstResponder];
}

-(void)hideKeyboard{
    if(self.view.frame.origin.y!=0){
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    }
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


@end
