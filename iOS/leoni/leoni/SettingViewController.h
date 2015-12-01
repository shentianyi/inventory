//
//  SettingViewController.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetHelper.h"

@interface SettingViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *hud;
}


@end
