//
//  ValiMobile.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/7/3.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "ValiMobile.h"

@implementation ValiMobile
+ (NSString *)valiMobile:(NSString *)mobile{
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        NSString *regex = @"^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$";
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if ( isMatch3) {
            return nil;
        }else{
            return @"请输入正确的电话号码";
        }
        
    }
    return nil;
}
@end
