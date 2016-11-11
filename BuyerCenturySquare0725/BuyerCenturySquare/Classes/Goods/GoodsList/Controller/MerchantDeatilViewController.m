//
//  MerchantDeatilViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MerchantDeatilViewController.h"
#import "MerchantDeatilNavView.h"//!自定义导航
#import "GoodsListView.h"//!collectionView部分
#import "CSPMerchantClosedView.h"//!商家关闭的view
#import "CSPMerchantBlackListView.h"// !黑名单状态的view
#import "CSPMerchantOutOfBusinessView.h"// !歇业状态的view
#import "CSPMerchantNoGoodsView.h"//!没有商品的view
#import "CSPMerchantInfoPopView.h"//!商家信息
#import "CSPAuthorityPopView.h"//!查看商品权限不足提示view
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ConversationWindowViewController.h"///!聊天界面
#import "CSPPostageViewController.h"//!邮费专拍
#import "GoodsInfoDTO.h"
#import "GoodDetailViewController.h"//!商品详情
#import "GoodsNotLevelTipDTO.h"//!商品查看权限dto
#import "PrepaiduUpgradeViewController.h"//!等级规则
#import "CCWebViewController.h"//!立即升级
#import "GetCategoryDTO.h"//!商品分类
#import "GoodsCategoryMenuView.h"//!商品分类的view
#import "MerchantShopDetailDTO.h"//!商家详情

#import "GUAAlertView.h"
#import "FilterView.h"

@interface MerchantDeatilViewController ()<CSPMerchantClosedViewDelegate,CSPAuthorityPopViewDelegate,CategoryMenuClick>{
    
    //!导航部分
    MerchantDeatilNavView *navView;
    
    GoodsListView *goodsListView;//!商品列表
    
    UIView *tipShowView;//!商家状态提示框
    
    GoodsCategoryMenuView *categoryMenuView;//!商品分类的view
    
    MerchantShopDetailDTO *shopDetailDTO;//!商家详情
    
    NSString *merchantName;//!商家名称
    
    NSString * structNo;//!筛选的类型，记录下来，只是为了筛选没有商品之后还能点击分类按钮
    
    
    
}
@property(nonatomic,strong)NSMutableArray *menuArray;//!商家分类

@property(nonatomic,copy)NSString *collectStatus;//! 0:收藏 1:取消收藏

//!筛选的界面
@property(nonatomic,strong)FilterView * filterView;
@property(nonatomic,strong)UIView * filterAlphaView;


@end

@implementation MerchantDeatilViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建界面
    [self createUI];
    
    //!请求商家详情
    [self requestMerchantInfo];
    
     //!商家的商品类别
    [self requestGoodsCategory];
    
    
    
    
    
    
}
#pragma mark 创建界面
-(void)createUI{

    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //!创建导航部分
    [self createNav];
    
    //!创建collectionview
    [self createCollectionView];
    
}

#pragma mark 创建导航部分
-(void)createNav{

    //!正常状态
    
    //!注意 ：商家关闭的时候这个导航不是这样显示
    navView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantDeatilNavView" owner:nil options:nil]lastObject];
    navView.frame = CGRectMake(0, 0, self.view.frame.size.width, navView.frame.size.height);
    navView.merchantNameLabel.text = @"";//!商家名称 先为空，请求回来以后再显示全

    [self.view addSubview:navView];
    
    //!去除系统自带的返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 0, 0);
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    
    __weak MerchantDeatilViewController *vc = self;
    navView.backBlock = ^(){//!返回按钮
    
       
        [vc.navigationController popViewControllerAnimated:YES];
        
    
    };
    //!客服按钮
    navView.serviceBtnBlock = ^(){
    
        [vc serviceBtnClick];
        
    };
    
    //!商家介绍
    navView.merchantIntroduceBlock = ^(){
    
        [vc showMerchantInfoView];
        
    };
    
    //!商品分类
    navView.merchantCategoryBlock = ^(){
    
        if (categoryMenuView == nil && self.menuArray) {
            
            categoryMenuView = [[GoodsCategoryMenuView alloc] initWithArray:self.menuArray withParentView:navView];
            
            categoryMenuView.delegate = vc;
            [self.view addSubview:categoryMenuView];
            [categoryMenuView showOrHidden];
            
        }else {
            
            [categoryMenuView showOrHidden];
        }
        
        [self.view bringSubviewToFront:categoryMenuView];

    
    };
    
    //!邮费专拍
    navView.postageBlock = ^(){
    
        // !邮费专拍
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

        CSPPostageViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        destViewController.merchantNo = vc.merchantNo;
        [vc.navigationController pushViewController:destViewController animated:YES];
        
    
    };
    
    //!收藏
    navView.collectBtnBlock = ^(){
    
        navView.collectBtn.enabled = NO;
        
        //!如果是选中状态，就取消收藏
        if (navView.collectBtn.selected) {
            
            [vc delMerchantFavoriteRequest];
            
            
        }else{//!不是选中状态，收藏
            
            
            [vc addMerchantFavoriteRequest];
        
        }
        
    
    };
    
    
    
    


}
//!客服按钮
-(void)serviceBtnClick{

    //!防止请求过程中点击多次
    navView.serviceBtn.enabled = NO;
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:self.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        navView.serviceBtn.enabled = YES;
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString *jId = [dic objectForKey:@"data"];
            NSString* jId = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

//
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantName jid:jId withMerchantNo:self.merchantNo];
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;
            
            conversationVC.timeStart = nil;
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        } else {
            
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        navView.serviceBtn.enabled = YES;
        
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];


}

//!商家分类
-(void)menuClick:(NSString *)searchId{

    structNo =searchId;//!记录下来
    [goodsListView filterWithStructNo:searchId];
    

}
#pragma mark 创建collectionView
-(void)createCollectionView{

    //!离上面 都有7px的距离
    CGFloat showY = CGRectGetMaxY(navView.frame);//!自定义导航的高度，collectionview显示的Y
    
    CGFloat showHight = self.view.frame.size.height - showY ;

    goodsListView = [[GoodsListView alloc]initWithFrame:CGRectMake(0, showY, self.view.frame.size.width , showHight) withMerchantNo:self.merchantNo withStructNo:nil withRangFlag:nil];
    
    [self.view addSubview:goodsListView];
    

    
    __weak MerchantDeatilViewController *vc = self;
    //!每次刷新完都会掉这里  显示商家各个状态对应的view
    goodsListView.merchantShowViewBlock = ^(MerchantListDetailsDTO* merchantDetail,NSInteger totalCount){
    
        [vc showMerchantTipView:merchantDetail withTotalCount:totalCount];
        
      
    };

    //!collectionviewcell 点击事件
    goodsListView.selectBlock = ^(Commodity * goodsCommodity){
    
        [vc cellSelect:goodsCommodity];
    
    };
    
    

}

//!显示商家各个状态对应的view
-(void)showMerchantTipView:(MerchantListDetailsDTO *)merchantDetail withTotalCount:(NSInteger)totalCount{
    
    navView.hidden = NO;
   // self.navigationController.navigationBar.hidden = YES;
    
    if (tipShowView) {
        
        [tipShowView removeFromSuperview];
    }
    
    //!商家状态：正常、无上架商品、歇业、黑名单无权限查看、关闭
    if ([merchantDetail.merchantStatus isEqualToString:@"1"]){//!关闭
        
        self.navigationController.navigationBar.hidden = NO;
        navView.hidden = YES;
        
        //!商家关闭状态
        self.title = @"提示";
        [self addCustombackButtonItem];//!返回按钮
        
        CSPMerchantClosedView * closeView = [self instanceMerchantClosedView];
        closeView.delegate = self;
        tipShowView = closeView;
        
        tipShowView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height -20);
        [self.view addSubview:tipShowView];
        
        
    }else if ([merchantDetail.blacklistFlag isEqualToString:@"1"]) {//!黑名单
        
        //!商家介绍、商品分类、邮费专拍点击无效 无客服按钮
        navView.merchantIntroduceBtn.enabled = NO;
        navView.merchantCategoryBtn.enabled = NO;
        navView.postageBtn.enabled = NO;
        
        navView.serviceBtn.hidden = YES;
        navView.collectBtn.hidden = YES;//!收藏按钮去除
        
        tipShowView = [self instanceMerchantBlackListView];
        
        tipShowView.frame = CGRectMake(0, CGRectGetMaxY(navView.frame)-35, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(navView.frame) +35);
        
        [self.view addSubview:tipShowView];
        

        
    }else if([merchantDetail.operateStatus isEqualToString:@"1"]){//!歇业
        
        
        //!商品分类、邮费专拍点击无效
        navView.merchantCategoryBtn.enabled = NO;
        navView.postageBtn.enabled = NO;
        
        CSPMerchantOutOfBusinessView* outOfBusinessView = [self instanceMerchantOutOfBusinessView];
        // !设置歇业时间
        [outOfBusinessView setupWithMerchantDetail:merchantDetail];
        
        tipShowView = outOfBusinessView;
        
        
        tipShowView.frame = CGRectMake(0, CGRectGetMaxY(navView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(navView.frame) );
        
        [self.view addSubview:tipShowView];
        

        
    }else if (!totalCount){//!无上架商品
        
        if (!structNo) {//!如果是从不是筛选过来的，就做限制
        
            //!商品分类、邮费专拍点击无效
            navView.merchantCategoryBtn.enabled = NO;
            navView.postageBtn.enabled = NO;
        }
    
        
        tipShowView = [self instanceMerchantNoGoodsView];
        
        tipShowView.frame = CGRectMake(0, CGRectGetMaxY(navView.frame) + 15 + 25 +14, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(navView.frame) - 15 -25 -14);//!15，sortview距离上面的距离，25：sortview的高度，14:sortview距离collectionview的距离
        
        [self.view addSubview:tipShowView];
        
        
    }
    
    
}

//!collectionviewcell 点击事件
-(void)cellSelect:(Commodity *)goodsCommodity{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    // !点击的是 邮费专拍
    if ([goodsCommodity.goodsType isEqualToString:@"1"]) {
        CSPPostageViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        
        destViewController.merchantNo = self.merchantNo;
        
        [self.navigationController pushViewController:destViewController animated:YES];
        
        
    } else {
        
        /*
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

#pragma mark - Setter and Getter  商家状态的提示view
//!商家关闭
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
#pragma mark 查看商品详情权限不足的提示view
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


#pragma mark 商家信息的view
- (CSPMerchantInfoPopView *)instanceMerchantInfoView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantInfoPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
    
    
}
//! 商家关闭view的代理方法
-(void)reviewGoodsList{

    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RDVTabBarController *totalTabBarController = (RDVTabBarController *)[AppDelegate currentAppDelegate].viewController;
    
    totalTabBarController.selectedIndex = 1;
    
    
}

-(void)reviewMerchantList{

    //!不能只是pop到root，不然“我的收藏”里面商家关闭无法调到全部商品
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RDVTabBarController *totalTabBarController = (RDVTabBarController *)[AppDelegate currentAppDelegate].viewController;
    
    totalTabBarController.selectedIndex = 0;
    

//    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark 请求商家详情
//!显示商家信息view
-(void)showMerchantInfoView{
    
    // !商家信息 view
    CSPMerchantInfoPopView* popView = [self instanceMerchantInfoView];
    popView.frame = self.view.bounds;
    [popView setupWithShopDto:shopDetailDTO];
    [self.view addSubview:popView];

    
}
-(void)requestMerchantInfo{

    __weak MerchantDeatilViewController * vc = self;
    
    navView.serviceBtn.hidden = YES;//!防止数据还没有回来就进入聊天界面，导致聊天数据显示不全
    
    [HttpManager sendHttpRequestForGetMerchantShopDetailWithMerchantNo:self.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            // !给商家信息view 赋值
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            shopDetailDTO = [[MerchantShopDetailDTO alloc]initWithDictionary:dataDict];
            
            navView.merchantNameLabel.text = shopDetailDTO.merchantName;//!商家名称 先为空，请求回来以后再显示全
            [navView.showImgeView sd_setImageWithURL:[NSURL URLWithString:shopDetailDTO.pictureUrl] placeholderImage:nil];
            merchantName = shopDetailDTO.merchantName;//!记录下来，聊天的时候传到下一个界面
            
            navView.serviceBtn.hidden = NO;//!数据请求回来，显示客服按钮

            //!判断商家是否被收藏
            if ([shopDetailDTO.isFavorite isEqualToString:@"0"]) {//!收藏
                
                navView.collectBtn.selected = YES;
                vc.collectStatus = @"0";
                
            }else{//!没有收藏
            
                navView.collectBtn.selected = NO;
                vc.collectStatus = @"1";

            }
            
            
        } else {
            
            
            [self.view makeMessage:[NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"merchantError", @"获取商家详情失败"),[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
        }
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];


}
#pragma mark 请求商家商品分类
-(void)requestGoodsCategory{

    [HttpManager sendHttpRequestForGetCategoryListWithMerchantNo:self.merchantNo withQueryType:@"1" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        self.menuArray = [NSMutableArray arrayWithCapacity:0];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            for (NSDictionary * categoryDic in dic[@"data"]) {
                
                GetCategoryDTO *goodsCategoryDTO = [[GetCategoryDTO alloc] init];
                [goodsCategoryDTO setDictFrom:categoryDic];
                [self.menuArray addObject:goodsCategoryDTO];

            }
            
        }else{
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询商品分类失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    


}
#pragma mark 商家收藏接口
-(void)addMerchantFavoriteRequest{

    __weak MerchantDeatilViewController * vc = self;
    
    [HttpManager sendHttpRequestForAddMerchantFavorite:self.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {//!收藏成功
            
            navView.collectBtn.selected = YES;
            vc.collectStatus = @"0";
            
            [vc postToChangeStatus];
            
            [self.view makeMessage:@"收藏成功" duration:1.0 position:@"center"];

        }else{
        
            [self.view makeMessage:dic[@"errorMessage"] duration:1.0 position:@"center"];
        
        }
        navView.collectBtn.enabled = YES;

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:1.0 position:@"center"];
        
        navView.collectBtn.enabled = YES;

    }];



}
-(void)delMerchantFavoriteRequest{

    __weak MerchantDeatilViewController * vc = self;

    [HttpManager sendHttpRequestForDelMerchantFavorite:self.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!取消收藏成功
            
            navView.collectBtn.selected = NO;
            vc.collectStatus = @"1";
            
            [vc postToChangeStatus];
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:1.0 position:@"center"];
            
        }
        navView.collectBtn.enabled = YES;
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:1.0 position:@"center"];

        navView.collectBtn.enabled = YES;

    }];
   
    
}
//!发送通知给商品列表，修改商家列表 cell的收藏状态
-(void)postToChangeStatus{

    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHANGECOLLECTSTATUS" object:self userInfo:@{@"merchantNo":self.merchantNo,@"collectStatus":self.collectStatus}];
    
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //!界面显示的时候隐藏导航
    self.navigationController.navigationBar.hidden = YES;
    
    //!此界面不隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

    //!添加观察
    [self addAllNotification];
    
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewDidDisappear:animated];
    
    //!界面消失的时候恢复显示导航
    self.navigationController.navigationBar.hidden = NO;
    
    //!移除所有的观察
    [self removeAllNotification];

    //!移除筛选的view
    [self removeFilterView];
    
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
    __weak MerchantDeatilViewController * merchantDetailVC = self;
    
    self.filterView.sureToSortBlock = ^(NSDictionary * upSortDic){
        
        //!先隐藏
        [merchantDetailVC filterAlphaTapClick];
        
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
