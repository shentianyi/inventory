//
//  InventoryModel.h
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventoryEntity.h"
#import "AFNetHelper.h"

@interface InventoryModel : NSObject

@property (retain, nonatomic) AFNetHelper *afnet;
@property (nonatomic) int recordIDToEdit;


- (void)queryWithPosition: (NSString *)positionString block:(void(^)(InventoryEntity *inventory_entity, NSError *error))block;

- (void)checkWithPosition: (NSString *)position WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (void)createWithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType WithChcekQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (NSMutableArray *)getList;

@end
