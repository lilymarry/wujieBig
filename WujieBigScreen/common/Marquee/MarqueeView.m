//
//  MarqueeView.m
//  Marquee(Up and Down)
//
//  Created by 花花 on 2017/8/15.
//  Copyright © 2017年 花花. All rights reserved.
//

#import "MarqueeView.h"
#import "UIView+HHAddition.h"
#import "MarqueeViewBtn.h"
@interface MarqueeView()
{
    NSTimer *timer;
}
@property(assign, nonatomic)int titleIndex;
@property(assign, nonatomic)int index;
@property (nonatomic) NSMutableArray *titles;
/**第一个*/
@property(nonatomic)MarqueeViewBtn *firstBtn;
/**更多个*/
@property(nonatomic)MarqueeViewBtn *moreBtn;
@end
@implementation MarqueeView

#pragma mark - init Methods
-(instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)titles{

    if (self = [super initWithFrame:frame]) {
        //清除子控件
        for (UIView *view in [self subviews]) {
            [_titles removeAllObjects];
            [view removeFromSuperview];
        }
        
        _titleArr  = titles;
        self.clipsToBounds = YES;
        NSMutableArray *MutableTitles = [NSMutableArray arrayWithArray:titles];
         NSArray *str = [NSArray array];
        self.titles = MutableTitles;
        [self.titles addObject:str]; //最后加一个空的,防止数组为空奔溃
        
        self.index = 1;
        self.firstBtn = (MarqueeViewBtn *)[self btnframe:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width - 2 *30, self.bounds.size.height) ];
        self.firstBtn .tag = self.index;
        NSArray *arr=self.titles[0];
        if (arr.count>0) {
            if (arr.count==1) {
                 self.firstBtn.lab2.text=arr[0];
            }
            else if (arr.count==2)
            {
                self.firstBtn.lab1.text=arr[0];
                self.firstBtn.lab2.text=arr[1];
              
            }
            else
            {
                self.firstBtn.lab1.text=arr[0];
                self.firstBtn.lab2.text=arr[1];
                self.firstBtn.lab3.text=arr[2];
            }
        }
       
        [self addSubview:self.firstBtn];
    }
    
    return self;
}

#pragma mark - SEL Methods
-(void)nextAd{
    
    for (UIView *view in [self subviews]) {
        [view removeFromSuperview];
    }
    
    MarqueeViewBtn *firstBtn = [self viewWithTag:self.index];
    self.moreBtn = (MarqueeViewBtn *) [self btnframe: CGRectMake(10, self.bounds.size.height,[UIScreen mainScreen].bounds.size.width -2 *30, self.bounds.size.height)];
    self.moreBtn.tag = self.index + 1;
    if ([self.titles[self.titleIndex+1] count]==0) {
        self.titleIndex = -1;
        self.index = 0;
    }
    if (self.moreBtn.tag == self.titles.count) {
        
        self.moreBtn.tag = 1;
    }
    NSArray *arr=self.titles[self.titleIndex+1];

    if (arr.count>0) {
        if (arr.count==1) {
           self.moreBtn.lab2.text=arr[0];
        }
        else if (arr.count==2)
        {
           self.moreBtn.lab1.text=arr[0];
            self.moreBtn.lab2.text=arr[1];
            
        }
        else
        {
           self.moreBtn.lab1.text=arr[0];
           self.moreBtn.lab2.text=arr[1];
           self.moreBtn.lab3.text=arr[2];
        }
    }
    [self addSubview:self.moreBtn];
    
    [UIView animateWithDuration:0.25 animations:^{
        firstBtn.y = -self.bounds.size.height;
        self.moreBtn.y = 0;
        
    } completion:^(BOOL finished) {
        [firstBtn removeFromSuperview];
        
    } ];
    self.index++;
    self.titleIndex++;
}

#pragma mark - Custom Methods
- (UIButton *)btnframe:(CGRect)frame  {
    
    MarqueeViewBtn *btn = [[MarqueeViewBtn alloc]initWithFrame:frame];
    return btn;
}
-(void) startScroll{
    
   timer=    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextAd) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer  forMode:NSRunLoopCommonModes];
    
}
-(void)stopScrollText
{
    [timer invalidate];
    timer=nil;
}

@end
