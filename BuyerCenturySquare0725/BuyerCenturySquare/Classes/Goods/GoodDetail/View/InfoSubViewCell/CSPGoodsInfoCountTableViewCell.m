//
//  CSPGoodsInfoCountTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoCountTableViewCell.h"
#import "GoodsInfoDetailsDTO.h"
@implementation CSPGoodsInfoCountTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModeState:(BOOL)modeState{
    
    _alphaView.hidden = !modeState;
    _selectedBlackView.hidden = modeState;
}
-(void)setSelectNums:(NSMutableArray *)selectNums{
    NSInteger numsCount = selectNums.count;
    NSInteger lineCount;
    NSInteger lineCountA = numsCount/3;
    NSInteger lineCountB = numsCount%3;
    if (lineCountB>0) {
        lineCount = lineCountA + 1;
    }else{
        lineCount = lineCountA;
    }
    [_selectLabels enumerateObjectsUsingBlock:^(UILabel *labels,NSUInteger idx, BOOL *stop){
        if (idx <numsCount) {
            GoodsInfoDetailsDTO *goodsInfoDTO = [selectNums objectAtIndex:idx];
            if (goodsInfoDTO.buyMode) {
                labels.text = [NSString stringWithFormat:@"%@样版: 1",goodsInfoDTO.color];
            }else{
                labels.text = [NSString stringWithFormat:@"%@ : %ld",goodsInfoDTO.color,goodsInfoDTO.buyNum];
            }
            
            [labels setHidden:NO];
        }else{
            [labels setHidden:YES];
        }
     
    }];
    [_lineViews enumerateObjectsUsingBlock:^(UIView *lines,NSUInteger idx, BOOL *stop){
        if (idx< (lineCountA*2 +lineCountB -1)) {
            [lines setHidden:NO];
        }else{
            [lines setHidden:YES];
        }
    }];
    int borderNum = 3;
    if (lineCount<borderNum) {
        
        CGRect cellFrame = self.frame;
        cellFrame.size.height = 135 + 30*(lineCount-borderNum);
        [self setFrame:cellFrame];
    }
}
- (void)setStartNum:(NSNumber*)num{
    
    _startNumL.text = [NSString stringWithFormat:@"本商品起批量：%@件",num];
}


@end
