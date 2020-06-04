//
//  TakeNumbe.m
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "TakeNumberModel.h"

@implementation TakeNumberModel
-(void)TakeNumberModelSuccess:(TakeNumberModelSuccessBlock)success andFailure:(TakeNumberModelFaiulureBlock)failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    if (SWNOTEmptyStr(self.merchant_id)) {
        [para setValue:self.merchant_id forKey:@"merchant_id"];
    }
    if (SWNOTEmptyStr(self.num_type)) {
        [para setValue:self.num_type forKey:@"num_type"];
    }
    
    if (SWNOTEmptyStr(self.desk_type_id)) {
        [para setValue:self.desk_type_id forKey:@"desk_type_id"];
    }
    if (SWNOTEmptyStr(self.create_user_type)) {
        [para setValue:self.create_user_type forKey:@"create_user_type"];
    }
    if (SWNOTEmptyStr(self.create_user_id)) {
        [para setValue:self.create_user_id forKey:@"create_user_id"];
    }
    if (SWNOTEmptyStr(self.use_time)) {
        [para setValue:self.use_time forKey:@"use_time"];
    }
    
    if (SWNOTEmptyStr(self.user_name)) {
        [para setValue:self.user_name forKey:@"user_name"];
    }
    if (SWNOTEmptyStr(self.user_phone)) {
        [para setValue:self.user_phone forKey:@"user_phone"];
    }
    [HttpManager postWithUrl:@"/api/takeNumber"   baseurl:canyin_Base_url andParameters:para andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
        success(dic[@"code"],dic[@"msg"],dic[@"data"]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
