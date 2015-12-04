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
@property (weak, nonatomic) IBOutlet UITextField *snTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;

@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *partUnitTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkQtyTextField;

@property (weak, nonatomic) IBOutlet UITextField *wireNrTextField;
@property (weak, nonatomic) IBOutlet UITextField *processNrTextField;
 

- (IBAction)saveAction:(id)sender;
- (IBAction)clearInputAction:(id)sender;

@property (strong,nonatomic) AFNetHelper *afnet;
@property (strong,nonatomic) InventoryModel *inventory;
@property (strong, nonatomic) UITextField *firstResponder;
@property (weak, nonatomic) IBOutlet UILabel *trick;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cleanStartBI;

@property(nonatomic,strong) NSMutableArray *partTypes;

- (IBAction)touchScreen:(id)sender;

@end

@implementation CheckCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.partTypes=[[NSMutableArray alloc]initWithObjects:@"",@"U",
                    @"L",@"E",@"M",nil];
    [self addPickerView];
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
    self.snTextField.delegate=self;
    self.positionTextField.delegate =self;
    self.partTextField.delegate = self;
    self.departmentTextField.delegate = self;
    self.partTypeTextField.delegate=self;
    self.partUnitTextField.delegate=self;
    self.wireNrTextField.delegate=self;
    self.processNrTextField.delegate=self;
    
    self.checkQtyTextField.delegate = self;
    self.afnet=[[AFNetHelper alloc]init];
   
    self.departmentTextField.text=[self.afnet defaultDepartment];
    
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
    
    
   // [self.positionTextField becomeFirstResponder];
}

-(void)clearTextFields:(NSArray *)textFields{
    for (int i=0; i<textFields.count; i++) {
        ((UITextField *)textFields[i]).text=@"";
    }
    self.departmentTextField.text=[self.afnet defaultDepartment];
}


- (BOOL)validateSn:(BOOL)clean
{
    if(clean){
    NSMutableArray *clearTextFields= [NSMutableArray arrayWithObjects:self.positionTextField,self.departmentTextField,self.partTextField,self.partTypeTextField,self.partUnitTextField,self.wireNrTextField,self.processNrTextField,self.checkQtyTextField,nil];
    
    [self clearTextFields:clearTextFields];
  }
    BOOL msgBool = NO;
    
    NSInteger sn=[self.snTextField.text integerValue];
    
    if([self.snTextField.text integerValue]>0){
    NSMutableArray *getData = [[NSMutableArray alloc] init];
    // NSInteger sn=[self.snTextField.text integerValue];
    getData = [self.inventory getListWithSn:[self.snTextField.text integerValue]];
    NSUInteger countGetData =[ getData count];
    if ( countGetData >1) {
        [self showMsg:[NSString stringWithFormat:@"唯一码重复，请联系管理员"] WithTime:1.0f];

        [self clearAllTextFields];
    } else if (countGetData == 0) {
        msgBool = YES;
        [self.positionTextField becomeFirstResponder];
    } else if(countGetData == 1) {
        [self showMsg:[NSString stringWithFormat:@"唯一码已存在，不可录入"] WithTime:1.0f];

        [self clearAllTextFields];
    }}else{
        [self showMsg:[NSString stringWithFormat:@"唯一码只可以为正整数"] WithTime:1.0f];
        [self clearAllTextFields];
    }
    return msgBool;
}



- (BOOL)validatePosition
{
    BOOL msgBool = NO;
        NSMutableArray *getData = [[NSMutableArray alloc] init];
    
    getData = [self.inventory getListWithPosition:self.positionTextField.text andDepartment:self.departmentTextField.text andPart:self.partTextField.text];
    
    NSUInteger countGetData =[ getData count];
    
    if ( countGetData >0 ) {
        [self showMsg:[NSString stringWithFormat:@"数据已存在，不可以手动录入"] WithTime:1.0f];
    } else  {
        msgBool = YES;
    }
    
    return msgBool;
}


- (void)validateText {
    if([self.snTextField.text length]>0){
    if ([self.positionTextField.text length] >0) {
        
        if([self.departmentTextField.text length] >0){
            
        if ([self.partTextField.text length] >0) {
            if ([self.partUnitTextField.text length] >0) {

             if(self.partTypeTextField.text.length>0 && [self.partTypes containsObject: self.partTypeTextField.text]){
                 
                 if((![self.partTypeTextField.text isEqualToString:@"U"]) || ([self.partTypeTextField.text isEqualToString:@"U"] && self.wireNrTextField.text.length>0 && self.processNrTextField.text.length>0)){
                 
                        
                      if([self.checkQtyTextField.text length] >0 && ([self isPureFloat:self.checkQtyTextField.text] || [self isPureInt:self.checkQtyTextField.text])){
                        if ([self validateSn:NO] && [self validatePosition]) {
                              [self saveCheckData];
                          }
                      }else{
                         [self showMsg:[NSString stringWithFormat:@"请输入全盘数量"] WithTime:1.0f WithOffset:50.0f];
                    }
                  }else{
                      if(self.wireNrTextField.text.length==0){
                          [self showMsg:[NSString stringWithFormat:@"请输入线号"] WithTime:1.0f  WithOffset:50.f];
                      }else{
                          [self showMsg:[NSString stringWithFormat:@"请输步骤号"] WithTime:1.0f  WithOffset:50.f];
                      }
                  }
                }else{
                    
                    [self showMsg:[NSString stringWithFormat:@"请选择输入正确类型"] WithTime:1.0f  WithOffset:50.f];
                    
                }
            }else{
                [self showMsg:[NSString stringWithFormat:@"请输入单位"] WithTime:1.0f  WithOffset:50.f];
            }
            }else{
                [self showMsg:[NSString stringWithFormat:@"请输入零件号"] WithTime:1.0f  WithOffset:50.f];
            }
            
        }else{
            [self showMsg:[NSString stringWithFormat:@"请输入部门"] WithTime:1.0f  WithOffset:50.f];
        }
    } else{
        [self showMsg:[NSString stringWithFormat:@"请输入库位"] WithTime:1.0f  WithOffset:50.f];

    }
    }else{
        [self showMsg:[NSString stringWithFormat:@"请输入唯一码"] WithTime:1.0f  WithOffset:50.f];

    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.checkQtyTextField) {
        [self validateText];
    }else if(textField==self.snTextField && self.snTextField.text.length>0){
        [self validateSn:YES];
    }else if(textField==self.positionTextField && self.positionTextField.text.length>0){
        if(self.departmentTextField.text.length>0){
            [self.partTypeTextField becomeFirstResponder];
        }else{
            [self.departmentTextField becomeFirstResponder];
        }
    }else if(textField==self.departmentTextField && self.departmentTextField.text.length>0){
        [self.partTextField becomeFirstResponder];
    }else if(textField==self.partTextField && self.partTextField.text.length>0){
        [self.partUnitTextField becomeFirstResponder];
    }else if(textField==self.partUnitTextField){
        [self.partTypeTextField becomeFirstResponder];
    }else if(textField==self.partTypeTextField){
        [self.wireNrTextField becomeFirstResponder];
    }else if(textField==self.wireNrTextField){
        [self.processNrTextField becomeFirstResponder];
    }else if(textField==self.processNrTextField){
        [self.checkQtyTextField becomeFirstResponder];
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

- (IBAction)saveAction:(id)sender {
    [self validateText];
}

- (void)saveCheckData{
    if ([self isPureFloat:self.checkQtyTextField.text] || [self isPureInt:self.checkQtyTextField.text]){
        InventoryModel *inventory = [[InventoryModel alloc] init];
        KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
        NSInteger sn=[self.snTextField.text integerValue];
       
        [inventory createLocalDataWithSn:sn WithPosition: self.positionTextField.text WithPart:self.partTextField.text WithDepartment:self.departmentTextField.text WithPartType:self.partTypeTextField.text WithPartUnit:self.partUnitTextField.text WithWireNr:self.wireNrTextField.text WithProcessNr:self.processNrTextField.text WithChcekQty:self.checkQtyTextField.text WithCheckUser:[keyChain objectForKey:(__bridge  id)kSecAttrAccount] block:^(NSString *msgString, NSError *error) {

            if (error == nil) {
                [self hideKeyboard];
                [self clearAllTextFields];
                [self.snTextField becomeFirstResponder];
            }
        }];
        
    }
    else {
        [self showMsg:[NSString stringWithFormat:@"请输入正确数量"] WithTime:1.0f];
    }
}

-(IBAction)clearInputAction:(id)sender{
    [self clearAllTextFields];
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

-(void) showMsg:(NSString *)msg WithTime:(float)time WithOffset:(float) offset{
    
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate=self;
    hud.mode = MBProgressHUDModeText;
    hud.labelText=msg;
    hud.yOffset=offset;
    [hud hide:YES afterDelay:time];
}

-(void)hudWasHidden:(MBProgressHUD *)hud{
    [hud removeFromSuperview];
    hud=nil;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField==self.snTextField){
            UIView* dummyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
            textField.inputView = dummyView;
        
        [self hideKeyboard];
    }else{
           CGRect frame=textField.frame;
           int offset=frame.origin.y;
            if(textField==self.partTextField){
                   offset=frame.origin.y-180;
               }else if(textField==self.partUnitTextField){
                   offset=frame.origin.y-150;
               }else if(textField==self.partTypeTextField){
                   offset=frame.origin.y-140;
               }else if(textField==self.wireNrTextField){
                   offset=frame.origin.y-135;
               }else if(textField==self.processNrTextField){
                   offset=frame.origin.y-130;
               }else if(textField==self.checkQtyTextField){
                   offset=frame.origin.y-200;
               }
           if(offset!=frame.origin.y){
           NSTimeInterval animationDuration=0.30f;
           [UIView animateWithDuration:animationDuration
                     animations:^{
                         self.view.frame=CGRectMake(0, -offset, self.view.bounds.size.width, self.view.bounds.size.height);
                     }];
           }
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
        [self.snTextField becomeFirstResponder];
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


-(void)addPickerView{
    pickerArray = self.partTypes;
    
    self.partTypeTextField.delegate = self;
    
    myPickerView = [[UIPickerView alloc]init];
    
    myPickerView.dataSource = self;
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"OK" style:UIBarButtonItemStyleDone
                                   target:self action:@selector(pickerDoneClicked)];
     toolBar = [[UIToolbar alloc]initWithFrame:
                          CGRectMake(0, self.view.frame.size.height-
                                     myPickerView.frame.size.height-50, 320, 50)];
    [toolBar setBarStyle:UIBarStyleBlackOpaque];
    NSArray *toolbarItems = [NSArray arrayWithObjects:
                             doneButton, nil];
    [toolBar setItems:toolbarItems];
    self.partTypeTextField.inputView = myPickerView;
    self.partTypeTextField.inputAccessoryView = toolBar;
}

#pragma mark - Picker View Data source
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}




-(void)pickerDoneClicked
{
    //[self.partTypeTextField resignFirstResponder];
    [self.wireNrTextField becomeFirstResponder];
   // self.firstResponder=self.wireNrTextField;
   //toolBar.hidden=YES;
   // myPickerView.hidden=YES;
    
}


#pragma mark- Picker View Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:
(NSInteger)row inComponent:(NSInteger)component{
    [self.partTypeTextField setText:[pickerArray objectAtIndex:row]];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:
(NSInteger)row forComponent:(NSInteger)component{
    return [pickerArray objectAtIndex:row];
}

@end
