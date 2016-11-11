//
//  GoodsListView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
// 商品列表的view

#import <UIKit/UIKit.h>
#import "MerchantListDetailsDTO.h"//!商家详情
#import "CommodityGroupListDTO.h"//!商品列表
#import "GoodsSortView.h"//!排序的view
#import "GoodsSortDTO.h"//!排序的DTO

@class MerchantDeatilViewController;

static const int  itemSpace = 5;//!item的间距
static const int sectionInsetValue = 7;//!collectionview离两边的距离

@interface GoodsListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    //!item的宽度（图片的宽度）、item高度
    float itemWidth;
    float itemHight;
    
    int page;//!页码
    int num;//!每页请求的个数
    NSString *merchantNo;//!商家number
    NSString * structNo;//!分类编号
    NSString *rangFlag;//!可见范围（0:全部（默认） 1:等级可见）
    
    MerchantListDetailsDTO* merchantDetail;//!商家详情
    
    //!返回顶部按钮
    UIButton *backUpBtn;
    
}
//!排序的view
@property(nonatomic,strong)GoodsSortView * goodsSortView;


@property(nonatomic,strong)UICollectionView * goodsCollectionView;

@property (nonatomic, strong) CommodityGroupListDTO* goodsListDTO;// !商品的列表
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

//!排序的DTO
@property (nonatomic,strong)GoodsSortDTO * sortDTO;

//!初始化的时候需要传入：商家编码、分类编码、查看权限 （没有的话可以传nil）

-(instancetype)initWithFrame:(CGRect)frame withMerchantNo:(NSString *)merchantNo withStructNo:(NSString *)structNo withRangFlag:(NSString *)rangFlag;


//!商家详情--》请求完数据之后判断商家状态，决定显示的是哪个view
@property(nonatomic,copy) void(^merchantShowViewBlock)(MerchantListDetailsDTO *,NSInteger) ;


//!点击事件的处理
@property(nonatomic,copy) void(^selectBlock)(Commodity *);

//!筛选的时候调用的方法
-(void)filterWithStructNo:(NSString *)filterStructNo;

//!全部商品列表 ：筛选没有数据的时候调用
@property(nonatomic,copy) void(^showNoGoodsTips)(NSInteger);

#pragma mark !重置sortDTO
-(void)resetSortDTO;

#pragma mark 给子类调用的方法
-(void)createSortView;

-(void)createCollectionView;

-(void)createRefresh;

//!去除动画，刷新数据
-(void)reloadData;

#pragma mark 给子类重写的方法
-(void)requestData:(SDRefreshView *)refresh;


@end
