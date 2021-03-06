//
//  UserModel.m
//  leoni
//
//  Created by ryan on 10/4/15.
//  Copyright (c) 2015 ryan. All rights reserved.
//

#import "UserModel.h"
#import "AFNetHelper.h"
#import "DBManager.h"

@interface UserModel()
 @property (nonatomic,retain)DBManager *db;
@end

@implementation UserModel

-(instancetype) init{
    self=[super self];
    if(self){
        _afnet=[[AFNetHelper alloc] init];
        
        _db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    }
    return self;
}

- (UserEntity *)findUserByNr:(NSString *)userNr{
    UserEntity *user=nil;
    NSString *query=[NSString stringWithFormat:@"select * from users where nr='%@' limit 1",userNr];
    
  NSArray *userData=[[NSArray alloc] initWithArray: [self.db loadDataFromDB:query]];
  //  NSLog(@"---------count:%d",userData.count);
    
    if(userData.count==1){
     NSString *user_id=   [userData[0] objectAtIndex: [self.db.arrColumnNames indexOfObject:@"id"]];
        NSString *nr=   [userData[0]
                              objectAtIndex: [self.db.arrColumnNames indexOfObject:@"nr"]];
        
        NSString *name=   [userData[0] objectAtIndex: [self.db.arrColumnNames indexOfObject:@"name"]];
        
        
        NSString *role=   [userData[0] objectAtIndex: [self.db.arrColumnNames indexOfObject:@"role"]];
        
        
        NSString *idSpan=   [userData[0] objectAtIndex: [self.db.arrColumnNames indexOfObject:@"id_span"]];
        
        
        user=[[UserEntity alloc] initWithId:user_id andNr:nr andName:name andRole:role andIdSpan:idSpan];
    }
    return  user;
}


-(void) createLocalData:(UserEntity *)userEntity{
    
    self.db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    NSString *query=[NSString stringWithFormat:@"insert into users(user_id,nr,name,role,id_span) values('%@','%@','%@','%@','%@')",
                     userEntity.userId,userEntity.nr,userEntity.name,userEntity.role,userEntity.idSpan];
    
    [self.db executeQuery:query];
}

-(void)save:(UserEntity *)userEntity{
    self.db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    NSString *query=[NSString stringWithFormat:@"update users set id_span='%@' where nr='%@'",
                    userEntity.idSpan, userEntity.nr];
    
    [self.db executeQuery:query];
  
}

-(void) cleanLocalData{
   self.db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    NSString *query=[NSString stringWithFormat:@"delete from users"];
    [self.db executeQuery:query];
}

+(NSString *)accountNr{
    KeychainItemWrapper *keyChain = [[KeychainItemWrapper alloc] initWithIdentifier:@"Leoni" accessGroup:nil];
    return [keyChain objectForKey:(__bridge  id)kSecAttrAccount];
}

@end
