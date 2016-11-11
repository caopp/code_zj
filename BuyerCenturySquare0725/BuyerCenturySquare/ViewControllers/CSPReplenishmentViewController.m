//
//  CSPReplenishmentViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPReplenishmentViewController.h"
#import "SMSegmentView.h"
#import "CSPReplenishmentInfoTableViewCell.h"
#import "CSPReplenishmentSectionHeaderView.h"
#import "RestockedDTO.h"
#import "ReplenishmentByTimeDTO.h"
#import "SkuListDTO.h"
#import "CSPAmountControlView.h"
#import "ReplenishmentByMerchantDTO.h"
#import "CartAddDTO.h"
#import "ConversationWindowViewController.h"
#import "MerchantDeatilViewController.h"//!商家详情
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"
#import "BadgeImageView.h"
#import "CartListDTO.h"
#import "CSPShoppingCartViewController.h"
#import "GoodsInfoDTO.h"
#import "GoodDetailViewController.h"

typedef NS_ENUM(NSUInteger, ReplenishmentListStyle) {
    ReplenishmentListStyleOrderByTime,
    ReplenishmentListStyleOrderByMerchant,
};

@interface CSPReplenishmentViewController () <SMSegmentViewDelegate, CSPReplenishmentInfoTableViewCellDelegate, CSPReplenishmentSectionHeaderViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{

    //!底部sc
    UIScrollView * bgSC;
    //!按时间排序的tableview
    UITableView * byTimeTableView;
    //!按商家排序的tableview
    UITableView * byMerchantTableView;
    
   //!从sc过来的
    BOOL isFromSc;
    
    //!判断是否在请求 按商家排序的列表，如果是就不进行请求
    BOOL merchantIsLoad;
    

}
@property (weak, nonatomic) IBOutlet SMSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *invalidWarningView;
@property (weak, nonatomic) IBOutlet BadgeImageView *cartImageView;
@property (weak, nonatomic) IBOutlet UIButton *AddCartButton;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *goShopCarListImageView;

@property (nonatomic, strong) ReplenishmentByTimeDTO* replenishmentGoodsList;
@property (nonatomic, strong) ReplenishmentByMerchantDTO* replenishmentMerchantList;

@property (nonatomic, assign)ReplenishmentListStyle style;

@property (nonatomic, assign)BOOL keyboardShown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintToAdjust;

@property (nonatomic, weak) SDRefreshHeaderView *byTimeRefreshHeader;
@property (nonatomic, weak) SDRefreshHeaderView *byMerchantRefreshHeader;



@end

@implementation CSPReplenishmentViewController

static NSString *SectionHeaderViewIdentifier = @"ReplenishmentSectionHeaderViewIdentifier";

static NSString* reuseCellIdentifier = @"replenishmentInfoCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建界面
    [self createUI];
    
    //!创建导航
    [self createNav];
    
    
    [self.invalidWarningView setHidden:YES];
    [self.view bringSubviewToFront:self.bottomView];
    
    //!给购物车添加手势
    UITapGestureRecognizer* gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cartImageViewClicked)];
    gestureRecognizer.numberOfTapsRequired = 1;
    gestureRecognizer.numberOfTouchesRequired = 1;
    [self.goShopCarListImageView addGestureRecognizer:gestureRecognizer];
    self.goShopCarListImageView.userInteractionEnabled = YES;
    
    //!header
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ReplenishmentSectionHeaderView" bundle:nil];
    [byMerchantTableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    
    //!创建刷新
    [self addRefresh];

    //!查询所有数据
//    [self loadNewGoodsList];
    
//    [self.byMerchantRefreshHeader beginRefreshing];
    
    //!先调用 按时间排序的，侧滑到按商家排序的，判断没有数据的时候再进行请求
    [self.byTimeRefreshHeader beginRefreshing];

    //!查询采购车信息
    [self updateCartAmount];
    
    //!设置 “按时间”可以返回顶部
    [self setSCAndTableViewCanScrollerToTop:YES];

    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
   
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
#pragma mark 创建导航
-(void)createNav{

    
    self.title = @"补货商品列表";

    [self addCustombackButtonItem];

    self.segmentView.delegate = self;
    [self.segmentView addSegmentWithTitle:@"按时间"];
    [self.segmentView addSegmentWithTitle:@"按商家"];

    [self.segmentView selectSegmentAtIndex:0];
    [self.view sendSubviewToBack:self.segmentView];
    
    
    
}
#pragma mark 创建界面
-(void)createUI{


    //!sc

    bgSC = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0 , self.view.frame.size.width, self.bgView.frame.size.height)];
    
    bgSC.showsHorizontalScrollIndicator = NO;
    bgSC.backgroundColor = [UIColor yellowColor];
    
    bgSC.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.bgView.frame.size.height);
    
    bgSC.pagingEnabled = YES;
    bgSC.delegate = self;
    [self.bgView addSubview:bgSC];
    
    CGFloat hight = SCREEN_HEIGHT - 30 - 50 - 64;
    
    //!按时间排序
    byTimeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, hight) style:UITableViewStylePlain];
    byTimeTableView.delegate = self;
    byTimeTableView.dataSource = self;
    byTimeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [bgSC addSubview:byTimeTableView];
    
    
    //!按商家排序
    byMerchantTableView = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(byTimeTableView.frame), 0, self.view.frame.size.width,  hight) style:UITableViewStyleGrouped];
    byMerchantTableView.delegate = self;
    byMerchantTableView.dataSource = self;
    byMerchantTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [bgSC addSubview:byMerchantTableView];
    
    

}
-(void)addRefresh{

    //!按时间排序
    SDRefreshHeaderView *byTimeRefreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [byTimeRefreshHeader addToScrollView:byTimeTableView];
    
    self.byTimeRefreshHeader = byTimeRefreshHeader;
    
    __weak CSPReplenishmentViewController * weakSelf = self;
    byTimeRefreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadByTimeNewGoodsList];
    };

    //!按商家排序
    SDRefreshHeaderView *byMerchantRefreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [byMerchantRefreshHeader addToScrollView:byMerchantTableView];
    
    self.byMerchantRefreshHeader = byMerchantRefreshHeader;
    
    byMerchantRefreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadByMerchatNewGoodsList];
    };
    
    



}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (tableView == byTimeTableView) {
        
        return self.replenishmentGoodsList.goodsList.count;

    }else{
        
        ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[section];
        return merchant.goodsList.count;
    
    }
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    return tableView == byTimeTableView ? 1 : self.replenishmentMerchantList.merchantList.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"CSPReplenishmentInfoTableViewCellId";

    CSPReplenishmentInfoTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        
      cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPReplenishmentInfoTableViewCell" owner:nil options:nil]lastObject];

    }
    
    if (cell) {
        
        if (tableView == byTimeTableView) {
            
            [cell setupWithTimeOrderForReplenishmentInfo:self.replenishmentGoodsList.goodsList[indexPath.row]];
            
        } else if (tableView == byMerchantTableView) {
            
            ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[indexPath.section];
            [cell setupWithMerchantOrderForReplenishmentInfo:merchant.goodsList[indexPath.row]];
            
        }
        
        
        cell.delegate = self;
        
    }
   
    
    return cell;
    
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    
    if (tableView == byMerchantTableView) {
        
        
        CSPReplenishmentSectionHeaderView * headerView = [[[NSBundle mainBundle]loadNibNamed:@"ReplenishmentSectionHeaderView" owner:nil options:nil]lastObject];
        
        
        ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[section];
        merchant.headerView = headerView;
        
        headerView.merchantInfo = merchant;
        headerView.index = section;
        headerView.delegate = self;
        
        return headerView;
    } else {
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
    return tableView == byTimeTableView ? 1 : [CSPReplenishmentSectionHeaderView sectionHeaderHeight];

    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == byTimeTableView) {
        
        ReplenishmentGoods* goods = self.replenishmentGoodsList.goodsList[indexPath.row];
        NSArray* skuList = goods.skuList;
        NSInteger skuListCount = skuList.count;
        NSInteger line = (skuListCount / 2) + (skuListCount % 2);
        return 86.0f + line * (10 + 29);
        
    } else {
        
        ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[indexPath.section];
        ReplenishmentGoods* goods = merchant.goodsList[indexPath.row];
        NSArray* skuList = goods.skuList;
        NSInteger skuListCount = skuList.count;
        NSInteger line = (skuListCount / 2) + (skuListCount % 2);
        return 86.0f + line * (10 + 29);
        
    }
    
    
}
//!去除多余线条
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{


    return 0.0001;

}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    footerView.backgroundColor = [UIColor clearColor];
    
    return footerView;

}




#pragma mark -
#pragma mark CSPReplenishmentInfoTableViewCellDelegate

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell *)replenishmentCell selectionStateChanged:(BOOL)selected {
    
    
    if (self.style == ReplenishmentListStyleOrderByMerchant) {
        
        NSIndexPath* indexPath = [byMerchantTableView indexPathForCell:replenishmentCell];

        [self updateSectionSelectionButtonStateForSection:indexPath.section];
    }
    
    [self updateAddCartButtonState];
    
    
    
    
}

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell*)replenishmentCell skuViewListValueChanged:(NSArray*)skuViewList {
    
    [self updateAddCartButtonState];

}

- (void)replenishmentCell:(CSPReplenishmentInfoTableViewCell*)replenishmentCell enquiryForGoodsInfo:(ReplenishmentGoods *)goodsInfo {
    
    NSInteger totalCount = 0;
    for (ReplenishmentSku* sku in goodsInfo.skuList) {
        totalCount += sku.value;
    }
//    if (totalCount<goodsInfo.batchNumLimit) {
//        [self.view makeMessage:@"没有达到起批数量,无法询单" duration:2.0f position:@"center"];
//
//        return;
//    }
    
    [HttpManager sendHttpRequestForGetMerchantRelAccount:goodsInfo.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            IMGoodsInfoDTO* imGoodsInfo = [[IMGoodsInfoDTO alloc]initWithReplenishmentInfo:goodsInfo];
            NSArray *arrDTO = [[NSArray alloc] initWithObjects:imGoodsInfo, nil];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc]initWithName:goodsInfo.merchantName jid:jid withArray:arrDTO];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;


            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}


- (void)replenishmentclickPhotoImageCell:(CSPReplenishmentInfoTableViewCell *)replenishmentCell
{
    NSString *goodsNo;
    
   
    if (self.style == ReplenishmentListStyleOrderByTime) {
        
        NSIndexPath* index = [byTimeTableView indexPathForCell:replenishmentCell];

        ReplenishmentGoods *replenismentDto = self.replenishmentGoodsList.goodsList[index.row];
        goodsNo = replenismentDto.goodsNo;
        
    } else if (ReplenishmentListStyleOrderByMerchant) {
        
        NSIndexPath* index = [byMerchantTableView indexPathForCell:replenishmentCell];

        ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[index.section];
        ReplenishmentGoods *replenismentDto = merchant.goodsList[index.row];
        goodsNo = replenismentDto.goodsNo;

        
    }
    
    if (goodsNo.length>0) {
        
        GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
        
        goodsInfoDTO.goodsNo =goodsNo;
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        [self.navigationController pushViewController:goodsInfo animated:YES];

    }
}

#pragma mark -
#pragma mark CSPReplenishmentHeaderTableViewCell

- (void)sectionHeaderSelected:(BOOL)selected sectionForIndex:(NSInteger)index {
    
    ReplenishmentMerchant*merchant = self.replenishmentMerchantList.merchantList[index];
    [merchant selectAllGoodsOfCurrentMerchant:selected];
    
    [byMerchantTableView reloadData];
    
    [self updateAddCartButtonState];
    
}

- (void)sectionHeaderView:(CSPReplenishmentSectionHeaderView*)sectionHeaderView merchantNamePressedForIndex:(NSInteger)index {
   
    
    ReplenishmentMerchant* merchantInfo = self.replenishmentMerchantList.merchantList[index];
    
    if (merchantInfo.merchantNo) {
        
        MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
        detailVC.merchantNo = merchantInfo.merchantNo;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
   

    
    
}
#pragma mark -
#pragma mark SMSegemntViewDelegate

- (void)segmentView:(SMSegmentView*)segmentView didSelectSegmentAtIndex:(NSInteger)index {
    
    //    if (index == 0) {
    //        self.style = ReplenishmentListStyleOrderByTime;
    //        if (self.replenishmentGoodsList.goodsList.count == 0) {
    //            [self.refreshHeader beginRefreshing];
    //        }
    //    } else {
    //        self.style = ReplenishmentListStyleOrderByMerchant;
    //        if (self.replenishmentMerchantList.merchantList.count == 0) {
    //            [self.refreshHeader beginRefreshing];
    //        }
    //    }
    
    if (isFromSc) {
        
        isFromSc = NO;

        return;
    }
    
    
    if (index == 0) {//!按时间排序
        
        bgSC.contentOffset = CGPointMake(0, 0);
        
        self.style = ReplenishmentListStyleOrderByTime;//!记录当前显示的排序类型
        
    } else {//!按商家排序
        
        bgSC.contentOffset = CGPointMake(bgSC.frame.size.width, 0);
        
        
        self.style = ReplenishmentListStyleOrderByMerchant;//!记录当前显示的排序类型
        
        //!判断是否有按商家排序的数据，没有的话就进行请求
        if (!self.replenishmentMerchantList && !merchantIsLoad) {//!没有数据就进行请求
            
            merchantIsLoad = YES;

            [self.byMerchantRefreshHeader beginRefreshing];
            
            
        }
        
    }
    
    
    [self updateAddCartButtonState];
    
    
    
}
#pragma mark - 
#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    isFromSc = YES;


    if (bgSC.contentOffset.x > 0) {//!按商家
        
        
        [self.segmentView selectSegmentAtIndex:1];
        
        self.style = ReplenishmentListStyleOrderByMerchant;//!记录当前显示的排序类型
        
        //!判断是否有按商家排序的数据，没有的话就进行请求
        if (!self.replenishmentMerchantList && !merchantIsLoad) {//!没有数据就进行请求
            
            merchantIsLoad = YES;
            
            [self.byMerchantRefreshHeader beginRefreshing];
            
            
        }
        
        [self setSCAndTableViewCanScrollerToTop:NO];
        
        
    }else{//!按时间
        
        [self.segmentView selectSegmentAtIndex:0];

        self.style = ReplenishmentListStyleOrderByTime;//!记录当前显示的排序类型
        
        [self setSCAndTableViewCanScrollerToTop:YES];


    }
    
    [self updateAddCartButtonState];

}

//!设置 “按时间”/"按商家"列表点击顶部可返回置顶的功能 isByTime:显示的是否是“按时间”
-(void)setSCAndTableViewCanScrollerToTop:(BOOL)isByTime{
    
    bgSC.scrollsToTop = NO;
    byTimeTableView.scrollsToTop = isByTime;
    byMerchantTableView.scrollsToTop = !isByTime;
    
}



#pragma mark -
#pragma mark Private Methods

- (void)updateAddCartButtonState {
    
    
    if (self.style == ReplenishmentListStyleOrderByMerchant) {
        
        if ([self.replenishmentMerchantList goodsListForAddingCart].count > 0) {
            
//            [self.AddCartButton setEnabled:YES];
            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
            
        } else {
//            [self.AddCartButton setEnabled:NO];
            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
            
        }
    } else {
        
        if ([self.replenishmentGoodsList goodsListForAddingCart].count > 0) {
//            [self.AddCartButton setEnabled:YES];
            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
        } else {
//            [self.AddCartButton setEnabled:NO];
            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
            
        }
    }
    
    
}


/**
 *  点击采购车进入采购车列表
 */
- (void)cartImageViewClicked {
 
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CSPShoppingCartViewController *scpVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
                
    scpVC.isBlockUp = YES;
    [self.navigationController pushViewController:scpVC animated:YES];
    
}

- (IBAction)addCartButtonClicked:(id)sender {
    
    
    if (self.style == ReplenishmentListStyleOrderByMerchant) {
        
        if ([self.replenishmentMerchantList goodsListForAddingCart].count > 0) {
            
            //            [self.AddCartButton setEnabled:YES];
//            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
            
        } else {
            //            [self.AddCartButton setEnabled:NO];
            [self.view makeMessage:@"尚未选购商品" duration:2.0f position:@"center"];
            return;

//            [self.AddCartButton setBackgroundColor:[UIColor grayColor]];
            
            
        }
    } else {
        
        if ([self.replenishmentGoodsList goodsListForAddingCart].count > 0) {
            //            [self.AddCartButton setEnabled:YES];
            [self.AddCartButton setBackgroundColor:[UIColor blackColor]];
        } else {
            //            [self.AddCartButton setEnabled:NO];
            [self.view makeMessage:@"尚未选购商品" duration:2.0f position:@"center"];
            return;
            
//            [self.AddCartButton setBackgroundColor:[UIColor grayColor]];
            
        }
    }
    NSArray* selectedCartAddingList = nil;
    if (self.style == ReplenishmentListStyleOrderByMerchant) {
        selectedCartAddingList = [self.replenishmentMerchantList goodsListForAddingCart];
    } else {
        selectedCartAddingList = [self.replenishmentGoodsList goodsListForAddingCart];
    }
    
    __block NSInteger amountAddedCart = 0;
    for (CartAddDTO* cartAddDTO in selectedCartAddingList) {
        [HttpManager sendHttpRequestForCartAdd:cartAddDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:addCartNotification object:nil];
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                amountAddedCart += 1;
                if (amountAddedCart == selectedCartAddingList.count) {
                    [self updateCartAmount];
                    [self.view makeMessage:@"添加采购车完成" duration:2.0f position:@"center"];

                }
            } else {
                NSLog(@"%@", [dic objectForKey:@"errorMessage"]);
                  [self.view makeMessage:[NSString stringWithFormat:@"添加采购车失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
                
              
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        }];
    }
    
}

- (void)updateSectionSelectionButtonStateForSection:(NSInteger)section {
    
    ReplenishmentMerchant* merchantInfo = self.replenishmentMerchantList.merchantList[section];
    BOOL selectionState = merchantInfo.isAllGoodsSelected;
    merchantInfo.selected = selectionState;
    
    CSPReplenishmentSectionHeaderView* headerView = merchantInfo.headerView;
    
    if (headerView) {
        headerView.selectButton.selected = selectionState;
    }
}


#pragma mark 请求补货商品列表所有商品
//!按时间排序
- (void)getGoodsReplenishmentByTime {
    
    
    [HttpManager sendHttpRequestForGetGoodsReplenishmentByTime:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.replenishmentGoodsList = [[ReplenishmentByTimeDTO alloc]initWithDictionary:dic];
            if (self.replenishmentGoodsList.goodsList.count > 0) {
                
                [byTimeTableView reloadData];
                
                [self.invalidWarningView setHidden:YES];
                
            } else {
                
                [self.invalidWarningView setHidden:NO];
                
                bgSC.hidden = YES;
    
            }
            
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询补货列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

          
        }
        
        [self.byTimeRefreshHeader endRefreshing];
        
        
        [self updateAddCartButtonState];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
        [self.byTimeRefreshHeader endRefreshing];
        
        [self updateAddCartButtonState];
    }];
}

//!按商家排序
- (void)getGoodsReplenishmentByMerchant {
    
    merchantIsLoad = YES;
    
    [HttpManager sendHttpRequestForGetGoodsReplenishmentByMerchant:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.replenishmentMerchantList = [[ReplenishmentByMerchantDTO alloc]initWithDictionary:dic];
            
            if (self.replenishmentMerchantList.merchantList.count > 0) {
                
                [byMerchantTableView reloadData];
                
                [self.invalidWarningView setHidden:YES];
                
            } else {
                
                [self.invalidWarningView setHidden:NO];
                bgSC.hidden = YES;
                
            }
            
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询补货列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

          
        }
        [self.byMerchantRefreshHeader endRefreshing];
        
        [self updateAddCartButtonState];
        
        merchantIsLoad = NO;//!标志没有请求了
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        [self.byMerchantRefreshHeader endRefreshing];
        
        [self updateAddCartButtonState];
        
        merchantIsLoad = NO;//!标志没有请求了

        
    }];
}

- (void)updateCartAmount {
    
    [HttpManager sendHttpRequestForCartListSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            CartListDTO* cartList = [[CartListDTO alloc]initWithDictionary:dic];
            if (cartList.merchantList.count > 0) {
                self.cartImageView.badgeNumber = [NSNumber numberWithInteger:cartList.totalGoodsAmount].stringValue;
            } else {
                self.cartImageView.badgeNumber = @"0";
            }
        } else {
            [self.view makeMessage:[NSString stringWithFormat:@"查询采购车信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
    
}

- (void)loadNewGoodsList {
    
    [self loadByTimeNewGoodsList];
    [self loadByMerchatNewGoodsList];
    
    
}
-(void)loadByTimeNewGoodsList{

    [self getGoodsReplenishmentByTime];

}
-(void)loadByMerchatNewGoodsList{
    
    
    
    [self getGoodsReplenishmentByMerchant];


}



// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    if (self.keyboardShown)
        return;
    
    NSDictionary* info = [aNotification userInfo];
    
    // Get the size of the keyboard.
    NSValue* aValue = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    self.constraintToAdjust.constant = keyboardSize.height - CGRectGetHeight(self.bottomView.frame);
    
    self.keyboardShown = YES;
}


// Called when the UIKeyboardDidHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)aNotification
{
    
    self.constraintToAdjust.constant = 0;
    
    self.keyboardShown = NO;
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
