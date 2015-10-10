//
//  CheckSynchronizeViewController.h
//  leoni
//
//  Created by ryan on 10/10/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckSynchronizeViewController : UIViewController<UIAlertViewDelegate>
- (IBAction)downloadAction:(id)sender;
- (IBAction)uploadAction:(id)sender;
@property (nonatomic, strong ) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;
@end
