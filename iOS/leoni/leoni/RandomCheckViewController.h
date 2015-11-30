//
//  RandomCheckViewController.h
//  leoni
//
//  Created by ryan on 10/13/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomCheckViewController : UIViewController<UITextFieldDelegate, CaptuvoEventsProtocol,MBProgressHUDDelegate>{
    MBProgressHUD *hud;
}


@end
