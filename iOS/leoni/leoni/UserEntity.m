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
        self.nr_string = nr;
    }
    return self;
}
@end
