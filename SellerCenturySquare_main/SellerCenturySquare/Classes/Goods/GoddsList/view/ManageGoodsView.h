//
//  ManageGoodsView.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDRefresh.h"
#import "WholeAndRetailSegmentView.h"

typedef NS_ENUM(NSInteger, GoodsStatus) {
    GoodStatusOnSales = 0,
    GoodStatusNewRelease = 1,
    GoodStatusUndercarriage
};

@interface ManageGoodsView : UIView

//!返回 是否是下拉刷新，以及商品的状态、销售渠道
@property(nonatomic,copy) void (^refreshBlock)(BOOL isHeader,NSInteger goodsStatus,NSString * channelType);

//!进入商品详情
@property(nonatomic,copy) void(^intoDetailBlock)(NSString *goodsNo);


// !单个商品上架 下架（goodsStatus：要让商品成为的状态：2上架，3下架）
@property(nonatomic,copy)void (^goodsOperationBlock)(NSString *goodsNo,NSString *goodsStatus);


//!多个商品上下架 （goodsStatus：要让商品成为的状态：2上架，3下架）
@property(nonatomic,copy)void (^multiGoodsOperationBlock)(NSMutableArray *selectGoodsArray,NSString *goodsStatus );


// !商家歇业和关闭的时候不能上架商品 把原因传回去
@property(nonatomic,copy)void(^cannotChangeStatus)(NSString *reason);


//!选中的数据
@property(nonatomic,strong)NSMutableArray * selectArray;


//!在售下面各个状态的分段选择
@property(nonatomic,strong)WholeAndRetailSegmentView * segmentView;

//!销售渠道
@property(nonatomic,copy)NSString * channelType;

//!初始化
-(instancetype)initWithFrame:(CGRect)frame withGoodsStatus:(NSInteger)goodsStatus;

//!刷新数据
-(void)reloadData:(NSMutableArray *)dataArray  withTotalCount:(NSInteger)totalCount;

-(void)endRefresh;

//!设置列表是否可以置顶
-(void)setTableViewScrollToTop:(BOOL)canToTop;

//!在售状态下，修改销售渠道的按钮点击block
@property(nonatomic,copy) void(^leftChangeChannelBlock)(NSMutableArray * selectArray);

@property(nonatomic,copy) void(^rightChangeChannelBlock)(NSMutableArray * selectArray);





@end
