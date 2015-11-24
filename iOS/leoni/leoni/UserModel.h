//
//  UserModel.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"
#import "AFNetHelper.h"

@interface UserModel : NSObject

-(instancetype) init;

- (void)loginWithNr: (NSString *)nrString block:(void(^)(UserEntity *user_entity, NSError *error))block;
@property (retain,nonatomic) AFNetHelper *afnet;

// download user data
//- (void) downloadUserData:(void(^)(NSMutableArray *users,NSError *error))block;


-(NSMutableArray *) getUserInPage:(NSInteger)page PerPage:(NSInteger)perPage:(void(^)(NSMutableArray *userEntites,NSError *error))block;


- (void) cleanLocalData;

-(void) createLocalData:(UserEntity *)userEntity;

-(UserEntity *)findUserByNr:(NSString *)userNr;

-(void)save:(UserEntity *)userEntity;

@end
