//
//  ApplyTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/5/10.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ApplyTableViewCell.h"

@implementation ApplyTableViewCell

- (void)awakeFromNib {

    self.backgroundColor = [UIColor clearColor];
    self.groundView.layer.masksToBounds = YES;
    self.groundView.layer.cornerRadius = 2;
    
    self.applyButton.layer.masksToBounds = YES;
    self.applyButton.layer.cornerRadius = 2;
    self.applyButton.layer.borderWidth = 1;
    [self.applyButton setTitleColor:[UIColor colorWithHexValue:0x666666 alpha:1] forState:(UIControlStateNormal)];
    self.applyButton.layer.borderColor = [UIColor colorWithHexValue:0x666666 alpha:1].CGColor;
    [_descritionLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    _descritionLabel.attributedText = [self getAttributedStringWithString:_descritionLabel.text lineSpace:2];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   }

- (IBAction)didClickButtonAction:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(jumpApplyPage)]) {
        [self.delegate performSelector:@selector(jumpApplyPage)];
    }
    
}

-(NSAttributedString *)getAttributedStringWithString:(NSString *)string lineSpace:(CGFloat)lineSpace {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpace; // 调整行间距
    NSRange range = NSMakeRange(0, [string length]);
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    return attributedString;
}


@end
