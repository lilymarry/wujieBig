//
//  AddCallNum.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/28.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^AddCallNumSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^AddCallNumFaiulureBlock)(NSError *error);
@interface AddCallNum : NSObject

@property(nonatomic,copy)NSString * id;

-(void)AddCallNumSuccess:(AddCallNumSuccessBlock)success andFailure:(AddCallNumFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
