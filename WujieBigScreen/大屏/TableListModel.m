//
//  TableListModel.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "TableListModel.h"

@implementation TableListModel
-(void)TableListModelSuccess:(TableListModelSuccessBlock)success andFailure:(TableListModelFaiulureBlock)failure
{
    [HttpManager postWithUrl:@"/api/tableList"   baseurl:canyin_Base_url andParameters:@{} andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
        [TableListModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"desk_info":@"TableListModel",@"num_list":@"TableListModel",@"details":@"TableListModel"};
        }];
        success(dic[@"code"],dic[@"msg"],[TableListModel mj_objectWithKeyValues:dic]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
