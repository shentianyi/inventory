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
        _db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    }
    return self;
}

/*
 下载所有抽盘数据
 */
- (void)webDownloadRandomCheckDatablock:(void(^)(NSMutableArray *, NSError *))block {
    AFNetHelper *afnet_helper = [[AFNetHelper alloc] init];
    AFHTTPRequestOperationManager *manager = [afnet_helper basicManager];

        [manager GET:[afnet_helper getRandomCheckData]
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@" log==== webDownloadRandomCheckDatablock====== %@", responseObject);
                 if([responseObject[@"result"] integerValue]== 1 ){
                     NSArray *arrayResult = responseObject[@"content"];
                     NSMutableArray *tableArray = [[NSMutableArray alloc] init];
                     for(int i=0; i<arrayResult.count; i++){
                         InventoryEntity *inventory =[[InventoryEntity alloc] initWithObject:arrayResult[i]];
                         [tableArray addObject: inventory];
                     }
                     if (block) {
                         block(tableArray, nil);
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
                     NSLog(error.description);
                     NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[NSString stringWithFormat:@"网络故障请联系管理员" ]];
                     block(nil, error);
                 }
             }
         
         ];
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

/*
 下载全盘数据
 ryan 2015.11.4
 */
- (void)webDownloadAllCheckDatablock:(void (^)(NSMutableArray *, NSError *))block {
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager GET:[self.afnet downloadCheckData]
       parameters:nil
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
             
            if([responseObject[@"result"] integerValue]== 1 ){
                NSArray *arrayResult = responseObject[@"content"];
                NSMutableArray *tableData = [[NSMutableArray alloc] init];
                for(int i=0; i<arrayResult.count; i++){
                    InventoryEntity *entity=[[InventoryEntity alloc] initWithObject:arrayResult[i]];
                    [tableData addObject:entity];
                }
                if (block) {
                      block(tableData, nil);
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

/*
 本地根据库位 查询 抽盘数据
 */
- (NSMutableArray *)localGetRandomCheckData: (NSString *)position {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where random_check_qty != '' order by random_check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and random_check_qty != ''order by random_check_time desc", position];
    }
//    NSLog(@"=== test query %@", query);
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
    
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    for (int i=0; i< [arrayData count]; i++) {
        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
        
        NSString *part = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part"]];
        
        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
        

        NSString *random_check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_qty"]];
        
        NSString *random_check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_user"]];
        
        NSString *random_check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_time"]];
        
        
        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
        //         NSString *ios_created_id = @"";
        NSString *idString = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"id"]];
        
        InventoryEntity *entity = [[InventoryEntity alloc] initDataWithPosition:position withDepartment:department withPart:part withPartType:part_type WithCheckQty:check_qty WithCheckUser:@"" WithCheckTime:@"" WithRandomCheckQty:random_check_qty WithRandomCheckUser:random_check_user WithRandomCheckTime:random_check_time WithiOSCreatedID:ios_created_id WithID:idString];
        
        
        
        [tableArray addObject:entity];
//        NSLog(@" numutable %d", [tableArray count]);
    }
    return tableArray;
}

/*
本地根据库位, 零件号查询记录
 */
- (NSMutableArray *)localGetDataByPosition: (NSString *)position ByPart: (NSString *)part {
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and part= '%@'", position, part];
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryString]];
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    for (int i=0; i< [arrayData count]; i++) {
        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
        
        NSString *part = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part"]];
        
        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
        if (check_qty == @"<null>") {
                        check_qty = @"";
        }
        check_qty = [NSString stringWithFormat:@"%@", check_qty];
        NSString *random_check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_qty"]];
        InventoryEntity *entity = [[InventoryEntity alloc] initWithPosition:position withDepartment:department withPart:part withPartType:part_type WithCheckQty:check_qty WithCheckUser:@"" WithCheckTime:@"" WithiOSCreatedID:@"" WithID:@""];

        [tableArray addObject:entity];

    }
    return tableArray;
}

/*
 本地根据库位查询记录
 */
// by position
- (NSMutableArray *)localGetDataByPosition: (NSString *)position{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@'", position];
    return [self getInventoryEnityListByQuery:queryString];
}

// by position and deparment
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and department='%@'", position,deparment];
    return [self getInventoryEnityListByQuery:queryString];
}


// by position and deparment and part
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment andPart:(NSString *)part{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and department='%@' and part='%@'", position,deparment,part];
    return [self getInventoryEnityListByQuery:queryString];
}

-(BOOL) updateCheckFields:(InventoryEntity *)entity{
    BOOL result=YES;
    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_local_check='%@' ,check_qty='%@', check_user='%@', check_time='%@' where inventory_id= '%@'",entity.is_local_check,entity.check_qty,entity.check_user,entity.check_time,entity.inventory_id];
    [self.db executeQuery:queryString];
    
    NSString *get=[NSString stringWithFormat:@"select * from inventories where inventory_id='%@' limit 1",entity.inventory_id];
    
    
  //  NSLog([self.db loadDataFromDB:get]);
    NSLog(@"after update......");
    
    return result;
}


// query base
-(NSMutableArray *)getInventoryEnityListByQuery:(NSString *)queryString{
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryString]];
    
    NSMutableArray *inventoryEntities = [[NSMutableArray alloc] init];
    for (int i=0; i< [arrayData count]; i++) {
        NSString *inventory_id=[[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"inventory_id"]];
        
        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
        
        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
        
        NSString *part = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part"]];
        
        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
        
        NSString *is_local_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_local_check"]];

        
        
        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
        if (check_qty == @"<null>") {
            check_qty = @"";
        }
        check_qty = [NSString stringWithFormat:@"%@", check_qty];
        
        
        
        NSString *check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_user"]];
        
        NSString *check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_time"]];
        
         NSString *is_local_random_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_local_random_check"]];
        
        
        NSString *random_check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_qty"]];
        
        if (random_check_qty == @"<null>") {
            random_check_qty = @"";
        }
        
        NSString *random_check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_user"]];
        
        NSString *random_check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_time"]];
        
    
        NSString *is_random_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_random_check"]];
        
        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
        
        InventoryEntity *entity = [[InventoryEntity alloc] initWithId:inventory_id WithPosition:position WithDepartment:department WithPart:part WithPartType:part_type WithIsLocalCheck:is_local_check WithCheckQty:check_qty WithCheckUser:check_user WithCheckTime:check_time WithIsLocalRandomCheck:is_local_random_check WithRandomCheckQty:random_check_qty WithRandomCheckUser:random_check_user WithRandomCheckTime:random_check_time WithIsRandomCheck:is_random_check WithiOSCreatedID:ios_created_id];
        
        NSLog(@"========= %@,%@, qty is %@, random_check_qty is %@",position, part, check_qty, random_check_qty);
        [inventoryEntities addObject:entity];
        //        NSLog(@" amount %d", [tableArray count]);
    }
    return inventoryEntities;
    
}

/*
 本地根据库位 update  check data记录
 */
- (NSString *)localUpdateDataByPosition: (InventoryEntity *)entity {
    NSString *queryString = [NSString stringWithFormat:@"update inventories set check_qty='%@', check_user='%@', check_time='%@' where position= '%@'", entity.check_qty, entity.check_user, entity.check_time, entity.position];
    [self.db executeQuery: queryString];
    return @"操作成功";
}


/*
 本地根据库位 update random check data记录
 */
- (NSString *)localUpdateRandomCheckDataByPosition: (InventoryEntity *)entity {
    NSString *queryString = [NSString stringWithFormat:@"update inventories set random_check_qty='%@', random_check_user='%@', random_check_time='%@' where position= '%@'", entity.random_check_qty, entity.random_check_user, entity.random_check_time, entity.position];
    [self.db executeQuery: queryString];
    return @"操作成功";
    
}

/*
 获取本地全盘数据
 */
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1' order by check_time desc", position];
    }
    return  [self getInventoryEnityListByQuery:query];
    
//    NSLog(@"=== test query %@", query);
//    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
//    
//    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
//    for (int i=0; i< [arrayData count]; i++) {
//        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
//        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
//        
//        NSString *part = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part"]];
//        
//        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
//        
//        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
//        
//        NSString *check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_user"]];
//        
//        NSString *check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_time"]];
//        
//        
//        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
////         NSString *ios_created_id = @"";
//        NSString *idString = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"id"]];
//        InventoryEntity *entity = [[InventoryEntity alloc] initWithPosition:position withDepartment:department withPart:part withPartType:part_type WithCheckQty:check_qty WithCheckUser:check_user WithCheckTime:check_time WithiOSCreatedID:ios_created_id WithID:idString];
////         NSLog(@"========= %@,%@,%@,%@,time:%@",position, department, check_qty, check_user, check_time);
//        [tableArray addObject:entity];
////       NSLog(@" numutable %d", [tableArray count]);
//    }
//    return tableArray;
}

/*
 获取本地抽盘数据
 */
- (NSMutableArray *)getRandomCheckDataWithPosition: (NSString *)position {
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where random_check_qty != '' order by random_check_time desc"];
//         query = [NSString stringWithFormat:@"select * from inventories where random_check_qty != '<null>' order by random_check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and random_check_qty != '' order by random_check_time desc", position];
//        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and random_check_qty != '<null>' order by random_check_time desc", position];
    }
//    NSLog(@"=== test query %@", query);
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
        NSString *random_check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_qty"]];
        NSString *random_check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_user"]];
        NSString *random_check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_time"]];
        
        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
        //         NSString *ios_created_id = @"";
        NSString *idString = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"id"]];
        InventoryEntity *entity = [[InventoryEntity alloc] initWithPosition:position withDepartment:department withPart:part withPartType:part_type WithCheckQty:check_qty WithCheckUser:check_user WithCheckTime:check_time WithiOSCreatedID:ios_created_id WithID:idString];
        //         NSLog(@"========= %@,%@,%@,%@,time:%@",position, department, check_qty, check_user, check_time);
        [tableArray addObject:entity];
        //       NSLog(@" numutable %d", [tableArray count]);
    }
    return tableArray;
}



- (BOOL)uploadCheckData: (InventoryEntity *)entity {

    __block BOOL boolResult = false;
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    InventoryEntity *inventory = [[InventoryEntity alloc] init];
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
                  
              }
              failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              }];
    return boolResult;
}

/*
 上传更新random check data
 */
- (BOOL)webUploadRandomCheckData: (InventoryEntity *)entity {
    __block BOOL boolResult = false;
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    InventoryEntity *inventory = [[InventoryEntity alloc] init];
    inventory = entity;
    [manager POST:[self.afnet uploadRandomCheckData]
       parameters:@{@"id" : inventory.inventory_id, @"random_check_qty" : inventory.random_check_qty, @"random_check_user" : inventory.random_check_user, @"random_check_time" :inventory.random_check_time}
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
              NSLog(@"log =========== webUploadRandomCheckData ========%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  boolResult = true;
              } else {
                  NSLog(@"log =========== webUploadRandomCheckData ========");
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"log =========== webUploadRandomCheckData ========%@", error.description);
          }];
    return boolResult;
}

/*
 获取抽盘数据 总页数，总条数
 */
- (void)getRandomTotal: (NSString *)pageSize block:(void (^)(NSInteger, NSError *))block {
    //    NSString *pageSizeString = @"2";
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager GET:[self.afnet getRandomTotal]
      parameters:@{@"per_page" : pageSize}
         success:^(AFHTTPRequestOperation * operation, id responseObject) {
//             NSLog(@"log =========  getTotal =======%@", responseObject);
             if([responseObject[@"result"] integerValue]== 1 ){
                 
                 NSInteger intTotal = 0;
                 intTotal = [responseObject[@"total_pages"] integerValue];
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



- (void)getTotal: (NSString *)pageSize block:(void (^)(NSInteger, NSError *))block  {
//- (void)getTotal: (NSString *)pageSize block:(void(^)(NSInteger intCount, NSError *error))block completion:(void(^)(BOOL finished))completion {
//    NSString *pageSizeString = @"2";
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager GET:[self.afnet getTotal]
      parameters:@{@"per_page" : pageSize}
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
//              NSLog(@"log =========  getTotal =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSInteger intTotal = 0;
                  intTotal = [responseObject[@"total_pages"] integerValue];
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
//          NSLog(@"log =========  getTotal =======%@", error.description);
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


- (void)webGetListWithPage:(NSInteger )page withPageSize: (NSString *)pageSize block:(void (^)(NSMutableArray *, NSError *))block {
    NSString *strPage = [NSString stringWithFormat:@"%ld", (long)page];
//    __block NSMutableArray *tableData = [[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager = [self.afnet basicManager];
    [manager GET:[self.afnet downloadCheckData]
       parameters:@{@"page": strPage, @"per_page": pageSize }
          success:^(AFHTTPRequestOperation * operation, id responseObject) {
//              NSLog(@"log =========  downloadCheckData =======%@", responseObject);
              if([responseObject[@"result"] integerValue]== 1 ){
                  NSArray *arrayResult = responseObject[@"content"];
                  NSMutableArray *tableData = [[NSMutableArray alloc] init];
//                  NSInteger count = responseObject[@"total_pages"];

                  for(int i=0; i<arrayResult.count; i++){
                      InventoryEntity *entity=[[InventoryEntity alloc] initWithObject:arrayResult[i]];
//                      NSLog(@"log webGetListWithPage ======  %@",entity.inventory_id);
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
        query = [NSString stringWithFormat:@"delete from inventories where position like '%%%@%%' ", strPosition];
    }
    
//    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
    [self.db executeQuery:query];
//    NSLog(@"=== test query %@", query);
    query = @"select * from inventories";
    
    NSArray *array = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: query]];
//    NSLog(@"current count is %d", [array count]);
}

/*
 本地创建全盘数据
 Ryan 2015.10.12
 */
- (void)localCreateCheckData: (InventoryEntity *)entity {
    //NSLog(@ "is local check %@",entity.is_local_check);
    
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    query = [NSString stringWithFormat:@"insert into inventories (inventory_id, department, position, part, part_type,is_local_check, check_qty, check_user, check_time, is_local_random_check,random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", entity.inventory_id, entity.department, entity.position, entity.part, entity.part_type,entity.is_local_check, entity.check_qty, entity.check_user, entity.check_time,entity.is_local_random_check, entity.random_check_qty, entity.random_check_user, entity.random_check_time, entity.is_random_check, entity.ios_created_id];
    
    [self.db executeQuery:query];
    if (self.db.affectedRows != 0) {
//        NSLog(@"======== success position %@=========", entity.position);
        
    }
    else {
//        NSLog(@"======== fail position %@=========", entity.position);
    }
    NSString *queryAll = [NSString stringWithFormat:@"select * from inventories"];
    NSString *queryRandom = [NSString stringWithFormat:@"select * from inventories where random_check_qty != '' order by random_check_time desc"];
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryAll]];
    NSArray *arrayRandom = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryRandom]];
//    NSLog(@"current count is %d, the random count is %d", [arrayData count], [arrayRandom count]);

}

///*
// 本地创建抽盘盘数据
// Ryan 2015.10.18
// */
//- (void)localCreateRandomCheckData: (InventoryEntity *)entity {
//    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
//    NSString *query;
//    //    NSString *uuid = [[NSUUID UUID] UUIDString];
//    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    //    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
//    //
//    //    if (self.recordIDToEdit == -1) {
//    query = [NSString stringWithFormat:@"insert into inventories (id, department, position, part, part_type, check_qty, check_user, check_time, random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id) values('%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", entity.inventory_id, entity.department, entity.position, entity.part, entity.part_type, entity.check_qty, entity.check_user, entity.check_time, entity.random_check_qty, entity.random_check_user, entity.random_check_time, entity.ios_created_id];
//    NSLog(@"===== query is %@", query);
//    [self.db executeQuery:query];
//    if (self.db.affectedRows != 0) {
//        NSLog(@"======== success position %@=========", entity.position);
//        
//    }
//    else {
//        NSLog(@"======== fail position %@=========", entity.position);
//    }
//}



/*
 本地查询 记录
 */
- (NSArray *)localGetData {
    NSString *queryAll = [NSString stringWithFormat:@"select * from inventories"];
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryAll]];
    NSLog(@"current count is %d", [arrayData count]);
    return  arrayData;
}

@end
