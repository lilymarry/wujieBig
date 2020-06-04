//
//  ExitModel.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "ExitModel.h"

@implementation ExitModel
-(void)ExitModelSuccess:(ExitModelSuccessBlock)success andFailure:(ExitModelFaiulureBlock)failure
{
    [HttpManager deleteWithUrl:@"/api/token/current"   baseurl:canyin_Base_url andParameters:@{} andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
        success(dic[@"code"],dic[@"msg"]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
