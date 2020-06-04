//
//  ViewTablePicModel.m
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "ViewTablePicModel.h"

@implementation ViewTablePicModel
-(void)ViewTablePicModelSuccess:(ViewTablePicModelSuccessBlock)success andFailure:(ViewTablePicModelFaiulureBlock)failure
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    if (SWNOTEmptyStr(self.merchant_id)) {
        [para setValue:self.merchant_id forKey:@"merchant_id"];
    }
    if (SWNOTEmptyStr(self.desk_type_id)) {
        [para setValue:self.desk_type_id forKey:@"desk_type_id"];
    }

    [HttpManager postWithUrl:@"/api/viewTablePic"   baseurl:canyin_Base_url andParameters:@{@"merchant_id":_merchant_id,@"desk_type_id":_desk_type_id} andSuccess:^(id Json) {
        NSDictionary * dic = (NSDictionary *)Json;
       success(dic[@"code"],dic[@"msg"],dic[@"data"]);
        
    } andFail:^(NSError *error) {
        failure(error);
    }];
}
@end
