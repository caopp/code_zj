//
//  RecommendSendFirstTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendSendFirstTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RecommendSendFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _imagesArr = [[NSMutableArray alloc]init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImagesArr:(NSMutableArray *)imagesArr{
    
    if (!imagesArr) {
        return;
    }
    
    _imagesArr = imagesArr;
    
    //删除
    for (id obj in self.subviews) {
        
        if ([obj isKindOfClass:[UIImageView class]]) {
            
            [obj removeFromSuperview];
        }
    }
    
    NSInteger rowCount = _imagesArr.count/5;
    if (_imagesArr.count%5>0) {
        rowCount++;
    }
   
    CGRect rect = self.frame;
    
    rect.size.height += 55*(rowCount-1);
    
    [self setFrame:rect];
    
    for (int i = 0; i<rowCount; i++) {
          
        for (int j = 0; j<5; j++) {
            
            if (i==rowCount-1&&_imagesArr.count%5==j) {
                
                break;
            }
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15+j*55, 49+i*55, 50, 50)];
            
            NSURL *url = [NSURL URLWithString:_imagesArr[i*5+j]];
            
            [imageView sd_setImageWithURL:url];
            
            [self addSubview:imageView];
            
        }
    }
    
    _tipsL.text = [NSString stringWithFormat:@"已推荐商品：%zi款",_imagesArr.count];
}


- (IBAction)modifyButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kModifyRecommendNumberNotification object:nil];
}

@end
