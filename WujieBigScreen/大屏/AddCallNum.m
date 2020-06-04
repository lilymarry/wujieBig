//
//  AddCallNum.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/28.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "AddCallNum.h"

@implementation AddCallNum
-(void)AddCallNumSuccess:(AddCallNumSuccessBlock)success andFailure:(AddCallNumFaiulureBlock)failure
{
    [HttpManager postWithUrl:@"/api/addCallNum"   baseurl:canyin_Base_url andParameters:@{@"id":_id} andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;

        success(dic[@"code"],dic[@"msg"],[AddCallNum mj_objectWithKeyValues:dic]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
