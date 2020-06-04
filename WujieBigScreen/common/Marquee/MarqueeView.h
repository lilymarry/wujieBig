//
//  MarqueeView.h
//  Marquee(Up and Down)
//
//  Created by 花花 on 2017/8/15.
//  Copyright © 2017年 花花. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarqueeView : UIView
/**存放titles的数组 和初始化的数组一致*/
@property(nonatomic)NSArray *titleArr;

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles;
-(void) startScroll;
-(void)stopScrollText;
@end
