//
//  SearchGoodsListView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsListView.h"

@interface SearchGoodsListView : GoodsListView
{

    NSString * queryParam;
    NSString * rangeFlag;
    
}




//!传入查询的内容、范围
-(instancetype)initWithFrame:(CGRect)frame withQueryParam:(NSString *)queryParams withRangeFlag:(NSString *)rangeFlags;


@end
