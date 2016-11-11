//
//  CSPBaseTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/5/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBaseTableViewCell.h"

@implementation CSPBaseTableViewCell
{
}
- (void)awakeFromNib {
    // Initialization code


}
-(void)drawRect:(CGRect)rect
{
  
    
   
    
}


-(void)setShowLine:(BOOL)showLine{
//    UIView *view = [self viewWithTag:99];
//    if (view) {
//        if (_showLine) {
//            view.hidden = NO;
//        }else{
//            view.hidden = YES;
//        }
//        
//    }else{
//        UIImageView *imagLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height, self.frame.size.width, 0.5)];
//        // imagLine.backgroundColor = [UIColor colorWithHexValue:0xececec alpha:1];
//        imagLine.tag = 99;
//        imagLine.image = [UIImage imageNamed:@"tableline"];
//        [self addSubview:imagLine];
//    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
     self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //显示线条
        if (_showLine) {
            self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height, SCREEN_WIDTH, 1)];
            self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:0.5];
            [self.contentView addSubview:self.lineLabel];
        }
    }
    return  self;
}

@end
