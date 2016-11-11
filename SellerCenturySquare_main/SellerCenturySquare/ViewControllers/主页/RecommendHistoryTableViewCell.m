//
//  RecommendHistoryTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendHistoryTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "GoodsPicDTO.h"
#import "NSDate+Utils.h"
//static const NSString *host = @"http://183.61.244.243:81";

@implementation RecommendHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
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
    
    rect.size.height = 90+55*rowCount;
    
    [self setFrame:rect];
    
    for (int i = 0; i<rowCount; i++) {
        
        for (int j = 0; j<5; j++) {
            
            if (j>0&&i==rowCount-1&&_imagesArr.count%5==j) {
                
                break;
            }
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(j*55, 5+i*55, 50, 50)];
            
            NSString *urlStr = [NSString stringWithFormat:@"%@",_imagesArr[i*5+j]];
            
            NSURL *url = [NSURL URLWithString:urlStr];
            
            [imageView sd_setImageWithURL:url];
            
            [self.viewForImages addSubview:imageView];
            
        }
    }
    
    _recommendGoodsL.text = [NSString stringWithFormat:@"推荐商品：%zi款",_imagesArr.count];
}

- (void)setRecommendRecordDTO:(RecommendRecordDTO *)recommendRecordDTO{
    
    _recommendRecordDTO = recommendRecordDTO;
    
    NSMutableArray *imagesUrls = [[NSMutableArray alloc]init];
    
    for (GoodsPicDTO *goodsPicDTO in recommendRecordDTO.GoodsPicDTOList) {
        
        [imagesUrls addObject:goodsPicDTO.picUrl];
    }
    
    self.imagesArr = imagesUrls;
    
    _recommendGoodsL.text = [NSString stringWithFormat:@"推荐商品：%@款",recommendRecordDTO.goodsNum];
    
    _receivePersonL.text = [NSString stringWithFormat:@"收件人：%@人",recommendRecordDTO.memberNum];

    NSString *dateStr= @"";
    
    if (recommendRecordDTO.createDate.length>16) {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        
//        [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
//        
//        NSDate *destDate= [dateFormatter dateFromString:recommendRecordDTO.createDate];
        dateStr = recommendRecordDTO.createDate;//[destDate stringToday];//[recommendRecordDTO.createDate substringToIndex:16];
    }
    
    _timeL.text = dateStr;
    
    _contentL.text = _recommendRecordDTO.content;
}

- (IBAction)checkDetailButtonClicked:(id)sender {

    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:_recommendRecordDTO,@"dto", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kCheckDetailInfoNotification object:nil userInfo:dic];
}


@end
