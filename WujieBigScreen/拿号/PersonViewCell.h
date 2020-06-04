//
//  TableTableViewCell.h
//  WujieBigScreen
//
//  Created by 天津沃天科技 on 2019/6/18.
//  Copyright © 2019年 wotianshiyan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *seePicBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;

@property (weak, nonatomic) IBOutlet UIImageView *flagImagv;


@end

NS_ASSUME_NONNULL_END
