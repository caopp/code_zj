//
//  TitleZoneGoodsTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 15/11/24.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "TitleZoneGoodsTableViewCell.h"
#import "Masonry.h"

@implementation TitleZoneGoodsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleLabel = [[UILabel alloc] init];
        [self addSubview:_titleLabel];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
        

        
        _titleLabel.text = @"暂无相关采购单";
//        _titleLabel.font = [UIFont fontWithName:@"" size:15];
                _titleLabel.font = [UIFont systemFontOfSize:15];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self);
            make.centerX.equalTo(self);
            make.centerY.equalTo(self).offset(-100);
            

            
        }];
        
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
