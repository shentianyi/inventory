//
//  LoginViewController.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic, readwrite, retain) UserModel* user;
@end
