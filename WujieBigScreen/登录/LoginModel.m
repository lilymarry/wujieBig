//
//  LoginModel.m
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "LoginModel.h"
#define kFile [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user.data"]
@implementation LoginModel
static LoginModel * login = nil;
+ (instancetype)shareInstance {
    @synchronized(self) {
        if (login == nil)
            login = [[self alloc] init];
    }
    return login;
}
- (User *)getUserInfo {
    User * user = [NSKeyedUnarchiver unarchiveObjectWithFile:kFile];
    return user;
}
- (void)save:(User *)userInfo {
    [NSKeyedArchiver archiveRootObject:userInfo toFile:kFile];
}
- (void)deleteUserInfo {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager isDeletableFileAtPath:kFile]) {
        [defaultManager removeItemAtPath:kFile error:nil];
    }
    
}


-(void)LoginModelSuccessBlock:(LoginModelSuccessBlock)success andFailure:(LoginModelFaiulureBlock)failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    if (SWNOTEmptyStr(self.manage_id)) {
        [para setValue:self.manage_id forKey:@"manage_id"];
    }
    if (SWNOTEmptyStr(self.password)) {
        [para setValue:self.password forKey:@"password"];
    }
    
    if (SWNOTEmptyStr(self.code)) {
        [para setValue:self.code forKey:@"code"];
    }
    if (SWNOTEmptyStr(self.code_type)) {
        [para setValue:self.code_type forKey:@"code_type"];
    }

    
    [HttpManager postWithUrl:@"/api/token" baseurl:canyin_Base_url andParameters:para andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;

       success(dic[@"code"],dic[@"msg"],[LoginModel mj_objectWithKeyValues:dic]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
