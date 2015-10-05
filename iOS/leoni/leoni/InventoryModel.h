//
//  InventoryModel.h
//  leoni
//
//  Created by ryan on 10/5/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "InventoryEntity.h"

@interface InventoryModel : NSObject

- (void)queryWithPosition: (NSString *)positionString block:(void(^)(InventoryEntity *inventory_entity, NSError *error))block;

@end
