//
//  CheckViewController.h
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captuvo.h"
#import "InventoryModel.h"

@interface CheckViewController : UIViewController<UITextFieldDelegate, CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;
 
- (IBAction)checkAction:(id)sender;

@end
