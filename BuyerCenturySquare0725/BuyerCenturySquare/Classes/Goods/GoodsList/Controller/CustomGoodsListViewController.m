//
//  CustomGoodsListViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/8/30.
//  Copyright © 2016年 pactera. All rights reserved.
// 商品侧滑手势添加和原来全部商品列表不一样，用！！！！标注出来了
//!侧滑出来的手势现在在商品列表无用

#import "CustomGoodsListViewController.h"
#import "LeftSlideViewController.h"
#import "SWRevealViewController.h"
#import "GoodsChannelViewController.h"//!频道
#import "GoodsClassViewController.h"//!商品分类
#import "GoodsFilterViewController.h"//!商品分类点击后进入的页面
#import "SearchMerhcantAndGoodController.h"//!搜索界面
#import "CSPShoppingCartViewController.h"//!采购车
#import "PrepaiduUpgradeViewController.h"//!等级规则
#import "CCWebViewController.h"//!//立即升级
#import "GoodDetailViewController.h"//!商品详情
#import "MerchantDeatilViewController.h"//!店铺

#import "CustomGoodsListView.h"//!商品列表
#import "SearchView.h"//!搜索框
#import "FilterView.h"//!筛选的view

#import "RefreshControl.h"
#import "SlidePageManager.h"//!我的等级可看，全部
#import "SlidePageSquareView.h"
#import "CSPAuthorityPopView.h"//!等级提示框

#import "PersonalCenterDTO.h"//!个人中心信息的dto
#import "GoodsNotLevelTipDTO.h"//!
#import "GoodsInfoDTO.h"//!商品详情的dto


@interface CustomGoodsListViewController ()<RefreshControlDelegate,SWRevealViewControllerDelegate,SlidePageSquareViewDelegate,UIScrollViewDelegate,CSPAuthorityPopViewDelegate>
{
    
    //!-----全部商品的导航：
    //!右导航
    UIButton * shopCarBtn;
    //!采购车小红点
    UILabel * shopRedAlertLabel;
    
    //是否打开侧面
    BOOL isOpen;
    
    //!显示界面的高度
    CGFloat showHight;
    //!网页显示的高度
    CGFloat webViewShowHight;
    
    //!全部商品列表最后一次滚动的Y
    CGFloat allGoodsContentY;
    //!可看商品列表最后一次滚动的Y
    CGFloat canGoodsContentY;
    
    //!是不是 “全部商品列表” 有拉出顶部头图的手势
    BOOL isAllTopRefresh;

    //!是否请求h5地址成功，不成功的话，每次进入这个页面就去请求h5地址
    BOOL requestWebViewUrlSuccess;
    
    AllListNoGoodsView * allNoGoodsView;
    AllListNoGoodsView * canNoGoodsView;

}

//!背景的sc
@property(nonatomic,strong)UIScrollView * bgScrollerView;

//!----商品部分
//!选择部分

//!底部的sc
@property(nonatomic,strong)UIScrollView * goodsSrollerView;
//!全部商品
@property(nonatomic,strong)CustomGoodsListView * allGoodsListView;
//!我的等级可看
@property(nonatomic,strong)CustomGoodsListView * canBrowserGoodsListView;

//!动画的刷新
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (nonatomic,strong)RefreshControl *topRefreshControl;
@property (nonatomic,strong)RefreshControl *bottomRefreshControl;

//侧面打开的时候添加一层view在上面
@property (nonatomic ,strong) UIView *maskView;

//!我的等级可看，全部
@property (nonatomic,strong) SlidePageManager *manager;

@property(nonatomic,strong)SlidePageSquareView * selectView;

//!请求的webview地址
@property(nonatomic,strong)NSString * requestH5Url;

//!筛选的界面
@property(nonatomic,strong)FilterView * filterView;
@property(nonatomic,strong)UIView * filterAlphaView;


@end


@implementation CustomGoodsListViewController

- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    
    //!创建界面
    [self createBgSc];
    
    //!包含创建webview，初始化webview的数据（必须在创建背景scrollerview之后，因为这个webview是放在scrollerview上面的）
    [super viewDidLoad];
    
    //!创建底部的商品部分
    [self createGoodsList];
    
    //!创建刷新
    [self createRefresh];
    
    //!处理h5给的事件
    [self registerHandlers];
    
    //!默认设置 点击statusBars让网页置顶
    [self setStatusEnableIsWebView:YES allEnable:NO canBrowserEnable:NO];
    
    //!请求数据（一进来的时候不请求商品列表，因为商品列表初始化的时候已经请求了）
    //[self requestWithRefresh:self.refreshHeader requestGoods:NO];

    
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //!是点击底部tabbar进入的，则一进入商品，显示 我的等级可看
    if ([MyUserDefault defaultLoadIntoAllGoods]) {
        
        self.goodsSrollerView.contentOffset = CGPointMake(self.view.frame.size.width,0);
        
    }
    //!添加侧滑的手势
    [self addLeftGestuer];
    
    //!请求个人中心的采购车数量
    [self requestPerCenterInfoForShopCar];
    
    //!添加观察
    [self addAllNotification];
    
    //!此界面不隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    //!创建导航 需要在这里创建，不要放到viewdidload 里面，不然子类会重写
    [self createNav];
    
    //!请求h5部分没有成功，每次进入的时候进行请求
    if (!requestWebViewUrlSuccess) {
        
        [self requestWithRefresh:nil requestGoods:NO];
        
    }
    

}
-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:YES];
    
    //!删除是从点击tabbar进入全部商品的标志
    [MyUserDefault removeIntoAllGoods];
    
    //!移除  透明view，防止到新界面的时候没有移除(侧滑收拾的时候出现)
    [self removeMaskView];
    
    //!移除所有的观察
    [self removeAllNotification];
    
    //!移除筛选的view
    [self removeFilterView];
    
    
}

#pragma mark 创建导航
-(void)createNav{
    
    
    float width = 30;//!导航左右按钮的宽度
    
    NSString * leftImageName = @"category";
    
    [self createAllGoodsNav];
    
    //!左按钮
    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavBtn.frame = CGRectMake(0, 0, width , 30 );//!图片实际宽度 18  14
    
    [leftNavBtn setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
    leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -(width - 18) , 0, 0);//!修改图片在按钮中的位置
    
    [leftNavBtn addTarget:self action:@selector(leftNavClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
}


//!全部商品的导航
-(void)createAllGoodsNav{
    
    
    //!中间的搜索view (搜索条)
    SearchView * centerSearchView = [[[NSBundle mainBundle]loadNibNamed:@"SearchView" owner:self options:nil]lastObject];
    centerSearchView.leftLabel.text = @"搜索商品";//!默认是“搜索商家”
    centerSearchView.searchViewTapBlock = ^(){//!点击搜索框的时候调用的方法
        
        SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
        searchVC.isSearchMerchant = NO;//!搜索的是商家传入 yes，搜索的是商品 传入no
        [self.navigationController pushViewController:searchVC animated:NO];
        
    };
    centerSearchView.layer.masksToBounds = YES;
    centerSearchView.layer.cornerRadius = 2;
    self.navigationItem.titleView = centerSearchView;
    
    
    //!右导航
    shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(0, 0, 35, 40);//!图片实际宽度 43  37（22  19）
    [shopCarBtn setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
    shopCarBtn.imageEdgeInsets = UIEdgeInsetsMake(0,0, 0, -8);//!修改图片在按钮中的位置
    [shopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //!采购车小红点
    shopRedAlertLabel = [[UILabel alloc]initWithFrame:CGRectMake(shopCarBtn.frame.size.width - 2, shopCarBtn.frame.size.height - (shopCarBtn.frame.size.height - 19)/2.0 - 23 , 7 , 7 )];
    [shopRedAlertLabel setBackgroundColor:[UIColor redColor]];
    shopRedAlertLabel.layer.masksToBounds = YES;
    shopRedAlertLabel.layer.cornerRadius = shopRedAlertLabel.frame.size.width/2.0;
    [shopCarBtn addSubview:shopRedAlertLabel];
    shopRedAlertLabel.hidden = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:shopCarBtn];
    
    
}
//!搜索按钮
-(void)searchBtnClick{
    
    SearchMerhcantAndGoodController * searchVC = [[SearchMerhcantAndGoodController alloc]init];
    searchVC.isSearchMerchant = NO;//!搜索的是商家传入 yes，搜索的是商品 传入no
    [self.navigationController pushViewController:searchVC animated:NO];
    
    
    
}
//!采购车按钮
-(void)shopCarBtnClick{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    shopVC.isBlockUp = YES;
    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
    [self.navigationController pushViewController:shopVC animated:YES];
    
}

#pragma mark 创建界面
-(void)createBgSc{
    
    //!显示的界面高度
    showHight = self.view.frame.size.height - 20 - self.navigationController.navigationBar.frame.size.height - self.rdv_tabBarController.tabBar.frame.size.height;
    
    //!背景的sc
    self.bgScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight)];
    self.bgScrollerView.contentSize = CGSizeMake(self.view.frame.size.width, showHight *2);
    self.bgScrollerView.delegate = self;
    self.bgScrollerView.pagingEnabled = YES;
    
    [self.view addSubview:self.bgScrollerView];
    
    
}

//!重写父类的方法
-(void)createWebView{
    
    //!webview的高度
    webViewShowHight = showHight;//!刚进来的时候webview显示的高度同整个界面显示的高度
    
    // 初始化webview
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, webViewShowHight)];
    
    self.webView.scrollView.scrollEnabled = YES;
    
    //!顶部的网页  父类调用createWebView创建了，在子类创建底部sc之后 添加上
    [self.bgScrollerView addSubview:self.webView];
    
    
}
//!创建商品部分
-(void)createGoodsList{
    
    //!全部、我的等级可看
    self.manager = [[SlidePageManager alloc]init];
    
    self.selectView =  (SlidePageSquareView *)[self.manager createBydataArr:@[@"全部",@"我的等级可看"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHexValue:0x333333 alpha:1] squareViewColor:[UIColor whiteColor] unSelectTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:13]];
    
    
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame),self.bgScrollerView.frame.size.width, 30);
    self.selectView.contentSize = CGSizeMake(self.view.frame.size.width, self.selectView.frame.size.height);
    self.selectView.delegateForSlidePage = self;
    [self.bgScrollerView addSubview:self.selectView];
    
    //!下面的商品列表部分
    self.goodsSrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.selectView.frame), self.view.frame.size.width, self.bgScrollerView.frame.size.height - self.selectView.frame.size.height)];
    
    self.goodsSrollerView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.goodsSrollerView.frame.size.height);
    
    self.goodsSrollerView.delegate = self;
    self.goodsSrollerView.pagingEnabled = YES;
    
    [self.bgScrollerView addSubview:self.goodsSrollerView];
    
    
    //!全部的view
    self.allGoodsListView = [[CustomGoodsListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,self.goodsSrollerView.frame.size.height) withMerchantNo:nil withStructNo:nil withRangFlag:@"0"];//!(0:全部（默认） 1:等级可见)
    
    [self.goodsSrollerView addSubview:self.allGoodsListView];
    
    
    //!等级可看collectionview
    self.canBrowserGoodsListView = [[CustomGoodsListView alloc]initWithFrame:CGRectMake(self.view.frame.size.width ,0, self.view.frame.size.width, self.goodsSrollerView.frame.size.height) withMerchantNo:nil withStructNo:nil withRangFlag:@"1"];
    
    [self.goodsSrollerView addSubview:self.canBrowserGoodsListView];
    
    
    //!实现点击商品的事件的block
    [self realizeGoodsLishBlock];
    
    //!添加商品列表滚动的观察
    [self addGoodListObserver];
    
    
}

#pragma mark scorllerViewDelegate  SlidePageSquareViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    
    if (scrollView == self.goodsSrollerView) {//!商品sc
        
        self.manager.contentOffsetX = scrollView.contentOffset.x;

        if (requestWebViewUrlSuccess && webViewShowHight != 0) {//!请求h5成功，商品列表下拉则为拉出h5页面；请求h5不成功仍旧保持商品可以下拉列表刷新
            
            //!改变商品列表可下拉出网页的对象；
            [self changeGoodsRefreshTop];
            
        }
        
        //!滚动商品列表所在的scrollerview之后，还原筛选条件
        [self resetGoodsSort];

    }
    
    //!改变点击状态栏可以回到顶部的scrollview
    [self changeStatusBarToTop];
    

    
    
}

//!改变商品列表可下拉出网页的对象；
-(void)changeGoodsRefreshTop{
    
    
    if (self.goodsSrollerView.contentOffset.x >= self.view.frame.size.width) {//!我的等级可看
        
        [self addTopRefresh:self.canBrowserGoodsListView];
        
        isAllTopRefresh = NO;

        
    }else{//!全部
        
        [self addTopRefresh:self.allGoodsListView];
        
        isAllTopRefresh = YES;
        
    }
    
    
    
}
//!改变点击状态栏可以回到顶部的scrollview
-(void)changeStatusBarToTop{

    if (self.bgScrollerView.contentOffset.y < webViewShowHight) {//!显示的是网页
        
        [self setStatusEnableIsWebView:YES allEnable:NO canBrowserEnable:NO];
        
    }else{//!显示的是商品列表
        
        if (self.goodsSrollerView.contentOffset.x < self.view.frame.size.width) {//!显示的是全部商品
            
            [self setStatusEnableIsWebView:NO allEnable:YES canBrowserEnable:NO];
            
        }else{//!显示的是可见商品
            
            [self setStatusEnableIsWebView:NO allEnable:NO canBrowserEnable:YES];
            
        }
        
        
    }
    
}

//!滚动商品列表所在的scrollerview之后，还原筛选条件
-(void)resetGoodsSort{

    if (self.goodsSrollerView.contentOffset.x == self.view.frame.size.width) {//!显示的是我的等级可看
        
        [self.allGoodsListView resetSortDTO];
        
    }else if(self.goodsSrollerView.contentOffset.x == 0){//!显示的是全部
        
        [self setStatusEnableIsWebView:NO allEnable:NO canBrowserEnable:YES];
        
        [self.canBrowserGoodsListView resetSortDTO];

    }

}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.goodsSrollerView) {//!商品的sc
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        
        
    }
    
    
  
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.goodsSrollerView) {
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        
        
        
    }
    
}

- (void)slidePageSquareView:(SlidePageSquareView *)view andBtnClickIndex:(NSInteger)index{
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    [self.goodsSrollerView  setContentOffset:CGPointMake(screenWith*index,0 ) animated:YES];
    
//    if (requestWebViewUrlSuccess && webViewShowHight != 0) {//!请求h5成功，商品列表下拉则为拉出h5页面；请求h5不成功仍旧保持商品可以下拉列表刷新
//        
//        //!改变商品列表可下拉出网页的对象；
//        [self changeGoodsRefreshTop];
//        
//    }
//    
//    //!改变点击状态栏可以回到顶部的scrollview
//    [self changeStatusBarToTop];
//
//    //!滚动商品列表所在的scrollerview之后，还原筛选条件
//    [self resetGoodsSort];

    
}

#pragma mark 创建刷新
-(void)createRefresh{
    
    
    //添加上拉
    self.bottomRefreshControl = [[RefreshControl alloc] initWithScrollView:self.webView.scrollView delegate:self];
    [self.bottomRefreshControl setBottomEnabled:YES];
    
    
    //添加下拉(一进来可看的是“我的等级可看”)
    [self addTopRefresh:self.canBrowserGoodsListView];
    
    isAllTopRefresh = YES;
    
    //!请求的刷新
    SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    [refreshHeader addToScrollView:self.bgScrollerView];
    
    self.refreshHeader = refreshHeader;
    
    __weak CustomGoodsListViewController * listVC = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [listVC requestWithRefresh:self.refreshHeader requestGoods:YES];//!下拉刷新的时候需要刷新商品列表
        
    };
    
    
}
//!因为会切换 全部/我的等级可看，可以上拉的动作也会切换，所以添加这么一个方法方便切换
-(void)addTopRefresh:(CustomGoodsListView *)goodsListView{
    
    self.topRefreshControl = nil;
    
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:goodsListView.goodsCollectionView delegate:self];
    
    [self.topRefreshControl setTopEnabled:YES];
    
    
}

-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    
    if (direction == RefreshDirectionTop) {
        
        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        
        DebugLog(@"上拉~~~~~~~~~~~~~");
        
        //!上拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.bgScrollerView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
    }else if (direction == RefreshDirectionBottom){
        
        [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        DebugLog(@"下拉~~~~");
        
        //下拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.bgScrollerView.contentOffset = CGPointMake(0, webViewShowHight);
            
        } completion:^(BOOL finished) {
            
        }];
        
        
        
    }
    
    
}
#pragma mark 设置点击tabbbar可返回顶部的属性
-(void)setStatusEnableIsWebView:(BOOL)webviewEnable  allEnable:(BOOL)allEnable canBrowserEnable:(BOOL)canBrowserEnable{
    
    //!大背景
    self.bgScrollerView.scrollsToTop = NO;
    
    //!网页
    self.webView.scrollView.scrollsToTop = NO;
    
    //!全部/我的等级可看
    self.selectView.scrollsToTop = NO;
    
    //!商品图片背景
    self.goodsSrollerView.scrollsToTop = NO;
    
    self.allGoodsListView.goodsCollectionView.scrollsToTop = NO;
    
    self.canBrowserGoodsListView.goodsCollectionView.scrollsToTop = NO;
    
    if (webviewEnable) {//!让网页置顶
        
        self.webView.scrollView.scrollsToTop = YES;
    }
    
    if (allEnable) {//!让全部商品置顶
        
        self.allGoodsListView.goodsCollectionView.scrollsToTop = YES;
    }
    
    if (canBrowserEnable) {//!让可见商品置顶
        
        self.canBrowserGoodsListView.goodsCollectionView.scrollsToTop = YES;
    }
    
}

#pragma mark !添加商品列表滚动的观察
//!添加
-(void)addGoodListObserver{
    
    [self.allGoodsListView.goodsCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
    [self.canBrowserGoodsListView.goodsCollectionView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionPrior context:NULL];
    
    
}
//!移除
-(void)removeGoodListObserver{
    
    [self.allGoodsListView.goodsCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    
    [self.canBrowserGoodsListView.goodsCollectionView removeObserver:self forKeyPath:@"contentOffset"];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if([keyPath isEqualToString:@"contentOffset"])
    {
        
        if (webViewShowHight < showHight/2.0) {
            
            return ;
            
        }
        
        float allOffset = self.allGoodsListView.goodsCollectionView.contentOffset.y - allGoodsContentY;
        float canOffset = self.canBrowserGoodsListView.goodsCollectionView.contentOffset.y - canGoodsContentY;
        
        allGoodsContentY = self.allGoodsListView.goodsCollectionView.contentOffset.y;
        canGoodsContentY = self.canBrowserGoodsListView.goodsCollectionView.contentOffset.y;
        
        DebugLog(@"allOffset:%f~~~canOffset:%f~~~allGoodsContentY:%f,canGoodsContentY:%f~~~%d~~~%f", allOffset,canOffset,allGoodsContentY,canGoodsContentY,isAllTopRefresh,self.bgScrollerView.contentOffset.y);
        
        if (allOffset > 0 || canOffset >0 ) {//!向上
            
            if ((allGoodsContentY > 0 && isAllTopRefresh == YES )|| (canGoodsContentY > 0 && isAllTopRefresh == NO)) {//!不显示
                
                DebugLog(@"向上，不显示");
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollerView.contentOffset = CGPointMake(0, webViewShowHight);
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }else{//!向下
            
            if ((allGoodsContentY < 0 && self.allGoodsListView.goodsCollectionView.dragging == NO && isAllTopRefresh == YES) || (canGoodsContentY < 0 && self.canBrowserGoodsListView.goodsCollectionView.dragging == NO && isAllTopRefresh == NO)){//!是要把顶部拉下来，显示
                
                DebugLog(@"向下，显示");
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollerView.contentOffset = CGPointMake(0, 0);
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }else if ((allGoodsContentY > 0 && isAllTopRefresh == YES )|| (canGoodsContentY > 0 && isAllTopRefresh == NO)) {//!不显示
                
                DebugLog(@"向下，不显示");
                
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                    
                    self.bgScrollerView.contentOffset = CGPointMake(0, webViewShowHight);
                    
                    
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            
        }
        
        
    }
    
    
}

#pragma mark 重写父类webviewDelegate LoadFailedDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [super webViewDidFinishLoad:webView];
    
    [self.refreshHeader endRefreshing];//!网页刷新结束就结束刷新动画
    
    DebugLog(@"webViewDidFinishLoad");
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [super webView:webView didFailLoadWithError:error];

    [self.refreshHeader endRefreshing];//!网页刷新结束就结束刷新动画
    
    DebugLog(@"didFailLoadWithError：%@",error);
}

//!点击重新加载按钮进入的方法
-(void)loadFailedAgainRequest{
    
    [super loadFailedAgainRequest];
    
    self.requestH5Url = nil;
    
    //!请求失败了重新请求网页但是没有必要重新请求商品列表
    [self requestWithRefresh:self.refreshHeader requestGoods:NO];
    
}

#pragma mark 刷新的请求
-(void)requestWithRefresh:(SDRefreshView *)refresh requestGoods:(BOOL)requestGoods{
    
 
    [HttpManager sendHttpRequestForAdvertUrl:@"goods_main" Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"] && [dic[@"data"] isKindOfClass:[NSDictionary class]]) {
            
            
            if ([self.requestH5Url isEqualToString:dic[@"data"][@"url"]]) {
                
                [self.webView reload];
                
            }else{
                
                self.requestH5Url = dic[@"data"][@"url"];
                
                //!请求webview的数据
                [HttpManager getCustomGoodsRequestWebView:self.webView withUrl:self.requestH5Url];
                
            }
            
            
            requestWebViewUrlSuccess = YES;//!请求h5地址成功
            
        }else{
            
            [self changeWebViewHight:0.0];//!请求失败的时候，把webview的高度改为0
            
            [self.refreshHeader endRefreshing];//!结束刷新动画
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        [self changeWebViewHight:0.0];//!请求失败的时候，把webview的高度改为0
        
        [self.refreshHeader endRefreshing];//!结束刷新动画
        
    }];
    
    
    
    //!刷新商品列表
    if (requestGoods) {
        
        [self.canBrowserGoodsListView requestData:nil];
        [self.allGoodsListView requestData:nil];
        
    }
    
    
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


#pragma mark 添加侧滑的手势
-(void)addLeftGestuer{
    
    //注册该页面可以执行滑动切换 筛选出来的结果页面不需要有侧滑功能
    SWRevealViewController *revealController = self.revealViewController;
    revealController.delegate = self;
    LeftSlideViewController * leftSlideVc = [[LeftSlideViewController alloc]init];
    //    leftSlideVc.selectClassName = @"全部商品";//!标志当前选中的是“全部商品”,把“全部商品”这一行的文字颜色修改为紫色
    revealController.rearViewController = leftSlideVc;//!全部商品列表 左边筛选框设置
    
    revealController.rearViewRevealWidth = SCREEN_WIDTH *0.4f;
    
    //!!!!!!!!!!!!!!!!!!!!
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];
    
    
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
        
        //!!!!!!!!!!!!!
        [self.view addGestureRecognizer:revealController.panGestureRecognizer];
        
        
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
//当maskView出现的时候，
- (void)backFormerVC:(UITapGestureRecognizer *)tap
{
    self.revealViewController.frontViewPosition = FrontViewPositionLeftSide;
    
}

#pragma mark 添加观察
-(void)addAllNotification{
    
    //!侧滑搜索分类是否通知--》弹出全部商品页面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAllGoodsVC) name:@"allGoodsList" object:nil];
    
    //!侧滑搜索分类是否通知--》弹出分类界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushCategoryVC) name:@"className" object:nil];
    
    //!侧滑 频道通知 --》弹出频道
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intoChannelClick:) name:@"intoChannel" object:nil];
    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideLeft) name:@"HideLeft" object:nil];
    
    
    //!显示筛选界面的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(filterClick:) name:@"ShowFilterViewNoti" object:nil];
    
}

-(void)removeAllNotification{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"allGoodsList" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"className" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"intoChannel" object:nil];
    
    //!home键退回到后台，收到通知，收回侧拉框
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideLeft" object:nil];
    
    //!显示筛选界面的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowFilterViewNoti" object:nil];
    
}

#pragma mark !收到进入商品分类的通知
-(void)pushCategoryVC{
    
    GoodsClassViewController *goodsClassVC = [[GoodsClassViewController alloc] init];
    [self.navigationController pushViewController:goodsClassVC animated:NO];
    
}
#pragma mark 收到进入全部商品的通知
-(void)pushToAllGoodsVC{
    
    AllGoodsViewController * allGoodsVC = [[AllGoodsViewController alloc]init];
    [self.navigationController pushViewController:allGoodsVC animated:YES];
    
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
-(void)hideLeft{
    
    //!如果是开启的，就关起来
    if (isOpen) {
        
        [self leftNavClick];
        
    }
    
    
}
-(void)leftNavClick{
    
    
    if (isOpen) {
        
        self.revealViewController.frontViewPosition = FrontViewPositionLeft;
        isOpen = NO;
        
    }else
    {
        self.revealViewController.frontViewPosition = FrontViewPositionRight;
        isOpen = YES;
        
        
    }
    
    
}

#pragma mark 实现点击商品进入商品详情的block
-(void)realizeGoodsLishBlock{
    
    __weak CustomGoodsListViewController * goodsListVC = self;
    //!进入商品详情
    self.allGoodsListView.selectBlock = ^(Commodity *goodsCommodity){
        
        [goodsListVC showNotLevelReadTipForGoodsNo:goodsCommodity.goodsNo withIsReadable:[goodsCommodity isReadable]];
        
        
    };
    
    self.canBrowserGoodsListView.selectBlock = ^(Commodity *goodsCommodity){
        
        [goodsListVC showNotLevelReadTipForGoodsNo:goodsCommodity.goodsNo withIsReadable:[goodsCommodity isReadable]];
        
        
    };
    
   
    
}
-(AllListNoGoodsView *)instanceAllNoGoodsView{
    
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AllListNoGoodsView" owner:nil options:nil];
    
    AllListNoGoodsView * noGoodsView = [nibView objectAtIndex:0];
    
    return noGoodsView;
    
}

#pragma mark 处理h5给的事件
-(void)registerHandlers{
    
    //!进入商品详情
    [self.bridge registerHandler:@"goodsDetails" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"goodsNo"] ) {
            
            [self showNotLevelReadTipForGoodsNo:data[@"goodsNo"] withIsReadable:[data[@"authFlag"] intValue]];
            
            
        }
        
        
    }];
    
    //!店铺
    [self.bridge registerHandler:@"merchantsGoodsList" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"merchantNo"]) {
            
            MerchantDeatilViewController * merchantDetail = [[MerchantDeatilViewController alloc]init];
            merchantDetail.merchantNo = data[@"merchantNo"];
            
            [self.navigationController pushViewController:merchantDetail animated:YES];
            
        }
        
        
    }];
    
    //!频道
    [self.bridge registerHandler:@"goodsChannel" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"id"]) {
            
            GoodsChannelViewController * channelVC = [[GoodsChannelViewController alloc]init];
            channelVC.channelId = [data[@"id"] intValue];
            channelVC.channelName = data[@"name"];
            channelVC.channelImg = data[@"img"];
            [self.navigationController pushViewController:channelVC animated:YES];
            
        }
        
        
    }];
    
    //!根据分类no进入
    [self.bridge registerHandler:@"goodsSearch" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"structureNo"]) {
            
            GoodsFilterViewController * filterVC = [[GoodsFilterViewController alloc]init];
            
            filterVC.structNo = data[@"structureNo"];
            filterVC.structName = data[@"keyword"];
            [self.navigationController pushViewController:filterVC animated:YES];
        }
        
//        [self pushCategoryVC];
        
    }];
    
    //!获取h5的高度，然后修改显示的高度
    [self.bridge registerHandler:@"resetWVHeight" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data[@"height"]) {
            
            CGFloat reallyWebViewHight = [data[@"height"] floatValue];
            if (reallyWebViewHight != webViewShowHight) {//!得到的h5高度 和 已经显示出来的h5高度 不相同
                
                if (reallyWebViewHight > showHight) {
                    
                    reallyWebViewHight = showHight;
                    
                }
                [self changeWebViewHight:reallyWebViewHight];
                
            }
            
            
        }
        
    }];
    

}
//!根据网页高度修改所有控件的位置
-(void)changeWebViewHight:(CGFloat)reallyWebViewHight{
    
    
    webViewShowHight = reallyWebViewHight;
    //!1、修改背景的contentsize
    self.bgScrollerView.contentSize = CGSizeMake(self.view.frame.size.width,reallyWebViewHight+ showHight);
    
    //!2、修改webview显示的高度，商品列表显示的高度
    self.webView.frame = CGRectMake(0, 0, self.view.frame.size.width, reallyWebViewHight);
    
    //!3、修改 全部、我的等级可看的位置
    self.selectView.frame = CGRectMake(0, CGRectGetMaxY(self.webView.frame),self.bgScrollerView.frame.size.width, 30);
    
    //!4、修改商品sc的位置
    self.goodsSrollerView.frame = CGRectMake(0, CGRectGetMaxY(self.selectView.frame), self.view.frame.size.width, self.bgScrollerView.frame.size.height - self.selectView.frame.size.height);

    
    [self.allGoodsListView removeHeaderRefresh];
    [self.canBrowserGoodsListView removeHeaderRefresh];
    
    self.topRefreshControl = nil;
    
    //!webview 的高度是0，就在商品列表商品添加下拉刷新功能;否则添加下拉出webview的功能
    if (reallyWebViewHight == 0) {
        
        requestWebViewUrlSuccess = NO;//!设定为没有请求成功

        [self.allGoodsListView addHeaderRefresh];
        [self.canBrowserGoodsListView addHeaderRefresh];

    }else{
        
        requestWebViewUrlSuccess = YES;//!设定为请求成功

        //!改变商品列表可下拉出网页的对象；点击statusBar可置顶的对象

        [self changeGoodsRefreshTop];
        
    }
    
    [self changeStatusBarToTop];


}

#pragma mark 进入商品详情
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
//查看商品详情权限不足的提示view
- (CSPAuthorityPopView*)instanceAuthorityPopView {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//!查看商品详情权限不足的提示view 的代理方法

//等级规则
- (void)showLevelRules{
    
    //进行点击
    PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    //bool值进行名字判断
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    
}

//立即升级
- (void)prepareToUpgradeUserLevel{
    
    CCWebViewController *cc = [[CCWebViewController alloc]init];
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    //bool 值进行判断
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];
}

#pragma mark 筛选
-(void)filterClick:(NSNotification *)noti{

    
    float leading = 45;

    if (!self.filterView) {
        
        self.filterView = [[[NSBundle mainBundle]loadNibNamed:@"FilterView" owner:nil options:nil]lastObject];
        self.filterView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH - leading, SCREEN_HEIGHT);

        
        self.filterAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        self.filterAlphaView.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.5];
        
        self.filterAlphaView.hidden = YES;
        
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterAlphaTapClick)];
        [self.filterAlphaView addGestureRecognizer:tapGes];
        
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.filterAlphaView];
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.filterView];

        
    }
    
   

    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
        self.filterView.center = CGPointMake(leading +(SCREEN_WIDTH - leading)/2.0, SCREEN_HEIGHT/2.0);
        
        self.filterAlphaView.hidden = NO;
        
    } completion:nil];
    
    //!初始化
    NSDictionary * sortDic = noti.userInfo;
    
    [self.filterView configData:sortDic];
   
    //!实现点击“确定”的block
    __weak CustomGoodsListViewController * customListVC = self;
    
    self.filterView.sureToSortBlock = ^(NSDictionary * upSortDic){
        
        //!先隐藏
        [customListVC filterAlphaTapClick];
    
        CustomGoodsListView * goodsListView;
        
        if (customListVC.goodsSrollerView.contentOffset.x > SCREEN_WIDTH/2.0) {//!显示的是我的等级可看
            
            goodsListView = self.canBrowserGoodsListView;
            
        }else{//!显示的是全部
        
            goodsListView = self.allGoodsListView;
        }
    
        goodsListView.sortDTO.minPrice = upSortDic[@"minPrice"];
        goodsListView.sortDTO.maxPrice = upSortDic[@"maxPrice"];
        goodsListView.sortDTO.upDayNum = upSortDic[@"upDayNum"];
        
        //!刷新数据
        [goodsListView requestData:nil];
        
    
    };
    
    
}

-(void)filterAlphaTapClick{


    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.filterView.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT/2.0);
        
        self.filterAlphaView.hidden = YES;
        
        //!收起键盘
        [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
        
    } completion:nil];
    


}
//!移除筛选的view
-(void)removeFilterView{

    [self.filterView removeFromSuperview];
    self.filterView = nil;

}
-(void)dealloc{
    
    //!移除商品列表滚动的观察
    [self removeGoodListObserver];
    
        
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
