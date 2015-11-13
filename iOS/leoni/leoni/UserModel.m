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
        
        user=[[UserEntity alloc] initWithId:user_id andNr:nr andName:name];
    }
    return  user;
}

- (void)loginWithNr:(NSString *)nrString block:(void (^)(UserEntity *, NSError *))block{
    AFNetHelper *afnet_helper = [[AFNetHelper alloc] init];
    AFHTTPRequestOperationManager *manager = [afnet_helper basicManager];
    [manager POST:[afnet_helper login]
       parameters:@{@"name" : nrString}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
              if([responseObject[@"result"] integerValue]== 1 ){
                  UserEntity *user = [[UserEntity alloc] initWithNr:nrString];
                  if (block) {
                      block(user, nil);
                  }
              }
              else{
                  if (block) {
                      NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:responseObject[@"content"]];
                      block(nil, error);
                  }
              }
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSLog(@"======= testing%@", error.description);
              if (block) {
//                  NSString *jsonString = [NSString stringWithFormat: @"{\"content\":网络故障请联系管理员}"];
//                  NSData *data = [jsonString dataUsingEncoding: NSUTF8StringEncoding];
//                  id dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//                  NSError *customError = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[dict objectForKey: @"content"]];
                 NSError *error = [[NSError alloc]initWithDomain:@"Leoni" code:200 userInfo:[NSString stringWithFormat:@"网络故障请联系管理员" ]];
                  
                  block(nil, error);
              }
          }
    
     ];
}

//-(void) downloadUserData:(void (^)(NSMutableArray *, NSError *))block{
//    NSMutableArray *users=[[NSMutableArray alloc] init];
//    NSInteger page=1;
//    
//    NSInteger perPage=[self.afnet getRequestQuantity];
//    while (true) {
//        NSMutableArray *perUsers=[self getUserInPage:page PerPage:perPage];
//        if(perUsers.count>0){
//            [users addObjectsFromArray:perUsers];
//        }else{
//            break;
//        }
//        page+=1;
//    }
//}

-(NSMutableArray *) getUserInPage:(NSInteger)page PerPage:(NSInteger)perPage:(void(^)(NSMutableArray *users,NSError *error))block{
      NSMutableArray *userEntities=[[NSMutableArray alloc] init];
    //NSMutableArray *users=[[NSMutableArray alloc] init];
    AFHTTPRequestOperationManager *manager=[self.afnet basicManager];
     
    [manager GET:[self.afnet downloadUserData]
      parameters:@{@"page":  [NSString stringWithFormat: @"%d", page]}
         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
             NSArray *users=responseObject[@"content"];
           
             for(int i=0;i<users.count;i++){
                 [userEntities addObject: [[UserEntity alloc] initWithId:users[i][@"user_id"] andNr:users[i][@"nr"] andName:users[i][@"name"]]];
             }
             
             if(block){
                 block(userEntities,nil);
             }
             
      } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
          if(block){
              NSError *error=[[NSError alloc] initWithDomain:@"Lenoi" code:200 userInfo:@{ NSLocalizedDescriptionKey :[NSString stringWithFormat:@"网络故障，请联系管理员"]}];
              block(nil,error);
          }
      }];
    return userEntities;
}

-(void) createLocalData:(UserEntity *)userEntity{
    
    self.db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    NSString *query=[NSString stringWithFormat:@"insert into users(user_id,nr,name) values('%@','%@','%@')",
                     userEntity.userId,userEntity.nr,userEntity.name];
    
    [self.db executeQuery:query];
}


-(void) cleanLocalData{
   self.db=[[DBManager alloc] initWithDatabaseFilename:@"userdb.sql"];
    NSString *query=[NSString stringWithFormat:@"delete from users"];
    [self.db executeQuery:query];
}

@end
