//
//  AddressDetailCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddressDetailCell.h"

@implementation AddressDetailCell

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

        [self makeUI];
    }
    return self;
}

//设置ui
-(void)makeUI
{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 80, 15)];
    self.nameLabel.text = @"详细地址";
    self.nameLabel.font = [UIFont systemFontOfSize:14];
    [self.nameLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self addSubview:self.nameLabel];
    
    //设置详细地址
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    [self.detailLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
     self.detailLabel.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5, 15, self.frame.size.width-60, 15);
    self.detailTextLabel.numberOfLines = 0;
    [self addSubview:self.detailLabel];

}
-(void)getHeight:(CGSize )size
{
    self.detailLabel.frame = CGRectMake(self.nameLabel.frame.origin.x + self.nameLabel.frame.size.width + 5, 15, self.frame.size.width-60, size.height);
}


@end
