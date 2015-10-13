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
    NSString *path = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
//        NSLog(@"===== testing YES");
        
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error: nil];
    }

//    NSLog(@"===== go testing YES");
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *ip = [dict objectForKey:@"ip"];
    NSString *port = [dict objectForKey:@"port"];
  
    return [ip stringByAppendingString:port];;
    
}

- (void)UpdateServerURLwithIP: (NSString *)ipString withProt: (NSString *)portString {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        NSLog(@"===== testing YES");

        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error: nil];
    }
    
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    [plistdict removeObjectForKey: @"ip"];
    [plistdict setObject:ipString forKey:@"ip"];
//    NSLog(@"===== testing %@", ipString);
    [plistdict removeObjectForKey: @"port"];
    [plistdict setObject:portString forKey:@"port"];
//   NSLog(@"===== testing %@", portString);
    [plistdict writeToFile:path atomically:YES];
    
    
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

- (NSString *)query {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"query"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

- (NSString *)check {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"check"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

- (NSString *)uploadCheckData {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"upload_check_data"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)getTotal {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"get_total"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}
- (NSString *)downloadCheckData {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"download_check_data"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)randomCheckData {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"random_check_data"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

@end
