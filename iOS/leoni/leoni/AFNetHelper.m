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

    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
    }
    
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *ip = [dict objectForKey:@"ip"];
    NSString *port = [dict objectForKey:@"port"];
  
    return [ip stringByAppendingString:port];;
    
}

- (void)UpdateServerURLwithIP: (NSString *)ipString withProt: (NSString *)portString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
    }
    
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    [plistdict removeObjectForKey: @"ip"];
    [plistdict setObject:ipString forKey:@"ip"];
    
    [plistdict removeObjectForKey: @"port"];
    [plistdict setObject:portString forKey:@"port"];
   
    [plistdict writeToFile:plistPath atomically:YES];
    
    
}


- (NSMutableDictionary *)URLDictionary{
//    NSString *plist_path = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
//    NSMutableDictionary *url_dictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:plist_path];
//    return url_dictionary;
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        plistPath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
    }
    
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    return plistdict;
}

- (NSString *)login{
    NSString *server_url = [self ServerURL];
    NSString *login_url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"login"]];
    return [login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
