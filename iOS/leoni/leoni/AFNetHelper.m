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
    
    
    NSURL *baseUrl = [NSURL URLWithString:[self ServerURL]];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseUrl];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    
    // 开启检测
    [manager.reachabilityManager startMonitoring];

    
    // 检测网络情况
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"当前网络 WWAN可用");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"当前网络 WiFi 可用");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"当前网络不可用");
                break;
            default:
                break;
        }
        
    }];

//    if ([manager.reachabilityManager isReachableViaWWAN]){
//        NSLog(@"ok");
//    }else{
//        NSLog(@"no");
//    }
//    
//    if ([manager.reachabilityManager isReachableViaWiFi]){
//        NSLog(@"ok");
//    }else{
//        NSLog(@"no");
//    }
//    
//    if ([manager.reachabilityManager isReachable]){
//        NSLog(@"ok");
//    }else{
//        NSLog(@"no");
//    }
    
    
    return manager;
}

- (NSString *)ServerURL{

    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error: nil];
    }

    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *ip = [dict objectForKey:@"ip"];
   //NSString *port = [dict objectForKey:@"port"];
  
    return  ip;
    
}

- (void)UpdateServerURLwithIP: (NSString *)ipString withRequest: (NSString *)requestString withDeparment:(NSString *)department withPartPrefix:(NSString *)partPrefix{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error: nil];
    }
    
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    //[plistdict removeObjectForKey: @"ip"];
    [plistdict setObject:ipString forKey:@"ip"];
    //[plistdict removeObjectForKey: @"department"];
    [plistdict setObject:department forKey:@"department"];
    //[plistdict removeObjectForKey: @"request_quantity"];
    [plistdict setObject:requestString forKey:@"request_quantity"];
    //[plistdict removeObjectForKey:@"part_prefix"];
    [plistdict setObject:partPrefix forKey:@"part_prefix"];
    
   // [plistdict removeObjectForKey:@"list_limit_user"];
  //  [plistdict setValue: [NSNumber numberWithBool:listLimitUser] forKey:@"list_limit_user"];
    
    [plistdict writeToFile:path atomically:YES];
        
}

-(void) updateInventorySettingWithListLimitUser:(BOOL)listLimitUser{

    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *path = [documentsPath stringByAppendingPathComponent:@"server.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath: path error: nil];
    }
    
    NSMutableDictionary *plistdict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
     [plistdict setValue: [NSNumber numberWithBool:listLimitUser] forKey:@"list_limit_user"];
    
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

- (NSInteger *)getRequestQuantity {
    NSString *requestQuantity = [[self URLDictionary] objectForKey: @"request_quantity"];
    if(requestQuantity==nil ||
       requestQuantity.length==0){
        requestQuantity=@"200";
    }
    //return  [requestQuantity stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return [requestQuantity integerValue];
}

-(NSString *) defaultDepartment{
    NSString *defaultDepartment = [[self URLDictionary] objectForKey: @"department"];
    return  [defaultDepartment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *) partNrPrefix{
    NSString *partNrPrefix=[[self URLDictionary] objectForKey:@"part_prefix"];
    return [partNrPrefix stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(NSString *) secretKey{
    NSString *secretKey=[[self URLDictionary] objectForKey:@"secret_key"];
    return [secretKey stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(BOOL)listLimitUser{
NSString *listLimitUser=[[self URLDictionary] objectForKey:@"list_limit_user"];
  return  [listLimitUser boolValue];
}
- (NSString *)login{
    NSString *server_url = [self ServerURL];
    NSString *login_url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"login"]];
    return [login_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)downloadUserData{
    NSString *downloadUserDataUrl=[[self ServerURL] stringByAppendingString:[[self URLDictionary] objectForKey:@"download_user_data"]];
    
     
    return [downloadUserDataUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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

- (NSString *)uploadRandomCheckData {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"upload_random_check_data"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
}

- (NSString *)getTotal {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"get_total"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

- (NSString *)getRandomTotal {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"get_random_total"]];
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

- (NSString *)downloadRandomCheckData {
    NSString *server_url = [self ServerURL];
    NSString *url = [server_url stringByAppendingString: [[self URLDictionary] objectForKey:@"download_random_check_data"]];
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

}

@end
