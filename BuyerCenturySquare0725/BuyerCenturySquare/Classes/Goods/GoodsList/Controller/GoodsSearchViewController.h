//
//  GoodsSearchViewController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllGoodsViewController.h"

@interface GoodsSearchViewController : AllGoodsViewController

/*
 
 导航上面更改（同GoodsFilterViewController 筛选结果页）
 
 创建tableView方法重写
 
 */

//!返回搜索界面的时候告诉搜索的是否是商家
@property(nonatomic,copy) void(^isSearchMerchantBlock)(BOOL);



@end
