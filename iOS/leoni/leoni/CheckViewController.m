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
#import "AFNetHelper.h"
#import "UserModel.h"
#import "UserEntity.h"

@interface CheckViewController ()
@property (weak, nonatomic) IBOutlet UITextField *snTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *partUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *wireNrTextField;
@property (weak, nonatomic) IBOutlet UITextField *processNrTextField;


@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;

- (IBAction)checkAction:(id)sender;


@property (strong, nonatomic) UITextField *firstResponder;
-(void)clearAllTextFields;
-(void)clearTextFields:(NSArray *)textFields;
-(void) initTextFieldsWithInventoryEntity:(InventoryEntity *)inventoryEntity;
@property (strong,nonatomic) InventoryModel *inventory;
@property (strong,nonatomic) InventoryEntity *currentInventoryEntity;
@property (strong,nonatomic) UserEntity *currentUserEntity;

@property (strong,nonatomic) AFNetHelper *afnet;

- (IBAction)touchScreen:(id)sender;

@end

@implementation CheckViewController

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
    [self clearAllTextFields];
    [self initController];
    self.afnet=[[AFNetHelper alloc] init];
    
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

-(void)clearAllTextFields{
    NSMutableArray *textFields=[[NSMutableArray alloc] init];
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            [textFields addObject:input];
        }
    }
    
    [self clearTextFields: textFields];
    [self.snTextField becomeFirstResponder];
}

-(void)clearTextFields:(NSArray *)textFields{
    for (int i=0; i<textFields.count; i++) {
        ((UITextField *)textFields[i]).text=@"";
    }
}

- (void)initController {
    self.snTextField.delegate = self;
    self.positionTextField.delegate = self;
    //[self.positionTextField becomeFirstResponder];
    
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.qtyTextField.delegate = self;
    
    self.partUnitTextField.enabled = NO;
    self.partUnitTextField.delegate = self;
    self.partTypeTextField.enabled = NO;
    self.partTypeTextField.delegate = self;
    
    self.wireNrTextField.enabled = NO;
    self.wireNrTextField.delegate = self;
    self.processNrTextField.enabled = NO;
    self.processNrTextField.delegate = self;
    
    self.inventory = [[InventoryModel alloc] init];
    self.currentUserEntity=[[[UserModel alloc]init] findUserByNr:[UserModel accountNr]];
}


-(void) initTextFieldsWithInventoryEntity:(InventoryEntity *)inventoryEntity{
    self.currentInventoryEntity=inventoryEntity;
    self.snTextField.text=[NSString stringWithFormat:@"%i", inventoryEntity.sn];
    self.positionTextField.text=inventoryEntity.position;
    self.departmentTextField.text = inventoryEntity.department;
    self.partTextField.text = inventoryEntity.part_nr;
    self.partUnitTextField.text=inventoryEntity.part_unit;
    self.partTypeTextField.text = inventoryEntity.part_type;
    self.wireNrTextField.text=inventoryEntity.wire_nr;
    self.processNrTextField.text=inventoryEntity.process_nr;
    self.qtyTextField.text = inventoryEntity.check_qty;
    if(self.qtyTextField.text.length==0){
       [self.qtyTextField becomeFirstResponder];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField!=self.qtyTextField){
        self.currentInventoryEntity=nil;
    }
    if(textField==self.snTextField){
        [self validateSn];
    }else if (textField == self.positionTextField) {
        [self validatePosition];
    }else if(textField==self.departmentTextField){
        [self validateDepartment];
    }else if(textField==self.partTextField){
        [self validatePart];
    }else if(textField==self.qtyTextField){
        [self validateText];
    }
    
    return YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)validateSn
{
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.positionTextField,self.departmentTextField,self.partTextField,self.partTypeTextField,self.partUnitTextField,self.wireNrTextField,self.processNrTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    BOOL msgBool = false;
    
    NSInteger sn=[self.snTextField.text integerValue];
  
    
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    getData = [self.inventory getListWithSn:sn];
    
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        [self showMsg:[NSString stringWithFormat:@"不存在唯一码，请联系管理员"] WithTime:1.0f];
        [self clearAllTextFields];
    } else if (countGetData == 0) {
        [self showMsg:[NSString stringWithFormat:@"不存在唯一码，请联系管理员"] WithTime:1.0f];
        [self clearAllTextFields];
    } else if(countGetData == 1) {
        if(![self.currentUserEntity validateIdSpan:sn]){
//              [self showMsg:[NSString stringWithFormat:@"没有权限操作唯一码"] WithTime:1.0f];
//            [self clearAllTextFields];
            [self initTextFieldsWithInventoryEntity:getData.firstObject];
            msgBool = true;
     }else{
           [self initTextFieldsWithInventoryEntity:getData.firstObject];
           msgBool = true;
        }
    }
    
    return msgBool;
}

- (BOOL)validatePosition
{
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.snTextField,self.departmentTextField,self.partTextField,self.partTypeTextField,self.partUnitTextField,self.wireNrTextField,self.processNrTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    BOOL msgBool = false;
    
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    getData = [self.inventory getListWithPosition:self.positionTextField.text];
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        if([self.afnet defaultDepartment].length==0){
            [self showMsg:[NSString stringWithFormat:@"库位包含多零件，输入部门"] WithTime:1.0f];

            [self.departmentTextField becomeFirstResponder];
            }else{
                self.departmentTextField.text=[self.afnet defaultDepartment];
                
                 [self textFieldShouldReturn:self.departmentTextField];
            }
        
    } else if (countGetData == 0) {
        [self showMsg:[NSString stringWithFormat:@"不存在库位，手动录入"] WithTime:1.0f];
       [self clearAllTextFields];
        
    } else if(countGetData == 1) {
        [self initTextFieldsWithInventoryEntity:getData.firstObject];
        msgBool = true;
    }
    
    return msgBool;
}


-(BOOL)validateDepartment{
    BOOL msgBool=false;
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.snTextField,self.partTextField,self.partTypeTextField,self.partUnitTextField,self.wireNrTextField,self.processNrTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    
    if(self.positionTextField.text.length==0){
        [self showMsg:[NSString stringWithFormat:@"请输入库位号"] WithTime:1.0f];
    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text];
        
        if(inventories.count==0){
            [self showMsg:[NSString stringWithFormat:@"不存在库位和部门，手动录入"] WithTime:1.0f];
            [self clearAllTextFields];
            
        }else if(inventories.count>1){
            [self showMsg:[NSString stringWithFormat:@"库位和部门多个零件，输入零件"] WithTime:1.0f];

            [self.partTextField becomeFirstResponder];
        }else{
            [self initTextFieldsWithInventoryEntity:inventories.firstObject];
            msgBool = true;
        }
    }
    return  msgBool;
}



-(BOOL)validatePart{
    BOOL msgBool=false;
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.snTextField,self.partTypeTextField,self.partUnitTextField,self.wireNrTextField,self.processNrTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    
    if(self.positionTextField.text.length==0 || self.departmentTextField.text==0){
        [self showMsg:[NSString stringWithFormat:@"请输入库位号和部门"] WithTime:1.0f];

    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text andPart:self.partTextField.text];
        
        if(inventories.count==0){
            [self showMsg:[NSString stringWithFormat:@"不存在数据，手动录入"] WithTime:1.0f];
            [self clearAllTextFields];
        }else if(inventories.count>1){
            [self showMsg:[NSString stringWithFormat:@"系统数据问题，请联系管理员"] WithTime:1.0f];

            [self.positionTextField becomeFirstResponder];
        }else{
            [self initTextFieldsWithInventoryEntity:inventories.firstObject];
            msgBool = true;
        }
    }
    return  msgBool;
}


- (void)validateText {
    
    if([self.snTextField.text length]>0){
        if ([self.positionTextField.text length] >0) {
        if ([self.partTextField.text length] >0) {
           // if([self.partTypeTextField.text length] >0){
                if([self.departmentTextField.text length] >0){
                    if([self.qtyTextField.text length] >0 && ([self isPureFloat:self.qtyTextField.text] || [self isPureInt:self.qtyTextField.text])){
                        if(self.currentInventoryEntity){
                           [self updateCheckData];
                            self.currentInventoryEntity=nil;
                        }else{
//                            if(self.firstResponder==self.qtyTextField){
//                                hud.yOffset=100;
//                            }

                            [self showMsg:[NSString stringWithFormat:@"系统数据问题，请联系管理员"] WithTime:1.0f];
                        }
                    }else{
//                        if(self.firstResponder==self.qtyTextField){
//                            hud.yOffset=100;
//                        }
                        [self showMsg:[NSString stringWithFormat:@"请输入正确数量"] WithTime:1.0f];
                    }
                }else{
                    [self showMsg:[NSString stringWithFormat:@"请输入部门"] WithTime:1.0f];
                }
//            }else{
//                hud.labelText = @"请输入类型";
//                [hud hide:YES afterDelay:1.5f];
//            }
            
        }else{
            [self showMsg:[NSString stringWithFormat:@"请输入零件号"] WithTime:1.0f];
        }
    } else{
        [self showMsg:[NSString stringWithFormat:@"请输入库位"] WithTime:1.0f];
    }}else{
        [self showMsg:[NSString stringWithFormat:@"请输入唯一码"] WithTime:1.0f];
    }
}


- (void)updateCheckData {
    
    if ([self isPureFloat:self.qtyTextField.text] || [self isPureInt:self.qtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
        NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
 
//
        self.currentInventoryEntity.is_local_check=@"1";
        self.currentInventoryEntity.check_qty=self.qtyTextField.text;
        self.currentInventoryEntity.check_user=[UserModel accountNr];
        self.currentInventoryEntity.check_time=checkTime;
        self.currentInventoryEntity.is_check_synced=@"0";
        
        if(![self.currentUserEntity validateIdSpan:self.currentInventoryEntity.sn]){
//            [self showMsg:[NSString stringWithFormat:@"没有权限操作唯一码"] WithTime:1.0f];
//            [self clearAllTextFields];
            [self showMsg:[NSString stringWithFormat:@"盘点成功"] WithTime:0.5f];
            
            [self clearAllTextFields];
        }else{
            if([inventory updateCheckFields:self.currentInventoryEntity]){
                [self showMsg:[NSString stringWithFormat:@"盘点成功"] WithTime:0.5f];
                
                [self clearAllTextFields];
            }
        }
    }
    else {
//        if(self.firstResponder==self.qtyTextField){
//            hud.yOffset=100;
//        }
        
        [self showMsg:[NSString stringWithFormat:@"请输入正确数量"] WithTime:1.0f];
        [self.qtyTextField becomeFirstResponder];
    }
}


- (IBAction)checkAction:(id)sender {
    //  self.snTextField.text=@"4";
  //  self.qtyTextField.text=[NSString stringWithFormat:@"%i",arc4random_uniform(1000)];
   // [self textFieldShouldReturn:self.snTextField];
    
    [self validateText];
    

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

-(void) showMsg:(NSString *)msg WithTime:(float)time{
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    hud.mode = MBProgressHUDModeText;
    hud.labelText=msg;
    [hud hide:YES afterDelay:time];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud=nil;
}


#pragma textField delegate
//disable keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField!=self.qtyTextField){
        UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        textField.inputView = dummyView;
       [self hideKeyboard];
    }else{
        
        CGRect frame=textField.frame;
        int offset=frame.origin.y-210;
        NSTimeInterval animationDuration=0.30f;
        [UIView animateWithDuration:animationDuration
                         animations:^{
                             self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                         }];
    
    }
     self.firstResponder=textField;
}

- (IBAction)touchScreen:(id)sender {
   // [self  dismissKeyboard];
    
    [self hideKeyboard];
    [self.snTextField becomeFirstResponder];
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
