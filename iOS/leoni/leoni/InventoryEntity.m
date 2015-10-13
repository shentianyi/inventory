//
//  InventoryEntity.m
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "InventoryEntity.h"

@implementation InventoryEntity

- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part = part;
        self.part_type = part_type;
    }
    return self;
}

- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser WithCheckTime: (NSString *)checkTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID:(NSString *)idString {
    self = [super init];
    if (self) {
        self.position = position;
        self.department = department;
        self.part = part;
        self.part_type = part_type;
        self.check_qty = checkQty;
        self.check_user = checkUser;
        self.check_time = checkTime;
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
        self.position = dictionary[@"position"]?dictionary[@"position"]:@"";
        self.department = dictionary[@"department"]?dictionary[@"department"]:@"";
        self.part = dictionary[@"part"]?dictionary[@"part"]:@"";
        self.part_type = dictionary[@"part_type"]?dictionary[@"part_type"]:@"";
        self.check_qty = dictionary[@"check_qty"]?dictionary[@"check_qty"]:@"";
        self.check_user = dictionary[@"check_user"]?dictionary[@"check_user"]:@"";
        self.check_time = dictionary[@"check_time"]?dictionary[@"check_time"]:@"";
        self.random_check_qty= dictionary[@"random_check_qty"]?dictionary[@"random_check_qty"]:@"";
        self.random_check_user = dictionary[@"random_check_user"]?dictionary[@"random_check_user"]:@"";
        self.random_check_time = dictionary[@"random_check_time"]?dictionary[@"random_check_time"]:@"";
        self.ios_created_id = dictionary[@"ios_created_id"]?dictionary[@"ios_created_id"]:@"";
        self.is_random_check = dictionary[@"is_random_check"]?dictionary[@"is_random_check"]:@"";
        
        NSLog(@"the check qty %@", self.check_qty);

    }
    return self;
}

@end
