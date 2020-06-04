//
//  LoginImgByCode.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^LoginImgByCodeSuccessBlock)(NSString *code,NSString* message  ,NSString * data);
typedef void(^LoginImgByCodelFaiulureBlock)(NSError *error);
@interface LoginImgByCode : NSObject
@property(nonatomic,copy )NSString *code;

-(void)LoginImgByCodeSuccessBlock:(LoginImgByCodeSuccessBlock)success andFailure:(LoginImgByCodelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
