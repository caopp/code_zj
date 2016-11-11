//
//  DetailPicTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "DetailPicTableViewCell.h"
#import "UIColor+UIColor.h"


@implementation DetailPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //展示名字
    [self.nameLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    //展示时间
    [self.timeLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    //按钮点击事件
    //设置窗口图的名字
    [self.setLabel setTextColor:[UIColor colorWithHex:0x000000 alpha:1]];
    //窗口图和详情图
    //分割线
    [self.lineView setBackgroundColor:[UIColor colorWithHex:0xc8c7cc alpha:1]];
    
    
    self.WindowWithDetail.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setImageTagGesture)];
    [self.WindowWithDetail addGestureRecognizer:tap];
    
}

//接受数据赋值给cell
-(void)acceptGoodImageDTO:(GoodImageDTO *)goodImageDTO
{
    //窗口图和详情图
    [self settingUrl:goodImageDTO.imageUrl];
}


- (void)settingUrl:(NSString *)url{
    
    if ( self.WindowWithDetail.image == nil) {
        return;
    }
    
    NSURL *url_ = [NSURL URLWithString:url];
    
    NSString *str = [self separatedByString:url];
    
    if (str) {
        NSArray *arr = [str componentsSeparatedByString:@"X"];
        if (arr.count >1) {
            CGFloat widthImg = [[arr objectAtIndex:0] floatValue];
            CGFloat heightImg = [[arr objectAtIndex:1] floatValue];
            CGFloat imageHeight = (SCREEN_WIDTH - 30)/widthImg*heightImg;
            self.widthConstrain.constant = (SCREEN_WIDTH - 30);
            self.heightConstraint.constant = imageHeight;
            CGRect rect = self.frame;
            rect.size.height = imageHeight + 109;
            [self setFrame:rect];
            
        }
    }
    
    self.WindowWithDetail.backgroundColor = [UIColor colorWithHexValue:0xf2f2f2 alpha:1];
    self.WindowWithDetail.contentMode = UIViewContentModeScaleAspectFit;
    [self.WindowWithDetail sd_setImageWithURL:url_ placeholderImage:[UIImage imageNamed:@"middle_placeHolder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            CGFloat imageHeight = (SCREEN_WIDTH - 30)/image.size.width *image.size.height;
    
            self.widthConstrain.constant = SCREEN_WIDTH - 30;
            
            self.heightConstraint.constant = imageHeight;
    
            CGRect rect = self.frame;
            
            rect.size.height = imageHeight + 109;
            
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





-(void)setImageTagGesture
{
    
    if ( self.WindowWithDetail.image == nil) {
        return;
    }

    if ([self.delegate respondsToSelector:@selector(amplificationImage:)]) {
        [self.delegate amplificationImage:self.WindowWithDetail];
    }
}

- (IBAction)didClickSelectButtonAction:(UIButton *)sender
{

    if ([self.delegate respondsToSelector:@selector(setDetailButton:image:)]) {
        
        [self.delegate setDetailButton:self.selectedButton image:self.WindowWithDetail];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
