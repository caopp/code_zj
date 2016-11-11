//
//  ClassNameCollectionView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/5.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ClassNameCollectionCell.h"
#import "Masonry.h"

@implementation ClassNameCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.layer.borderColor = [UIColor colorWithHexValue:0x999999 alpha:1].CGColor;
        self.textLabel.layer.borderWidth = 0.5f;
        self.textLabel.layer.masksToBounds = YES;
        self.textLabel.layer.cornerRadius = 5;
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:self.textLabel];
        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        
//        self.textLabel.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        }
    return self;
}

@end
