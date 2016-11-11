//
//  AudiAndFilterTableViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AudiAndFilterTableViewCell.h"

@implementation AudiAndFilterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    [self.detailAlertLabel setTextColor:[UIColor colorWithHex:0x666666]];
    
    [self.filterLabel setBackgroundColor:[UIColor colorWithHex:0xc8c7cc]];
    
    [self.numLabel setTextColor:[UIColor colorWithHex:0xfd4f57]];
    
}

-(void)configWithFilter:(BOOL)isFilter withNum:(NSInteger)num{


    //!参考图筛选：修改提示的内容
    if (isFilter) {
        
        
        [self.operationTitleLabel setText:@"零售_商品默认参考图筛选"];
        
        [self.detailAlertLabel setText:@"您可从零售端用户分享的商品照片中，筛选适合的图片作为商品的默认参考图。"];
        
        [self.numLeftLabel setText:@"有新增参考图的商品："];
        
    }

    //!数量
    [self.numLabel setText:[NSString stringWithFormat:@"%ld",(long)num]];
    

    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
