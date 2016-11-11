//
//  MyCollectionViewCell.m
//  collection
//
//  Created by 徐茂怀 on 16/2/23.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import "MyCollectionViewCell.h"
#import "UIColor+UIColor.h"

@implementation MyCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]init];
        
        _label.backgroundColor = [UIColor clearColor];
        [_label setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        _label.layer.borderWidth = 1;
        _label.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    [_label setFrame:self.bounds];
    _label.textAlignment = 1;
     _label.font = [UIFont systemFontOfSize:13];
    _label.layer.masksToBounds = YES;
    _label.layer.cornerRadius = 4;

    [self.contentView addSubview:_label];

}

@end
