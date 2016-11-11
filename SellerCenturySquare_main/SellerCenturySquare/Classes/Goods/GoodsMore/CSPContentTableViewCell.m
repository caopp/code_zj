//
//  CSPContentTableViewCell.m
//  CustomerCenturySquare
//
//  Created by caopenpen on 16/6/21.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "CSPContentTableViewCell.h"

@implementation CSPContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)loadDTO:(GoodsMoreDTO *)dto{
   
  
    if (dto.details.length) {
         _contentLabel.text = dto.details;
        CGSize size = [self sizeWithText:dto.details font:[UIFont systemFontOfSize:12] maxSize:CGSizeMake(SCREEN_WIDTH-30, SCREEN_HIGHT)];
        CGRect rect = self.frame;
        rect.size.height = size.height +30;
        [self setFrame:rect];
    }else{
        _contentLabel.text = @"";
        CGRect rect = self.frame;
        rect.size.height = 0;
        [self setFrame:rect];
    }
   
}
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
