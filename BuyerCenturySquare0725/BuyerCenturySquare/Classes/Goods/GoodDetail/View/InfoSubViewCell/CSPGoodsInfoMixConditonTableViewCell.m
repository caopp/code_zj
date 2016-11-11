//
//  CSPGoodsInfoMixConditonTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoMixConditonTableViewCell.h"

@implementation CSPGoodsInfoMixConditonTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMix:(NSNumber*)num price:(NSNumber*)price{
    
    float price_f = [price floatValue];
    
    _mixL.text = [NSString stringWithFormat:@"全店满%@件或满%.2lf元可混批",num,price_f];
    
    if ([num integerValue]==-1) {
        _mixL.text = [NSString stringWithFormat:@"全店满%.2lf元可混批",price_f];
    }
    
    if ([price integerValue]==-1) {
        _mixL.text = [NSString stringWithFormat:@"全店满%@件可混批",num];
    }
    
    if ([num integerValue]==-1&&[price integerValue]==-1) {
        _mixL.text = [NSString stringWithFormat:@"全店可混批"];
    }
    
}

- (void)updateBatchMsg:(NSString*)batchMsg{
    
    _mixL.text = batchMsg;
}

- (void)setModeState:(BOOL)modeState{
    
    _alphaView.hidden = !modeState;
}

@end
