//
//  CSPGoodsViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPGoodsListViewController.h"
#import "CSPGoodsCollectionViewCell.h"
#import "SMSegmentView.h"
#import "CommodityGroupListDTO.h"
#import "CSPMerchantInfoPopView.h"
#import "CSPMerchantNoGoodsView.h"
#import "CSPMerchantOutOfBusinessView.h"
#import "CPSGoodsDetailsPreviewViewController.h"
#import "GetGoodsCategoryListDTO.h"
#import "GoodsCategoryDTO.h"
#import "ACMacros.h"
#import "GoodsCategoryMenuView.h"
#import "SDRefresh.h"
#import "CPSPostageViewController.h"// !邮费专拍
#import "MerchantDeatilNavView.h"//!导航

//#import "CSPPostageViewController.h"

typedef void(^DidFinishedBlock)();


@interface CSPGoodsListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, CategoryMenuClick> {
    
    //!导航部分
    MerchantDeatilNavView *navView;

    GoodsCategoryMenuView * categoryMenuView;
    UIButton *backTopButton;// !返回顶部按钮
    
}


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UILabel *noticeView;



@property (nonatomic, strong) CommodityGroupListDTO* allGroupList;

@property (strong, nonatomic) UIButton* titleButton;
@property (weak, nonatomic) UIView* specialTipView;
@property (strong, nonatomic) NSMutableArray * menuArray;

@property (nonatomic, strong) NSString* structureNo;

@property (nonatomic, weak) SDRefreshHeaderView * refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView * refreshFooter;

@end

@implementation CSPGoodsListViewController

static NSString * const reuseIdentifier = @"goodsCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建导航
    [self cretaeNav];
    
    // !返回顶部按钮
    backTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backTopButton.frame = CGRectMake(SCREEN_WIDTH - 40, self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 45, 30, 30);
    
    [backTopButton setBackgroundImage:[UIImage imageNamed:@"03_商家商品列表_返回顶部"] forState:UIControlStateNormal];
    [backTopButton addTarget:self action:@selector(backTopBtnClick) forControlEvents:UIControlEventTouchUpInside];
    backTopButton.hidden = YES;
    [self.view addSubview:backTopButton];
    
    // !请求
    SDRefreshHeaderView* refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.collectionView];
    
    self.refreshHeader = refreshHeader;
    
    __weak CSPGoodsListViewController * weakSelf = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadNewGoodsList];
    };
    
    SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.collectionView];
    
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf loadMoreGoodsList];
    };
    
    self.collectionView.alwaysBounceVertical = YES;
    
    self.collectionView.delegate = self;
    
    self.collectionView.dataSource = self;
    
}


#pragma mark 创建导航
-(void)cretaeNav{

    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    //!注意 ：商家关闭的时候这个导航不是这样显示
    navView = [[[NSBundle mainBundle]loadNibNamed:@"MerchantDeatilNavView" owner:nil options:nil]lastObject];
    navView.frame = CGRectMake(0, 0, self.view.frame.size.width, navView.frame.size.height);
    navView.merchantNameLabel.text = getMerchantInfoDTO.merchantName;
    [navView.showImgeView sd_setImageWithURL:[NSURL URLWithString:getMerchantInfoDTO.pictureUrl]];
    [self.view addSubview:navView];
    
    
    //!去除系统自带的返回按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 0, 0);
    [leftBtn setTitle:@"" forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    __weak CSPGoodsListViewController *vc = self;

    navView.backBlock = ^(){//!返回按钮
        
        [vc.navigationController popViewControllerAnimated:YES];
        
    };
    
    //!商家介绍
    navView.merchantIntroduceBlock = ^(){
        
        CSPMerchantInfoPopView* popView = [vc instanceMerchantInfoView];
        popView.frame = vc.view.bounds;
        
        [HttpManager sendHttpRequestForGetMerchantInfo:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                NSDictionary* dataDict = [dic objectForKey:@"data"];
                [popView setupWithDictionary:dataDict];
                [vc.view addSubview:popView];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];

        
    };

    //!商品分类
    navView.merchantCategoryBlock = ^(){
        
        if (self.allGroupList.totalCount<=1&&self.structureNo==nil) {
            return;
        }
        
        if (categoryMenuView == nil) {
            categoryMenuView = [[GoodsCategoryMenuView alloc] initWithArray:vc.menuArray withParentView:navView];
            categoryMenuView.delegate = vc;
            [self.view addSubview:categoryMenuView];
            [categoryMenuView showOrHidden];
        }else {
            [categoryMenuView showOrHidden];
        }
        
    };

    //!邮费专拍
    navView.postageBlock = ^(){
        
        if (self.allGroupList.totalCount<=1&&self.structureNo==nil) {
            return;
        }
        
        
        CPSPostageViewController *postageInfo = [[CPSPostageViewController alloc]init];
        
        [vc.navigationController pushViewController:postageInfo animated:YES];
        

        
    };

    

}
#pragma mark 返回顶部按钮的事件
-(void)backTopBtnClick{

    [self.collectionView setContentOffset:CGPointZero animated:YES];


}
#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 20) {
        
        [backTopButton setHidden:NO];
        
    } else {
        
        [backTopButton setHidden:YES];
    }
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [backTopButton setHidden:YES];

}

- (void)viewWillAppear:(BOOL)animated{
    
    [self tabbarHidden:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    //初始化menu菜单
    self.menuArray = [[NSMutableArray alloc] init];
    //获取menu菜单
    [self queryMenu];
    
    [self loadNewGoodsList];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
    
}

- (BOOL)showTipViewForAbnormalMode {

    if (!self.allGroupList) {
        return NO;
    }

    if ([self.allGroupList.operateStatus isEqualToString:@"1"]) {
        if (self.specialTipView) {
            [self.specialTipView removeFromSuperview];
        }
        CSPMerchantOutOfBusinessView* outOfBusinessView = [self instanceMerchantOutOfBusinessView];
        [outOfBusinessView setupWithCloseStartTime:self.allGroupList.closeStartTime andCloseEndTime:self.allGroupList.closeEndTime];
        self.specialTipView = outOfBusinessView;
        [self.view addSubview:self.specialTipView];
        return YES;
    }
    
    if (self.allGroupList.groupList.count == 0) {
        
        if (self.specialTipView) {
            [self.specialTipView removeFromSuperview];
        }
        
        self.specialTipView = [self instanceMerchantNoGoodsView];
        [self.view addSubview:self.specialTipView];
        
        return YES;
    }

    return NO;
}



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    self.specialTipView.frame = CGRectMake(0, CGRectGetMaxY(navView.frame), self.view.frame.size.width, self.collectionView.frame.size.height);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    // goodsType 0普通  1邮费
    if (indexPath.row == 0 ) {
        
        if ([cell.commodityInfo.goodsType isEqualToString:@"1"]) {
            
            [cell.cornerView setHidden:YES];

        }else{// !普通
        
            [cell.cornerView setHidden:NO];

        }
    
    } else {
    
        [cell.cornerView setHidden:YES];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Commodity* commodityInfo = [self commodityForRowAtIndexPath:indexPath];

    // 0:普通  1：邮费
    if ([commodityInfo.goodsType isEqualToString:@"1"]) {
        
        CPSPostageViewController *postageInfo = [[CPSPostageViewController alloc]init];
        
        [self.navigationController pushViewController:postageInfo animated:YES];
        
        
    }else{
    
        CPSGoodsDetailsPreviewViewController *goodsInfo = [[CPSGoodsDetailsPreviewViewController alloc]init];
        
        goodsInfo.goodsNo = commodityInfo.goodsNo;
        
        goodsInfo.isFromConversation = YES;
        
        if (commodityInfo) {
            [self.navigationController pushViewController:goodsInfo animated:YES];
        }
        
    }
    
   
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGFloat width = (CGRectGetWidth(collectionView.frame) - 20) / 2 ;
    
    return CGSizeMake(width, 65 + width);
    

}

#pragma mark -
#pragma mark getMenuNetwork
- (void) queryMenu {
    
    [HttpManager sendHttpRequestForGetGoodsCategoryList:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            GetGoodsCategoryListDTO *getGoodsCategoryListDTO = [[GetGoodsCategoryListDTO alloc] init];
            getGoodsCategoryListDTO.goodsCategoryDTOList = [dic objectForKey:@"data"];
            
            for( int index = 0; index < getGoodsCategoryListDTO.goodsCategoryDTOList.count; index ++){
                
                NSDictionary *Dictionary = [getGoodsCategoryListDTO.goodsCategoryDTOList objectAtIndex:index];
                GoodsCategoryDTO *goodsCategoryDTO = [[GoodsCategoryDTO alloc] init];
                [goodsCategoryDTO setDictFrom:Dictionary];
                [self.menuArray addObject:goodsCategoryDTO];
                
            }

        }else{
            

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark menuClick delegate
- (void)menuClick:(NSString *)searchId {
    self.structureNo = searchId;

    [self loadNewGoodsList];



}

#pragma mark -
#pragma mark Private Methods

- (CommodityGroupListDTO*)commodityGroupListForCurrentObserver {
    
    CommodityGroupListDTO* currentCommodityGroupList = self.allGroupList;

    return currentCommodityGroupList;
}

- (CommodityGroup*)commodityGroupForSection:(NSInteger)section {
    
    
    CommodityGroupListDTO* currentCommodityGroupList = [self commodityGroupListForCurrentObserver];
    
    if (section < currentCommodityGroupList.groupList.count) {
        
        return currentCommodityGroupList.groupList[section];
    }

    return nil;
    
    
}

- (Commodity*)commodityForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    CommodityGroup* commodityGroup = [self commodityGroupForSection:indexPath.section];
    
    if (commodityGroup && commodityGroup.commodityList.count > indexPath.row) {
    
        return commodityGroup.commodityList[indexPath.row];
    
    }
    return nil;
    
    
}


- (void)getGoodsListWithPageNo:(NSInteger)pageNo structureNo:(NSString*)structureNo rangeFlag:(NSString*)rangeFlag complete:(void (^)(NSDictionary* dataDict))complete {
   
    
    [HttpManager sendHttpRequestForGetShopGoodsList:[NSNumber numberWithInteger:pageNo] pageSize:[NSNumber numberWithInteger:customPageSize] structureNo:structureNo queryTime:@"" goodsType:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
           
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            complete(dataDict);
            
        }

        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        //!看如果到底了，就修改底部提示文字
        if ([self.allGroupList isLoadedAll]) {
            
            [self.refreshFooter noDataRefresh];
            
        }
        

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];

    }];
    
    

}

- (void)loadNewGoodsList {
    
    [self getGoodsListWithPageNo:1 structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
        
        
        self.allGroupList = [[CommodityGroupListDTO alloc]initWithDictionary:dataDict];

        if (self.allGroupList.totalCount<=1&&self.structureNo==nil){
            
            self.collectionView.hidden = YES;
            [self showTipViewForAbnormalMode];
            
        }else if(self.allGroupList.totalCount==0&&self.structureNo){
            
            self.collectionView.hidden = YES;
            
        }else{
            
            self.collectionView.hidden = NO;
        }
        
        [CATransaction begin];
        
        [self.collectionView reloadData];
        
        [CATransaction commit];
        
        
    }];}

- (void)loadMoreGoodsList {
    
    //!加载到最底部了，就不刷新了
    if ([self.allGroupList isLoadedAll]) {
        
        [self.refreshFooter noDataRefresh];

        return;
    
    }

    [self getGoodsListWithPageNo:[self.allGroupList nextPage] structureNo:self.structureNo rangeFlag:nil complete:^(NSDictionary* dataDict) {
        
        [self.allGroupList addCommoditiesFromDictionary:dataDict];
        
        [CATransaction begin];
        
        [self.collectionView reloadData];
        
        [CATransaction commit];
        
        
        
    }];
    
    
}

- (CSPMerchantInfoPopView *)instanceMerchantInfoView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantInfoPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


#pragma mark - Setter and Getter


- (CSPMerchantOutOfBusinessView*)instanceMerchantOutOfBusinessView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantOutOfBusinessView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (CSPMerchantNoGoodsView*)instanceMerchantNoGoodsView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantNoGoodsView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}


/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }

 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }

 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
