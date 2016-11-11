//
//  GoodsChannelViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsChannelViewController.h"
#import "SWRevealViewController.h"//!侧滑所需
#import "LeftSlideViewController.h"//!侧滑出来的页面
#import "GoodsClassViewController.h"//!分类
#import "PersonalCenterDTO.h"//!个人中心
#import "CSPShoppingCartViewController.h"//!采购车
#import "SearchMerhcantAndGoodController.h"//!搜索
#import "AllGoodsListSelectView.h"//! 全部 我的等级可看 选择框
#import "ChannelGoodsListView.h"
#import "GoodDetailViewController.h"
#import "GoodsInfoDTO.h"
#import "GoodsNotLevelTipDTO.h"
#import "CSPAuthorityPopView.h"
#import "AllListNoGoodsView.h"
#import "PrepaiduUpgradeViewController.h"//!等级规则
#import "CCWebViewController.h"//!立即升级
#import "AllGoodsViewController.h"//!全部商品列表

#import "SlidePageManager.h"//!我的等级可看，全部
#import "SlidePageSquareView.h"

#import "UIImageView+WebCache.h"
#import "RefreshControl.h"//!上拉下拉的动画

@interface GoodsChannelViewController ()<SWRevealViewControllerDelegate,UIScrollViewDelegate,CSPAuthorityPopViewDelegate,SlidePageSquareViewDelegate,RefreshControlDelegate>
{

    UILabel * shopRedAlertLabel;//!采购车的小红点

    //是否打开侧面
    BOOL isOpen;

    //!全部、我的等级可看 view
    SlidePageSquareView * selectView;
    
    ChannelGoodsListView * allGoodsListView;
    ChannelGoodsListView * canBrowserListView;

    //!图片显示的高度
    CGFloat headerImageViewHight;
    
    //!全部商品列表最后一次滚动的Y
    CGFloat allGoodsContentY;
    //!可看商品列表最后一次滚动的Y
    CGFloat canGoodsContentY;
    
    //!是不是 “全部商品列表” 有拉出顶部头图的手势
    BOOL isAllTopRefresh;
    
    
}
//!我的等级可看，全部
@property (nonatomic,strong) SlidePageManager *manager;

//侧面打开的时候添加一层view在上面
@property (nonatomic ,strong) UIView *maskView;

//!最底部的scrollview
@property(nonatomic,strong)UIScrollView * bgScrollView;

//!顶部的图片
@property(nonatomic,strong)UIImageView * headerImageView;

//!商品的背景sc
@property(nonatomic,strong)UIScrollView * goodsBackSrollview;

//!刷新的动画
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
//!上拉下拉的动画
@property (nonatomic,strong)RefreshControl *topRefreshControl;
@property (nonatomic,strong)RefreshControl *bottomRefreshControl;


@end

@implementation GoodsChannelViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //!创建界面
    [self createUI];
    
    //!创建刷新
    [self createRefresh];
    

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //!添加侧滑的手势
    [self addLeftGestuer];
    
    //!请求个人中心的采购车数量
    [self requestPerCenterInfoForShopCar];

    //!添加观察
    [self addAllNotification];
    
    //!商品列表滚动的观察
    [self addGoodListObserver];
    
    //!创建导航
    [self createNav];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    


}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    //!移除  透明view，防止到新界面的时候没有移除(侧滑收拾的时候出现)
    [self removeMaskView];
    
    //!移除所有的观察
    [self removeAllNotification];

    //!商品列表滚动的观察
    [self removeGoodListObserver];

}
#pragma mark 添加侧滑的手势
-(void)addLeftGestuer{
    
    //注册该页面可以执行滑动切换 筛选出来的结果页面不需要有侧滑功能
    SWRevealViewController *revealController = self.revealViewController;
    revealController.delegate = self;
    LeftSlideViewController * leftSlideVc = [[LeftSlideViewController alloc]init];
    leftSlideVc.selectClassName = self.channelName;//!标志当前选中的是“全部商品”,把“全部商品”这一行的文字颜色修改为紫色
    revealController.rearViewController = leftSlideVc;//!全部商品列表 左边筛选框设置
    
    revealController.rearViewRevealWidth = SCREEN_WIDTH *0.4f;
    
    [allGoodsListView addGestureRecognizer:revealController.panGestureRecognizer];
    
    
}
#pragma mark 创建导航
-(void)createNav{

    
    
    //! 左导航
    UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    
    UIButton * returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [returnBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [returnBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    returnBtn.frame = CGRectMake(0, (leftView.frame.size.height - 30)/2, 30, 30);//10  18
    returnBtn.imageEdgeInsets = UIEdgeInsetsMake(0,- (returnBtn.frame.size.width - 18), 0, 0);//!18是图片实际的宽度
    [leftView addSubview:returnBtn];
    
    
    
    //!分类按钮
    UIButton * classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [classBtn setImage:[UIImage imageNamed:@"category"] forState:UIControlStateNormal];
    classBtn.frame = CGRectMake(CGRectGetMaxX(returnBtn.frame)+10, (leftView.frame.size.height - 24)/2, 24, 24);
    [classBtn addTarget:self action:@selector(classBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:classBtn];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftView];;
    
    //!title
    self.title = self.channelName;
    
    //!右导航
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"serchImage"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, (rightView.frame.size.height - 20)/2, 26, 20);
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:searchBtn];

    
    UIButton *  shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(CGRectGetMaxX(searchBtn.frame) + 15, (rightView.frame.size.height - 19)/2, 22, 19);
    [shopCarBtn setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
    [shopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shopCarBtn];
    
    //!采购车小红点
    shopRedAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(shopCarBtn.frame.size.width, -4 , 4, 4)];
    [shopRedAlertLabel setBackgroundColor:[UIColor redColor]];
    shopRedAlertLabel.layer.masksToBounds = YES;
    shopRedAlertLabel.layer.cornerRadius = 2;
    shopRedAlertLabel.hidden = YES;

    [shopCarBtn addSubview:shopRedAlertLabel];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    
}
-(void)backBtnClick{

    [self.navigationController popToRootViewControllerAnimated:YES];
    
//    [self.navigationController popViewControllerAnimated:YES];

}
//!分类
-(void)classBtnClick{

    
    if (isOpen) {
        
        self.revealViewController.frontViewPosition = FrontViewPositionLeft;
        isOpen = NO;
        
    }else
    {
        self.revealViewController.frontViewPosition = FrontViewPositionRight;
        isOpen = YES;
        
        
    }


}
//!搜索
-(void)searchBtnClick{

    SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
    searchVC.isSearchMerchant = NO;//!搜索的是商家传入 yes，搜索的是商品 传入no
    [self.navigationController pushViewController:searchVC animated:NO];
    

}
//!采购车
-(void)shopCarBtnClick{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    shopVC.isBlockUp = YES;
    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
    [self.navigationController pushViewController:shopVC animated:YES];

}

#pragma mark 侧滑的代理方法
- (void)revealController:(SWRevealViewController *)revealController animateToPosition:(FrontViewPosition)position
{
    
    //显示左面标签
    if (position == FrontViewPositionRight) {
        
        [self.maskView  removeFromSuperview];

        //创建不可点击的视图
        self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+1000)];
        
        //添加Tap点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backFormerVC:)];
        
        //添加手势
        [self.maskView addGestureRecognizer:tap];
        
        
        //注册该页面可以执行滑动切换
        SWRevealViewController *revealController = self.revealViewController;
        revealController.delegate = self;
        [self.maskView addGestureRecognizer:revealController.panGestureRecognizer];
        //添加视图
        [revealController.frontViewController.view addSubview:self.maskView];
        
        
        isOpen = YES;
        
    }
    
    if (position == FrontViewPositionLeft) {
        
        //添加新的手势
        SWRevealViewController *revealController = self.revealViewController;
        revealController.delegate = self;
        
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        //移除视图
        [self removeMaskView];
        
    }
    
    
}
-(void)removeMaskView{
    
    if (self.maskView) {
        
        //移除视图
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }
    
    
    isOpen = NO;
    
}
//点击maskView的时候，收回界面
- (void)backFormerVC:(UITapGestureRecognizer *)tap
{
    self.revealViewController.frontViewPosition = FrontViewPositionLeftSide;
    
}
#pragma mark 所有观察
-(void)addAllNotification{
    
    //!侧滑搜索分类是否通知--》弹出分类界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCategoryVC) name:@"className" object:nil];
    
    //!侧滑 频道通知 --》弹出频道
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoChannelClick:) name:@"intoChannel" object:nil];
    
    //!测试 点击“全部商品”时的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushAllGoodsClick) name:@"allGoodsList" object:nil];

    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goBackHome) name:@"HideLeft" object:nil];
    
    

    
}

-(void)removeAllNotification{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"className" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"intoChannel" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"allGoodsList" object:nil];
    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideLeft" object:nil];
    

    

}
-(void)goBackHome{

    //!如果侧拉是开启的
    if (isOpen) {
        
        [self classBtnClick];
        
        //!返回到界面
        [self.navigationController popToRootViewControllerAnimated:YES];
        

    }
    
    
}

#pragma mark !收到进入商品分类的通知
-(void)pushCategoryVC{
    
    GoodsClassViewController *goodsClassVC = [[GoodsClassViewController alloc] init];
    [self.navigationController pushViewController:goodsClassVC animated:NO];
    
}
#pragma mark 收到进入频道的通知
-(void)intoChannelClick:(NSNotification  *)notification{
    
    NSDictionary * channelDic = notification.userInfo;
    
    GoodsChannelViewController * channelVC = [[GoodsChannelViewController alloc]init];
    channelVC.channelId = [channelDic[@"id"] intValue];
    channelVC.channelName = channelDic[@"channelName"];
    channelVC.channelImg = channelDic[@"channelImg"];
    
    [self.navigationController pushViewController:channelVC animated:YES];
    
}
#pragma mark 收到点击“全部商品” 返回根目录的通知
-(void)pushAllGoodsClick{

//    [self.navigationController popToRootViewControllerAnimated:YES];

    AllGoodsViewController * allGoodsVC = [[AllGoodsViewController alloc]init];
    [self.navigationController pushViewController:allGoodsVC animated:YES];
    

}

#pragma mark 创建界面
-(void)createUI{

    //!最底部支持上下滑动的sc
    headerImageViewHight = SCREEN_WIDTH/2.0;
    
    CGFloat bgScrollViewHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    self.bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, bgScrollViewHight)];
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, headerImageViewHight + bgScrollViewHight);
    
    [self.view addSubview:self.bgScrollView];
    
    //!顶部的图片
    if (![self.channelImg isEqualToString:@""] && self.channelImg) {//!有图片显示
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, headerImageViewHight)];
        
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImageView.clipsToBounds = YES;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.channelImg] placeholderImage:[UIImage imageNamed:@"big_placeHolder"]];
        
        [self.bgScrollView addSubview:self.headerImageView];

        
    }else{//!无图片不显示
    
        headerImageViewHight = 0.0;
    
    }
    
    
    //!1、全部 我的等级可看 的view
    //!全部、我的等级可看
    self.manager = [[SlidePageManager alloc]init];
    
    selectView =  (SlidePageSquareView *)[self.manager createBydataArr:@[@"全部",@"我的等级可看"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHexValue:0xd9d9d9 alpha:1] squareViewColor:[UIColor whiteColor] unSelectTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:13]];
    
    selectView.layer.masksToBounds = YES;
    selectView.layer.cornerRadius = 2;
    selectView.layer.borderWidth = 2;
    selectView.layer.borderColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1].CGColor;
    
    selectView.frame = CGRectMake(40, CGRectGetMaxY(self.headerImageView.frame) + 17,self.view.frame.size.width - 80, 25);
    selectView.contentSize = CGSizeMake(self.view.frame.size.width - 80, selectView.frame.size.height);
    selectView.delegateForSlidePage = self;
    [self.bgScrollView addSubview:selectView];
    

    //!sc
    CGFloat showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 - CGRectGetMaxY(selectView.frame) - 10 + headerImageViewHight;//!10是商品列表离选择框的距离

    self.goodsBackSrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(selectView.frame) + 10 , self.view.frame.size.width, showHight)];
    
    self.goodsBackSrollview.contentSize = CGSizeMake(self.view.frame.size.width*2, showHight);
    self.goodsBackSrollview.delegate = self;
    self.goodsBackSrollview.pagingEnabled = YES;
    [self.bgScrollView addSubview:self.goodsBackSrollview];
    
    
    //!全部
    allGoodsListView = [[ChannelGoodsListView alloc]initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, showHight) withChannelId:self.channelId rangFlag:@"0"];//0:全部（默认） 1:等级可见
    [allGoodsListView setBackgroundColor:[UIColor redColor]];
    [self.goodsBackSrollview addSubview:allGoodsListView];

    //!我的等级可看
    canBrowserListView = [[ChannelGoodsListView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allGoodsListView.frame), allGoodsListView.frame.origin.y, allGoodsListView.frame.size.width, showHight)withChannelId:self.channelId rangFlag:@"1"];//0:全部（默认） 1:等级可见
    
    [self.goodsBackSrollview addSubview:canBrowserListView];
    
    //!点击事件
    __weak GoodsChannelViewController * vc = self;
    allGoodsListView.selectBlock = ^(Commodity *goodsCommodity){
        
        [vc cellSelect:goodsCommodity];
        
        
    };
    
    canBrowserListView.selectBlock = ^(Commodity *goodsCommodity){
        
        [vc cellSelect:goodsCommodity];
        
    };
    
    //!无商品的提示页面
    allGoodsListView.noGoodsBlock = ^(){
    
        AllListNoGoodsView  * noGoodsView = [vc instanceAllNoGoodsView];
        noGoodsView.frame = allGoodsListView.frame;
        [self.goodsBackSrollview addSubview:noGoodsView];
    
        
    };
    
    //!无商品的提示页面
    canBrowserListView.noGoodsBlock = ^(){
        
        AllListNoGoodsView  * noGoodsView = [vc instanceAllNoGoodsView];
        noGoodsView.frame = canBrowserListView.frame;
        [self.goodsBackSrollview addSubview:noGoodsView];

        
    };
    
    //!设置 全部列表可以回到顶部
    [self setScAndTableViewScrollerToTop:YES];


}
#pragma mark 创建刷新
-(void)createRefresh{
    
    __weak GoodsChannelViewController * goodsChannelListVC = self;
    
    //添加下拉(一进来可看的是“全部”)
    [self addTopRefresh:allGoodsListView];
    
    isAllTopRefresh = YES;
    
    SDRefreshHeaderView * headerRefreshView = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [headerRefreshView addToScrollView:self.bgScrollView];
    self.refreshHeader = headerRefreshView;
    
    self.refreshHeader.beginRefreshingOperation = ^{
    
        
        [goodsChannelListVC requestWithRefresh:self.refreshHeader];
        
    
    };
    
    
}
//!因为会切换 全部/我的等级可看，可以上拉的动作也会切换，所以添加这么一个方法方便切换
-(void)addTopRefresh:(ChannelGoodsListView *)goodsListView{
    
    self.topRefreshControl = nil;
    
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:goodsListView.goodsCollectionView delegate:self];
    
    [self.topRefreshControl setTopEnabled:YES];
    
    
}
-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) {
        
        allGoodsContentY = allGoodsListView.goodsCollectionView.contentOffset.y;
        canGoodsContentY = canBrowserListView.goodsCollectionView.contentOffset.y;
        
//        DebugLog(@":%f~~~:%f", allGoodsContentY,canGoodsContentY);

        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        
        //!上拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.bgScrollView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }
    
    
}
#pragma mark !添加商品列表滚动的观察
//!添加
-(void)addGoodListObserver{
    
    [allGoodsListView.goodsCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
    [canBrowserListView.goodsCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
    
}
//!移除
-(void)removeGoodListObserver{
    
    [allGoodsListView.goodsCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    
    [canBrowserListView.goodsCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"contentOffset"])
    {
        
        float allOffset = allGoodsListView.goodsCollectionView.contentOffset.y - allGoodsContentY;
        float canOffset = canBrowserListView.goodsCollectionView.contentOffset.y - canGoodsContentY;
        
        allGoodsContentY = allGoodsListView.goodsCollectionView.contentOffset.y;
        canGoodsContentY = canBrowserListView.goodsCollectionView.contentOffset.y;

        DebugLog(@"allOffset:%f~~~canOffset:%f~~~allY:%f~~~~canY:%f", allOffset,canOffset,allGoodsContentY,canGoodsContentY);
        
        if (allOffset > 0 || canOffset >0 ) {//!向上
            
            if ((allGoodsContentY > 0 && isAllTopRefresh == YES )|| (canGoodsContentY > 0 && isAllTopRefresh == NO)) {//!不显示
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollView.contentOffset = CGPointMake(0, headerImageViewHight);
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }else{//!向下
        
            if ((allGoodsContentY < 0 && allGoodsListView.goodsCollectionView.dragging == NO && isAllTopRefresh == YES) || (canGoodsContentY < 0 && canBrowserListView.goodsCollectionView.dragging == NO && isAllTopRefresh == NO)){//!是要把顶部拉下来，显示
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollView.contentOffset = CGPointMake(0, 0);
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }else if ((allGoodsContentY > 0 && isAllTopRefresh == YES )|| (canGoodsContentY > 0 && isAllTopRefresh == NO)) {//!不显示
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollView.contentOffset = CGPointMake(0, headerImageViewHight);
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
        
    }
    
    
}

//!collectionviewcell 点击事件
-(void)cellSelect:(Commodity *)goodsCommodity{
    
    /*
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // !判断商品是否可以查看  如果可以 ，进入商品详情
    if ([goodsCommodity isReadable]) {
        
        GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
        
        goodsInfoDTO.goodsNo = goodsCommodity.goodsNo;
        
        GoodDetailViewController *goodsInfo = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        [self.navigationController pushViewController:goodsInfo animated:YES];
        
        
    } else {//!不可以查看 ，显示等级提示
        
        [self showNotLevelReadTipForGoodsNo:goodsCommodity.goodsNo];
        
    }
    */
    
    [self showNotLevelReadTipForGoodsNo:goodsCommodity.goodsNo withIsReadable:[goodsCommodity isReadable]];


    
}
-(AllListNoGoodsView *)instanceAllNoGoodsView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AllListNoGoodsView" owner:nil options:nil];
    
    AllListNoGoodsView * noGoodsView = [nibView objectAtIndex:0];
    
    
    return noGoodsView;
    
}
//!goodsNo：商品编码  isReadable：商品列表请求回来的时候是否可以查看
- (void)showNotLevelReadTipForGoodsNo:(NSString*)goodsNo withIsReadable:(BOOL)isReadable{
    
    /*
     该方法是在点击进入商品详情之前再次进行判断是否有权限进入
     
     有蒙层                             无蒙层
     无权限进入：弹出等级不足提示          提示刷新
     有权限进入：提示刷新列表              直接进入
     */
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            GoodsNotLevelTipDTO *goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {//!最新请求结果为不能查看
                
                if (isReadable) {//!列表数据请求回来的时候是可以查看的，无蒙层，现不可以查看
                    
                    [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                    
                }else{//!列表数据请求回来的时候是可以不能查看的，有蒙层
                    
                    [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                    
                    CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                    popView.frame = self.view.bounds;
                    popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                    
                    popView.delegate = self;
                    [self.view addSubview:popView];
                    
                }
                
                
                
            } else {//!最新请求结果为能查看
                
                if (isReadable) {//!列表数据请求回来的时候是可以查看的，无蒙层，现也可查看
                    
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
                    
                    goodsInfoDTO.goodsNo = goodsNo;
                    
                    GoodDetailViewController *goodsInfo = [storyboard instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
                    [self.navigationController pushViewController:goodsInfo animated:YES];
                    
                    
                }else{//!列表数据请求回来的时候是可以不能查看的，有蒙层，现克查看了
                    
                    [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                    
                    
                }
                
                
            }
            
        }else {
            
            [self.view makeMessage:@"查询权限失败" duration:2.0f position:@"center"];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];
    
    
}

- (void)showNotLevelReadTipForGoodsNo:(NSString*)goodsNo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            GoodsNotLevelTipDTO *goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                
                CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                popView.frame = self.view.bounds;
                popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                
                popView.delegate = self;
                [self.view addSubview:popView];
                
                
            } else {
                
                [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
                
            }
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询权限失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];
}
//查看商品详情权限不足的提示view
- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//!查看商品详情权限不足的提示view 的代理方法
- (void)showLevelRules{
    
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    //bool值进行名字判断
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];

    
}
- (void)prepareToUpgradeUserLevel{
    
    
    CCWebViewController * cc = [[CCWebViewController alloc]init];
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    //bool 值进行判断
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];

}
#pragma mark scorllerViewDelegate  SlidePageSquareViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.goodsBackSrollview) {//!商品的sc
        
        self.manager.contentOffsetX = scrollView.contentOffset.x;
        
        if (_goodsBackSrollview.contentOffset.x < self.view.frame.size.width) {//!显示的是全部商品
            
            //!设置全部商品列表可以顶部下拉
            [self addTopRefresh:allGoodsListView];
            
            isAllTopRefresh = YES;

            [self setScAndTableViewScrollerToTop:YES];//!设置 全部 可以置顶
            
        }else{//!显示的是可见商品
        
            //!设置可见列表可以顶部下拉
            [self addTopRefresh:canBrowserListView];
            
            isAllTopRefresh = NO;

            [self setScAndTableViewScrollerToTop:NO];//!设置 可看 可以置顶
            
        }
        
    }
    

    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.goodsBackSrollview) {
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
       
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.goodsBackSrollview) {
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        
        
        
    }
    
}
- (void)slidePageSquareView:(SlidePageSquareView *)view andBtnClickIndex:(NSInteger)index{
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    [self.goodsBackSrollview  setContentOffset:CGPointMake(screenWith*index,0 ) animated:YES];
    
    
}


//!改变sc上面两个tableView哪个可以点击至顶部  showAll：显示全部
-(void)setScAndTableViewScrollerToTop:(BOOL)showAll{
    
    self.bgScrollView.scrollsToTop = NO;
    self.goodsBackSrollview.scrollsToTop = NO;
    selectView.scrollsToTop = NO;
    
    allGoodsListView.goodsCollectionView.scrollsToTop = showAll;
    canBrowserListView.goodsCollectionView.scrollsToTop = !showAll;
    
}

#pragma mark 请求个人中心信息--》为了得到采购车的数量
-(void)requestPerCenterInfoForShopCar{
    
    shopRedAlertLabel.hidden = YES;
    
    [HttpManager sendHttpRequestForPersonalCenterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            PersonalCenterDTO * personalDTO = [[PersonalCenterDTO alloc]initWithDictionary:dic[@"data"]];
            
            if ([personalDTO.cartNum intValue]) {
                
                
                shopRedAlertLabel.hidden = NO;//!采购车中有商品，显示提示的红点
                
            }else{
                
                shopRedAlertLabel.hidden = YES;
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
}
#pragma mark 刷新请求商品列表
-(void)requestWithRefresh:(SDRefreshView *)refresh{
    
    //!刷新商品列表
    [allGoodsListView requestData:nil];
    [canBrowserListView requestData:nil];
    
    allGoodsListView.finishRequest = ^(){//!刷新结束
        
        [refresh endRefreshing];
        
    };

    canBrowserListView.finishRequest = ^(){//!刷新结束
    
        [refresh endRefreshing];

    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
