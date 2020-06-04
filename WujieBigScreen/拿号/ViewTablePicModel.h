//
//  ViewTablePicModel.h
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/6/13.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^ViewTablePicModelSuccessBlock)(NSString *code,NSString* message  ,NSDictionary *picDic );
typedef void(^ViewTablePicModelFaiulureBlock)(NSError *error);
@interface ViewTablePicModel : NSObject
@property(nonatomic,copy)NSString *merchant_id;
@property(nonatomic,copy)NSString *desk_type_id;


@property(nonatomic,strong)NSArray *data;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;

-(void)ViewTablePicModelSuccess:(ViewTablePicModelSuccessBlock)success andFailure:(ViewTablePicModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
