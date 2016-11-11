//
//  CSPGoodsInfoTextTableViewCell.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPGoodsInfoTextTableViewCell.h"

@implementation CSPGoodsInfoTextTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setInfoString:(NSString *)infoString{
    
      CGRect tmpRect = [infoString boundingRectWithSize:CGSizeMake(self.frame.size.width-20,1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] context:nil];
    NSArray *arr = [infoString componentsSeparatedByString:@"\n\n"];
    CGRect cellFrame = self.frame;
    cellFrame.size.height =tmpRect.size.height +10*(arr.count-1) +100;
    
    [self setFrame:cellFrame];
}
@end
