//
//  AddressDetailTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/10.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddressDetailTableViewCell.h"

@implementation AddressDetailTableViewCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;

}

-(void)awakeFromNib
{
    
    [self.nameLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.detailIofoLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
}

@end
