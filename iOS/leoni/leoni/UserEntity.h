//
//  UserEntity.h
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserEntity : NSObject

@property (nonatomic, copy) NSString *nr_string;


- (id)initWithNr: (NSString *)nr;
@end
