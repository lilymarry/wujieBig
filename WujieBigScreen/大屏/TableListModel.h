//
//  TableListModel.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/19.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


typedef void(^TableListModelSuccessBlock)(NSString *code,NSString* message  ,id data);
typedef void(^TableListModelFaiulureBlock)(NSError *error);
@interface TableListModel : NSObject


@property(nonatomic,strong)TableListModel *data ;
@property(nonatomic,strong)NSArray *desk_info;

@property(nonatomic,copy)NSString * id;
@property(nonatomic,copy)NSString *name ;
@property(nonatomic,strong)NSArray *num_list;

@property(nonatomic,copy)NSString * number ;

@property(nonatomic,copy)NSString *wait_number;

@property(nonatomic,strong)TableListModel *merchant_info;
@property(nonatomic,copy)NSString * mer_id;
@property(nonatomic,strong)NSArray * photos;
@property(nonatomic,strong)TableListModel *qr_code;

@property(nonatomic,strong)NSArray *details ;

@property(nonatomic,copy)NSString *user_phone;
@property(nonatomic,copy)NSString *user_name;
@property(nonatomic,copy)NSString *desk_type_id;
@property(nonatomic,copy)NSString *take_info;
@property(nonatomic,copy)NSString *number_show;
@property(nonatomic,strong)TableListModel *second_type;

@property(nonatomic,copy)NSString *first_name;
@property(nonatomic,copy)NSString *second_name;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *updated_at;
@property(nonatomic,copy)NSString *picture;
@property(nonatomic,copy)NSString *tag;

@property(nonatomic,copy)NSString *call_word;
@property(nonatomic,copy)NSString *type_details;
@property(nonatomic,copy)NSString *img ;


-(void)TableListModelSuccess:(TableListModelSuccessBlock)success andFailure:(TableListModelFaiulureBlock)failure;
@end

NS_ASSUME_NONNULL_END
