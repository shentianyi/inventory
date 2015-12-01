//
//  InventoryEntity.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "InventoryEntity.h"

@implementation InventoryEntity



-(id) initWithId:(NSString *)inventory_id WithSn:(NSInteger)sn WithPosition:(NSString *)position WithDepartment:(NSString *)department WithPartNr:(NSString *)part_nr WithPartUnit:(NSString*)part_unit WithPartType:(NSString *)part_type WithIsLocalCheck:(NSString *)isLocalCheck WithCheckQty:(NSString *)checkQty WithCheckUser:(NSString *)checkUser WithCheckTime:(NSString *)checkTime WithIsLocalRandomCheck:(NSString *)isLocalRandomCheck WithRandomCheckQty:(NSString *)randomCheckQty WithRandomCheckUser:(NSString *)randomCheckUser WithRandomCheckTime:(NSString *)randomCheckTime WithIsRandomCheck:(NSString *)isRandomCheck WithiOSCreatedID:(NSString *)iOSCreatedId WithIsCheckSynced:(NSString *)isCheckSynced WithIsRandomCheckSynced:(NSString *)isRandomCheckSynced{
    self=[super init];
    
    if(self){
        self.inventory_id=inventory_id;
        self.sn=sn;
        self.position=position;
        self.department=department;
        self.part_nr=part_nr;
        self.part_type=part_type;
        self.part_unit=part_unit;
        self.is_local_check=isLocalCheck;
        self.check_qty=checkQty;
        self.check_user=checkUser;
        self.check_time=checkTime;
        self.is_local_random_check=isLocalRandomCheck;
        self.random_check_qty=randomCheckQty;
        self.random_check_user=randomCheckUser;
        self.random_check_time=randomCheckTime;
        self.is_random_check=isRandomCheck;
        
        self.ios_created_id=iOSCreatedId;
        
        self.is_check_synced=isCheckSynced;
        self.is_random_check_synced=isRandomCheckSynced;
    }
    return self;
  
}


- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part_nr withPartType: (NSString *)part_type {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part_nr = part_nr;
        self.part_type = part_type;
    }
    return self;
}

- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part_nr withPartType: (NSString *)part_type WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser WithCheckTime: (NSString *)checkTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID:(NSString *)idString {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part_nr = part_nr;
        self.part_type = part_type;
        self.check_qty = checkQty;
        self.check_user = checkUser;
        self.check_time = checkTime;
        self.ios_created_id = iOSCreatedId;
        self.inventory_id = idString;

    }
    return self;
}

- (id)initRandomCheckDataWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part_nr withPartType: (NSString *)part_type WithRandomCheckQty: (NSString *)randomCheckQty WithRandomCheckUser: (NSString *)randomCheckUser WithRandomCheckTime: (NSString *)randomCheckTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID:(NSString *)idString {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part_nr = part_nr;
        self.part_type = part_type;
        self.random_check_qty = randomCheckQty;
        self.random_check_user = randomCheckUser;
        self.random_check_time = randomCheckTime;
        self.ios_created_id = iOSCreatedId;
        self.inventory_id = idString;
        
    }
    return self;
}

/*
 初始全数据
 */
- (id)initDataWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part_nr withPartType: (NSString *)part_type WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser WithCheckTime: (NSString *)checkTime WithRandomCheckQty: (NSString *)randomCheckQty WithRandomCheckUser: (NSString *)randomCheckUser WithRandomCheckTime: (NSString *)randomCheckTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID:(NSString *)idString {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part_nr = part_nr;
        self.part_type = part_type;
        self.check_qty = checkQty;
        self.check_user = checkUser;
        self.check_time = checkTime;
        self.random_check_qty = randomCheckQty;
        self.random_check_user = randomCheckUser;
        self.random_check_time = randomCheckTime;
        self.ios_created_id = iOSCreatedId;
        self.inventory_id = idString;
        
    }
    return self;
}


-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.inventory_id = dictionary[@"id"]?dictionary[@"id"]:@"";
        self.sn= [dictionary[@"sn"] integerValue];
       // NSLog(@"sn.........:%i",self.sn);
        self.position = dictionary[@"position"]?dictionary[@"position"]:@"";
        self.department = dictionary[@"department"]?dictionary[@"department"]:@"";
        self.part_nr = dictionary[@"part_nr"]?dictionary[@"part_nr"]:@"";
        self.part_type = dictionary[@"part_type"]?dictionary[@"part_type"]:@"";
        self.part_unit= dictionary[@"part_unit"]?dictionary[@"part_unit"]:@"";

//        self.check_qty = [NSString stringWithFormat:@"%@", dictionary[@"check_qty"]];
//        if ([self.check_qty isEqualToString:@"<null>"]) {
//            self.check_qty = @"";
//        }
        id checkQty = dictionary[@"check_qty"];
        self.check_qty = @"";
        if (checkQty != [NSNull null]){
           self.check_qty = (NSString *)checkQty;
        }
        self.check_user = dictionary[@"check_user"]?dictionary[@"check_user"]:@"";
        self.check_time = dictionary[@"check_time"]?dictionary[@"check_time"]:@"";
        
        id randomCheckQty = dictionary[@"random_check_qty"];
        self.random_check_qty = @"";
        if (checkQty != [NSNull null]){
            self.random_check_qty = (NSString *)randomCheckQty;
        }
        self.random_check_user = dictionary[@"random_check_user"]?dictionary[@"random_check_user"]:@"";
        self.random_check_time = dictionary[@"random_check_time"]?dictionary[@"random_check_time"]:@"";
        self.ios_created_id = dictionary[@"ios_created_id"]?dictionary[@"ios_created_id"]:@"";
        self.is_random_check = dictionary[@"is_random_check"]?dictionary[@"is_random_check"]:@"";
        
//        NSLog(@"the check qty %@", self.check_qty);

    }
    return self;
}

-(NSString *) is_local_check{
    if (!_is_local_check) _is_local_check=@"0";
        return _is_local_check;
}

-(NSString *) is_local_random_check{
    if (!_is_local_random_check) _is_local_random_check=@"0";
        return _is_local_random_check;
}

-(NSString *)is_check_synced{
 if(!_is_check_synced) _is_check_synced=@"0";
    return _is_check_synced;
}

-(NSString *)is_random_check_synced{
 if(!_is_random_check_synced) _is_random_check_synced=@"0";
    return  _is_random_check_synced;
}
@end
