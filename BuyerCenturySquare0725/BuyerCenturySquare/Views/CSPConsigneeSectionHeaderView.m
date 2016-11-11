//
//  CSPConsigneeSectionHeaderView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPConsigneeSectionHeaderView.h"
#import "OrderDetailDTO.h"

@implementation CSPConsigneeSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    self.addressLabel.hidden = YES;
    
}

- (void)setConsignee:(ConsigneeDTO *)consignee {
    _consignee = consignee;

    if (consignee) {
        
    
    if (consignee.addressDescription.length>0) {
        self.addressLabel.hidden = NO;

    }
    self.nameLabel.text = [NSString stringWithFormat:@"收货人: %@", _consignee.consigneeName];
    self.phoneNumLabel.text = _consignee.consigneePhone;
    self.addressLabel.text = [NSString stringWithFormat:@"收件地址: %@", _consignee.addressDescription];
    }
}
    

- (void)setOrderDetailInfo:(OrderDetailDTO *)orderDetailInfo {
    
    _orderDetailInfo = orderDetailInfo;
    
    
    if (orderDetailInfo.addressDescription.length>0) {
        self.addressLabel.hidden = NO;
        
    }

    self.nameLabel.text = [NSString stringWithFormat:@"收货人: %@", _orderDetailInfo.consigneeName];
    self.phoneNumLabel.text = _orderDetailInfo.consigneePhone;
    self.addressLabel.text = [NSString stringWithFormat:@"收件地址: %@",_orderDetailInfo.addressDescription];

    self.trailingSpaceLayoutConstraint.constant = 15.0f;
    [self.indicationButton setHidden:YES];
}

- (IBAction)changeConsigneeButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeConsigneeButtonClicked)]) {
        [self.delegate changeConsigneeButtonClicked];
    }
}

+ (CGFloat)sectionHeaderHeightWithContent:(NSString *)content {
    CGSize labelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , CGFLOAT_MAX);
    NSAttributedString* attrContentString = [[NSAttributedString alloc]initWithString:content attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    CGRect bounding =[attrContentString boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading context:nil];
    CGSize size;
    
    size=[content boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,1000 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;
    


    return 54.0f + size.height;
}

/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
//     BOUNDING
    CGSize size;
    
    size=[value boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width,1000 ) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;

    return size.height;
}





@end
