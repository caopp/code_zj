//
//  ShippingTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ShippingTableViewCell.h"

@implementation ShippingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
//        self.backgroundColor = [UIColor redColor];
        [self makeUI];
    }
    return self;
}
//设置
-(void)makeUI
{
    //设置图像
    self.iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 8, 29, 29)];
//    self.iconView.backgroundColor = [UIColor yellowColor];
    [self addSubview:self.iconView];
    
    self.iconRed = [[UILabel alloc]initWithFrame:CGRectMake(37, 8, 7, 7)];
    self.iconRed.backgroundColor =  [UIColor colorWithHexValue:0xfd4f57 alpha:1];
    self.iconRed.layer.masksToBounds = YES;
    self.iconRed.layer.cornerRadius = 3.5;
    [self addSubview:self.iconRed];
    
    
    
    self.detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconView.frame.size.width + self.iconView.frame.origin.x + 16, 15, 200, 14)];
    [self addSubview:self.detailLabel];
    
    self.detailLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    self.detailLabel.font = [UIFont systemFontOfSize:17.0f];
    
    _lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(59, 44, SCREEN_WIDTH - 59, 0.5)];
    _lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    [self.contentView addSubview:_lineLabel];
    
}


@end
