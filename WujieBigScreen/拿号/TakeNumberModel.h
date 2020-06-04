//
//  TakeNumbe.h
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TakeNumberModelSuccessBlock)(NSString *code,NSString* message  ,NSDictionary *dataDic );
typedef void(^TakeNumberModelFaiulureBlock)(NSError *error);

@interface TakeNumberModel : NSObject
@property(nonatomic,copy)NSString *merchant_id;
@property(nonatomic,copy)NSString *num_type;

@property(nonatomic,copy)NSString *desk_type_id;
@property(nonatomic,copy)NSString *create_user_type;
@property(nonatomic,copy)NSString *create_user_id;
@property(nonatomic,copy)NSString *use_time;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *user_phone;


-(void)TakeNumberModelSuccess:(TakeNumberModelSuccessBlock)success andFailure:(TakeNumberModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
