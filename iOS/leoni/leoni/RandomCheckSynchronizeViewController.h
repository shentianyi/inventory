//
//  RandomCheckSynchronizeViewController.h
//  leoni
//
//  Created by ryan on 10/17/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RandomCheckSynchronizeViewController : UIViewController
- (IBAction)downloadAction:(id)sender;
- (IBAction)uploadAction:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *randomDownloadButton;
@property (strong, nonatomic) IBOutlet UIButton *randomuploadButton;
@property (nonatomic, strong ) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *myTimer;

@end
