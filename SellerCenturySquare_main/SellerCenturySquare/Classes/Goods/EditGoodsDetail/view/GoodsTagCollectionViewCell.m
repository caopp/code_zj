//
//  GoodsTagCollectionViewCell.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsTagCollectionViewCell.h"
#import "Masonry.h"
#import "UIColor+HexColor.h"
@interface GoodsTagCollectionViewCell ()


@end
@implementation GoodsTagCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        self.tagNameLabel = [[UILabel alloc] init];
        [self addSubview:self.tagNameLabel];
        
        self.tagNameLabel.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:1].CGColor;
        self.tagNameLabel.layer.borderWidth = 0.5;
        self.tagNameLabel.layer.cornerRadius = 2;
        self.tagNameLabel.layer.masksToBounds = YES;
        self.tagNameLabel.textAlignment = NSTextAlignmentCenter;
        
        self.tagNameLabel.font = [UIFont systemFontOfSize:13];
        
        self.tagNameLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
        
        [self.tagNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        
    }
    return self;
    
}
@end

