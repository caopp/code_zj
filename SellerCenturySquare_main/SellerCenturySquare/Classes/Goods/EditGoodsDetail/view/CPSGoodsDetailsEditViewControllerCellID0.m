//
//  CPSGoodsDetailsEditViewControllerCellID0.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/27.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "CPSGoodsDetailsEditViewControllerCellID0.h"

@implementation CPSGoodsDetailsEditViewControllerCellID0

- (void)awakeFromNib {

    
    // Initialization code
}

-(void)getGoodName:(NSString *)goodName{

    [self.goodName setFont:[UIFont systemFontOfSize:15]];
    self.goodName.textAlignment = NSTextAlignmentLeft;
    
    // !计算大小 ，改变大小
    float width =0;
    if (SCREEN_WIDTH>375) {
        
        width = 240;
        
    }else if(SCREEN_WIDTH >320 && SCREEN_WIDTH<=375){
        
        width = 170;
        
    }else{
    
        width =200;

    }
    CGSize  goodNameSize = [goodName boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil].size;
    if (goodNameSize.height>35) {
        
        self.goodNameHight.constant = goodNameSize.height;

    }else{
    
        self.goodNameHight.constant = 35;

    }
    
    


}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
