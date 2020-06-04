//
//  LoginModel.h
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN


typedef void(^LoginModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^LoginModelFaiulureBlock)(NSError *error);
@interface LoginModel : NSObject
@property(nonatomic,copy )NSString *manage_id;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *code_type;
@property (nonatomic, strong) User * data;


//@property(nonatomic,strong )LoginModel *data;
//@property(nonatomic,copy)NSString *access_token;
//@property(nonatomic,copy)NSString *expires_in;
//@property(nonatomic,copy)NSString *token_type;
//@property(nonatomic,strong )LoginModel *user_info;
//@property(nonatomic,copy)NSString *merchant_id;
//@property(nonatomic,copy)NSString *uid;


-(void)LoginModelSuccessBlock:(LoginModelSuccessBlock)success andFailure:(LoginModelFaiulureBlock)failure;

+ (instancetype)shareInstance;
//保存登陆用户信息
- (void)save:(User *)userInfo;
//获取已保存用户信息
- (User *)getUserInfo;
//删除用户信息
- (void)deleteUserInfo;

@end

NS_ASSUME_NONNULL_END
