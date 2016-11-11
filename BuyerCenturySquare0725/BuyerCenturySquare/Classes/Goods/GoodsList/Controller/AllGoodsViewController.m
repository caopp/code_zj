//
//  AllGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AllGoodsViewController.h"
#import "GoodsChannelViewController.h"//!频道
#import "CCWebViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "GoodsFilterViewController.h"
#import "GoodsSearchViewController.h"
#import "GoodsChannelViewController.h"


@interface AllGoodsViewController ()<CCWebViewControllerDelegate,SlidePageSquareViewDelegate>
{
    //h5页面（一级立即升级界面）
    CCWebViewController * cc;
}



@end

@implementation AllGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    //!创建界面
    [self createHeaderAndSc];
    
    [self createTableView];
    
    
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //!是点击底部tabbar进入的，则一进入商品，显示 全部
    if ([MyUserDefault defaultLoadIntoAllGoods]) {
        
        self.backSrollview.contentOffset = CGPointMake(0, 0);
        
    }
    //!添加侧滑的手势
//    [self addLeftGestuer];
    
    //!请求个人中心的采购车数量
    [self requestPerCenterInfoForShopCar];
    
    //!此界面不隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    //!创建导航 需要在这里创建，不要放到viewdidload 里面，不然子类会重写
    [self createNav];
    
    //!添加观察
    [self addAllNotification];
    
    
    
}



-(void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    
    //!删除是从点击tabbar进入全部商品的标志
    [MyUserDefault removeIntoAllGoods];
    
    //!移除所有的观察
    [self removeAllNotification];
    
    //!移除筛选的view
    [self removeFilterView];
    
}



#pragma mark 创建导航
-(void)createNav{

    
    float width = 30;//!导航左右按钮的宽度
//
//    NSString * leftImageName = @"category";
    
    [self createAllGoodsNav];
        
    //!左按钮
//    UIButton *leftNavBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    leftNavBtn.frame = CGRectMake(0, 0, width , 30 );//!图片实际宽度 18  14
//    
//    [leftNavBtn setImage:[UIImage imageNamed:leftImageName] forState:UIControlStateNormal];
//    leftNavBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -(width - 18) , 0, 0);//!修改图片在按钮中的位置
//
//    [leftNavBtn addTarget:self action:@selector(leftNavClick) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftNavBtn];
    
    UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, width, 30);
    [leftBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    
    leftBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    
    [leftBtn addTarget:self action:@selector(backBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
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
    
    
    /*
    self.title = @"全部商品";
    
    //!右导航
    UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
    
    UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"serchImage"] forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(0, (rightView.frame.size.height - 40)/2, 35, 40);//!原本26、20
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [rightView addSubview:searchBtn];
    
    shopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shopCarBtn.frame = CGRectMake(rightView.frame.size.width - 35, (rightView.frame.size.height - 40)/2, 35 , 40 );//!原本：22、19
    shopCarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -8);

    [shopCarBtn setImage:[UIImage imageNamed:@"navShopCar"] forState:UIControlStateNormal];
    [shopCarBtn addTarget:self action:@selector(shopCarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:shopCarBtn];
    
    
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];

     */
    
   
    
     
    

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

/*
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
*/
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark 创建界面
-(void)createHeaderAndSc{

    //!1、全部 我的等级可看 的view
    //!全部、我的等级可看
    self.manager = [[SlidePageManager alloc]init];
    
    SlidePageSquareView * selectView =  (SlidePageSquareView *)[self.manager createBydataArr:@[@"全部",@"我的等级可看"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHexValue:0x333333 alpha:1] squareViewColor:[UIColor whiteColor] unSelectTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:13]];
    
    
    selectView.frame = CGRectMake(0, 0,self.view.frame.size.width, 30);
    selectView.contentSize = CGSizeMake(self.view.frame.size.width, selectView.frame.size.height);
    selectView.delegateForSlidePage = self;
    [self.view addSubview:selectView];
    
    
    //2、scrollview
    CGFloat showHight = self.view.frame.size.height -self.navigationController.navigationBar.frame.size.height - 20 -CGRectGetMaxY(selectView.frame);
    
    //!从筛选、搜索 过来没有tabbar，则要全截面显示collectionview
    if (self.structName || self.searchContent) {
        
        showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 -CGRectGetMaxY(selectView.frame) ;
        
    }
    
    
    self.backSrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(selectView.frame), self.view.frame.size.width, showHight)];
    
    self.backSrollview.contentSize = CGSizeMake(self.view.frame.size.width*2, showHight);
    self.backSrollview.delegate = self;
    self.backSrollview.pagingEnabled = YES;
    [self.view addSubview:self.backSrollview];


}


-(void)createTableView{

    
    //3、collectionView
    //!全部按钮点击事件
    __weak AllGoodsViewController * vc = self;

    //!全部collectionview
    allGoodsListView = [[GoodsListView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width ,self.backSrollview.frame.size.height) withMerchantNo:nil withStructNo:self.structNo withRangFlag:@"0"];//!(0:全部（默认） 1:等级可见)

    [self.backSrollview addSubview:allGoodsListView];

    
    
    //!等级可看collectionview
    canBrowserGoodsListView = [[GoodsListView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(allGoodsListView.frame), 0, self.view.frame.size.width, self.backSrollview.frame.size.height) withMerchantNo:nil withStructNo:self.structNo withRangFlag:@"1"];
    [self.backSrollview addSubview:canBrowserGoodsListView];


    //!点击事件
    allGoodsListView.selectBlock = ^(Commodity *goodsCommodity){
    
        [vc cellSelect:goodsCommodity];
        
    
    };
    
    canBrowserGoodsListView.selectBlock = ^(Commodity *goodsCommodity){
        
        [vc cellSelect:goodsCommodity];

        
    };
    //!
    allGoodsListView.showNoGoodsTips = ^(NSInteger totalCount){
    
        [allNoGoodsView removeFromSuperview];
        allNoGoodsView = nil;
        
        if (!totalCount) {//!有数据，出去没有数据的提示
            
            allNoGoodsView = [vc instanceAllNoGoodsView];
            allNoGoodsView.frame = CGRectMake(0, 15 + 25 + 14, self.backSrollview.frame.size.width, self.backSrollview.frame.size.height - (15 + 25 + 14));//!减去sortView的位置
            
            [self.backSrollview addSubview:allNoGoodsView];

        }
    };
    
    canBrowserGoodsListView.showNoGoodsTips = ^(NSInteger totalCount){
    
         [canNoGoodsView removeFromSuperview];
         canNoGoodsView = nil;
        
        if (!totalCount) {//!有数据，出去没有数据的提示
            
            canNoGoodsView = [vc instanceAllNoGoodsView];
            canNoGoodsView.frame = CGRectMake(self.view.frame.size.width, 15 + 25 + 14, self.backSrollview.frame.size.width, self.backSrollview.frame.size.height - (15 + 25 + 14));//!减去sortView的位置
            
            [self.backSrollview addSubview:canNoGoodsView];

            
        }
    };
    
    //!设置 点击状态栏，“全部”对应的tableview 可置顶
    [self setScAndTableViewScrollerToTop:YES];
    
    
}

//!collectionviewcell 点击事件
-(void)cellSelect:(Commodity *)goodsCommodity{
    
    
    [self showNotLevelReadTipForGoodsNo:goodsCommodity.goodsNo withIsReadable:[goodsCommodity isReadable]];
    
    
}
#pragma mark 各个情况下的view
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
            {//!是字典，就显示错误提示
                [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                
                CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                popView.frame = self.view.bounds;
                popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                
                popView.delegate = self;
                [self.view addSubview:popView];
                
                
            } else {//!不是字典，就进入商品详情
                
                [self.view makeMessage:@"您的等级已变化，请刷新页面后查看！" duration:3.0 position:@"center"];
            
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
    cc = [[CCWebViewController alloc]init];
    cc.delegate = self;
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    //bool 值进行判断
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];
}
#pragma mark scorllerViewDelegate  SlidePageSquareViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.backSrollview) {
        
        self.manager.contentOffsetX = scrollView.contentOffset.x;
        
    }
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.backSrollview) {
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        if (scrollView.contentOffset.x >= self.view.frame.size.width) {//!我的等级可看
            
            [self setScAndTableViewScrollerToTop:NO];//!设置 可看 可以置顶
            
            //!把筛选条件还原
            [allGoodsListView resetSortDTO];

        }else{//!全部
            
            [self setScAndTableViewScrollerToTop:YES];//!设置 全部 可以置顶
            //!把筛选条件还原
            [canBrowserGoodsListView resetSortDTO];

            
        }
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.backSrollview) {
        
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        
        
        
    }
    
}
- (void)slidePageSquareView:(SlidePageSquareView *)view andBtnClickIndex:(NSInteger)index{
    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    [self.backSrollview  setContentOffset:CGPointMake(screenWith*index,0 ) animated:YES];
    
    if (index == 0) {//!全部
        
        [self setScAndTableViewScrollerToTop:YES];//!设置 全部 可以置顶
        //!把筛选条件还原
        [canBrowserGoodsListView resetSortDTO];

    }else{//!我的等级可看
        
        [self setScAndTableViewScrollerToTop:NO];//!设置 可看 可以置顶
        //!把筛选条件还原
        [allGoodsListView resetSortDTO];

    }
    
}

//!改变sc上面两个tableView哪个可以点击至顶部  showAll：显示全部
-(void)setScAndTableViewScrollerToTop:(BOOL)showAll{
    
    self.backSrollview.scrollsToTop = NO;
    allGoodsListView.goodsCollectionView.scrollsToTop = showAll;
    canBrowserGoodsListView.goodsCollectionView.scrollsToTop = !showAll;
    
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

        [allGoodsListView addGestureRecognizer:revealController.panGestureRecognizer];
        
       
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
-(void)addAllNotification{
    
    //!显示筛选界面的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(filterClick:) name:@"ShowFilterViewNoti" object:nil];
    
}

-(void)removeAllNotification{
    
    //!显示筛选界面的通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowFilterViewNoti" object:nil];
    
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
    __weak AllGoodsViewController * goodsListVC = self;
    
    self.filterView.sureToSortBlock = ^(NSDictionary * upSortDic){
        
        //!先隐藏
        [goodsListVC filterAlphaTapClick];
        
        GoodsListView * goodsListView;
        
        if (goodsListVC.backSrollview.contentOffset.x > SCREEN_WIDTH/2.0) {//!显示的是我的等级可看
            
            goodsListView = canBrowserGoodsListView;
            
        }else{//!显示的是全部
            
            goodsListView = allGoodsListView;
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
