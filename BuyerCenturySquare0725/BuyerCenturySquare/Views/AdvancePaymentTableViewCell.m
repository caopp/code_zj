//
//  AdvancePaymentTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/3/9.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AdvancePaymentTableViewCell.h"
@interface AdvancePaymentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *advancePaymentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;

@end


@implementation AdvancePaymentTableViewCell
- (IBAction)didClickAdvancePaymentBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickAdvancePaymentPage)]) {
        [self.delegate performSelector:@selector(didClickAdvancePaymentPage)];
    }
}

- (void)awakeFromNib {
    self.advancePaymentLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    [self.advancePaymentButton setTitleColor:[UIColor colorWithHexValue:0x666666 alpha:1] forState:(UIControlStateNormal)];
    self.advancePaymentButton.layer.borderColor = [UIColor colorWithHexValue:0x666666 alpha:1].CGColor;
    
//    [self.advancePaymentButton setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    
//    self.advancePaymentButton.layer.cornerRadius = 2;
    self.advancePaymentButton.layer.borderWidth = 1;
    
    self.advancePaymentButton.layer.cornerRadius = 2;
    self.advancePaymentButton.layer.masksToBounds = YES;
    
    self.payLabel.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    self.payLabel.font = [UIFont systemFontOfSize:14];
//    self.payLabel.text = @"余额:¥6780068.88";
    
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    
    self.heightConstraint.constant = 0.5;

    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
