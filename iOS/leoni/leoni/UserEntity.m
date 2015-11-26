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

-(id) initWithId:(NSString *)userId andNr:(NSString *)nr andName:(NSString *)name andRole:(NSString *)role andIdSpan:(NSString *)idSpan{
    self = [super init];
    if (self) {
        self.userId=userId;
        self.nr= nr;
        self.name=name;
        self.role=role,
        self.idSpan=idSpan;
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

-(NSInteger) idSpanCount{
    if (!_idSpanCount) {
        NSInteger count=0;
        if(self.idSpan && self.idSpan.length>0){
        NSArray *spans=[self.idSpan componentsSeparatedByString:@","];
        NSLog(@"%@",spans);
        for (NSString *span in spans) {
            NSLog(@"span: %@",span);
            NSArray *sspans=[span componentsSeparatedByString:@"-"];
            if([sspans count]==2){
            count+=([sspans[1] integerValue]-[sspans[0] integerValue]+1);
            }
        }
        }
        _idSpanCount=count;//[NSString stringWithFormat:@"%i",count];
    }
    return _idSpanCount;
}

-(BOOL)validateIdSpan:(NSInteger)sn{
    BOOL result=NO;
    
    if(self.idSpan && self.idSpan.length>0){
        NSArray *spans=[self.idSpan componentsSeparatedByString:@","];
        
        for (NSString *span in spans) {
            NSArray *sspans=[span componentsSeparatedByString:@"-"];
            if([sspans count]==2){

            NSInteger from=[sspans[0] integerValue];
            NSInteger to=[sspans[1] integerValue];
            if (sn>=from && sn<=to) {
                result=YES;
                break;
            }}
        }
    }
    
    return  result;
}

-(BOOL)isRoleTeamLeader{
 return  [self.role isEqualToString: @"组长"];
}
@end
