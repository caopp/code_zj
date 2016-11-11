//
//  MoneyReconrdCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MoneyReconrdCell.h"

@implementation MoneyReconrdCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
//        self.backgroundColor = [UIColor redColor];

        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH, 0.5)];
        self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        [self.contentView addSubview:self.lineLabel];
        
        
    }

    return self;
}


@end
