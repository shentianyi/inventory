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
#import "AFNetHelper.h"

@interface CheckCreateViewController ()
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partUnitTextField;

@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkQtyTextField;
- (IBAction)saveAction:(id)sender;
- (IBAction)clearInputAction:(id)sender;

@property (strong,nonatomic) AFNetHelper *afnet;
@property (strong,nonatomic) InventoryModel *inventory;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *trick;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cleanStartBI;

- (IBAction)touchScreen:(id)sender;

@end

@implementation CheckCreateViewController

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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[Captuvo sharedCaptuvoDevice] removeCaptuvoDelegate:self];
    [self.firstResponder resignFirstResponder];
    self.firstResponder=nil;
    if(self.firstResponder.text.length>0){
        [self textFieldShouldReturn:self.firstResponder];
    }
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
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.partTypeTextField.delegate=self;
    self.checkQtyTextField.delegate = self;
    self.afnet=[[AFNetHelper alloc]init];
   
    self.departmentTextField.text=[self.afnet defaultDepartment];
    
    self.inventory = [[InventoryModel alloc] init];
    
  //  [self.positionTextField becomeFirstResponder];
    
    
//    self.positionTextField.text=@"MBA";
//    self.departmentTextField.text=@"MB";
//    self.partTypeTextField.text=@"ff";
//    self.partTextField.text=@"T163";
//    self.checkQtyTextField.text=@"100";
}

-(void)clearAllTextFields{
    NSMutableArray *textFields=[[NSMutableArray alloc] init];
    for(id input in self.view.subviews){
        if([input isKindOfClass:[UITextField class]]){
            [textFields addObject:input];
        }
    }
    
    [self clearTextFields: textFields];
    
    self.departmentTextField.text=[self.afnet defaultDepartment];
    
   // [self.positionTextField becomeFirstResponder];
}

-(void)clearTextFields:(NSArray *)textFields{
    for (int i=0; i<textFields.count; i++) {
        ((UITextField *)textFields[i]).text=@"";
    }
}


- (BOOL)validatePosition
{
    BOOL msgBool = NO;
   
    
   // hud.labelText = @"加载中...";
        NSMutableArray *getData = [[NSMutableArray alloc] init];
    
    getData = [self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text andPart:self.partTextField.text];
    
    NSUInteger countGetData =[ getData count];
    
    if ( countGetData >0 ) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       hud.mode = MBProgressHUDModeText;
        hud.labelText = [NSString stringWithFormat:@"数据已存在，不可以手动录入"];
        [hud hide:YES afterDelay:1.0f];
    } else  {
       // [hud hide:YES];
        msgBool = YES;
    }
    
    return msgBool;
}


- (void)validateText {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    if ([self.positionTextField.text length] >0) {
        if ([self.partTextField.text length] >0) {
            if([self.partTypeTextField.text length] >0){
                if([self.departmentTextField.text length] >0){
                    if([self.checkQtyTextField.text length] >0 && ([self isPureFloat:self.checkQtyTextField.text] || [self isPureInt:self.checkQtyTextField.text])){
//
                        [hud hide:YES];
                        if ([self validatePosition]) {
                            
                            [self saveCheckData];
                            
                        }
                    }else{
                        if(self.firstResponder==self.checkQtyTextField){
                            hud.yOffset=100;
                        }
                        
                        hud.labelText = @"请输入全盘数量";
                        [hud hide:YES afterDelay:0.5f];

                    }
                }else{
                    hud.labelText = @"请输入部门";
                    [hud hide:YES afterDelay:0.5f];
                }
            }else{
                hud.labelText = @"请输入类型";
                [hud hide:YES afterDelay:0.5f];
            }
                
        }else{
            hud.labelText = @"请输入零件号";
            [hud hide:YES afterDelay:0.5f];
        }
    } else{
        hud.labelText = @"请输入库位";
        [hud hide:YES afterDelay:0.5f];

    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.checkQtyTextField) {
//        [self validPosition:textField];
        [self validateText];
    }else if(textField==self.positionTextField && self.positionTextField.text.length>0){
        if(self.departmentTextField.text.length>0){
            [self.partTypeTextField becomeFirstResponder];
        }else{
            [self.departmentTextField becomeFirstResponder];
        }
    }else if(textField==self.departmentTextField && self.departmentTextField.text.length>0){
        [self.partTypeTextField becomeFirstResponder];
    }else if(textField==self.partTypeTextField && self.partTypeTextField.text.length>0){
        [self.partTextField becomeFirstResponder];
    }else if(textField==self.partTextField && self.partTextField.text.length>0){
        [self.checkQtyTextField becomeFirstResponder];
    }
//    [textField resignFirstResponder];
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

- (IBAction)saveAction:(id)sender {
    [self validateText];
}

- (void)saveCheckData{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    if ([self isPureFloat:self.checkQtyTextField.text] || [self isPureInt:self.checkQtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        
       
        [inventory createWithPosition: self.positionTextField.text WithPart:self.partTextField.text WithDepartment:self.departmentTextField.text WithPartType:self.partTypeTextField.text WithChcekQty:self.checkQtyTextField.text WithCheckUser:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(NSString *msgString, NSError *error) {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [NSString stringWithFormat:@"%@", msgString];
            [hud hide:YES afterDelay:0.5f];
            if (error == nil) {
                [self hideKeyboard];
                [self clearAllTextFields];
                [self.positionTextField becomeFirstResponder];
            }
        }];
        
    }
    else {
        hud.labelText = [NSString stringWithFormat:@"请输入全盘数量"];
        [hud hide:YES afterDelay:1.0f];
    }
}

-(IBAction)clearInputAction:(id)sender{
    [self clearAllTextFields];
   // [self touchScreen:self.view];
   
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
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame=textField.frame;
    int offset=frame.origin.y;
    
    if(textField==self.partTypeTextField){
        offset=frame.origin.y-200;
    }else if(textField==self.partTextField){
        offset=frame.origin.y-150;
    }else if(textField==self.partTextField){
        offset=frame.origin.y-100;
    }
    if(offset!=frame.origin.y){
    NSTimeInterval animationDuration=0.30f;
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
    }
    self.firstResponder=textField;
    
    [self setCleanStartBTTitle];
}

- (IBAction)touchScreen:(id)sender {
    [self hideKeyboard];
    if(self.firstResponder){
        [self.view endEditing:YES];
        self.firstResponder=nil;
    }else{
        [self.view endEditing:NO];
        [self.positionTextField becomeFirstResponder];
    }
    //[self setCleanStartBTTitle];
}

-(void) setCleanStartBTTitle{
    if(self.firstResponder){
        self.cleanStartBI.title=@"清除";
    }else{
        self.cleanStartBI.title=@"开始";
    }
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
@end
