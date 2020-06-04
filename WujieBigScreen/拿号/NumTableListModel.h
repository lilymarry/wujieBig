//
//  NumTableListModel.h
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^NumTableListModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^NumTableListModelFaiulureBlock)(NSError *error);
@interface NumTableListModel : NSObject

@property(nonatomic,strong)NumTableListModel *data;
@property(nonatomic,copy)NSString *banner_img;
@property(nonatomic,strong)NSArray *desk_list;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *wait_number;
@property(nonatomic,strong)NSArray *surname_list;
@property(nonatomic,copy)NSString *second_name;

-(void)NumTableListModelSuccess:(NumTableListModelSuccessBlock)success andFailure:(NumTableListModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
