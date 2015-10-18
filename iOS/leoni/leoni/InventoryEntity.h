//
//  InventoryEntity.h
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InventoryEntity : NSObject

@property (nonatomic, copy) NSString *inventory_id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *part;
@property (nonatomic, copy) NSString *part_type;
@property (nonatomic, copy) NSString *check_qty;
@property (nonatomic, copy) NSString *check_user;
@property (nonatomic, copy) NSString *check_time;
@property (nonatomic, copy) NSString *ios_created_id;
@property (nonatomic, copy) NSString *random_check_qty;
@property (nonatomic, copy) NSString *random_check_user;
@property (nonatomic, copy) NSString *random_check_time;
@property (nonatomic, copy) NSString *is_random_check;


- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type;

- (id)initWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser WithCheckTime: (NSString *)checkTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID: (NSString *)idString;

- (id)initRandomCheckDataWithPosition: (NSString *)position withDepartment: (NSString *)department withPart: (NSString *)part withPartType: (NSString *)part_type WithRandomCheckQty: (NSString *)randomCheckQty WithRandomCheckUser: (NSString *)randomCheckUser WithRandomCheckTime: (NSString *)randomCheckTime WithiOSCreatedID: (NSString *)iOSCreatedId WithID: (NSString *)idString;

- (id)initWithObject: (NSDictionary *)dictionary;

@end
