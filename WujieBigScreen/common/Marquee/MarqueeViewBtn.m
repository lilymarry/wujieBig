//
//  MarqueeViewBtn.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/28.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "MarqueeViewBtn.h"

@implementation MarqueeViewBtn

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
      
        _lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/3)];
       _lab1.font=[UIFont systemFontOfSize:14];
       _lab1.textColor=[UIColor whiteColor];
        [self addSubview:_lab1];
        
     _lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lab1.frame), self.frame.size.width, self.frame.size.height/3)];
        _lab2.font=[UIFont systemFontOfSize:14];
        _lab2.textColor=[UIColor whiteColor];
      [self addSubview:_lab2];
        
       _lab3=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lab2.frame),  self.frame.size.width, self.frame.size.height/3)];
        _lab3.font=[UIFont systemFontOfSize:14];
        _lab3.textColor=[UIColor whiteColor];
       [self addSubview:_lab3];
        
        
      
        
    }
    return self;
}

@end
