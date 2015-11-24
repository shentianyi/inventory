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
- (void)UpdateServerURLwithIP: (NSString *)ipString withRequest: (NSString *)requestString withDeparment:(NSString *)deparment withPartPrefix:(NSString *)partPrefix;
- (NSString *)getRequestQuantity;
- (NSString *)defaultDepartment;
- (NSString *)partNrPrefix;
- (NSString *)login;
- (NSString *) downloadUserData;
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
