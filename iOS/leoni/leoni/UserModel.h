//
//  UserModel.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

@interface UserMoel : NSObject

- (void)loginWithNr: (NSString *)nrString block:(void(^)(UserEntity *user_entity, NSError *error))block;


@end
