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

- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser WithCheckTime: (NSString *)checkTime WithiOSCreatedID: (NSString *)iOSCreatedId {
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

    }
    return self;
}


-(instancetype)initWithObject:(NSDictionary *)dictionary
{
    self=[super init];
    if(self){
        self.position = dictionary[@"position"]?dictionary[@"position"]:@"";
        self.department = dictionary[@"department"]?dictionary[@"department"]:@"";
        self.part = dictionary[@"part"]?dictionary[@"part"]:@"";
        self.part_type = dictionary[@"part_type"]?dictionary[@"part_type"]:@"";
    }
    return self;
}

@end
