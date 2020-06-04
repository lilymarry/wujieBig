//
//  LGJAutoRunLabel.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/28.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LGJAutoRunLabel;
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, RunDirectionType) {
    LeftType = 0,
    RightType = 1,
};

@protocol LGJAutoRunLabelDelegate <NSObject>

@optional
- (void)operateLabel: (LGJAutoRunLabel *)autoLabel animationDidStopFinished: (BOOL)finished;

@end
@interface LGJAutoRunLabel : UIView
@property (nonatomic, weak) id <LGJAutoRunLabelDelegate> delegate;
@property (nonatomic, assign) CGFloat speed;
@property (nonatomic, assign) RunDirectionType directionType;

- (void)addContentView: (UIView *)view;
- (void)startAnimation;
- (void)stopAnimation;
@end

NS_ASSUME_NONNULL_END
