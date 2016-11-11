//
//  CSPGoodsInfoSubSizePicTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 李春晓 on 15/7/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsInfoSubSizePicTableViewCell.h"

@implementation CSPGoodsInfoSubSizePicTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setReferenceButtonNum:(NSInteger)num{
    NSString *title = [NSString stringWithFormat:@"参考图(%zi)",num];
    _refL.text = title;
   
}

- (IBAction)objectiveButton:(id)sender {
        
    [self objectiveState:YES];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"objectiveButton",@"type", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kObjectiveAndRefrenceButtonClickedNotification object:nil userInfo:dic];
}

- (IBAction)referenceButton:(id)sender {
    
    [self objectiveState:NO];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"referenceButton",@"type", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kObjectiveAndRefrenceButtonClickedNotification object:nil userInfo:dic];
}

- (void)objectiveState:(BOOL)objective{
    
    if (objective) {
        _objBackView.backgroundColor = [UIColor whiteColor];
        _objL.textColor = [UIColor blackColor];
        
        _refBackView.backgroundColor = [UIColor blackColor];
        _refL.textColor = [UIColor whiteColor];
    }else{
        _objBackView.backgroundColor = [UIColor blackColor];
        _objL.textColor = [UIColor whiteColor];
        
        _refBackView.backgroundColor = [UIColor whiteColor];
        _refL.textColor = [UIColor blackColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
