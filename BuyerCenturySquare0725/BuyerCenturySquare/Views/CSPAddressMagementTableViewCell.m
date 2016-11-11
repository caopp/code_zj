//
//  CSPAdressMagementTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAddressMagementTableViewCell.h"
#import "UIColor+UIColor.h"

@implementation CSPAddressMagementTableViewCell

- (void)awakeFromNib {
    
    //姓名
    [self.nameLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    //电话
    [self.phoneNumberLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    //详细地址
    [self.detaiAdressLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    [self.defaultLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.deleteLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    [self.editLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];

    
    [self.defuaultButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateNormal)];
     [self.defuaultButton setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:(UIControlStateSelected)];
    
//    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, _lineView.frame.origin.y + 31)];

//    self.detaiAdressLabel.backgroundColor = [UIColor redColor];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)defaultButtonClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultButtonTaped:)]) {
        [self.delegate defaultButtonTaped:sender];
    }
}
- (IBAction)editButtonClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editButtonTaped:)]) {
        [self.delegate editButtonTaped:sender];
    }
}
- (IBAction)deleteButtonClicked:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteButtonTaped:cell:)]) {
        [self.delegate deleteButtonTaped:self.deleteButton cell:self];
    }
}

-(void)getAddressMagementTableViewCellConsigneeDTO:(ConsigneeDTO *)consigneeDTO
{
    //#名字进行赋值
    _nameLabel.text  = consigneeDTO.consigneeName;
    //#电话号码进行赋值
    _phoneNumberLabel.text = consigneeDTO.consigneePhone;
    
    //#详细地址进行赋值
    _detaiAdressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",consigneeDTO.provinceName,consigneeDTO.cityName,consigneeDTO.countyName,consigneeDTO.detailAddress];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_detaiAdressLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:2];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _detaiAdressLabel.text.length)];
//    _detaiAdressLabel.attributedText = attributedString;
    
    _detaiAdressLabel.numberOfLines = 0;
    //#defaultFlag（对选中地址进行默认选项）
    if ([consigneeDTO.defaultFlag isEqualToString:@"0"]) {
        _defuaultButton.selected = YES;
    }else{
        _defuaultButton.selected = NO;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size = [_detaiAdressLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    CGRect frame = self.frame;
    frame.size.height = size.height +90;
    self.frame = frame;

    
}

-(CGFloat)setHeight:(NSString *)addressHeight
{
    CGSize  detailAddressHeight = [addressHeight boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    return detailAddressHeight.height;
}




@end
