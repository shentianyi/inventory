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

- (void)webGetRandomCheckData: (NSString *)strPage block:(void(^)(NSMutableArray *tableArray, NSError *error))block;

- (void)queryWithPosition: (NSString *)positionString block:(void(^)(InventoryEntity *inventory_entity, NSError *error))block;

- (void)checkWithPosition: (NSString *)position WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (void)webRandomCheckWithPosition: (NSString *)position WithRandomCheckQty: (NSString *)randomCheckQty WithRandomCheckUser: (NSString *)randomCheckUser block:(void(^)(NSString *msgString, NSError *error))block;


- (void)createWithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType WithChcekQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (void)localDeleteData: (NSString *)strPosition;
- (void)localCreateCheckData: (InventoryEntity *)entity;
//- (void)localCreateRandomCheckData: (InventoryEntity *)entity;


- (NSMutableArray *)getListWithPosition: (NSString *)position;

- (BOOL)uploadCheckData: (InventoryEntity *)entity;
/*
 上传更新random check data
 */
- (BOOL)webUploadRandomCheckData: (InventoryEntity *)entity;

- (void)getTotalBlock:(void(^)(NSInteger intCount, NSError *error))block;

- (NSMutableArray *)webGetListWithPage: (NSInteger )page block:(void (^)(NSMutableArray * tableArray, NSError *error))block;

- (NSMutableArray *)localGetRandomCheckData: (NSString *)position;

@end
