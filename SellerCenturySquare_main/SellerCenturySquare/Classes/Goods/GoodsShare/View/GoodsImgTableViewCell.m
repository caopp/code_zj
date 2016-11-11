//
//  GoodsImgTableViewCell.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/8.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsImgTableViewCell.h"

@implementation GoodsImgTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)refigDTO:(GoodsSharePicDTO *)dto{
    [_goodsImgView sd_setImageWithURL:[NSURL URLWithString:dto.imageUrl] placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
    NSString *str = [self separatedByString:dto.imageUrl] ;
    if (str) {
        NSArray *arr = [str componentsSeparatedByString:@"X"];
        if (arr.count >1) {
            CGFloat widthImg = [[arr objectAtIndex:0] floatValue];
            CGFloat heightImg = [[arr objectAtIndex:1] floatValue];
            CGFloat width = [[UIScreen mainScreen]bounds].size.width;
            CGFloat height = (width-30)/widthImg*heightImg;
            
            CGRect rect = self.frame;
            rect.size.height = height+3;
            [self setFrame:rect];
            
        }
        
    }

}
-(NSString *)separatedByString:(NSString *)strUrl{
    NSArray *arr1 = [strUrl componentsSeparatedByString:@"_"];
    NSString *separate = [arr1 lastObject];
    NSArray *arr2 = [separate componentsSeparatedByString:@"."];
    NSString *separate2 = [arr2 firstObject];
    return separate2;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
