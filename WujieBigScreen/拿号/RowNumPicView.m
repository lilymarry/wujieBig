//
//  RowNumPicView.m
//  WuJieManager
//
//  Created by 天津沃天科技 on 2019/5/17.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import "RowNumPicView.h"
#import "SNBannerView.h"
@interface RowNumPicView ()
@property (strong, nonatomic) IBOutlet UIView *bannerView;
@property (strong, nonatomic) IBOutlet UIView *backView;
@property (strong, nonatomic) IBOutlet  NSLayoutConstraint *backViewWW;
@property (strong, nonatomic) IBOutlet  NSLayoutConstraint *backViewHH;
@end

@implementation RowNumPicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"RowNumPicView" owner:self options:nil];
        [self addSubview:_thisView];
  
    _backViewWW.constant=ScreenW/2;
    _backViewHH.constant=(ScreenW/2)/125 *72;
     
    
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _thisView.frame = self.bounds;
}
- (IBAction)cancellPress:(id)sender {
    
    [self removeFromSuperview];
}
-(void)setUrlArr:(NSArray *)urlArr
{
    _urlArr =urlArr;

    SNBannerView *banner=[[SNBannerView alloc]initWithFrame:CGRectMake(0,0,    _backViewWW.constant-10, _backViewHH.constant-10) delegate:nil imageURLs:_urlArr placeholderImageName:@"无界优品默认空视图"  currentPageTintColor:[UIColor redColor] pageTintColor:[UIColor lightGrayColor]];

  [_bannerView addSubview:banner];
}

@end
