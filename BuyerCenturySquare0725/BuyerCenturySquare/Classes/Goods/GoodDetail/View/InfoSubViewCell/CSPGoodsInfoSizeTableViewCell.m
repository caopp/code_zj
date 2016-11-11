//
//  CSPGoodsInfoSizeTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsInfoSizeTableViewCell.h"
#import "DoubleSku.h"

@implementation CSPGoodsInfoSizeTableViewCell{
    
    NSMutableArray *skuListArr;
    
}

- (void)awakeFromNib {
    // Initialization cod
    [_skuControlViews enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
   
        obj.delegate = self;
    }];
    
}


- (void)setSkuList:(NSMutableArray *)skuList{
    
    skuListArr = skuList;
    
    [skuList sortUsingComparator:^NSComparisonResult(DoubleSku * obj1, DoubleSku * obj2) {
        if (obj1.sort > obj2.sort) {
            return NSOrderedDescending;
        } else if (obj1.sort < obj2.sort) {
            return NSOrderedAscending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    NSInteger skuListCount = skuList.count;
    
    NSInteger lineCount;
    NSInteger lineCountA = skuListCount/2;
    NSInteger lineCountB = skuListCount%2;
    
    if (lineCountB>0) {
        lineCount = lineCountA + 1;
    }else{
        lineCount = lineCountA;
    }
    
    [_skuControlViews enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {

        if (idx<skuListCount) {
            [obj setHidden:NO];
            
            DoubleSku *skuDTO = skuList[idx];
            
            if (skuDTO) {
                obj.title = skuDTO.skuName;
                obj.skuValue = skuDTO;
            }
        }else{
            [obj setHidden:YES];
        }
        
    }];
    
    int borderNum = 1;
    if (lineCount>borderNum) {
        
        CGRect cellFrame = self.frame;
        cellFrame.size.height += 40*(lineCount-borderNum);
        
        [self setFrame:cellFrame];
    }
}

- (void)setModeState:(BOOL)modeState{
    
    _alphaView.hidden = !modeState;
}

- (void)skuControlView:(CSPSkuControlView*)skuControlView skuValueChanged:(BasicSkuDTO*)skuValue{
    
    _total = 0;
    for (DoubleSku *tmpSku in skuListArr) {
        
        _total += tmpSku.spotValue;
    }
    
    NSString *totalStr = [NSString stringWithFormat:@"%zi",_total];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:totalStr,@"totalCount", nil];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kGoodsCountChangedNotification object:nil userInfo:dic];
    
}


@end