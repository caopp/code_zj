//
//  CSPGoodsInfoSubPicsTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoSubPicsTableViewCell.h"
#import "UIImageView+WebCache.h"


@implementation CSPGoodsInfoSubPicsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUrl:(NSString *)url{
    _imgView.image = nil;
    NSURL *url_ = [NSURL URLWithString:url];
    NSString *str = [self separatedByString:url] ;
    if (str) {
        NSArray *arr = [str componentsSeparatedByString:@"X"];
        if (arr.count >1) {
            CGFloat widthImg = [[arr objectAtIndex:0] floatValue];
            CGFloat heightImg = [[arr objectAtIndex:1] floatValue];
            CGFloat width = [[UIScreen mainScreen]bounds].size.width;
            CGFloat height = width/widthImg*heightImg;
            
            CGRect rect = self.frame;
            rect.size.height = height+3;
            [self setFrame:rect];
            
        }
    
    }
    _imgView.backgroundColor = [UIColor colorWithHexValue:0xf2f2f2 alpha:1];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    [_imgView sd_setImageWithURL:url_ placeholderImage:[UIImage imageNamed:@"placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            
            CGFloat width = [[UIScreen mainScreen]bounds].size.width;
            CGFloat height = width/image.size.width*image.size.height;
            
            CGRect rect = self.frame;
            rect.size.height = height+3;
            [self setFrame:rect];
        }

    }];
    
}
-(NSString *)separatedByString:(NSString *)strUrl{
   NSArray *arr1 = [strUrl componentsSeparatedByString:@"_"];
    NSString *separate = [arr1 lastObject];
    NSArray *arr2 = [separate componentsSeparatedByString:@"."];
    NSString *separate2 = [arr2 firstObject];
    return separate2;
}
@end
