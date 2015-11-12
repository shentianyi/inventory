//
//  UserEntity.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "UserEntity.h"

@implementation UserEntity

- (id)initWithNr:(NSString *)nr{
    self = [super init];
    if (self) {
        self.nr = nr;
    }
    return self;
}

- (id) initWithId:(NSString *)userId andNr:(NSString *)nr andName:(NSString *)name{
    self = [super init];
    if (self) {
        self.userId=userId;
        self.nr= nr;
        self.name=name;
    }
    return self;
}
@end
