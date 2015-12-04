//
//  CheckCreateViewController.h
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Captuvo.h"
#import "InventoryModel.h"

@interface CheckCreateViewController : UIViewController<UITextFieldDelegate, CaptuvoEventsProtocol,UIPickerViewDataSource,UIPickerViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *hud;
    
    UIPickerView *myPickerView;
    UIToolbar *toolBar;
    NSArray *pickerArray;

}



@end
