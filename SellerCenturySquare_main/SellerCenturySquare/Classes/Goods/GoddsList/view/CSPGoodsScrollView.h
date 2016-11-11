//
//  CSPGoodsScrollView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CPSGoodsViewController.h"
#import "RefreshControl.h"

@interface CSPGoodsScrollView : UIScrollView<UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>

//!商品数据
@property(nonatomic,strong)NSMutableArray *resourceData;

//!商品数量
@property(nonatomic,strong)NSMutableDictionary *numDic;


@property(nonatomic,strong)NSMutableArray *tipNoDataArray;

@property(nonatomic,strong)NSMutableArray *titleArray;
// !选择商品
@property(nonatomic,copy)void (^selectedGoodsBlock)(NSMutableArray *array);
// !上架 下架
@property(nonatomic,copy)void (^goodsOperationBlock)(NSString *goodsNo,NSString *goodsStatus);
// !全选/全不选
@property(nonatomic,copy)void (^undercarriageBlock)(NSMutableArray *array);

// !商家歇业和关闭的时候不能上架商品 把原因传回去
@property(nonatomic,copy)void(^cannotChangeStatus)(NSString *reason);


// !商品详情编辑
@property(nonatomic,copy)void (^goodsDetailsEditBlock)(NSString *goodsNo);

@property(nonatomic,copy)void (^refreshBlock)(NSString *goodsStatus,GoodsSalesStatus salesStatus);


- (void)addViewOnScrollViewWithNumber:(NSInteger)number;

- (void)hiddenTipNoDataLabel;

- (void)selectAllWithGoodsSalesStatus:(GoodsSalesStatus)goodsSalesStatus;

- (void)selectNothingWithGoodsSalesStatus:(GoodsSalesStatus)goodsSalesStatus;

/**
 *  刷新数据
 */
- (void)reloadData;

/**
 *  上拉加载完成
 */
- (void)completeRefresh;


- (void)completeRefresh:(NSInteger)index;



//!每次请求回来，都需要先把状态改成yes
-(void)changeBottomStatus:(NSInteger)index;

//!没有数据的时候停止给footer的下拉；有数据，但是已经全部请求了，就改底部提示语
-(void)stopFooterRefreshAlert:(NSInteger)index withNumDic:(NSDictionary *)dic;

//!设置 点击状态栏 tableView是否可以滑动到顶部
-(void)setScToTopWithGrounding:(BOOL)isGrounding withNew:(BOOL)isNew withUnGrounding:(BOOL)isUnGrounding;

@end
