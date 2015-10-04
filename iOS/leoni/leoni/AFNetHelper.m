//
//  AFNetHelper.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "AFNetHelper.h"

@implementation AFNetHelper

- (instancetype)init{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (AFHTTPRequestOperationManager *)basicManager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    return manager;
}

- (NSString *)ServerURL{
    NSArray *document_dictionary = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *document = [document_dictionary firstObject];
//    NSString *path = [document stringByAppendingPathComponent:@"ip.address.archive"];
    NSString *ip = [[self URLDictionary] objectForKey:@"ip"];
    NSString *port = [[self URLDictionary] objectForKey:@"port"];
    
    return [ip stringByAppendingString:port];;
    
}


- (NSMutableDictionary *)URLDictionary{
    NSString *plist_path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
    NSMutableDictionary *url_dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plist_path];
    return url_dictionary;
}

- (NSString *)login{
    NSString *server_url = [self ServerURL];
    NSString *login_url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"login"]];
    return [login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
