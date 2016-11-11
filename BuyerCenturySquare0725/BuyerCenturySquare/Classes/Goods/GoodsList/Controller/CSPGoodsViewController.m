//
//  CSPGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import "CSPGoodsViewController.h"
#import "MembershipUpgradeViewController.h"
#import "MembershipGradeRulesViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "GoodDetailViewController.h"
#import "AllListNoGoodsView.h"//!全部商品--》筛选-->暂无相关商品view

typedef void(^DidFinishedBlock)();

// !商品列表----全部，我的等级可看，商家详情
typedef NS_ENUM(NSInteger, CollectionViewObserve) {
    CollectionViewObserveAllGoods,
    CollectionViewObserveVisibleGoods,
    CollectionViewObserveSingleMerchantGoods,
};

// !商家详情---商家状态
typedef NS_ENUM(NSInteger, SingleMerchantStatus) {
    SingleMerchantStatusNormal,
    SingleMerchantStatusNoGoods,
    SingleMerchantStatusOutOfBusiness,
    SingleMerchantStatusClose,
    SingleMerchantStatusBlackList,
    
};

@interface CSPGoodsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SMSegmentViewDelegate, REMenuDelegate, CSPMerchantClosedViewDelegate, CSPAuthorityPopViewDelegate, CategoryMenuClick, CSPCategoryMenuDelegate,CSPMerchantClosedViewDelegate,MembershipUpgradeViewControllerDelegate> {
    
    GoodsCategoryMenuView * categoryMenuView;// !商家详情--商品分类的view
    UIImageView * rigthItemImageView;// !有导航的图片
    CGFloat imageviewAngle;// !有导航的箭头旋转角度
    
    // !毛玻璃导航的控件
    // !导航的背景图片
    UIImageView *navImageView;
   
    // !返回按钮
    UIButton *backBarBtn;
    // !导航中间的view
    UIView * navCenterView;
    
    // !客服按钮
    UIButton * serviceBtn;
    
    CGRect bounding;//!商家名字大小
    
}


@property (weak, nonatomic) IBOutlet SMSegmentView *segmentView;// !分段选择
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *backTopButton;

@property (nonatomic, strong) CommodityGroupListDTO* allGroupList;// !全部 商品的列表

@property (nonatomic, strong) CommodityGroupListDTO* visibleGroupList;// !我的等级可看

@property (nonatomic, assign)CollectionViewObserve observe;// !商品列表的状态

@property (strong, nonatomic) REMenu *menu;// ! “商品” nav 中间的筛选view

@property (strong, nonatomic) CSPCategoryMenu* categoryMenu;// !“商品”--商品分类

@property (strong, nonatomic) UIButton* titleButton;// !nav中间的button

@property (strong, nonatomic) CommodityClassification* commodifyClassification; //！“商品”--商品分类 请求的商品分类信息

@property (strong, nonatomic) UIView* specialTipView;// !商家详情--提示商家状态的view

@property (strong, nonatomic) UIView* AllNoGoodsTipView;// !全部商品，没有商品时的提示

@property (nonatomic, strong) NSString* structureNo;// !查询的分类
// !全部商品--分别记录 全部、我的等级可看的当前查询的等级
@property (nonatomic, strong) NSString* allStructureNo;// !查询的分类
@property (nonatomic, strong) NSString* visibleStructureNo;// !查询的分类



@property (nonatomic, assign) SingleMerchantStatus singleMerchantStatus;// !商家状态


@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@property(nonatomic,assign)BOOL loadAll;//!点击的是全部
@property(nonatomic,assign)BOOL loadVisable;//!点击的是可看



@end

@implementation CSPGoodsViewController

static NSString * const reuseIdentifier = @"goodsCell";

- (void)viewDidLoad {
    [super viewDidLoad];

    
    // !返回顶部按钮
    [self.backTopButton setHidden:YES];

    // !创建顶部的segment
    [self setupSegmentViewWithStyle:self.style];

    // !创建刷新
    [self createRefresh];
    
    self.collectionView.alwaysBounceVertical = YES;
    
    // !设置nav的样式: 商家详情--创建客服按钮、设置字体  商品列表：请求分类数据  self.style：全部商品、商家店铺列表
    [self setupNavigationBarTitleWithStyle:self.style];
    
    
    imageviewAngle = 0;


}


- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    // !保证在这个界面的时候tabbar不隐藏  (查看的是商家详情的时候不显示底部的tabbar)
    if (self.isFromLetter == YES || self.style == CSPGoodsViewStyleSingleMerchant) {
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
        
    }else{//!全部商品情况
        
        [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    }

    //!防止到下一个界面再回来之后导航就木有了
    if (navImageView && navCenterView && backBarBtn) {
        
        [self.navigationController.navigationBar addSubview:navImageView];
        [self.navigationController.navigationBar addSubview:navCenterView];
        [self.navigationController.navigationBar addSubview:backBarBtn];
    }
    

    //!如果是在全部商品情况下,并且是点击底部tabbar进入的，则一进入商品，显示 全部
    if (self.style == CSPGoodsViewStyleAll && [MyUserDefault defaultLoadIntoAllGoods]) {
        
        [self.segmentView selectSegmentAtIndex:0];
        
    }
    
    
    //注册该页面可以执行滑动切换
    SWRevealViewController *revealController = self.revealViewController;
    [self.view addGestureRecognizer:revealController.panGestureRecognizer];

    
}




-(void)viewWillDisappear:(BOOL)animated
{
    
    // !保证在任何情况下 ，点击tabbar的商家 时显示的是商家列表
    NSArray* controllers = self.navigationController.viewControllers;
    if ([controllers count] == 2) {
        
        // !第二个controller是商品详情，并且tabbar 选中的是 商家
        if ([[controllers objectAtIndex:1] isKindOfClass:[CSPGoodsViewController class]] && [[controllers objectAtIndex:0] isKindOfClass:[CSPMerchantTableViewController class]]) {
            
            [self.navigationController popViewControllerAnimated:YES];
        
        }
    
    }
    
    // !删除这个页面导航上有的，但是其他导航不需要的控件
    [navImageView removeFromSuperview];
    [navCenterView removeFromSuperview];
    [backBarBtn removeFromSuperview];
    
    // !中部的一级分类 开着就关，没有就收起来
    if (self.menu.isOpen)
        return [self.menu close];

    //!隐藏二级分类
    [self closeCategoryMenu];
    
    //!删除是从点击tabbar进入全部商品的标志
    [MyUserDefault removeIntoAllGoods];
    
}


#pragma mark !创建顶部的segment
- (void)setupSegmentViewWithStyle:(CSPGoodsViewStyle)style {
    
    // !商品的情况
    if (style == CSPGoodsViewStyleAll) {
        
        [self.segmentView addSegmentWithTitle:NSLocalizedString(@"all", @"全部")];
        
        [self.segmentView addSegmentWithTitle:NSLocalizedString(@"canBrowse",@"我的等级可看")];
        
        // !设定当前 选中全部
        [self.segmentView selectSegmentAtIndex:0];
        
        //！记录当前选中的是全部商品
        self.observe = CollectionViewObserveAllGoods;
        
        
    } else {// !商家详情
        
        
        [self.segmentView addSegmentWithTitle:NSLocalizedString(@"merchantIntroduce", @"商家介绍") onSelectionImage:[UIImage imageNamed:@"good_merchantIntroduce"] offSelectionImage:[UIImage imageNamed:@"good_merchantIntroduce"]];
        
        [self.segmentView addSegmentWithTitle:NSLocalizedString(@"goodCategory", @"商品分类") onSelectionImage:[UIImage imageNamed:@"good_merchantCategory"] offSelectionImage:[UIImage imageNamed:@"good_merchantCategory"]];
        
        [self.segmentView addSegmentWithTitle:NSLocalizedString(@"postage", @"邮费专拍") onSelectionImage:[UIImage imageNamed:@"good_postage"] offSelectionImage:[UIImage imageNamed:@"good_postage"]];
        
        [self.segmentView selectSegmentAtIndex:0];
        
        self.segmentView.segmentOnSelectionColor = self.segmentView.segmentOffSelectionColor;
        self.segmentView.segmentOnSelectionTextColor = self.segmentView.segmentOffSelectionTextColor;
        
        // !记录当前 是商家详情 的商品列表
        self.observe = CollectionViewObserveSingleMerchantGoods;
    }
    
    
    
    [self.segmentView selectSegmentAtIndex:0];
    
    self.segmentView.delegate = self;
    
    
}
#pragma mark !创建刷新
-(void)createRefresh{
    
    // !header
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.collectionView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPGoodsViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadNewGoodsList];
    };
    
    
    // !footer
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.collectionView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf loadMoreGoodsList];
    };
    
    // !判断当前商店是什么状态  黑名单  歇业  无商品的时候不进行刷新  改为刷新回来后判断一遍
//    if (![self showTipViewForSingleMerchantMode]) {
    
//        [refreshHeader beginRefreshing];
        [self loadNewGoodsList];
    
//    }
    
}
#pragma mark !判断当前商店是什么状态  黑名单  歇业  无商品的时候不进行刷新
- (BOOL)showTipViewForSingleMerchantMode {
    
    
    if (self.style == CSPGoodsViewStyleAll || self.merchantDetail == nil) {
        
        self.singleMerchantStatus = SingleMerchantStatusNormal;
        return NO;
    }
    
    
    // 黑名单
    else if ([self.merchantDetail.blacklistFlag isEqualToString:@"1"]) {
        
        if (self.specialTipView) {
            [self.specialTipView removeFromSuperview];
        }
        // !在界面上加上 黑名单，无权查看的view
        self.specialTipView = [self instanceMerchantBlackListView];
        [self.view addSubview:self.specialTipView];
        
        self.singleMerchantStatus = SingleMerchantStatusBlackList;
        
        return YES;
        
    }
    
    
    //歇业
    else if ([self.merchantDetail.operateStatus isEqualToString: @"1"]) {
        
        if (self.specialTipView) {
            [self.specialTipView removeFromSuperview];
        }
        // !添加上 歇业状态的view
        CSPMerchantOutOfBusinessView* outOfBusinessView = [self instanceMerchantOutOfBusinessView];
        // !设置歇业时间
        [outOfBusinessView setupWithMerchantDetail:self.merchantDetail];
        self.specialTipView = outOfBusinessView;
        [self.view addSubview:self.specialTipView];
        
        self.singleMerchantStatus = SingleMerchantStatusOutOfBusiness;
        
        return YES;
        
    }
    // !商家状态(0:开启 1:关闭)
    else if ([self.merchantDetail.merchantStatus isEqualToString:@"1"]){
    
        //!关闭
        if (self.specialTipView) {
            [self.specialTipView removeFromSuperview];
        }
        // !添加上 关闭状态的view
        CSPMerchantClosedView* outOfBusinessView = [self instanceMerchantClosedView];
        outOfBusinessView.delegate = self;
        self.specialTipView = outOfBusinessView;
        [self.view addSubview:self.specialTipView];
        
        self.singleMerchantStatus = SingleMerchantStatusClose;
        
        return YES;

    }
    

    
    
//!有无商品更改为在请求后判断
//    //无商品
//    else if (self.merchantDetail.goodsNum.integerValue == 0) {
//        
//        if (self.specialTipView) {
//            [self.specialTipView removeFromSuperview];
//        }
//        //!添加上  没有商品的提示view
//        self.specialTipView = [self instanceMerchantNoGoodsView];
//        [self.view addSubview:self.specialTipView];
//        
//        self.singleMerchantStatus = SingleMerchantStatusNoGoods;
//        
//        return YES;
//        
//    }

    
    return NO;
}

#pragma mark 全部商品 --没有商品的时候显示的view
- (BOOL)showTipViewForAllMode:(int)showArrayCount{

    //!有要显示的数据
    if (showArrayCount) {
        
        if (self.AllNoGoodsTipView) {
            [self.AllNoGoodsTipView removeFromSuperview];
        }
        
        return NO;//!不显示提示view
        
    }else{//!没有要显示的数据
    
        
        if (self.AllNoGoodsTipView) {
            [self.AllNoGoodsTipView removeFromSuperview];
        }
        // !添加 商家没有商品的提示view
        self.AllNoGoodsTipView = [self instanceAllNoGoodsView];
        self.AllNoGoodsTipView.frame = CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - self.collectionView.frame.origin.y);

        [self.view addSubview:self.AllNoGoodsTipView];
    
        return YES;//!显示提示view
        
    }


}


- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    // !除去正常状态  关闭状态  设置添加的view的frame
    if (self.singleMerchantStatus != SingleMerchantStatusNormal &&
        self.singleMerchantStatus != SingleMerchantStatusClose) {
        
        if (self.specialTipView) {
            
            CGRect viewFrame = self.view.bounds;
            viewFrame.origin.y = CGRectGetMaxY(self.segmentView.frame);
            viewFrame.size.height -= CGRectGetMaxY(self.segmentView.frame);
            self.specialTipView.frame = viewFrame;
            
        }
    } else {
        // !正常状态 关闭状态 添加的view的frame
        self.specialTipView.frame = self.view.bounds;
        
    }
}

#pragma mark !导航--设置nav的样式  分类数据的请求
- (void)setupNavigationBarTitleWithStyle:(CSPGoodsViewStyle)style {
    // !商家详情
    if (style == CSPGoodsViewStyleSingleMerchant) {
        
        /*
         
         !无商品、歇业中 ：有毛玻璃、title、可客服按钮可以点击
         ！黑名单       毛玻璃、title、客服按钮不可以点
         !商家关闭 只显示 title为“提示”
         
         SingleMerchantStatusNormal,1 ---
         SingleMerchantStatusNoGoods,  1
         SingleMerchantStatusOutOfBusiness,  1
         SingleMerchantStatusClose,  3
         SingleMerchantStatusBlackList, 2
         无上架商品

        */
        
        // !添加返回按钮
        [self addCustombackButtonItem];
        
        
        
        // !商家关闭  只显示 title为“提示”
        if (self.singleMerchantStatus == SingleMerchantStatusClose) {
            
            self.title = @"提示";
            
            
        } else {
            
            // !商家导航背景
            [self shopNavBg];
            
            // !商家shopNavView
            [self shopNavView];
            
            
            // ! 商家详情--商品列表的分类
            //初始化menu菜单
            self.menuArray = [[NSMutableArray alloc] init];

            //商家详情--商品分类 获取menu菜单
            [self queryMenu];

            
        }
        
        
    } else { // !商品
        
        // !导航中间的titleView(分类点击按钮)
        UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
        self.titleButton = [[UIButton alloc]initWithFrame:titleView.bounds];
        
        NSAttributedString* title = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"goodTitle", @"全部商品") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
        
        [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
        
        [self.titleButton setImage:[UIImage imageNamed:@"good_category"] forState:UIControlStateNormal];
        
        [self.titleButton addTarget:self action:@selector(navigationTitleItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [titleView addSubview:self.titleButton];
        
        self.navigationItem.titleView = titleView;
        
        // !全部商品--商品列表 请求商品品分类数据
        [self requestGoodCategoryData];
    
    }
}


// !商家导航背景
-(void)shopNavBg{
    
    
    
    // !设置背景图
    
    float navHeight = self.navigationController.navigationBar.frame.size.height;
    
    navImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, navHeight +20)];
    
    [navImageView sd_setImageWithURL:[NSURL URLWithString:self.merchantDetail.pictureUrl]];
    
    UIImage *navImage = navImageView.image;
    [navImageView setImage:navImage];
    
    navImageView.contentMode = UIViewContentModeScaleAspectFill;
    navImageView.clipsToBounds  = YES;
    
   
    
    //实现模糊效果
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    visualEffectView.frame = CGRectMake(0,0, SCREEN_WIDTH, navHeight +20);
    visualEffectView.alpha = 1;
    [navImageView addSubview:visualEffectView];
    
    //让颜色更黑
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, navHeight +20)];
    [blackView setBackgroundColor:[UIColor blackColor]];
    blackView.alpha = 0.3;
    [navImageView addSubview:blackView];
   
    [self.navigationController.navigationBar addSubview:navImageView];
    
    
    
}

// !商家详情--商品titleView

-(void)shopNavView{
    
    // !返回按钮
    backBarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBarBtn.frame = CGRectMake(15, 11, 10, 18);
    [backBarBtn setBackgroundImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [backBarBtn addTarget:self action:@selector(backBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:backBarBtn];

    
    // !中间的view
    
    //计算字体宽度
    CGSize labelSize = CGSizeMake(SCREEN_WIDTH - 110, CGFLOAT_MAX);
    
    NSAttributedString* attrContentString = [[NSAttributedString alloc]initWithString:self.merchantDetail.merchantName attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    bounding =[attrContentString boundingRectWithSize:labelSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading context:nil];
    
    
    navCenterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bounding.size.width + 20, 40)];
    
    // !商家名称
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, bounding.size.width, 40)];
    label.text = self.merchantDetail.merchantName;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    [navCenterView addSubview:label];

    
    // !客服按钮
    [self ServiceBtn];
    
//    self.navigationItem.titleView = navCenterView;
    navCenterView.center = CGPointMake(SCREEN_WIDTH/2, 20);
        
    [self.navigationController.navigationBar addSubview:navCenterView];



}
// !客服按钮
-(void)ServiceBtn{
    
    if (serviceBtn) {
        
        [serviceBtn removeFromSuperview];
        
    }
    
    serviceBtn = [[UIButton alloc] initWithFrame:CGRectMake(bounding.size.width, 0, 20, 40)];
    [serviceBtn setImage:[UIImage imageNamed:@"good_customeService"] forState:UIControlStateNormal];
    [serviceBtn addTarget:self action:@selector(customerServiceClick) forControlEvents:UIControlEventTouchDown];
    
    [navCenterView addSubview:serviceBtn];

    
    // !如果是黑名单，客服按钮不可以点击
    if (self.singleMerchantStatus == SingleMerchantStatusBlackList) {
        
        [serviceBtn removeFromSuperview];
        serviceBtn.enabled = NO;
        
    }
    
    
    
}


/**
 *  返回按钮
 */
- (void)backBarButtonClick{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark !导航--客户聊天按钮
- (void)customerServiceClick{
    
    //!防止请求过程中点击多次
    serviceBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:self.merchantDetail.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        serviceBtn.enabled = YES;
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:self.merchantDetail.merchantName jid:jid withMerchantNo:self.merchantDetail.merchantNo];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;


            [self.navigationController pushViewController:conversationVC animated:YES];
            
        } else {
            

            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

          
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        serviceBtn.enabled = YES;

         [self.view makeMessage:@"请求失败" duration:2.0f position:@"center"];
       
    }];
}




#pragma mark !商家详情 ---商品分类查询
- (void) queryMenu {
    
    if(self.merchantDetail != nil) {
        
        [HttpManager sendHttpRequestForGetCategoryListWithMerchantNo:self.merchantDetail.merchantNo withQueryType:@"1"  success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                GetCategoryListDTO* getCategoryListDTO = [[GetCategoryListDTO alloc] init];
                getCategoryListDTO.getCategoryDTOList = [dic objectForKey:@"data"];
                // !把商家详情--商品分类 放到数组中
                for( int index = 0; index < getCategoryListDTO.getCategoryDTOList.count; index ++){
                    
                    NSDictionary *Dictionary = [getCategoryListDTO.getCategoryDTOList objectAtIndex:index];
                    
                    GetCategoryDTO *goodsCategoryDTO = [[GetCategoryDTO alloc] init];
                    [goodsCategoryDTO setDictFrom:Dictionary];
                    [self.menuArray addObject:goodsCategoryDTO];
                
                }
            }else{
                
                
                [self.view makeMessage:[NSString stringWithFormat:@"查询商品分类失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            }
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            
            
        }];
        
    }
    
    
}

#pragma mark !全部商品--商品列表 请求商品品分类数据
-(void)requestGoodCategoryData{

    // !商品--商品分类请求
    [HttpManager sendHttpRequestForGetCategoryListWithMerchantNo:@"" withQueryType:@"1"  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            // !组合数据
            self.commodifyClassification = [[CommodityClassification alloc]initWithDictionaries:[dic objectForKey:@"data"]];
            NSMutableArray* items = [NSMutableArray array];
            
            // !-----一级分类
            // !全部按钮  block里面写的是点击了这个按钮呢之后的操作
        
            REMenuItem *item = [[REMenuItem alloc] initWithTitle:NSLocalizedString(@"all", @"全部") subtitle:nil image:nil highlightedImage:nil action:^(REMenuItem *item) {
                
                
                NSAttributedString* title = [[NSAttributedString alloc]initWithString:NSLocalizedString(@"goodTitle", @"全部商品") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                
                [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
                
                self.navigationItem.rightBarButtonItem = nil;
                // !点击之后，指定 当前要筛选的商品类别
                self.structureNo = nil;
                
                
                [self.refreshHeader beginRefreshing];
                
            }];
            [items addObject:item];
            
            // !二级分类
            for (CommodityClassificationDTO* dto in [self.commodifyClassification getPrimarycategory]) {
                
                REMenuItem *item = [[REMenuItem alloc] initWithTitle:dto.categoryName subtitle:nil image:nil highlightedImage:nil action:^(REMenuItem *item) {
                    
                    NSAttributedString* title = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@" %@", item.title] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:18.0f], NSForegroundColorAttributeName: [UIColor whiteColor]}];
                    
                    [self.titleButton setAttributedTitle:title forState:UIControlStateNormal];
                    // !指定导航右按钮
                    rigthItemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 13, 22, 13)];
                    [rigthItemImageView setImage:[UIImage imageNamed:@"good_categoryUp"]];
                    
                    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
                    [btn addSubview:rigthItemImageView];
                    [btn addTarget:self action:@selector(categoryMenuItemClicked:) forControlEvents:UIControlEventTouchUpInside];
                    
                    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
                    
                    // !点击之后，指定 当前要筛选的商品类别
                    self.structureNo = dto.structureNo;
                    [self.refreshHeader beginRefreshing];
                    
                    if (self.categoryMenu.isOpen) {
                        [self.categoryMenu dismissWithAnimation:YES];
                    }
                    // =====!三级分类
                    _categoryMenu = [[CSPCategoryMenu alloc]initWithCommodityClassification:self.commodifyClassification parentId:dto.id];
                    _categoryMenu.delegate = self;
                    
                    
                }];
                [items addObject:item];
            }
            // !设置二级分类的样式
            [self setupMenuWithItems:items];
            
        } else {
            
             [self.view makeMessage:[NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"goodCategoryError", @"查询商品分类失败"),[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
       
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

#pragma mark !导航---设置二级分类的样式
- (void)setupMenuWithItems:(NSArray*)items {
    
    self.menu = [[REMenu alloc] initWithItems:items];
    self.menu.delegate = self;
    
    if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
        
    }
    
    self.menu.backgroundColor = HEX_COLOR(0x666666F9);
    self.menu.backgroundAlpha = 1;
    self.menu.highlightedBackgroundColor = HEX_COLOR(0x99999933);
    self.menu.highlightedTextColor = HEX_COLOR(0xFFFFFFFF);
    self.menu.highlightedSeparatorColor = HEX_COLOR(0x99999966);
    self.menu.textColor = HEX_COLOR(0x999999FF);
    self.menu.separatorColor = HEX_COLOR(0x99999966);
    self.menu.separatorHeight = 0.5f;
    
    self.menu.font = [UIFont systemFontOfSize:15.0f];
    
    self.menu.itemHeight = 40.0f;
    
    
    self.menu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = NO;
    self.menu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    CommodityGroupListDTO* currentGroupList = [self commodityGroupListForCurrentObserver];
    return currentGroupList.groupList.count;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    CommodityGroup* groupInfo = [self commodityGroupForSection:section];

    return groupInfo.commodityList.count;
    
    
}

- (CSPGoodsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    // Configure the cell
    cell.commodityInfo = [self commodityForRowAtIndexPath:indexPath];

    if (indexPath.row == 0) {
        
        if ([cell.commodityInfo.goodsType isEqualToString:@"1"]) {
            
            [cell.cornerView setHidden:YES];
            
        }else{// !普通
            
            [cell.cornerView setHidden:NO];
            
        }
        
    } else {
        [cell.cornerView  setHidden:YES];
    }

    return cell;
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Commodity* commodityInfo = [self commodityForRowAtIndexPath:indexPath];
    
    
    // !点击的是 邮费专拍
    if ([commodityInfo.goodsType isEqualToString:@"1"]) {
        
        CSPPostageViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        
        destViewController.merchantNo = self.merchantDetail.merchantNo;
        
        [self.navigationController pushViewController:destViewController animated:YES];
        
    } else {
        
        
        // !判断商品是否可以查看  如果可以 ，进入商品详情
        if ([commodityInfo isReadable]) {

            GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
            
            goodsInfoDTO.goodsNo = commodityInfo.goodsNo;
            
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
//            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
//            goodsInfo.goodsNo = commodityInfo.goodsNo;
            
            
            GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
            [self.navigationController pushViewController:goodsInfo animated:YES];
            
            
        } else {//!不可以查看 ，显示等级提示
            
            [self showNotLevelReadTipForGoodsNo:commodityInfo.goodsNo];
            
        }
    }
    
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeZero;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    
    CGFloat width = (CGRectGetWidth(collectionView.frame) - 20) / 2 ;
    CGFloat height = 59 + width;

    return CGSizeMake(width, height);
    
    
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{

    UICollectionReusableView *reusableview = nil;

    if (kind == UICollectionElementKindSectionHeader){

        CSPGoodsSectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];

            reusableview = headerView;

    }
    
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(CSPGoodsCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell startAnimation];
    
}

#pragma mark -
#pragma mark SMSegmentViewDelegate  点击segment的代理方法

- (void)segmentView:(SMSegmentView *)segmentView didSelectSegmentAtIndex:(NSInteger)index {
    
    // !商品
    if (self.style == CSPGoodsViewStyleAll) {
        
        // !获取点击的是  全部 还是  我的等级可看
        self.observe = (index == 0 ? CollectionViewObserveAllGoods : CollectionViewObserveVisibleGoods);
        // !判断当前选择的筛选类别是否和用户当前选择的相同，相同则展示上次取到的数据，不相同则刷新数据
        
        NSString *selectSegStrutureNo;
        
        
        //!把请求的是全部或者可见设为no
        self.loadAll = NO;
        self.loadVisable = NO;
        
        
        // !记录点击按钮 当前筛选的类别
        if (self.observe == CollectionViewObserveAllGoods) {
            
            self.loadAll = YES;//!请求的是全部
            
            selectSegStrutureNo = self.allStructureNo;
            
        }else if (self.observe == CollectionViewObserveVisibleGoods){
        
            self.loadVisable = YES;//!请求的是可见
            
            selectSegStrutureNo = self.visibleStructureNo;
        
        }
        
        
        // !判断筛选的类别是否相同
        if ([selectSegStrutureNo isEqualToString:self.structureNo]) {
            
            
            // !获取对应seg的数据
            CommodityGroupListDTO* currentGroupList = [self commodityGroupListForCurrentObserver];
            
            if (currentGroupList.groupList.count == 0) {
                
                [self.refreshHeader beginRefreshing];
                
            } else {
                
                //!如果有count不为0，则说明有数据，无商品页面也应该去除
                if (self.AllNoGoodsTipView) {
                    
                    [self.AllNoGoodsTipView removeFromSuperview];
                    self.collectionView.hidden = NO;
                }
                [self reload];
                
            }

            
        }else{// !不相同则取刷新数据，并且把对应选择的类别更改
        
            [self.refreshHeader beginRefreshing];

            
        }

        
    } else {// !单独的商家
        
        // !商家详情
        if (index == 0) {
            // !黑名单  商家关闭的时候点击是无效的
            if (self.singleMerchantStatus == SingleMerchantStatusClose ||
                self.singleMerchantStatus == SingleMerchantStatusBlackList) {
                
                return;
            
            }
            // !商家信息 view
            CSPMerchantInfoPopView* popView = [self instanceMerchantInfoView];
            popView.frame = self.view.bounds;
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [HttpManager sendHttpRequestForGetMerchantShopDetailWithMerchantNo:self.merchantDetail.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
               
                
                NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                    // !给商家信息view 赋值
                    NSDictionary* dataDict = [dic objectForKey:@"data"];
                    [popView setupWithDictionary:dataDict];
                    [self.view addSubview:popView];
                    
                } else {
                    
                    
                    [self.view makeMessage:[NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"merchantError", @"获取商家详情失败"),[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
                    
                    
                }
                

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            }];
            
        } else if (index == 1) {// !商品分类
            
            
            
            // !除了正常状态 其他期狂点击都无效
            if (self.singleMerchantStatus != SingleMerchantStatusNormal) {
               
                return;
            }
            
            if (categoryMenuView == nil) {
                
                categoryMenuView = [[GoodsCategoryMenuView alloc] initWithArray:self.menuArray withParentView:self.segmentView];
                
                categoryMenuView.delegate = self;
                [self.view addSubview:categoryMenuView];
                [categoryMenuView showOrHidden];
                
            }else {
                
                [categoryMenuView showOrHidden];
            }
            
            
            
            
        } else {
            // !除了正常状态 其他期狂点击都无效
            if (self.singleMerchantStatus != SingleMerchantStatusNormal) {
                
                return;
            }
            // !邮费专拍
            CSPPostageViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
            destViewController.merchantNo = self.merchantDetail.merchantNo;
            [self.navigationController pushViewController:destViewController animated:YES];
        }

        self.observe = CollectionViewObserveSingleMerchantGoods;
        
    }
    
}

#pragma mark 商家详情--商品分类  代理方法 处理菜单点击事件
- (void)menuClick:(NSString *)searchId {
    
    
    self.structureNo = searchId;

    [self.refreshHeader beginRefreshing];
    
}

#pragma mark -
#pragma mark CSPCategoryMenuDelegate  商品--二级分类

- (void)didShowCategoryMenu:(CSPCategoryMenu *)menu {
    
    
    //收起一级分类
    [self.menu close];

    
    imageviewAngle += 180;
    //0.1秒旋转180度
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        rigthItemImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(imageviewAngle));
        
    } completion:^(BOOL finished) {
        
    }];
    
    
}

- (void)didDismissCategoryMenu:(CSPCategoryMenu *)menu {

    imageviewAngle += 180;
    //0.1秒旋转180度
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        rigthItemImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(imageviewAngle));
    } completion:^(BOOL finished) {
        
    }];
    

}

- (void)didSelectedCategoryMenu:(CSPCategoryMenu *)menu withStructureNo:(NSString *)structureNo {

    self.structureNo = structureNo;

    [self.refreshHeader beginRefreshing];
    
    
}


#pragma mark -
#pragma mark Private Methods

- (IBAction)backTopButtonClicked:(id)sender {
    [self.collectionView setContentOffset:CGPointZero animated:YES];
}

#pragma mark  !点击seg的时候 获取要显示的数据  ：全部 我的等级可看  商家详情
- (CommodityGroupListDTO*)commodityGroupListForCurrentObserver {
    
    CommodityGroupListDTO* currentCommodityGroupList = nil;
    switch (self.observe) {
        case CollectionViewObserveAllGoods:
        case CollectionViewObserveSingleMerchantGoods:
            currentCommodityGroupList = self.allGroupList;
            break;
            
        case CollectionViewObserveVisibleGoods:
            currentCommodityGroupList = self.visibleGroupList;
            break;
        default:
            break;
    }

    return currentCommodityGroupList;
    
}
#pragma mark 根据 第几段 获取 对应段里面的数据
- (CommodityGroup*)commodityGroupForSection:(NSInteger)section {
    
    CommodityGroupListDTO* currentCommodityGroupList = [self commodityGroupListForCurrentObserver];
    if (section < currentCommodityGroupList.groupList.count) {
        
        return currentCommodityGroupList.groupList[section];
    
    }

    return nil;
}
#pragma mark  !根据 第几行 获取对应的数据
- (Commodity*)commodityForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    CommodityGroup* commodityGroup = [self commodityGroupForSection:indexPath.section];
    
    if (commodityGroup && commodityGroup.commodityList.count > indexPath.row) {
        
        return commodityGroup.commodityList[indexPath.row];
    }
    
    return nil;
}

#pragma mark 显示等级详情
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
                NSLog(@"the currentLevel is %@\n",goodsNotLevelTipDTO.currentLevel);
                
                CSPAuthorityPopView* popView = [self instanceAuthorityPopView];
                popView.frame = self.view.bounds;
                popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;

                popView.delegate = self;
                [self.view addSubview:popView];
                
                
            } else {
                
                  [self.view makeMessage:[NSString stringWithFormat:@"查询商品权限限制失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
             
            }

        } else {
            
             [self.view makeMessage:[NSString stringWithFormat:@"查询权限失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
           
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
    }];
}

#pragma mark !下拉刷新
- (void)loadNewGoodsList {
    
    // !商品--全部商品
    if (self.observe == CollectionViewObserveAllGoods) {
        
        // !把“全部"查看的类别更改
        self.allStructureNo = self.structureNo;
        
        //查询所有
        [self getGoodsListWithPageNo:1 merchantNo:nil structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
            
            //!获得组合好的 商品数据  大数组里面 包含小数组，小数组里面包含同一个更新时间的商品
            self.allGroupList = [[CommodityGroupListDTO alloc]initWithDictionary:dataDict];
            
            //!判断是否有数据，没有数据就显示无数据的提示view
            
            if (![self showTipViewForAllMode:self.allGroupList.totalCount]) {//!不显示提示view 显示collectionView
                
                self.collectionView.hidden = NO;
                [self reload];
                
            }else{//!显示提示view
            
                self.collectionView.hidden = YES;

            }
            
            
        }];
        
        
    } else if (self.observe == CollectionViewObserveVisibleGoods) {
       
        // !把“我的等级可看"查看的类别更改
        self.visibleStructureNo = self.structureNo;
        
        
        // !商品--查询可见
        [self getGoodsListWithPageNo:1 merchantNo:nil structureNo:self.structureNo rangeFlag:@"1" complete:^(NSDictionary* dataDict) {
            
            self.visibleGroupList = [[CommodityGroupListDTO alloc]initWithDictionary:dataDict];

            //!判断是否有数据，没有数据就显示无数据的提示view
            
            if (![self showTipViewForAllMode:self.visibleGroupList.totalCount]) {//!不显示提示view 显示collectionView
                
                self.collectionView.hidden = NO;
                [self reload];
                
            }else{//!显示提示view
                
                self.collectionView.hidden = YES;
                
            }
            
            
        }];
        
        
    } else if (self.observe == CollectionViewObserveSingleMerchantGoods) {
        
        // !商家详情 ---商品列表
        [self getGoodsListWithPageNo:1 merchantNo:self.merchantDetail.merchantNo structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
            
            self.merchantDetail.blacklistFlag = dataDict[@"blacklistFlag"];
            self.merchantDetail.closeStartTime = dataDict[@"closeStartTime"];
            self.merchantDetail.closeEndTime = dataDict[@"closeEndTime"];
            self.merchantDetail.operateStatus = dataDict[@"operateStatus"];
            self.merchantDetail.merchantStatus = dataDict[@"merchantStatus"];
            
            if (![self showTipViewForSingleMerchantMode]) {
                
                self.allGroupList = [[CommodityGroupListDTO alloc]initWithDictionary:dataDict];
                
                // !判断商家的商品数量是否为0
                if (self.allGroupList.totalCount == 0) {
                    
                    if (self.specialTipView) {
                        [self.specialTipView removeFromSuperview];
                    }
                    // !添加 商家没有商品的提示view
                    self.specialTipView = [self instanceMerchantNoGoodsView];
                    [self.view addSubview:self.specialTipView];
                   
                    //!是进行筛选 结果没有商品的话，不更改状态
                    if (!self.structureNo) {
                        
                        // !状态为商家没有 商品
                        self.singleMerchantStatus = SingleMerchantStatusNoGoods;
                        
                    }
                   
                    
                } else {
                    
                    self.collectionView.hidden = NO;

                    [self reload];

                    
                }
                
                
            }else{
            
                self.collectionView.hidden = YES;
            
            }
            
            [self changeNav];

            
        }];
    }
    
}

#pragma mark !上拉加载
- (void)loadMoreGoodsList {
    
    // !商品--全部商品
    if (self.observe == CollectionViewObserveAllGoods) {
        // !已经加载 全部了
        if ([self.allGroupList isLoadedAll]) {
            
            
            return;
            
        }
        
        
        [self getGoodsListWithPageNo:[self.allGroupList nextPage] merchantNo:nil structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
        
            [self.allGroupList addCommoditiesFromDictionary:dataDict withByDaySave:YES];
            
            [self reload];

        }];
        
        
    } else if (self.observe == CollectionViewObserveVisibleGoods) {
        // !我的等级可看
        
        if ([self.visibleGroupList isLoadedAll]) {

            
            return;
        }

        [self getGoodsListWithPageNo:[self.visibleGroupList nextPage] merchantNo:nil structureNo:self.structureNo rangeFlag:@"1" complete:^(NSDictionary* dataDict) {
            
            [self.visibleGroupList addCommoditiesFromDictionary:dataDict withByDaySave:YES];

            
            [self reload];

            
        }];
      
     } else if (self.observe == CollectionViewObserveSingleMerchantGoods) {
      // !商家详情
         
         if ([self.allGroupList isLoadedAll]) {
             
            return;
        }

        [self getGoodsListWithPageNo:[self.allGroupList nextPage] merchantNo:self.merchantDetail.merchantNo structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
            
            self.merchantDetail.blacklistFlag = dataDict[@"blacklistFlag"];
            self.merchantDetail.closeStartTime = dataDict[@"closeStartTime"];
            self.merchantDetail.closeEndTime = dataDict[@"closeEndTime"];
            self.merchantDetail.operateStatus = dataDict[@"operateStatus"];
            self.merchantDetail.merchantStatus = dataDict[@"merchantStatus"];

            
            if (![self showTipViewForSingleMerchantMode]) {
                
                [self.allGroupList addCommoditiesFromDictionary:dataDict withByDaySave:YES];
                
                self.collectionView.hidden = NO;
                
                [self reload];

                
            }else{
            
                self.collectionView.hidden = YES;
                
                
            }
           
            [self changeNav];
            
            
        }];
         
    }
}
-(void)reload{

    //!添加事物，用于去除动画
    [CATransaction begin];
    
    [self.collectionView reloadData];
    
    
    [CATransaction commit];

}
//!如果点击进来的时候，商家状态有改变，则更改导航
-(void)changeNav{

    //!正常、无上架、歇业、黑名单--》关闭  关闭--》开启（不会有这种情况，如果原本是关闭则不会出现在列表里面）
    if (self.singleMerchantStatus == SingleMerchantStatusClose) {
        
        self.title = @"提示";
        [navImageView removeFromSuperview];
        [backBarBtn removeFromSuperview];
        [navCenterView removeFromSuperview];
        
        
    }else{//!正常、无上架、歇业、黑名单
    
        //!黑名单的时候没有 客服按钮 其他时候都有
        [self ServiceBtn];
        
    
    }
    

}

#pragma mark !请求数据  pageNo：页码  merchantNo：商家no  structureNo：分类no  rangeFlag:全部、可看
- (void)getGoodsListWithPageNo:(NSInteger)pageNo merchantNo:(NSString*)merchantNo structureNo:(NSString*)structureNo rangeFlag:(NSString*)rangeFlag complete:(void (^)(NSDictionary* dataDict))complete {
    
    /*
    [HttpManager sendHttpRequestForGetGoodsListWithPageNo:[NSNumber numberWithInteger:pageNo] pageSize:[NSNumber numberWithInteger:pageSize] merchantNo:merchantNo structureNo:structureNo rangeFlag:rangeFlag success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            complete(dataDict);
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"goodListError", @"查询商品列表失败") ,[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

        }
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        

        //!商家详情
        if (self.style == CSPGoodsViewStyleSingleMerchant && [self.allGroupList isLoadedAll]) {
            
            //!请求完毕，底部提示更改为已经到底了
            [self.refreshFooter noDataRefresh];

            
        }else{//!全部商品
         
            //!查看的是全部
            if (self.loadAll && [self.allGroupList isLoadedAll]) {
                
                //!请求完毕，底部提示更改为已经到底了
                [self.refreshFooter noDataRefresh];
                
            }else if (self.loadVisable && [self.visibleGroupList isLoadedAll]){
            
                //!请求完毕，底部提示更改为已经到底了
                [self.refreshFooter noDataRefresh];

            
            }
            
            
        }
        
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self.view makeMessage:NSLocalizedString(@"connectError", @"网络连接异常")  duration:2.0f position:@"center"];
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
    }];

     */
    
    
}

#pragma mark 商家信息view
- (CSPMerchantInfoPopView *)instanceMerchantInfoView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantInfoPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
    
}

- (void)navigationTitleItemClicked:(id)sender {
    
    // !中部的一级分类 开着就关，没有就收起来
    if (self.menu.isOpen)
        return [self.menu close];

    [self.menu showFromNavigationController:self.navigationController];
    
    // 显示 一级分类 则收起二三级分类
//    [self.categoryMenu dismissWithAnimation:YES];
    

    
    
}

- (void)categoryMenuItemClicked:(id)sender {
    
    if (self.categoryMenu.isOpen) {
    
        [self.categoryMenu dismissWithAnimation:YES];
    
    } else {
        
        [self.categoryMenu showInView:self.navigationController.view belowSubview:self.navigationController.navigationBar];
    }
    
    
}
//!一级分类将要出现的时候
-(void)willOpenMenu:(REMenu *)menu {
    
    //!隐藏二级分类
    [self closeCategoryMenu];
    
}
//!隐藏二级分类
-(void)closeCategoryMenu{

    if (self.categoryMenu.isOpen) {
        [self.categoryMenu dismissWithAnimation:YES];
    }

}
- (void)animateIndicator:(CAShapeLayer *)indicator Forward:(BOOL)forward complete:(void(^)())complete {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithControlPoints:0.4 :0.0 :0.2 :1.0]];

    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
    anim.values = forward ? @[ @0, @(M_PI) ] : @[ @(M_PI), @0 ];

    if (!anim.removedOnCompletion) {
        [indicator addAnimation:anim forKey:anim.keyPath];
    } else {
        [indicator addAnimation:anim forKey:anim.keyPath];
        [indicator setValue:anim.values.lastObject forKeyPath:anim.keyPath];
    }

    [CATransaction commit];

    complete();
}

#pragma mark - Setter and Getter  商家状态的提示view

- (CSPMerchantClosedView *)instanceMerchantClosedView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantClosedView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
// !黑名单状态的view
- (CSPMerchantBlackListView*)instanceMerchantBlackListView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantBlackListView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
// !歇业状态的view
- (CSPMerchantOutOfBusinessView*)instanceMerchantOutOfBusinessView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantOutOfBusinessView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
//!没有商品的view
- (CSPMerchantNoGoodsView*)instanceMerchantNoGoodsView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantNoGoodsView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


-(AllListNoGoodsView *)instanceAllNoGoodsView{

    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AllListNoGoodsView" owner:nil options:nil];
    
    AllListNoGoodsView * noGoodsView = [nibView objectAtIndex:0];
    
    
    return noGoodsView;
    
}

#pragma mark -
#pragma mark CSPMerchantClosedViewDelegate
- (void)reviewGoodsList {
    //切换到tabBar的第二个viewcontroller
    [self.rdv_tabBarController setSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}
- (void)reviewMerchantList {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark CSPAuthorityPopViewDelegate

- (void)showLevelRules {
  
    
    
    
    
    MembershipGradeRulesViewController *membershipGradeRulesVC = [[MembershipGradeRulesViewController alloc]init];
//    membershipGradeRulesVC.delegate = self;
    
    [self.navigationController pushViewController:membershipGradeRulesVC animated:YES];
   
    
//    [self performSegueWithIdentifier:@"toMemberVip" sender:self];

}

//-(void)

- (void)prepareToUpgradeUserLevel {
    
    MembershipUpgradeViewController *membershipUpgradeVC = [[MembershipUpgradeViewController alloc]init];
    membershipUpgradeVC.delegate = self;
    [self.navigationController pushViewController:membershipUpgradeVC animated:YES];

//    [self performSegueWithIdentifier:@"toVipUpgrade" sender:self];
}


-(void)returnsListOfGoods
{

    [self.navigationController popViewControllerAnimated:YES];

}



-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{
    CSPPayAvailabelViewController *payAvailabelViewC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    
    //status true表示成功，false表示失败
    
    payAvailabelViewC.payStatus = ^(BOOL status)
    
    {
        DebugLog(@"%d", status);
        
    };
    

    payAvailabelViewC.dic = dic;
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
}

#pragma mark -
#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 50) {
        [self.backTopButton setHidden:NO];
    } else {
        [self.backTopButton setHidden:YES];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.backTopButton setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
