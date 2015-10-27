//
//  AFNetHelper.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

@interface AFNetHelper : NSObject

- (AFHTTPRequestOperationManager *)basicManager;
- (NSString *)ServerURL;
- (void)UpdateServerURLwithIP: (NSString *)ipString withProt: (NSString *)portString;
- (NSString *)login;
- (NSString *)query;
- (NSString *)check;
- (NSString *)uploadCheckData;
- (NSString *)getTotal;
- (NSString *)getRandomTotal;
- (NSString *)downloadCheckData;
- (NSString *)randomCheckData;
- (NSString *)getRandomCheckData;
- (NSString *)uploadRandomCheckData;
@end
