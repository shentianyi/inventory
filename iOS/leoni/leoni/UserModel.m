//
//  UserModel.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "UserModel.h"
#import "AFNetHelper.h"

@implementation UserMoel

- (void)loginWithNr:(NSString *)nrString block:(void (^)(UserEntity *, NSError *))block{
//    NSString *NrString = nrString;
    AFNetHelper *afnet_helper = [[AFNetHelper alloc] init];
//    NSLog(@"======= testing");
    AFHTTPRequestOperationManager *manager = [afnet_helper basicManager];
    [manager POST:[afnet_helper login]
       parameters:@{@"name" : nrString}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//                  NSLog(@"======= testing%@", responseObject[@"result"]);
              if([responseObject[@"result"] integerValue]== 1 ){
                  UserEntity *user = [[UserEntity alloc] initWithNr:nrString];
                  if (block) {
                      block(user, nil);
                  }
              }
              else{
                  if (block) {
                      NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:responseObject[@"content"]];
                      block(nil, error);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"======= testing%@", error.description);
              if (block) {
//                  NSString *jsonString = [NSString stringWithFormat: @"{\"content\":网络故障请联系管理员}"];
//                  NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
//                  id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                  NSError *customError = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[dict objectForKey: @"content"]];
                 NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[NSString stringWithFormat:@"网络故障请联系管理员" ]];
                  
                  block(nil, error);
              }
          }
    
     ];
}

@end
