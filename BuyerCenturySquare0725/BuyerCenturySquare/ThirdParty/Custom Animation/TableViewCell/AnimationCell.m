//
//  AnimationCell.m
//  标签动画
//
//  Created by 陈光 on 15/9/17.
//  Copyright (c) 2015年 陈光. All rights reserved.
//

#import "AnimationCell.h"

@implementation AnimationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //设置要添加动画的vlabel
        UILabel *animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(-100, 10, 0, 0)];
        animationLabel.backgroundColor = [UIColor redColor];
        animationLabel.text = @"全国包邮";
        
        
        [self addSubview:animationLabel];
        
        //动画
        [UIView animateWithDuration:0.4 animations:^{
            //改变位置
            animationLabel.frame = CGRectMake(0, 10, 80, 20);
            
        }];
    }
    return  self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
