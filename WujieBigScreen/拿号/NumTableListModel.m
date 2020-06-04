//
//  NumTableListModel.m
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "NumTableListModel.h"

@implementation NumTableListModel
-(void)NumTableListModelSuccess:(NumTableListModelSuccessBlock)success andFailure:(NumTableListModelFaiulureBlock)failure
{
    [HttpManager postWithUrl:@"/api/getDeskType"   baseurl:canyin_Base_url andParameters:@{} andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
        [NumTableListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"desk_list":@"NumTableListModel",@"surname_list":@"NumTableListModel"};
        }];
        success(dic[@"code"],dic[@"msg"],[NumTableListModel mj_objectWithKeyValues:dic]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
