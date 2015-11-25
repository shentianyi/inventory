//
//  UserEntity.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

@property (nonatomic) NSString *userId;
@property (nonatomic, copy) NSString *nr;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *role;
@property (nonatomic, copy) NSString *idSpan;
@property (nonatomic,copy) NSString *idSpanCount;

- (id)initWithNr: (NSString *)nr;
- (id) initWithId:(NSString *)userId andNr:(NSString *)nr andName:(NSString *)name andRole:(NSString *)role andIdSpan:(NSString *)idSpan;

- (id) initWithId:(NSString *)userId andNr:(NSString *)nr andName:(NSString *)name;

@end
