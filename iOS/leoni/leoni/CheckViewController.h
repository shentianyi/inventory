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

@interface CheckViewController : UIViewController<UITextFieldDelegate, CaptuvoEventsProtocol,MBProgressHUDDelegate>{
    MBProgressHUD *hud;
}

@end
