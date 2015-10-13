//
//  RandomCheckViewController.h
//  leoni
//
//  Created by ryan on 10/13/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomCheckViewController : UIViewController<UITextFieldDelegate, CaptuvoEventsProtocol>
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;

@property (weak, nonatomic) IBOutlet UITextField *partTextField;
@property (weak, nonatomic) IBOutlet UITextField *departmentTextField;
@property (weak, nonatomic) IBOutlet UITextField *partTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *checkQtyTextField;
@property (weak, nonatomic) IBOutlet UITextField *randomCheckQtyTextField;
- (IBAction)saveAtion:(id)sender;

@end
