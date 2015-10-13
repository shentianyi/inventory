//
//  InventoryModel.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "InventoryModel.h"
#import "AFNetHelper.h"
#import "DBManager.h"

@interface InventoryModel()

@property (nonatomic, retain)DBManager *db;

@end

@implementation InventoryModel

- (instancetype)init {
    self = [super init];
    if (self) {
        _afnet = [[AFNetHelper alloc] init];
        _db = [[DBManager alloc] init];
    }
    return self;
}

- (void)queryWithPosition:(NSString *)positionString block:(void (^)(InventoryEntity *, NSError *))block {
    AFNetHelper *afnet_helper = [[AFNetHelper alloc] init];
    AFHTTPRequestOperationManager *manager = [afnet_helper basicManager];
    [manager GET:[afnet_helper query]
       parameters:@{@"position" : positionString}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSLog(@"query with position result %@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSArray *arrayResult = responseObject[@"content"];
                  
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

- (void)checkWithPosition: (NSString *)position WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *, NSError *))block {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager POST:[self.afnet check]
       parameters:@{@"position" : position, @"check_qty" : checkQty, @"check_user" : checkUser, @"check_time" :checkTime}
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"testing ========= checkWithPosition =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSString *msgString = responseObject[@"content"];
                  NSLog(@"testing ========= checkWithPosition =======%@", msgString);
                  if (block) {
                      block(msgString, nil);
                  }
              }
              else {
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
          }];
}

- (void)webRandomCheckWithPosition:(NSString *)position WithRandomCheckQty:(NSString *)randomCheckQty WithRandomCheckUser:(NSString *)randomCheckUser block:(void (^)(NSString *, NSError *))block {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager POST:[self.afnet randomCheckData]
       parameters:@{@"position" : position, @"random_check_qty" : randomCheckQty, @"random_check_user" : randomCheckUser, @"random_check_time" :checkTime}
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"testing ========= checkWithPosition =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSString *msgString = responseObject[@"content"];
                  NSLog(@"testing ========= checkWithPosition =======%@", msgString);
                  if (block) {
                      block(msgString, nil);
                  }
              }
              else {
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
              }];
}

- (void)createWithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType WithChcekQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *, NSError *))block{
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];

//    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into inventories (id, department, position, part, part_type, check_qty, check_user, check_time, random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id) values(null, '%@', '%@', '%@', '%@', '%@', '%@', '%@', null, null, null, null, '%@')", department, position, part, partType, checkQty, checkUser, checkTime, uuid];
    NSLog(@"===== query is %@", query);
        [self.db executeQuery:query];
        if (self.db.affectedRows != 0) {
//            NSLog(@"======== success =========");
            NSString *msgString = @"操作成功";
//            NSLog(@"testing ========= checkWithPosition =======%@", msgString);
            if (block) {
                block(msgString, nil);
            }
        }
        else {
            if (block) {
                NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo: @"操作失败"];
                block(nil, error);
            }
//            NSLog(@"========= failure ========");
        }
//    }else {
//        NSLog(@"somthing is happen");
//    }
}

- (NSMutableArray *)getListWithPosition: (NSString *)position {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' order by check_time desc", position];
    }
    NSLog(@"=== test query %@", query);
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
    
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    for (int i=0; i< [arrayData count]; i++) {
        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
        
        NSString *part = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part"]];
        
        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
        
        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
        
        NSString *check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_user"]];
        
        NSString *check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_time"]];
        
        
        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
//         NSString *ios_created_id = @"";
        NSString *idString = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"id"]];
        InventoryEntity *entity = [[InventoryEntity alloc] initWithPosition:position withDepartment:department withPart:part withPartType:part_type WithCheckQty:check_qty WithCheckUser:check_user WithCheckTime:check_time WithiOSCreatedID:ios_created_id WithID:idString];
         NSLog(@"========= %@,%@,%@,%@,time:%@",position, department, check_qty, check_user, check_time);
        [tableArray addObject:entity];
       NSLog(@" numutable %d", [tableArray count]);
    }
    return tableArray;
}


- (BOOL)uploadCheckData: (InventoryEntity *)entity {
//    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
//    tableArray = [self getListWithPosition:@""];
    __block BOOL boolResult = false;
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
//    NSInteger countInt = 0;
//    countInt = [tableArray count];
//    for (int i=0; i< [tableArray count]; i++) {
    InventoryEntity *inventory = [[InventoryEntity alloc] init];
//        inventory = tableArray[i];
    inventory = entity;
    [manager POST:[self.afnet uploadCheckData]
           parameters:@{@"id" : inventory.inventory_id, @"department" : inventory.department, @"position" : inventory.position, @"part" : inventory.part, @"part_type" : inventory.part_type, @"check_qty" : inventory.check_qty, @"check_user" : inventory.check_user, @"check_time" :inventory.check_time, @"ios_created_id" : inventory.ios_created_id}
              success:^(AFHTTPRequestOperation * operation, id responseObject) {
                  NSLog(@"testing ========= checkWithPosition =======%@", responseObject);
                  if([responseObject[@"result"] integerValue]== 1 ){
//                      NSString *msgString = responseObject[@"content"];
                      NSLog(@"========= upload =======%@", inventory.ios_created_id);
//                      
//                      if (block) {
//                          block(countInt, nil);
//                      }
                      boolResult = true;
                  }
//                  else {
//                      NSLog(@"=======error ios_created_id is %@", inventory.ios_created_id);
//                      NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:responseObject[@"content"]];
////                      if (block) {
////                          block(-1, error);
////                      }
//                  }
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                  
//                  if (block) {
//                      block(-1, error);
//                  }

              }];
    return boolResult;


}

- (void)getTotalBlock:(void (^)(NSInteger, NSError *))block {
    
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager GET:[self.afnet getTotal]
       parameters:nil
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"log =========  getTotal =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  
                  NSInteger intTotal = 0;
                  intTotal = [responseObject[@"content"] integerValue];
                  if (block) {
                      block(intTotal, nil);
                  }
                  
              }else {
                  if (block) {
                      block(-1, nil);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (block) {
                  block(-1, error);
              }
          NSLog(@"log =========  getTotal =======%@", error.description);
          }];
}

//- (NSInteger)getTotal {
//    int i = 0;
//    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
//    [manager GET:[self.afnet getTotal]
//      parameters:nil
//         success:^(AFHTTPRequestOperation * operation, id responseObject) {
//             if([responseObject[@"result"] integerValue]== 1 ){
//                 int intTotal = 0;
//                 intTotal = responseObject[@"content"];
//                 i = intTotal;
//            }
//         }
//         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//         }];
//}


- (void)webGetListWithPage:(NSInteger )page block:(void (^)(NSMutableArray *, NSError *))block {
    NSString *strPage = [NSString stringWithFormat:@"%ld", (long)page];
//    __block NSMutableArray *tableData = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager POST:[self.afnet downloadCheckData]
       parameters:@{@"page": strPage }
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"log =========  downloadCheckData =======%@", responseObject);
              
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSArray *arrayResult = responseObject[@"content"];
                  NSMutableArray *tableData = [[NSMutableArray alloc] init];
//                  NSInteger count = responseObject[@"total_pages"];

                  for(int i=0; i<arrayResult.count; i++){
                      InventoryEntity *entity=[[InventoryEntity alloc] initWithObject:arrayResult[i]];
                      [tableData addObject:entity];
                  }
                  if (block) {
                      block(tableData,nil);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              //                  if (block) {
              //                      block(-1, error);
              //                  }
              
          }];
//    return tableData;
}

- (void)downloadCheckData {
    
}

/*
 本地清空数据
 Ryan 2015.10.12

 */
- (void)localDeleteData: (NSString *)strPosition {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    if ([strPosition isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"delete from inventories"];
    }
    else {
        query = [NSString stringWithFormat:@"select from inventories where position like '%%%@%%' ", strPosition];
    }
    
//    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
    [self.db executeQuery:query];
    NSLog(@"=== test query %@", query);
}

/*
 本地创建全盘数据
 Ryan 2015.10.12
 */
- (void)localCreateCheckData: (InventoryEntity *)entity {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
//    NSString *uuid = [[NSUUID UUID] UUIDString];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
//    
    //    if (self.recordIDToEdit == -1) {
    query = [NSString stringWithFormat:@"insert into inventories (id, department, position, part, part_type, check_qty, check_user, check_time, random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", entity.inventory_id, entity.department, entity.position, entity.part, entity.part_type, entity.check_qty, entity.check_user, entity.check_time, entity.random_check_qty, entity.random_check_user, entity.random_check_time, entity.ios_created_id];
    NSLog(@"===== query is %@", query);
    [self.db executeQuery:query];
    if (self.db.affectedRows != 0) {
        NSLog(@"======== success position %@=========", entity.position);
        
    }
    else {
        NSLog(@"======== fail position %@=========", entity.position);
    }
}

@end
