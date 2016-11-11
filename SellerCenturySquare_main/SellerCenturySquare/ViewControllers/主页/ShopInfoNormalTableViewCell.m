//
//  ShopInfoNormalTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/10.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ShopInfoNormalTableViewCell.h"

@implementation ShopInfoNormalTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)getDetailInfoStr:(NSString *)str num:(NSNumber *)num
{

    self.detailInfoL.text = str;
    
    

}


@end
