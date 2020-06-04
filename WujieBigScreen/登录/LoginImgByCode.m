//
//  LoginImgByCode.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "LoginImgByCode.h"

@implementation LoginImgByCode
-(void)LoginImgByCodeSuccessBlock:(LoginImgByCodeSuccessBlock)success andFailure:(LoginImgByCodelFaiulureBlock)failure
{
    [HttpManager postWithUrl:@"/api/getImgByCode" baseurl:canyin_Base_url andParameters:@{@"code":_code}  andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
        
        success(dic[@"code"],dic[@"msg"],dic[@"data"]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
