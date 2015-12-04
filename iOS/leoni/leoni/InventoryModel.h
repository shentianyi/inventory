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

- (instancetype)init;



- (void)createLocalDataWithSn:(NSInteger)sn WithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType  WithPartUnit:(NSString *) partUnit WithWireNr:(NSString *)wireNr WithProcessNr:(NSString*)processNr WithChcekQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (void)localDeleteData: (NSString *)strPosition;
- (void)localCreateCheckData: (InventoryEntity *)entity;
//- (void)localCreateRandomCheckData: (InventoryEntity *)entity;

/*
 获取本地数据
 */
// Charot
// by sn
- (NSMutableArray *)getListWithSn:(NSInteger)sn;
// by position
- (NSMutableArray *)searchLocalCheckDataList:(NSString *)q;
- (NSMutableArray *)searchLocalCheckDataList:(NSString *)q WithUserNr:(NSString *)userNr;
- (NSMutableArray *)searchLocalCheckUnSyncDataList:(NSString *)q;
- (NSMutableArray *)searchLocalCheckUnSyncDataList:(NSString *)q WithUserNr:(NSString *)userNr;


- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position;
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position WithUserNr:(NSString *)userNr;

-(NSMutableArray *)getLocalCheckOrCreateUnsyncDataListWithUserNr:(NSString *)userNr;

- (NSMutableArray *)getLocalCheckUnSyncDataListWithPosition: (NSString *)position;
- (NSMutableArray *)getLocalCheckUnSyncDataListWithPosition: (NSString *)position WithUserNr:(NSString *)userNr;



- (NSMutableArray *)searchLocalCreateCheckDataList:(NSString *)q;
- (NSMutableArray *)searchLocalCreateCheckDataList:(NSString *)q WithUserNr:(NSString *)userNr;
- (NSMutableArray *)searchLocalCreateCheckUnSyncDataList:(NSString *)q;
- (NSMutableArray *)searchLocalCreateCheckUnSyncDataList:(NSString *)q WithUserNr:(NSString *)userNr;

- (NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position;
- (NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position WithUserNr:(NSString *) userNr;
- (NSMutableArray *)getLocalCreateCheckUnSyncDataListWithPoistion:(NSString *)position;
- (NSMutableArray *)getLocalCreateCheckUnSyncDataListWithPoistion:(NSString *)position WithUserNr:(NSString *) userNr;

// 获取本地抽盘数据
- (NSMutableArray *)searchLocalRandomCheckDataList:(NSString *)q;
- (NSMutableArray *)getLocalRandomCheckDataListWithPosition: (NSString *)position;

// 获取本地抽盘数据
- (NSMutableArray *)searchLocalRandomCheckUnSyncDataList:(NSString *)q;
- (NSMutableArray *)getLocalRandomCheckUnSyncDataListWithPosition: (NSString *)position;
/*
 本地数据查询
 */
//－－－全盘／录入查询－－－－

// by position
- (NSMutableArray *)getListWithPosition: (NSString *)position;

// by position and department
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment;

// by position and department and part
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment andPart:(NSString *)part;

//－－－抽盘查询－－－－

//random by sn
- (NSMutableArray *)getRandomListWithSn:(NSInteger)sn;
// random by position
- (NSMutableArray *)getRandomListWithPosition: (NSString *)position;
// random by position and department
-(NSMutableArray *)getRandomListWithPosition:(NSString *)position andDepartment:(NSString *)deparment;
// random by position and department and part
-(NSMutableArray *)getRandomListWithPosition:(NSString *)position andDepartment:(NSString *)deparment andPart:(NSString *)part;



/*
 本地数据更新
*/
// update check fields
-(BOOL)updateCheckFields:(InventoryEntity *)entity;
// update random check fields
-(BOOL)updateRandomCheckFields:(InventoryEntity *)entity;
// update sync tag
-(BOOL)updateCheckSync:(InventoryEntity *)entity;
-(BOOL)updateRandomCheckSync:(InventoryEntity *)entity;

/*
 本地查询 记录
 */
- (NSArray *)localGetData;

@end
