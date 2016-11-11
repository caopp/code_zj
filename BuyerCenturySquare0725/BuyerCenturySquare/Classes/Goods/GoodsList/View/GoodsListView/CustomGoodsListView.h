//
//  CustomGoodsListView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/8/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsListView.h"

#import "AllListNoGoodsView.h"//!全部商品--》筛选-->暂无相关商品view

@interface CustomGoodsListView : GoodsListView
{
    AllListNoGoodsView * noGoodsView;

}
//!添加下拉刷新
-(void)addHeaderRefresh;

//!移除下拉刷新
-(void)removeHeaderRefresh;



@end
