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
@property (strong, nonatomic) UITextField *firstResponder;
-(void)clearAllTextFields;
-(void)clearTextFields:(NSArray *)textFields;
-(void) initTextFieldsWithInventoryEntity:(InventoryEntity *)inventoryEntity;
//@property (strong,nonatomic) NSString *inventory_id;
@property (strong,nonatomic) InventoryEntity *currentInventoryEntity;
@end

@implementation CheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    //[self.view addGestureRecognizer:tap];
    
    
}


//-(void)dismissKeyboard {
//    NSArray *subviews = [self.view subviews];
//    for (id objInput in subviews) {
//        if ([objInput isKindOfClass:[UITextField class]]) {
//            UITextField *theTextField = objInput;
//            if ([objInput isFirstResponder]) {
//                [theTextField resignFirstResponder];
//            }
//        }
//    }
//}


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
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
}

#pragma textField delegate
//disable keyboard
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField!=self.qtyTextField){
    UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    textField.inputView = dummyView;
        
    }else{
    
        CGRect frame = textField.frame;
        int offset = frame.origin.y + 32 - (self.view.frame.size.height - 216.0);//键盘高度216
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
        if(offset > 0)
            self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height);
        
        [UIView commitAnimations];
        
    }
    
    self.firstResponder=textField;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}


- (IBAction)clickScreen:(id)sender {
    [self.positionTextField becomeFirstResponder];
}


-(void)decoderDataReceived:(NSString *)data
{
    self.firstResponder.text=[data copy];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   
    hud.mode = MBProgressHUDModeText;

   hud.labelText = [NSString stringWithFormat:@"加载中..."];
    [hud hide:YES afterDelay:0.5f];
    
    if(self.firstResponder.text.length>0){
        [self textFieldShouldReturn:self.firstResponder];
    }
//if(self.firstResponder.tag)
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
  //  self.positionTextField.text = data;
    //[self validatePosition];
   // [self.positionTextField resignFirstResponder];
   // [self.qtyTextField becomeFirstResponder];
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

- (void)initController {
    self.positionTextField.delegate =self;
    [self.positionTextField becomeFirstResponder];
    
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.qtyTextField.delegate = self;
    
    self.partTypeTextField.enabled = NO;
    self.partTypeTextField.delegate =self;
    
    _inventory = [[InventoryModel alloc] init];
   // [self.inventory getListWithPosition:@""];
}


-(void) initTextFieldsWithInventoryEntity:(InventoryEntity *)inventoryEntity{
   // self.inventory_id=inventoryEntity.inventory_id;
    self.currentInventoryEntity=inventoryEntity;
    
    self.positionTextField.text=inventoryEntity.position;
    self.departmentTextField.text = inventoryEntity.department;
    self.partTextField.text = inventoryEntity.part;
    self.partTypeTextField.text = inventoryEntity.part_type;
    self.qtyTextField.text = inventoryEntity.check_qty;
     [self.qtyTextField becomeFirstResponder];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField!=self.qtyTextField){
        self.currentInventoryEntity=nil;
    }
    
    if (textField == self.positionTextField) {
        [self validatePosition];
    }else if(textField==self.departmentTextField){
        [self validateDepartment];
    }else if(textField==self.partTextField){
        [self validatePart];
    }else if(textField==self.qtyTextField){
        [self validateText];
    }
    
    [textField resignFirstResponder];
    
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


- (BOOL)validatePosition
{
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.departmentTextField,self.partTextField,self.partTypeTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    BOOL msgBool = false;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    getData = [self.inventory localGetDataByPosition:self.positionTextField.text];
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        hud.labelText = [NSString stringWithFormat:@"库位包含多零件，输入部门"];
        [hud hide:YES afterDelay:1.5];
        
        [self.departmentTextField becomeFirstResponder];
        
    } else if (countGetData == 0) {
        hud.labelText = [NSString stringWithFormat:@"不存在库位，手动录入"];
        [hud hide:YES afterDelay:1.5f];
        
        [self clearAllTextFields];
        [self.positionTextField becomeFirstResponder];
        
    } else if(countGetData == 1) {
        [self initTextFieldsWithInventoryEntity:getData.firstObject];
        [hud hide:YES];
        msgBool = true;
    }
    
    return msgBool;
}


-(BOOL)validateDepartment{
    BOOL msgBool=false;
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.partTextField,self.partTypeTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    if(self.positionTextField.text.length==0){
      hud.labelText=@"请输入库位号！";
        [hud hide:YES afterDelay:1.5f];
    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text];
        
        if(inventories.count==0){
            
            hud.labelText = [NSString stringWithFormat:@"不存在库位和部门，手动录入"];
            [self clearAllTextFields];
            
            [self.positionTextField becomeFirstResponder];
            
            [hud hide:YES afterDelay:1.5f];
        }else if(inventories.count>1){
            hud.labelText = [NSString stringWithFormat:@"库位和部门多个零件，输入零件"];
            [hud hide:YES afterDelay:1.5];
            
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
    
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.partTypeTextField,self.qtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDModeText;
    hud.labelText = @"加载中...";
    if(self.positionTextField.text.length==0 || self.departmentTextField.text==0){
        hud.labelText=@"请输入库位号和部门！";
        [hud hide:YES afterDelay:1.5f];
    }else{
        NSMutableArray *inventories=[self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text andPart:self.partTextField.text];
        
        if(inventories.count==0){
            
            hud.labelText = [NSString stringWithFormat:@"不存在数据，手动录入"];
            [self clearAllTextFields];
            [self.positionTextField becomeFirstResponder];
            [hud hide:YES afterDelay:1.5f];
        }else if(inventories.count>1){
            hud.labelText = [NSString stringWithFormat:@"系统数据问题，请联系管理员！"];
            [hud hide:YES afterDelay:10.5];
            
            [self.positionTextField becomeFirstResponder];
        }else{
            [self initTextFieldsWithInventoryEntity:inventories.firstObject];
            [hud hide:YES];
            msgBool = true;
        }
    }
    return  msgBool;
}


- (void)validateText {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if ([self.positionTextField.text length] >0) {
        if ([self.partTextField.text length] >0) {
           // if([self.partTypeTextField.text length] >0){
                if([self.departmentTextField.text length] >0){
                    if([self.qtyTextField.text length] >0){
                        [hud hide:YES afterDelay:1.5f];

                        if(self.currentInventoryEntity){
                           [self updateCheckData];
                            self.currentInventoryEntity=nil;
                        }else{
                            hud.labelText = @"不可提交，请输入数据";
                            [hud hide:YES afterDelay:1.5f];
                        }
                    }else{
                        hud.labelText = @"请输入全盘数量";
                        [hud hide:YES afterDelay:1.5f];
                        
                    }
                }else{
                    hud.labelText = @"请输入部门";
                    [hud hide:YES afterDelay:1.5f];
                }
//            }else{
//                hud.labelText = @"请输入类型";
//                [hud hide:YES afterDelay:1.5f];
//            }
            
        }else{
            hud.labelText = @"请输入零件号";
            [hud hide:YES afterDelay:1.5f];
        }
    } else{
        hud.labelText = @"请输入库位";
        [hud hide:YES afterDelay:1.5f];
        
    }
}


- (void)updateCheckData {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"加载中...";
    
    hud.mode = MBProgressHUDModeText;
    NSLog(@"qty.........%@",self.qtyTextField.text);
    
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
        self.currentInventoryEntity.check_user=[keyChain objectForKey:(__bridge  id)kSecAttrAccount];
        self.currentInventoryEntity.check_time=checkTime;
        
        
        if([inventory updateCheckFields:self.currentInventoryEntity]){
            
            hud.labelText = [NSString stringWithFormat:@"盘点成功"];
            [hud hide:YES afterDelay:1.5f];
            
            [self clearAllTextFields];
            
            [self.qtyTextField resignFirstResponder];
            [self.positionTextField becomeFirstResponder];
        }
        
    }
    else {
        hud.labelText = [NSString stringWithFormat:@"请输入全盘数量"];
        [hud hide:YES afterDelay:1.5f];
    }
}

- (IBAction)checkAction:(id)sender {
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
@end
