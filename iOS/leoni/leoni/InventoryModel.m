
///
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



- (void)createLocalDataWithSn:(NSInteger)sn WithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType WithPartUnit:(NSString *) partUnit WithWireNr:(NSString *)wireNr WithProcessNr:(NSString *)processNr WithChcekQty:(NSString *)checkQty WithCheckUser:(NSString *)checkUser block:(void (^)(NSString *, NSError *))block{
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *checkTime = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];

//    if (self.recordIDToEdit == -1) {
        query = [NSString stringWithFormat:@"insert into inventories (id,sn,is_local_check,is_check_synced,is_random_check_synced, department, position, part_nr, part_type,part_unit,wire_nr,process_nr, check_qty, check_user, check_time, random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id) values(null,%i,'1','0','0', '%@', '%@', '%@', '%@','%@', '%@','%@', '%@', '%@', '%@', null, null, null, null, '%@')",sn, department, position, part, partType,partUnit,wireNr,processNr, checkQty, checkUser, checkTime, uuid];
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
 获取本地全盘数据
 list & upload & count
 */

-(NSMutableArray *)searchLocalCheckDataList:(NSString *)q{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' order by check_time desc", q,[q integerValue],q];
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)searchLocalCheckDataList:(NSString *)q  WithUserNr:(NSString *)userNr;{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and check_user='%@' order by check_time desc", q,[q integerValue],q,userNr];
    return  [self getInventoryEnityListByQuery:query];
}


-(NSMutableArray *)searchLocalCheckUnSyncDataList:(NSString *)q{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1'  and is_check_synced='0' order by check_time desc", q,[q integerValue],q];
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)searchLocalCheckUnSyncDataList:(NSString *)q  WithUserNr:(NSString *)userNr;{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and is_check_synced='0' and check_user='%@' order by check_time desc", q,[q integerValue],q,userNr];
    return  [self getInventoryEnityListByQuery:query];
}


//包含全盘和录入的数据
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1' order by check_time desc", position];
    }
    return  [self getInventoryEnityListByQuery:query];
    
}


//包含全盘和录入的数据
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position WithUserNr:(NSString *)userNr {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' and check_user='%@' order by check_time desc",userNr];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1'  and check_user='%@'  order by check_time desc", position,userNr];
    }
    return  [self getInventoryEnityListByQuery:query];
}

- (NSMutableArray *)getAllLocalCheckDataListWithPosition: (NSString *)userNr{
    NSString *query;

    query = [NSString stringWithFormat:@"select * from inventories where check_qty = '' order by check_time desc"];

    return  [self getInventoryEnityListByQuery:query];
    
}

-(NSMutableArray *)getLocalCheckOrCreateUnsyncDataListWithUserNr:(NSString *)userNr {
    NSString *query= [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1'  and is_check_synced='0'   and check_user='%@' order by check_time desc",userNr];
    
    return  [self getInventoryEnityListByQuery:query];
}


//包含全盘数据
- (NSMutableArray *)getLocalCheckUnSyncDataListWithPosition: (NSString *)position {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' and is_check_synced='0' and (ios_created_id=='' or ios_created_id=='<null>') order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1'  and is_check_synced='0' and (ios_created_id=='' or ios_created_id=='<null>') order by check_time desc", position];
    }
    return  [self getInventoryEnityListByQuery:query];
    
}

//包含全盘的数据
- (NSMutableArray *)getLocalCheckUnSyncDataListWithPosition: (NSString *)position WithUserNr:(NSString *)userNr {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1'  and is_check_synced='0' and check_user='%@'  and (ios_created_id=='' or ios_created_id=='<null>') order by check_time desc",userNr];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != ''  and is_check_synced='0' and is_local_check='1'  and check_user='%@'  and (ios_created_id=='' or ios_created_id=='<null>')  order by check_time desc", position,userNr];
    }
    return  [self getInventoryEnityListByQuery:query];
}




-(NSMutableArray *)searchLocalCreateCheckDataList:(NSString *)q{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc", q,[q integerValue],q];
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)searchLocalCreateCheckDataList:(NSString *)q  WithUserNr:(NSString *)userNr;{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and (ios_created_id!='' and ios_created_id!='<null>') and check_user='%@' order by check_time desc", q,[q integerValue],q,userNr];
    return  [self getInventoryEnityListByQuery:query];
}


-(NSMutableArray *)searchLocalCreateCheckUnSyncDataList:(NSString *)q{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and is_check_synced='0'  and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc", q,[q integerValue],q];
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)searchLocalCreateCheckUnSyncDataList:(NSString *)q  WithUserNr:(NSString *)userNr{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and check_qty != '' and is_local_check='1' and is_check_synced='0'  and (ios_created_id!='' and ios_created_id!='<null>') and check_user='%@' order by check_time desc", q,[q integerValue],q,userNr];
    return  [self getInventoryEnityListByQuery:query];
}


-(NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position{
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1' and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc", position];
    }
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position WithUserNr:(NSString *)userNr{
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' and check_user='%@' and (ios_created_id!='' and ios_created_id!='<null>')  order by check_time desc",userNr];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1'  and check_user='%@' and (ios_created_id!='' and ios_created_id!='<null>')  order by check_time desc", position,userNr];
    }
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)getLocalCreateCheckUnSyncDataListWithPoistion:(NSString *)position{
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1'  and is_check_synced='0' and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1'  and is_check_synced='0' and (ios_created_id!='' and ios_created_id!='<null>') order by check_time desc", position];
    }
    return  [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)getLocalCreateCheckUnSyncDataListWithPoistion:(NSString *)position WithUserNr:(NSString *)userNr{
    NSString *query;
    if ([position isEqualToString:@""]) {
        query = [NSString stringWithFormat:@"select * from inventories where check_qty != '' and is_local_check='1' and is_check_synced='0' and check_user='%@' and (ios_created_id!='' and ios_created_id!='<null>')  order by check_time desc",userNr];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and check_qty != '' and is_local_check='1'   and is_check_synced='0' and check_user='%@' and (ios_created_id!='' and ios_created_id!='<null>')  order by check_time desc", position,userNr];
    }
    return  [self getInventoryEnityListByQuery:query];
}

/*
 本地根据库位 查询 抽盘数据
 */
// list and upload
-(NSMutableArray *)searchLocalRandomCheckDataList:(NSString *)q{
  NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and random_check_qty != ''  and is_local_random_check='1' order by random_check_time desc", q,[q integerValue],q];
    
    return [self getInventoryEnityListByQuery:query];
}

-(NSMutableArray *)searchLocalRandomCheckUnSyncDataList:(NSString *)q{
    NSString *query = [NSString stringWithFormat:@"select * from inventories where (position like '%%%@%%' or sn=%i or part_nr like '%%%@%%') and random_check_qty != ''  and is_local_random_check='1'  and is_random_check_synced='0' order by random_check_time desc", q,[q integerValue],q];
    
    return [self getInventoryEnityListByQuery:query];
}

- (NSMutableArray *)getLocalRandomCheckDataListWithPosition: (NSString *)position {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query =[NSString stringWithFormat:@"select * from inventories where random_check_qty != '' and is_local_random_check='1' order by random_check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and random_check_qty != ''  and is_local_random_check='1' order by random_check_time desc", position];
    }
    
    return [self getInventoryEnityListByQuery:query];
}

- (NSMutableArray *)getLocalRandomCheckUnSyncDataListWithPosition: (NSString *)position {
    NSString *query;
    if ([position isEqualToString:@""]) {
        query =[NSString stringWithFormat:@"select * from inventories where random_check_qty != '' and is_local_random_check='1'  and is_random_check_synced='0' order by random_check_time desc"];
    }
    else {
        query = [NSString stringWithFormat:@"select * from inventories where position like '%%%@%%' and random_check_qty != ''  and is_local_random_check='1'  and is_random_check_synced='0' order by random_check_time desc", position];
    }
    
    return [self getInventoryEnityListByQuery:query];
}




/*
 本地根据库位查询记录
 */
// by sn
- (NSMutableArray *)getListWithSn:(NSInteger)sn{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where sn=%i",sn];
    return [self getInventoryEnityListByQuery:queryString];
}

// by position
- (NSMutableArray *)getListWithPosition: (NSString *)position{
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
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and department='%@' and part_nr='%@'", position,deparment,part];
    return [self getInventoryEnityListByQuery:queryString];
}


-(NSMutableArray *)getRandomListWithSn:(NSInteger)sn{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where sn= %li and is_random_check = 'true'", (long)sn];
    return [self getInventoryEnityListByQuery:queryString];

}

// random by position
- (NSMutableArray *)getRandomListWithPosition: (NSString *)position{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and is_random_check='1'", position];
    return [self getInventoryEnityListByQuery:queryString];
}


// random by position and deparment
-(NSMutableArray *)getRandomListWithPosition:(NSString *)position andDepartment:(NSString *)deparment{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and department='%@'  and is_random_check='1'", position,deparment];
    return [self getInventoryEnityListByQuery:queryString];
}



// random by position and deparment and part
-(NSMutableArray *)getRandomListWithPosition:(NSString *)position andDepartment:(NSString *)deparment andPart:(NSString *)part{
    NSString *queryString = [NSString stringWithFormat:@"select * from inventories where position= '%@' and department='%@' and part_nr='%@'  and is_random_check='1'", position,deparment,part];
    return [self getInventoryEnityListByQuery:queryString];
}


-(BOOL) updateCheckFields:(InventoryEntity *)entity{
    BOOL result=YES;
    
//    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_local_check='%@' ,check_qty='%@', check_user='%@', check_time='%@' ,is_check_synced='%@' where inventory_id= '%@'",entity.is_local_check,entity.check_qty,entity.check_user,entity.check_time,entity.is_check_synced,entity.inventory_id];
//    // 如果是手动录入，可以更新
//    if([entity.inventory_id isEqualToString:@""] && [entity.is_local_check isEqualToString:@"1"] && ![entity.ios_created_id isEqualToString:@""] && entity.ios_created_id!=nil){
//      queryString=[NSString stringWithFormat:@"update inventories set is_local_check='%@' ,check_qty='%@', check_user='%@', check_time='%@',is_check_synced='%@' where ios_created_id= '%@'",entity.is_local_check,entity.check_qty,entity.check_user,entity.check_time,entity.is_check_synced,entity.ios_created_id];
//    }
    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_local_check='%@' ,check_qty='%@', check_user='%@', check_time='%@' ,is_check_synced='%@' where sn= %i",entity.is_local_check,entity.check_qty,entity.check_user,entity.check_time,entity.is_check_synced,entity.sn];
    
    [self.db executeQuery:queryString];

    return result;
}


-(BOOL) updateRandomCheckFields:(InventoryEntity *)entity{
    BOOL result=YES;
    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_local_random_check='%@' ,random_check_qty='%@', random_check_user='%@', random_check_time='%@',is_random_check_synced='%@' where sn= %i",entity.is_local_random_check,entity.random_check_qty,entity.random_check_user,entity.random_check_time,entity.is_random_check_synced,entity.sn];
    [self.db executeQuery:queryString];
    return result;
}

-(BOOL) updateCheckSync:(InventoryEntity *)entity{
    BOOL result=YES;
    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_check_synced='%@' where sn= %i",entity.is_check_synced,entity.sn];
    [self.db executeQuery:queryString];
    return result;
}


-(BOOL) updateRandomCheckSync:(InventoryEntity *)entity{
    BOOL result=YES;
    NSString *queryString=[NSString stringWithFormat:@"update inventories set is_random_check_synced='%@' where sn= %i",entity.is_random_check_synced,entity.sn];
    [self.db executeQuery:queryString];
    return result;
}

// query base
-(NSMutableArray *)getInventoryEnityListByQuery:(NSString *)queryString{
    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryString]];
    NSMutableArray *inventoryEntities = [[NSMutableArray alloc] init];
    for (int i=0; i< [arrayData count]; i++) {
        
        NSString *inventory_id=[[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"inventory_id"]];
        
        NSInteger sn=[[[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"sn"]] integerValue];
        
        NSString *position = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"position"]];
        
        NSString *department = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"department"]];
        
        NSString *part_nr = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_nr"]];
        
        NSString *part_type = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_type"]];
        
        
        NSString *part_unit= [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"part_unit"]];
        
        NSString *wire_nr= [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"wire_nr"]];

        NSString *process_nr= [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"process_nr"]];

        
        NSString *is_local_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_local_check"]];

        NSString *check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_qty"]];
        if ([check_qty isEqualToString: @"<null>"]) {
            check_qty = @"";
        }
        check_qty = [NSString stringWithFormat:@"%@", check_qty];
        
        NSString *check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_user"]];
        
        NSString *check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"check_time"]];
        
         NSString *is_local_random_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_local_random_check"]];
        
        
        NSString *random_check_qty = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_qty"]];
        
          NSLog(check_qty);
          NSLog(random_check_qty);
        if ([random_check_qty isEqualToString: @"<null>"]) {
            random_check_qty = @"";
        }
        
        random_check_qty = [NSString stringWithFormat:@"%@", random_check_qty];
        
        NSString *random_check_user = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_user"]];
        
        NSString *random_check_time = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"random_check_time"]];
        
    
        NSString *is_random_check = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_random_check"]];
        
        NSString *ios_created_id = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"ios_created_id"]];
        
        
        NSString *is_check_synced = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_check_synced"]];

        NSString *is_random_check_synced = [[arrayData objectAtIndex:i] objectAtIndex:[self.db.arrColumnNames indexOfObject:@"is_random_check_synced"]];

        
        InventoryEntity *entity = [[InventoryEntity alloc] initWithId:inventory_id WithSn:sn WithPosition:position WithDepartment:department WithPartNr:part_nr WithPartUnit:part_unit WithPartType:part_type WithWireNr:wire_nr WithProcessNr:process_nr WithIsLocalCheck:is_local_check WithCheckQty:check_qty WithCheckUser:check_user WithCheckTime:check_time WithIsLocalRandomCheck:is_local_random_check WithRandomCheckQty:random_check_qty WithRandomCheckUser:random_check_user WithRandomCheckTime:random_check_time WithIsRandomCheck:is_random_check WithiOSCreatedID:ios_created_id WithIsCheckSynced:is_check_synced WithIsRandomCheckSynced:is_random_check_synced];
        
        NSLog(@"%i========= %@,%@, qty is %@, random_check_qty is %@, %@",sn,position, part_nr, check_qty, random_check_qty,[random_check_qty isEqualToString:@"<null>"]);
        [inventoryEntities addObject:entity];
        
    }
    
    return inventoryEntities;
    
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
 创建本地全盘数据
 Ryan 2015.10.12
 */
- (void)localCreateCheckData: (InventoryEntity *)entity {
    //NSLog(@ "is local check %@",entity.is_local_check);
    
   // NSLog(@"======== success sn %i=========", entity.sn);
    
    self.db = [[DBManager alloc] initWithDatabaseFilename:@"inventorydb.sql"];
    NSString *query;
    query = [NSString stringWithFormat:@"insert into inventories (inventory_id,sn, department, position, part_nr, part_type,part_unit,wire_nr,process_nr,is_local_check, check_qty, check_user, check_time, is_local_random_check,random_check_qty, random_check_user, random_check_time, is_random_check, ios_created_id,is_check_synced,is_random_check_synced) values('%@','%i' ,'%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@')", entity.inventory_id,entity.sn, entity.department, entity.position, entity.part_nr, entity.part_type,entity.part_unit,entity.wire_nr,entity.process_nr,entity.is_local_check, entity.check_qty, entity.check_user, entity.check_time,entity.is_local_random_check, entity.random_check_qty, entity.random_check_user, entity.random_check_time, entity.is_random_check, entity.ios_created_id,entity.is_check_synced,entity.is_random_check_synced];
    
    [self.db executeQuery:query];
//    if (self.db.affectedRows != 0) {
//        NSLog(@"======== success sn %i=========", entity.sn);
//        
//    }
//    else {
//        NSLog(@"======== fail sn %i=========", entity.sn);
//    }
//    NSString *queryAll = [NSString stringWithFormat:@"select * from inventories"];
//    NSString *queryRandom = [NSString stringWithFormat:@"select * from inventories where random_check_qty != '' order by random_check_time desc"];
//    NSArray *arrayData = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryAll]];
//    NSArray *arrayRandom = [[NSArray alloc] initWithArray: [self.db loadDataFromDB: queryRandom]];
//    NSLog(@"current count is %d, the random count is %d", [arrayData count], [arrayRandom count]);

}


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
