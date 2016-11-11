//
//  CSPColorSizeTableViewCell.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CSPColorSizeTableViewCell.h"
#import "DoubleSku.h"
#import "GoodsInfoDetailsDTO.h"
static NSInteger indexTag;
@implementation CSPColorSizeTableViewCell{
    NSMutableArray *skuListArr;
    //NSInteger indexTag;
    CGRect selfF;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib {
    // Initialization cod
    [_skuControlViews enumerateObjectsUsingBlock:^(CSPSkuControlView* obj, NSUInteger idx, BOOL *stop) {
        
        obj.delegate = self;
    }];
    selfF = self.frame;

    
}
- (void)setModeState:(BOOL)modeState{
    
    _alphView.hidden = !modeState;
}
-(void)setColorList:(NSMutableArray *)colorList{
        NSInteger colorListCount = colorList.count;
    if (colorListCount >4) {
        self.colorScroll.pagingEnabled = YES;
        self.colorScroll.scrollEnabled = YES;

    }else{
        self.colorScroll.scrollEnabled = NO;

    }
   
    [_segments enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        
        if (idx<colorListCount) {
            [obj setHidden:NO];
            GoodsInfoDetailsDTO *goodsInfoDetails = [colorList objectAtIndex:idx];
            [obj setTitle:goodsInfoDetails.color forState:UIControlStateNormal];
            if (idx == _select_itm) {
                UIImage *img= [UIImage imageNamed:@"color_normal"];
                img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
                obj.backgroundColor = [UIColor whiteColor];
                [obj setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
                [obj setBackgroundImage:img forState:UIControlStateNormal];
            }
//            DoubleSku *skuDTO = skuList[idx];
//            
//            if (skuDTO) {
//                obj.title = skuDTO.skuName;
//                obj.skuValue = skuDTO;
//            }
        }else{
            [obj setHidden:YES];
        }
        
    }];

}
- (void)setSkuList:(NSMutableArray *)skuList{
    skuListArr = nil;
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
        
        CGRect cellFrame = selfF;
        cellFrame.size.height += 40*(lineCount-borderNum)+5+8;
        CGRect rect = _minLabel.frame;
        rect.origin.y += 40*(lineCount-borderNum)+5;
        _minLabel.frame = rect;
        [self setFrame:cellFrame];
    }else{
        CGRect cellFrame = selfF;
        cellFrame.size.height +=5+8;
        [self setFrame:cellFrame];
    }
}
- (IBAction)colorChange:(UIButton *)sender {
   
//    if (indexTag == sender.tag) {
//        return;
//    }else{
//        indexTag = sender.tag;
//    }
    [_segments enumerateObjectsUsingBlock:^(UIButton* obj, NSUInteger idx, BOOL *stop) {
        if (idx ==sender.tag) {
            UIImage *img= [UIImage imageNamed:@"color_normal"];
            img = [img stretchableImageWithLeftCapWidth:2 topCapHeight:2];
            obj.backgroundColor = [UIColor whiteColor];
            [obj setTitleColor:[UIColor colorWithHexValue:0x333333 alpha:1] forState:UIControlStateNormal];
            [obj setBackgroundImage:img forState:UIControlStateNormal];
        }else{
            obj.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [obj setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
             [obj setBackgroundImage:nil forState:UIControlStateNormal];
        }
     
    }];
 
    NSString *totalStr = [NSString stringWithFormat:@"%zi",sender.tag];
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:totalStr,@"colorTag", nil];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kGoodsColorChangedNotification object:nil userInfo:dic];
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
