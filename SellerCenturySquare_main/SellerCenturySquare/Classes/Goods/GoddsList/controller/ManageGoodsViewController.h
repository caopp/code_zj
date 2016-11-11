//
//  ManageGoodsViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, GoodsSalesStatus) {
    SalesStatusOnSales = 0,
    SalesStatusNewRelease = 1,
    SalesStatusUndercarriage
};



@interface ManageGoodsViewController : BaseViewController

//!要进入“在售”的各个状态则传对应的字段，否则是进入 “新发布”

//!“在售”的各个状态：销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售

@property(nonatomic,strong)NSString * type;

//!进入已下架
@property(nonatomic,assign)BOOL isIntoUndercarriage;

//!进入新发布
@property(nonatomic,assign)BOOL isIntoNews;


@end
