//
//  AllGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
// !全部商品列表、筛选 商品结果列表、搜索 商品结果列表
/*
 
 1、全部商品列表：
 无标识、有侧滑功能
    
 2、筛选界面过来的：
 有 strucutNo
 
 无侧滑功能、有选择 “商家”“商品”框、有可点击的搜索框
 
 3、搜索界面过来的：
 
 有搜索的词
 
 无侧滑功能、有选择 “商家”“商品”框、有可点击的搜索框

 
 */

#import "BaseViewController.h"
#import "SWRevealViewController.h"//!侧滑所需
#import "AllGoodsListSelectView.h"//!全部、我的等级可看 view
#import "GoodsListView.h"//!商品列表
#import "GoodDetailViewController.h"
#import "GoodsInfoDTO.h"
#import "GoodsNotLevelTipDTO.h"//!可查看等级
#import "CSPAuthorityPopView.h"//!等级权限提示view
#import "GoodsClassViewController.h"
#import "AllListNoGoodsView.h"//!全部商品--》筛选-->暂无相关商品view
#import "AppDelegate.h"
#import "LeftSlideViewController.h"
#import "SearchView.h"//!假搜索框
#import "CSPShoppingCartViewController.h"//!采购车
#import "SearchMerhcantAndGoodController.h"//!搜索界面
#import "PersonalCenterDTO.h"//!个人中心的dto
#import "MerchantAndGoodSelectView.h"//!商家、商品的选择框
#import "SlidePageManager.h"//!我的等级可看，全部
#import "SlidePageSquareView.h"

#import "FilterView.h"

@interface AllGoodsViewController : BaseViewController<UIScrollViewDelegate,CSPAuthorityPopViewDelegate ,SWRevealViewControllerDelegate>

{
    //!-----全部商品的导航：
    //!右导航
    UIButton * shopCarBtn;
    //!采购车小红点
    UILabel * shopRedAlertLabel;
    
    
    //!全部、我的等级可看 view
//    AllGoodsListSelectView *selectView;
    
    GoodsListView *allGoodsListView;//!全部商品列表
    GoodsListView *canBrowserGoodsListView;//!可看商品列表
    
    //是否打开侧面
    BOOL isOpen;
    
    AllListNoGoodsView * allNoGoodsView;
    AllListNoGoodsView * canNoGoodsView;
    
    
}

//!我的等级可看，全部
@property (nonatomic,strong) SlidePageManager *manager;

@property(nonatomic,strong)UIScrollView * backSrollview;

//侧面打开的时候添加一层view在上面
@property (nonatomic ,strong) UIView *maskView;


//1、全部商品列表

//2、筛选界面过来的：搜索框显示 筛选时候选中的内容

//!筛选的标签
@property(nonatomic,copy)NSString *structNo;
//!筛选的类别（用来做title）
@property(nonatomic,copy)NSString *structName;


//3、搜索界面过来的： 搜索框显示 搜索的内容

@property(nonatomic,copy)NSString *searchContent;

//!筛选的界面
@property(nonatomic,strong)FilterView * filterView;
@property(nonatomic,strong)UIView * filterAlphaView;

#pragma mark 给子类调用的方法
//!collectionviewcell 点击事件
-(void)cellSelect:(Commodity *)goodsCommodity;
//!没有相关商品的提示view
-(AllListNoGoodsView *)instanceAllNoGoodsView;
#pragma mark 给子类重写的方法
//!创建tableView（给搜索结果 子类重写的方法）
-(void)createTableView;

//!改变sc上面两个tableView哪个可以点击至顶部  showAll：显示全部
-(void)setScAndTableViewScrollerToTop:(BOOL)showAll;

-(void)addAllNotification;

-(void)removeAllNotification;

//!移除筛选的view
-(void)removeFilterView;

@end
