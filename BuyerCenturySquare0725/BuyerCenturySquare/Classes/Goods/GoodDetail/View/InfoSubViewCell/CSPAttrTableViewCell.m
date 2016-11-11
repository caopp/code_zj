//
//  CSPAttrTableViewCell.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPAttrTableViewCell.h"

@implementation CSPAttrTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setAttrListDTO:(AttrListDTO *)attrDto{
    self.titleLabel.text = attrDto.attrName;
    self.valueLabel.text = attrDto.attrValText;
    // attrCell.imagesArr = [self getWindowsImageURLs];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
    
    CGSize size = [self.valueLabel.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 178-15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    CGRect frame = self.frame;
    frame.size.height =  (size.height+30) >50?size.height+30:50;  //frame.size.width;
    [self setFrame:frame];
}

@end
