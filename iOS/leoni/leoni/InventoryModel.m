//
//  InventoryModel.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "InventoryModel.h"
#import "AFNetHelper.h"

@implementation InventoryModel

- (void)queryWithPosition:(NSString *)positionString block:(void (^)(InventoryEntity *, NSError *))block {
    AFNetHelper *afnet_helper = [[AFNetHelper alloc] init];
    AFHTTPRequestOperationManager *manager = [afnet_helper basicManager];
    [manager GET:[afnet_helper query]
       parameters:@{@"position" : positionString}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSArray *arrayResult = responseObject[@"content"];
                  NSLog(@"testing =========%@", responseObject);
                  for(int i=0; i<arrayResult.count; i++){
                      InventoryEntity *inventory =[[InventoryEntity alloc] initWithObject:arrayResult[i]];
                      if (block) {
                          block(inventory, nil);
                      }
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
              if (block) {
                  NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[NSString stringWithFormat:@"网络故障请联系管理员" ]];
                  block(nil, error);
              }
          }
     
     ];

}

@end
