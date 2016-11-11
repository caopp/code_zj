//
//  RefreshTableView.h
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "HttpManager.h"
#import "GoodsShareDTO.h"
@interface RefreshTableView : UITableView
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property(nonatomic,strong)NSMutableArray *arrShareGoods;
@property(nonatomic,assign)NSInteger totalCount;
@property(nonatomic,strong)NSString *goodsNo;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,assign)GoodsShareStatus shareStatus;
@property(nonatomic,assign)int pageNo;
@property (nonatomic,strong)void(^changeHeadBlock)();
@end
