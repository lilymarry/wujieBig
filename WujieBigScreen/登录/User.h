//
//  User.h
//  SuperiorAcme
//
//  Created by GYM on 2017/8/23.
//  Copyright © 2017年 GYM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property(nonatomic,strong )User *data;
@property(nonatomic,copy)NSString *access_token;
@property(nonatomic,copy)NSString *expires_in;
@property(nonatomic,copy)NSString *token_type;
@property(nonatomic,strong )User *user_info;
@property(nonatomic,copy)NSString *merchant_id;
@property(nonatomic,copy)NSString *uid;

@end
