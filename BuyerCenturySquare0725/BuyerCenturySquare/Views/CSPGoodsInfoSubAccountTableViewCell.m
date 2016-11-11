//
//  CSPGoodsInfoSubAccountTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/14.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoSubAccountTableViewCell.h"
#import "ConversationWindowViewController.h"
@implementation CSPGoodsInfoSubAccountTableViewCell{
    
    NSInteger startNum;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)consultAndSettleButton:(id)sender {
    
    NSDictionary *goodsDic = [[NSDictionary alloc]initWithObjectsAndKeys:_goodsInfo,@"list",_hasSelectedModel,@"model", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kConsultAndSettleButtonClickedNotification object:nil userInfo:goodsDic];
    
    
}

- (void)setStartNum:(NSNumber*)num{
    
    _startNumL.text = [NSString stringWithFormat:@"起批：%@",num];
    startNum = [num integerValue];
}

- (void)setHasSelectedNum:(NSInteger)num{
    
    _hasSelectedNumL.text = [NSString stringWithFormat:@"已选购：%zi",num];
}

- (void)setHasSelectedModel:(NSString *)hasSelectedModel{
    
    _hasSelectedModel = hasSelectedModel;
    
    if ([hasSelectedModel isEqualToString:@"0"]) {
        
        _startNumL.text = [NSString stringWithFormat:@"发版：1"];
        _hasSelectedNumL.hidden = YES;
        _lineView.hidden = YES;
        [_button setTitle:@"发版结算" forState:UIControlStateNormal];
        [_button setTitle:@"发版结算" forState:UIControlStateHighlighted];
    }else{

        _startNumL.text = [NSString stringWithFormat:@"起批：%zi",startNum];
        _hasSelectedNumL.hidden = NO;
        _lineView.hidden = NO;
        [_button setTitle:@"询单结算" forState:UIControlStateNormal];
        [_button setTitle:@"询单结算" forState:UIControlStateHighlighted];
    }
}

@end
