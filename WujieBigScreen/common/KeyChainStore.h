//
//  KeyChainStore.h
//  keyChain
//
//  Created by 天津沃天科技 on 2019/6/3.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject

+ (void)save:(NSString*)service data:(id)data;
+ (id)load:(NSString*)service;
+ (void)deleteKeyData:(NSString*)service;
@end

NS_ASSUME_NONNULL_END
