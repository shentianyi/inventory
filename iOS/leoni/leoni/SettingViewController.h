//
//  SettingViewController.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetHelper.h"

@interface SettingViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
- (IBAction)backAction:(id)sender;
- (IBAction)saveAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *ipTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *requestTextField;
@property (nonatomic, retain) AFNetHelper *afnet_helper;
@end
