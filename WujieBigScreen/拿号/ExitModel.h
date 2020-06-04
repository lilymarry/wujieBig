//
//  ExitModel.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ExitModelSuccessBlock)(NSString *code,NSString* message);
typedef void(^ExitModelFaiulureBlock)(NSError *error);
@interface ExitModel : NSObject
-(void)ExitModelSuccess:(ExitModelSuccessBlock)success andFailure:(ExitModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
