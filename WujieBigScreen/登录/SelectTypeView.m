//
//  SelectTypeView.m
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/17.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "SelectTypeView.h"

@interface SelectTypeView ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@end

@implementation SelectTypeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"SelectTypeView" owner:self options:nil];
        [self addSubview:_thisView];
        
    
         _view1.layer.borderColor=[UIColor lightGrayColor].CGColor;
          _view1.layer.borderWidth=1.0;
         _view2.layer.borderColor=[UIColor lightGrayColor].CGColor;
         _view2.layer.borderWidth=1.0;
    
       
    }
    return self;
}



- (void)layoutSubviews {
    [super layoutSubviews];
    _thisView.frame = self.bounds;
}
-(IBAction)cancellPress:(id)sender
{
    [self removeFromSuperview];
  
}

@end
