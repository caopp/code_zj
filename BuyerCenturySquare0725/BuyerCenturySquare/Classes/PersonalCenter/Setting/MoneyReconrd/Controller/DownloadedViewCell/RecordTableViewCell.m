//
//  RecordTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/20.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "RecordTableViewCell.h"

#import "UIColor+UIColor.h"

@implementation RecordTableViewCell

- (void)awakeFromNib {
    
     self.gradeaLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
     self.createTimeLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
     self.moneyLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    
}
-(void)setModelParameters:(DealFlowModel *)parameters
{
    self.gradeaLabel.text = parameters.subject;
    self.createTimeLabel.text = parameters.createTime ;
    self.moneyLabel.text = [NSString stringWithFormat:@"+%f",parameters.amount];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
