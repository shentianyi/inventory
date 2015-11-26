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

/*
 下载所有抽盘数据
 */
- (void)webDownloadRandomCheckDatablock:(void(^)(NSMutableArray *dataArray, NSError *error))block;
    
/*
 下载翻页抽盘数据
*/
- (void)webGetRandomCheckData: (NSInteger )page withPageSize: (NSString *)pageSize block:(void(^)(NSMutableArray *tableArray, NSError *error))block;

- (void)queryWithPosition: (NSString *)positionString block:(void(^)(InventoryEntity *inventory_entity, NSError *error))block;

- (void)checkWithPosition: (NSString *)position WithCheckQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

- (void)webRandomCheckWithPosition: (NSString *)position WithRandomCheckQty: (NSString *)randomCheckQty WithRandomCheckUser: (NSString *)randomCheckUser block:(void(^)(NSString *msgString, NSError *error))block;


- (void)createLocalDataWithSn:(NSInteger)sn WithPosition: (NSString *)position WithPart: (NSString *)part WithDepartment: (NSString *)department WithPartType: (NSString *)partType  WithPartUnit:(NSString *) partUnit WithChcekQty: (NSString *)checkQty WithCheckUser: (NSString *)checkUser block:(void(^)(NSString *msgString, NSError *error))block;

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
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position;
- (NSMutableArray *)getLocalCheckDataListWithPosition: (NSString *)position WithUserNr:(NSString *)userNr;
- (NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position;
- (NSMutableArray *)getLocalCreateCheckDataListWithPoistion:(NSString *)position WithUserNr:(NSString *) userNr;

// 获取本地抽盘数据
- (NSMutableArray *)getLocalRandomCheckDataListWithPosition: (NSString *)position;

/*
 本地数据查询
 */

// by position
- (NSMutableArray *)getListWithPosition: (NSString *)position;

// by position and department
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment;

// by position and department and part
-(NSMutableArray *)getListWithPosition:(NSString *)position andDepartment:(NSString *)deparment andPart:(NSString *)part;

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





- (BOOL)uploadCheckData: (InventoryEntity *)entity;
/*
 上传更新random check data
 */
- (BOOL)webUploadRandomCheckData: (InventoryEntity *)entity;

/*
 获取抽盘数据 总页数，总条数
 */
- (void)getRandomTotal: (NSString *)pageSize block:(void (^)(NSInteger intCount, NSError *error))block;
    

- (void)getTotal: (NSString *)pageSize block:(void(^)(NSInteger intCount, NSError *error))block ;

//- (void)getTotal: (NSString *)pageSize block:(void(^)(NSInteger intCount, NSError *error))block completion:(void(^)(BOOL finished))completion;

- (void)webGetListWithPage: (NSInteger )page withPageSize: (NSString *)pageSize block:(void (^)(NSMutableArray * tableArray, NSError *error))block;

/*
 下载全盘数据
 ryan 2015.11.4
 */
- (void)webDownloadAllCheckDatablock:(void (^)(NSMutableArray * tableArray, NSError *error))block;

/*
 本地根据库位 update 记录
 */
- (NSString *)localUpdateDataByPosition: (InventoryEntity *)entity;

/*
 本地根据库位 update random check data记录
 */
- (NSString *)localUpdateRandomCheckDataByPosition: (InventoryEntity *)entity;

/*
 本地查询 记录
 */
- (NSArray *)localGetData;

@end
