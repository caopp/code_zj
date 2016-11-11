//
//  GoodDetailViewController.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/4.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodDetailViewController.h"
#import "CSPGoodsInfoSubViewController.h"
#import "WindowImgView.h"
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"
#import "StepListDTO.h"
#import "CustomBarButtonItem.h"
#import "GoodsInfoDTO.h"
#import "IMGoodsInfoDTO.h"
#import "ConversationWindowViewController.h"

#import "MerchantDeatilViewController.h"
#import "GoodsNotLevelTipDTO.h"
#import "CSPAuthorityPopView.h"
#import "CSPMerchantClosedView.h"

#import "CSPShoppingCartViewController.h"
#import "CSPGoodsInfoTopInfoTableViewCell.h"
#import "CSPGoodsInfoTopTableViewCell.h"
#import "CSPGoodsInfoSizeTableViewCell.h"
#import "CSPGoodsInfoModelTableViewCell.h"
#import "CSPGoodsInfoCountTableViewCell.h"
#import "CSPGoodsInfoMixConditonTableViewCell.h"
#import "CSPGoodsInfoShopTableViewCell.h"
#import "CSPGoodsInfoSubTipsTableViewCell.h"
#import "CSPGoodsInfoSubSizePicTableViewCell.h"
#import "CSPGoodsInfoSubPicsTableViewCell.h"
#import "CSPGoodsInfoSubAccountTableViewCell.h"
#import "CSPGoodsInfoNoticeTableViewCell.h"
#import "CSPGoodsInfoTextTableViewCell.h"
#import "CSPColorSizeTableViewCell.h"
#import "CSPAttrTableViewCell.h"
#import "SegmentView.h"
#import "BottomView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "CSPAuthorityTitlePopView.h"
#import "SGActionView.h"
#import "GetDownloadImageListDTO.h"
#import "CSPShareView.h"
#import "Appdelegate.h"

#import "DownloadImageDTO.h"
#import "DownloadLogControl.h"
#import "PictureDTO.h"
#import "CSPPayAndDownloadViewController.h"
#import "MembershipUpgradeViewController.h"
#import "CSPPayAvailabelViewController.h"
#import "CCWebViewController.h"
#import "PrepaiduUpgradeViewController.h"
#import "PersonalCenterDTO.h"
#include <mach/mach.h>
#define kBasicRowCount 6
#define kScroolRow 375/2-40
typedef enum _ObjectStyle {
    ObjectStyleObject,
    ObjectStyleForment,
    ObjectStyleAttr
} ObjectStyle;
@interface GoodDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,SegmentViewDelegate,CSPAuthorityTitlePopViewDelegate,CSPShareViewDelegate,CSPAuthorityPopViewDelegate,CSPMerchantClosedViewDelegate ,MembershipUpgradeViewControllerDelegate,CCWebViewControllerDelegate>{
    //CSPGoodsInfoSubViewController *vc;
    
    BOOL isTitle;
    
    GoodsNotLevelTipDTO *goodsNotLevelTipDTO;
    
    UIButton *leftBackBtn;
     NSArray *threeButtonArray;
    float totalPrice;
    float presentPrice;
    float  scroolH;//滚动高度
    NSUInteger rowCount;//显示行数
    NSUInteger tableViewRowCount;//商品信息 个数
    NSUInteger bottomTableViewRowCount;//商品详情 个数
    BOOL noticeShow;// 是否有数据
     int counts;
    long stepListCount;
    NSInteger totalCount;
    
    NSString *noticeMsg;//提示信息
    
     NSInteger referenceImagesCount;
    NSInteger naviViewTag;
    //优化加载速度
    NSDictionary *objectiveImagesDic;
    NSDictionary *referenceImagesDic;
    NSMutableArray *attrImageArray;
    //StepList 临界价格
    NSMutableDictionary *stepListCriticalPriceDic;
    NSMutableDictionary *stepListCriticalPriceMinDic;
    NSMutableDictionary *stepListCriticalPriceMaxDic;
    
    CSPAuthorityPopView* popView;
    CSPAuthorityTitlePopView *popTitleView;
     CSPShareView *shareView;
    ObjectStyle objectattStyle;//按钮选择
    MBProgressHUD *hud;
    BOOL  showNavBtn;
    BOOL hasText;//是否存在 文字描述
    BOOL showNetWork;
    MembershipUpgradeViewController *membershipUpgradeVC;
    
    NSInteger color_item; //颜色选中 状态
    //立即升级（跳转会员升级页面）
    CCWebViewController *cc;
    
    BOOL isPost;
    
}
@property(nonatomic,strong)GoodsInfoDetailsDTO *goodsInfoDetailsDTO;;
//@property(nonatomic,strong)UITableView *tableView;
//@property(nonatomic,strong)WindowImgView *imgScroll;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITableView *goodsInfoTableView;
@property (strong, nonatomic)  UITableView *imageTableView;

@property (strong, nonatomic) SegmentView *imgSelectView;
@property (strong, nonatomic) BottomView *bottomView;
@property (strong, nonatomic) WindowImgView *imgScroll;

@property (nonatomic,assign)BOOL modeStateSelected; //是否选择样本
@property (nonatomic,assign)BOOL showObjectiveImage; //是否显示客观图
@property (nonatomic,assign)BOOL hasSampleSku;       //

@property(nonatomic, strong) NSMutableArray *arrColorItems;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic,strong) InfiniteDownloadButton *infiniteDownloadButton;
@property (nonatomic, assign) BOOL isDownloading;
@property(nonatomic,strong)    UIView *downView;
/**
 *  剩余下载次数
 */
@property(nonatomic,assign)NSInteger residueDownload;

/**
 *  如果选择窗口图=1，如果选择客观图=1，如果选择窗口图和客观图=0
 */
@property(nonatomic,assign)NSInteger cancelDownloadCount;

/**
 *  置顶
 */
@property(nonatomic,strong)UIButton *topButton;


@property(nonatomic,strong)NSMutableArray *downloadImageArray;

@property (nonatomic,strong)RefreshControl *topRefreshControl;
@property (nonatomic,strong)RefreshControl *bottomRefreshControl;
@end

@implementation GoodDetailViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    isPost = YES;
    isTitle = YES;
    totalCount = 0;
    totalPrice = 0;
    _modeStateSelected = NO;
    _showObjectiveImage = YES;
    
    self.title = NSLocalizedString(@"goodsDetailTitle", @"商品详情");
    
    
    leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBackBtn.frame = CGRectMake(0, 0, 10, 18);
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    [leftBackBtn addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];
    //[self createScrollView];
  
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topButtonClick:)];
    [self.navigationController.navigationBar addGestureRecognizer:tapGesture];
    

    // Do any additional setup after loading the view.
    [self initScrollView];
    [self initTableView];
    [self initToolBar];
    [self initDownView];
    [self createHUD];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    naviViewTag = timeInterval;
    
}

#pragma mark  CREATE UI

- (void)initScrollView{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height*2);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.scrollEnabled = NO;
    
    [self.view addSubview:self.scrollView];
}

- (void)initTableView{
    
    self.goodsInfoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height-50)];
    //self.goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.goodsInfoTableView.delegate = self;
    self.goodsInfoTableView.showsVerticalScrollIndicator = NO;
    self.goodsInfoTableView.tag = 99;
    self.goodsInfoTableView.dataSource = self;
    self.goodsInfoTableView.contentSize = CGSizeMake(0, self.view.frame.size.height+self.view.frame.size.width);
    [self.scrollView addSubview:self.goodsInfoTableView];
    self.scrollView.hidden = YES;
    
    if ([self.goodsInfoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.goodsInfoTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.goodsInfoTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.goodsInfoTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    
    scroolH = self.goodsInfoTableView.frame.size.height;
    //添加上拉
    self.bottomRefreshControl = [[RefreshControl alloc] initWithScrollView:self.goodsInfoTableView delegate:self];
    [self.bottomRefreshControl setBottomEnabled:YES];
    
    [self.bottomRefreshControl setTopEnabled:NO];
    _imgSelectView= [[SegmentView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height, self.scrollView.frame.size.width, 30)];
    _imgSelectView.delegate = self;
    self.imageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.scrollView.frame.size.height- 10+_imgSelectView.frame.size.height, self.scrollView.frame.size.width, self.scrollView.frame.size.height-50-_imgSelectView.frame.size.height +10+2) style:UITableViewStylePlain];
    
    self.imageTableView.delegate = self;
    
    self.imageTableView.dataSource = self;
    
    self.imageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.scrollView addSubview:self.imageTableView];
    [self.scrollView addSubview:_imgSelectView];
//    //添加下拉
    self.topRefreshControl = [[RefreshControl alloc] initWithScrollView:self.imageTableView delegate:self];
    
    [self.topRefreshControl setTopEnabled:YES];
    
    
    self.topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.topButton setBackgroundImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
    
    [self.topButton addTarget:self action:@selector(topButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.topButton.frame = CGRectMake(self.view.frame.size.width-25-35,self.scrollView.frame.size.height*2-25-35-50, 35, 35);
    
    [self.scrollView addSubview:self.topButton];
    
    
    
  
}



-(void)initToolBar{
    
    _bottomView =[[BottomView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height-64 -50, Main_Screen_Width, 50)];
    [self.view addSubview:_bottomView];
    
}

-(void)initDownView{
    
    if (!_downView) {
        _downView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.view.frame.size.width , self.view.frame.size.height)];
        [self.view addSubview:_downView];
        _downView.hidden = YES;
        
    }
}

-(void)createHUD{
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud show:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    _modeStateSelected = NO;
   // _bottomView.startNumL.text = @"合计:￥0.00";
   // _bottomView.hasSelectedNumL.text = @"共0件";
    [self updateConsultData];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    GoodsInfoDTO *goodsInfo = [GoodsInfoDTO sharedInstance];
    [self getGoodsDetailInfoWith:goodsInfo.goodsNo];
    
    [self requestPerCenterInfoForShopCar];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:NO];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodsCountChanged:) name:kGoodsCountChangedNotification object:nil];
    
      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodsColorChanged:) name:kGoodsColorChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(modeStateChangedNotification:) name:kModeStateChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(objectiveOrRefrenceButtonClicked:) name:kObjectiveAndRefrenceButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDownloadViewNotification) name:kDownloadButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectButtonNotification) name:kCollectButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showShareViewNotification) name:kShareButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadPic:) name:kSGActionViewDownload object:nil];
    
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissDownloadViewNotification) name:kSGActionViewDismissNotification object:nil];
    
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopDownloadingNotification) name:kStopDownAnimation object:nil];
           [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updataImageTable) name:@"ReloadPhoto" object:nil];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:NO];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsCountChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsColorChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kModeStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kObjectiveAndRefrenceButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDownloadButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCollectButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kShareButtonClickedNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:kSGActionViewDownload object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSGActionViewDismissNotification object:nil];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:kStopDownAnimation object:nil];
        [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ReloadPhoto" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    totalCount = 0; totalPrice = 0;
    [self updateConsultData];
    [self removeThreeAnimationButton];
    self.scrollView.contentOffset = CGPointMake(0, 0);
    self.goodsInfoTableView.contentOffset = CGPointMake(0, 0);
}
#pragma mark UI


#pragma  mark UIScrollView  delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 99) {
        if (scrollView.contentOffset.y > kScroolRow&&!showNavBtn) {
            showNavBtn = YES;
            [self showThreeAnimationButton];
            
        
//           UIView *view = [self.view viewWithTag:999];
//            view.hidden = showNavBtn;
//            NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
//            [self.goodsInfoTableView reloadRowsAtIndexPaths:@[topInfoCellIndex] withRowAnimation:UITableViewRowAnimationNone];
            
        }
        if (scrollView.contentOffset.y <=kScroolRow&&showNavBtn) {
             showNavBtn = NO;
            [self  dismissThreeAnimationButton];
           
           
            
        }
    }
 
}


#pragma mark  UITableView datasource   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.goodsInfoTableView) {
        return tableViewRowCount +1 ;
    }else if(tableView==self.imageTableView){
        if (noticeShow) {
            return 1;
        }
        if (hasText) {
            return bottomTableViewRowCount +1;
        }else {
            return bottomTableViewRowCount;
        }
       
        
        
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (tableView == self.goodsInfoTableView &&tableView.frame.size.height+tableView.frame.size.width >tableView.contentSize.height) {
//        tableView.contentSize = CGSizeMake(0, tableView.frame.size.height+tableView.frame.size.width);
//    }
//    NSLog(@"height===%f",tableView.contentSize.height);
    CSPBaseTableViewCell *cell;
    if (tableView == self.goodsInfoTableView) {
        if (_hasSampleSku) {
            
            switch (indexPath.row) {
                case 0:
                    cell = [self createCSPGoodsInfoTopTableViewCell:indexPath withTable:tableView];
                    break;
                case 1:
                    cell = [self createCSPGoodsInfoTopInfoTableViewCell:indexPath withTable:tableView];
                    break;

                case 2:
                     cell = [self createCSPGoodsInfoSizeTableViewCell:indexPath withTable:tableView];
                    break;
                case 3:
                     cell = [self createCSPGoodsInfoModelTableViewCell:indexPath withTable:tableView];
                    break;
                case 4:
                     cell = [self createCSPGoodsInfoCountTableViewCell:indexPath withTable:tableView];
                    break;

                case 5:
                    cell = [self createCSPGoodsInfoShopTableViewCell:indexPath withTable:tableView];
                    break;
                case 6:
                    cell = [self createCSPGoodsInfoSubTipsTableViewCell:indexPath withTable:tableView];
                    break;

                default:
                    return nil;
                    break;
            }
            
        }else{
            
            switch (indexPath.row) {
                case 0:
                    cell = [self createCSPGoodsInfoTopTableViewCell:indexPath withTable:tableView];
                    break;
                case 1:
                    cell = [self createCSPGoodsInfoTopInfoTableViewCell:indexPath withTable:tableView];
                    break;
//                case 2:
//                    cell = [self createCSPBaseTableViewCell:indexPath withTable:tableView];
//                    break;
                case 2:
                    cell = [self createCSPGoodsInfoSizeTableViewCell:indexPath withTable:tableView];
                    break;
                case 3:
                    cell = [self createCSPGoodsInfoCountTableViewCell:indexPath withTable:tableView];
                    break;

                case 4:
                    cell = [self createCSPGoodsInfoShopTableViewCell:indexPath withTable:tableView];
                    break;
                case 5:
                    cell = [self createCSPGoodsInfoSubTipsTableViewCell:indexPath withTable:tableView];
                    break;

                default:
                    return nil;
                    break;
            }
            
        }
        cell.showLine = YES;
        return cell;
    }else{
        if (noticeShow) {
            
           return  [self createCSPGoodsInfoNoticeTableViewCell:indexPath withTable:tableView];
        }
        if (hasText) {
            if (indexPath.row==0) {
                 return [self createCSPGoodsInfoTextTableViewCell:indexPath withTable:tableView];
            }else{
               return [self createCSPGoodsInfoSubPicsTableViewCell:indexPath withTable:tableView];
            }
        }else{
            if (objectattStyle == ObjectStyleAttr) {
                return [self createCSPAttrTableViewCell:indexPath withTable:tableView];
            }else {
                return [self createCSPGoodsInfoSubPicsTableViewCell:indexPath withTable:tableView];
            }
            
        }
        

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==self.goodsInfoTableView&&indexPath.row ==2) {
        CSPBaseTableViewCell *cell = [self createCSPGoodsInfoSizeTableViewCells:indexPath withTable:self.goodsInfoTableView];
        CGFloat height =cell.frame.size.height;
        return height;
    }
    CSPBaseTableViewCell *cell = (CSPBaseTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat height =cell.frame.size.height;
    
    
    if ([_goodsInfoDetailsDTO.batchMsg length]==0) {
        if (tableView==self.goodsInfoTableView) {
//            if (_hasSampleSku) {
//                if (indexPath.row == 5) {
//                    return 0;
//                }
//            }else{
//                if (indexPath.row == 4) {
//                    return 0;
//                }
//            }
        }
    }
  

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (self.imageTableView ==tableView&&objectattStyle != ObjectStyleAttr) {
        if (bottomTableViewRowCount) {
            if (hasText&&indexPath.row ==0) {
                return;
            }
            [self tapImage:indexPath];
        }
        
        return;
    }
    if (_modeStateSelected) {
        [[NSNotificationCenter defaultCenter]postNotificationName:kModeStateChangedNotification object:nil];
    }
    if (self.goodsInfoTableView==tableView) {
        [self.view endEditing:YES];
    }
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[CSPGoodsInfoShopTableViewCell class]]) {
        
        [self goodsViewControllerCell];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        if (indexPath.row == 1) {
            [cell setSeparatorInset: UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
        }else {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }

    }
    
    
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        
        
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.imageTableView==tableView) {
        return 10.0f;
    }
    return tableView.tableHeaderView.frame.size.height;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    return headerView;
}

#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop){
        
        DebugLog(@"下拉");
        
        //结束加载
        [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        
        //上拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, 0);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }else if (direction == RefreshDirectionBottom){
        
        DebugLog(@"上拉");
        
        //结束加载
        [self.topRefreshControl finishRefreshingDirection:RefreshDirectionTop];
        
        [self.imageTableView reloadData];
        //下拉
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.scrollView.contentOffset = CGPointMake(0, self.view.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark 
-(void)updataImageTable{
    [_imageTableView reloadData];
}

#pragma mark GET  DATA
- (void)updateAttrRowCountWithList:(NSArray*)list{
    if (list.count) {
        noticeShow = NO;
        
    }else{
        noticeShow = YES;
        noticeMsg = @"商家暂未填写商品规格参数！";
    }
    if (_hasSampleSku) {
        rowCount = kBasicRowCount+list.count+1;
        tableViewRowCount = kBasicRowCount;
        bottomTableViewRowCount = list.count;
    }else{
        rowCount = kBasicRowCount+list.count;
        tableViewRowCount = kBasicRowCount-1;
        bottomTableViewRowCount = list.count;
        
    }
}
- (void)updateRowCountWithList:(NSArray*)list{
    
    NSInteger level = 0;
    if ([MemberInfoDTO sharedInstance]) {
        NSInteger memberLevel = [[MemberInfoDTO sharedInstance].memberLevel integerValue];
        NSInteger shopLevel = [_goodsInfoDetailsDTO.shopLevel integerValue];
        level =(memberLevel>shopLevel)?memberLevel:shopLevel;
    }
    
    NSArray *imageList = list;
    
    if (level<=2) {
        
        noticeShow = YES;
        noticeMsg = @"当前等级无查看权限！";
    }else{
        noticeShow = NO;
    }
    
    if (_hasSampleSku) {
        if (level>2) {
            rowCount = kBasicRowCount+imageList.count+1;
            tableViewRowCount = kBasicRowCount;
            bottomTableViewRowCount = imageList.count;
        }else{
            rowCount = kBasicRowCount;
            tableViewRowCount = kBasicRowCount;
            bottomTableViewRowCount = 0;
        }
    }else{
        if (level>2) {
            rowCount = kBasicRowCount+imageList.count;
            tableViewRowCount = kBasicRowCount-1;
            bottomTableViewRowCount = imageList.count;
        }else{
            rowCount = kBasicRowCount-1;
            tableViewRowCount = kBasicRowCount-1;
            bottomTableViewRowCount = 0;
        }
        
    }
    
}


- (NSArray *)getWindowsImageURLs{
    
    NSArray *imageList = _goodsInfoDetailsDTO.windowImageList;
    
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tmpDic in imageList) {
        
        NSNumber *sort = tmpDic[@"sort"];
        NSString *picUrl = tmpDic[@"picUrl"];
        [imageDic setObject:picUrl forKey:sort];
    }
    
    NSMutableArray *resultArr = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<imageList.count; i++) {
        
        NSString *url = imageDic[[NSNumber numberWithInt:i+1]];
        if (url) {
            [resultArr addObject:url];
        }
        
    }
    
    return resultArr;
}
- (void)getGoodsDetailInfoWith:(NSString *)goodsNo{
    
    [HttpManager sendHttpRequestForGetNewGoodsInfoDetailsWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        //self.tableView.separatorStyle = UITablfeViewCellSeparatorStyleSingleLine;
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSArray class]])
            {
                _arrColorItems = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dicItm in [dic objectForKey:@"data"] ) {
                    GoodsInfoDetailsDTO * goodsItemDetailsDTO = [[GoodsInfoDetailsDTO alloc] init];
                    [goodsItemDetailsDTO setDictFrom:dicItm];
                    
                    [_arrColorItems addObject:goodsItemDetailsDTO];
                    
                }
                //                _goodsInfoDetailsDTO = [[GoodsInfoDetailsDTO alloc] init];
                //                [_goodsInfoDetailsDTO setDictFrom:[dic objectForKey:@"data"]];
                if (_arrColorItems.count==0) {
                    [hud hide:YES];
                    return ;
                }
                _goodsInfoDetailsDTO = [_arrColorItems objectAtIndex:0];
                
                [self getDataSuccess];
                
            }
        }else{
            
            //[self alertWithAlertTip:@"未获取到服务器数据"];
            //[[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (void)getJID:(NSString *)merchantNo withArray:(NSArray *)arr{
    [self createHUD];
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [hud hide:YES];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];
            NSNumber *isExit = dic[@"data"][@"isExit"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:_goodsInfoDetailsDTO.merchantName jid:jid withArray:arr];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;

            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }else{
            
        }
        
        //[[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataFinishNotification object:nil];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];
}
- (void)getDataSuccess{
    
    if ([_goodsInfoDetailsDTO.goodsStatus isEqualToString:@"2"]) {
        self.scrollView.hidden = NO;
        hasText = _goodsInfoDetailsDTO.details&&[_goodsInfoDetailsDTO.details length];
        //hasSampleSku
        if ([_goodsInfoDetailsDTO.sampleSkuInfo isKindOfClass:[NSDictionary class]]&&[_goodsInfoDetailsDTO.sampleSkuInfo.allKeys count]>0) {
            _hasSampleSku = YES;
            
        }else{
            
            _hasSampleSku = NO;
        }
        
        //imageList
        referenceImagesDic = nil;
        objectiveImagesDic = nil;
        stepListCriticalPriceDic = nil;
        stepListCriticalPriceMaxDic = nil;
        stepListCriticalPriceMinDic = nil;
        
        referenceImagesDic = [self getReferenceImages];
        objectiveImagesDic = [self getObjectiveImages];
//        attrImageArray = (NSMutableArray *)[self getAttrImages];
        stepListCriticalPriceDic = [[NSMutableDictionary alloc]init];
        stepListCriticalPriceMinDic = [[NSMutableDictionary alloc]init];
        stepListCriticalPriceMaxDic = [[NSMutableDictionary alloc]init];
        
        for (StepListDTO *tmpStepDTO in _goodsInfoDetailsDTO.stepList) {
            
            NSString *criticalPrice_min = [NSString stringWithFormat:@"%@",tmpStepDTO.minNum];
            NSString *criticalPrice_max = [NSString stringWithFormat:@"%@",tmpStepDTO.maxNum];
            
            if (!stepListCriticalPriceDic[criticalPrice_min]) {
                
                [stepListCriticalPriceDic setObject:@1 forKey:criticalPrice_min];
                [stepListCriticalPriceMinDic setObject:@1 forKey:criticalPrice_min];
            }else{
                
                NSNumber *obj = stepListCriticalPriceDic[criticalPrice_min];
                
                obj = [NSNumber numberWithInteger:[obj integerValue]];
                
                [stepListCriticalPriceDic setObject:obj forKey:criticalPrice_min];
                
                obj = stepListCriticalPriceMinDic[criticalPrice_min];
                
                obj = [NSNumber numberWithInteger:[obj integerValue]];
                
                [stepListCriticalPriceMinDic setObject:obj forKey:criticalPrice_min];
            }
            
            if (![criticalPrice_max isEqualToString:@""]) {
                
                if (!stepListCriticalPriceDic[criticalPrice_max]) {
                    
                    [stepListCriticalPriceDic setObject:@1 forKey:criticalPrice_max];
                    [stepListCriticalPriceMaxDic setObject:@1 forKey:criticalPrice_max];
                }else{
                    
                    NSNumber *obj = stepListCriticalPriceDic[criticalPrice_max];
                    
                    obj = [NSNumber numberWithInteger:[obj integerValue]];
                    
                    [stepListCriticalPriceDic setObject:obj forKey:criticalPrice_max];
                    
                    obj = stepListCriticalPriceMaxDic[criticalPrice_max];
                    
                    obj = [NSNumber numberWithInteger:[obj integerValue]];
                    
                    [stepListCriticalPriceMaxDic setObject:obj forKey:criticalPrice_max];
                }
            }
        }
        
        
        [self.goodsInfoTableView reloadData];
        
        
    }else{
        self.scrollView.hidden = YES;
        self.title = @"提示";
        
        CSPMerchantClosedView *merchantCloseView = [self instanceMerchantClosedView];
        //        merchantCloseView.type = MerchantClosedViewTypeGoodsInvalid;
        CGRect rect = self.view.frame;
        rect.origin.y -= 60;
        merchantCloseView.frame = self.view.frame;
        
        [merchantCloseView setType:MerchantClosedViewTypeGoodsInvalid];
        
        merchantCloseView.delegate = self;
        
        [self.view addSubview:merchantCloseView];
        
    }
    [hud hide:YES];
}
#pragma mark 请求个人中心信息--》为了得到采购车的数量
-(void)requestPerCenterInfoForShopCar{
    
    _bottomView.shopPoint.hidden = YES;
    
    [HttpManager sendHttpRequestForPersonalCenterSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            PersonalCenterDTO * personalDTO = [[PersonalCenterDTO alloc]initWithDictionary:dic[@"data"]];
            
            if ([personalDTO.cartNum intValue]) {
                
                
                _bottomView.shopPoint.hidden = NO;//!采购车中有商品，显示提示的红点
                
            }else{
                _bottomView.shopPoint.hidden = YES;

            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        
    }];
    
    
    
}


- (void)reviewGoodsList{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RDVTabBarController *totalTabBarController = (RDVTabBarController *)[AppDelegate currentAppDelegate].viewController;
    
    totalTabBarController.selectedIndex = 1;
    
}

- (void)reviewMerchantList{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    RDVTabBarController *totalTabBarController = (RDVTabBarController *)[AppDelegate currentAppDelegate].viewController;
    
    totalTabBarController.selectedIndex = 0;
    
}

- (CSPMerchantClosedView *)instanceMerchantClosedView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPMerchantClosedView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
- (NSDictionary *)getObjectiveImages{
    
     hasText = _goodsInfoDetailsDTO.details&&[_goodsInfoDetailsDTO.details length];
    NSArray *imageList = _goodsInfoDetailsDTO.objectiveImageList;
    [self updateRowCountWithList:imageList];
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tmpDic in imageList) {
        
        NSNumber *sort = tmpDic[@"sort"];
        NSString *picUrl = tmpDic[@"picUrl"];
        [imageDic setObject:picUrl forKey:sort];
    }
    
    return imageDic;
}

- (NSDictionary *)getReferenceImages{
    hasText = NO;
    NSArray *imageList = _goodsInfoDetailsDTO.referImageList;
    [self updateRowCountWithList:imageList];
    
    referenceImagesCount = imageList.count;
    
    NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
    
    for (NSDictionary *tmpDic in imageList) {
        
        NSNumber *sort = tmpDic[@"sort"];
        NSString *picUrl = tmpDic[@"picUrl"];
        [imageDic setObject:picUrl forKey:sort];
    }
    
    [self setReferenceButtonNum];
    return imageDic;
}
-(NSMutableArray *)getAttrImages{
    hasText = NO;
    NSArray *imageList = _goodsInfoDetailsDTO.attrList;
    [self updateAttrRowCountWithList:imageList];
    attrImageArray = _goodsInfoDetailsDTO.attrList;
    return _goodsInfoDetailsDTO.attrList;
}

- (void)objectiveImgBtnClicked:(id)sender {
    objectattStyle = ObjectStyleObject;
    [self objectiveState:ObjectStyleObject];
    _showObjectiveImage = YES;
    [self getObjectiveImages];
    [self.imageTableView reloadData];
}

- (void)referenceImgBtnClicked:(id)sender {
    objectattStyle  = ObjectStyleForment;
    [self objectiveState:ObjectStyleForment];
    _showObjectiveImage = NO;
    [self getReferenceImages];
    [self.imageTableView reloadData];
}
-(void)attrImgBtnClicked:(id)sender{
    objectattStyle = ObjectStyleAttr;
    [self objectiveState:ObjectStyleAttr];
    [self getAttrImages];
    [self.imageTableView reloadData];
}
- (void)objectiveState:(ObjectStyle )objective{
    
    switch (objective) {
        case ObjectStyleObject:
        {
            _imgSelectView.objectBtn.backgroundColor = [UIColor whiteColor];
            [_imgSelectView.objectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _imgSelectView.reftBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.reftBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.attrBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
        }
            break;
        case ObjectStyleForment:
        {
            _imgSelectView.objectBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.objectBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            
            _imgSelectView.reftBtn.backgroundColor = [UIColor whiteColor];
            [_imgSelectView.reftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.attrBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
        }
            break;
        case ObjectStyleAttr:
        {
            _imgSelectView.reftBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.reftBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
            
            _imgSelectView.attrBtn.backgroundColor = [UIColor whiteColor];
            [_imgSelectView.attrBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            _imgSelectView.objectBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
            [_imgSelectView.objectBtn setTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    
}
- (void)setReferenceButtonNum{
    
    NSString *title = [NSString stringWithFormat:@"参考图(%zi)",referenceImagesCount];
    [_imgSelectView.reftBtn setTitle:title forState:UIControlStateNormal];
    //_refL.text = title;
    
    if (referenceImagesCount==0) {
        
        noticeShow = YES;
        noticeMsg = @"商家暂未上传参考图!";
        
    }else{
        
        if([[MemberInfoDTO sharedInstance].memberLevel integerValue]>=2){
            noticeShow = NO;
        }else{
            
            noticeMsg = @"当前等级无查看权限！";
            noticeShow = YES;
        }
    }
}
-(void)collectWithgoodNo:(NSString*)goodsNo
{
    NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
    CSPGoodsInfoTopInfoTableViewCell *cell = [self.goodsInfoTableView cellForRowAtIndexPath:topInfoCellIndex];
   // [self.goodsInfoTableView reloadRowsAtIndexPaths:@[topInfoCellIndex] withRowAnimation:UITableViewRowAnimationNone];
    __block UIButton *collectButton = cell.saveBtn;// = ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).collectButton;
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([_goodsInfoDetailsDTO.isFavorite  isEqualToString:@"1"]) {
        [HttpManager  sendHttpRequestForAddGoodsFavoriteWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                _goodsInfoDetailsDTO.isFavorite = @"0";
                
                [collectButton setSelected:YES];
                [self setCollectionButtonOfThreeAnimationSelected:YES];
                
                
            }else{
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }else{
        [HttpManager sendHttpRequestForDelFavoriteWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                _goodsInfoDetailsDTO.isFavorite = @"1";
                
                [collectButton setSelected:NO];
                [self setCollectionButtonOfThreeAnimationSelected:NO];
                
            }else{
                
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        
    }
}

- (void)downloadPic:(NSNotification *)noti;
{
    
    //@传值进行判断(根据传过来的值（0，1包括客观图和窗口图两种的（这两种又分为，窗口图下载，客观图下载，窗口图和客观图下载三种形式））)
    
    if ([(NSString *)noti.object isEqualToString:@"0"]) {
        
        self.cancelDownloadCount = 1;
        
    }else if([(NSString *)noti.object isEqualToString:@"1"]){
        
        self.cancelDownloadCount = 1;
        
    }else if ([(NSString *)noti.object isEqualToString:@"3"]){
        
        self.cancelDownloadCount = 0;
    }
    
    
    if (![(NSString *)noti.object isEqualToString:@"2"]) {
        
        if ((self.residueDownload - [DownloadLogControl sharedInstance].downloadingItems+self.cancelDownloadCount)<0) {
            
            [self showNoDownloadTimes];
            
            return;
        }
        
        [self updateDownloadStateOnDownloading:YES];
        
    }
    
    
    DownloadImageDTO* downloadImageDTO = [[DownloadImageDTO alloc] init];
    PictureDTO *pictureDTO = [[PictureDTO alloc] init];
    
    NSDictionary *Dictionary = [self.listArray objectAtIndex:0];
    [downloadImageDTO setDictFrom:Dictionary];
    
    NSString *windowString;
    NSString *imterString;
    //图片的数量
    NSString * objectImageItems;
    NSString * windowImageItems;
    
    //!图片大小
    NSNumber *windowPicSize;
    NSNumber *objectPicSize;
    
    
    
    for (NSDictionary *dic in downloadImageDTO.pictureDTOList) {
        
        [pictureDTO setDictFrom:dic];
        
        if ([pictureDTO.picType isEqualToString:@"0"]) {//!窗口图
            
            windowString = pictureDTO.zipUrl;
            windowImageItems = pictureDTO.qty;
            
            windowPicSize = pictureDTO.picSize;
            
            
        }else if([pictureDTO.picType isEqualToString:@"1"])//!客观图
        {
            
            imterString = pictureDTO.zipUrl;
            objectImageItems = pictureDTO.qty;
            objectPicSize = pictureDTO.picSize;
            
        }
    }
    
    
    
    if ([(NSString *)noti.object isEqualToString:@"0"]) {
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:goodsInfoDetailsDTO.defaultPicUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectPicSize];
        
        [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];

        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:_goodsInfoDetailsDTO.defaultPicUrl];
        
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:nil windowFigureUrl:windowString pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];
        
        
    }else if([(NSString *)noti.object isEqualToString:@"1"])
    {
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:goodsInfoDetailsDTO.defaultPicUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectPicSize];
        
        [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];

        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:_goodsInfoDetailsDTO.defaultPicUrl];
        
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString windowFigureUrl:nil pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];
        
        
    }else if ([(NSString *)noti.object isEqualToString:@"2"]){
        
        
        
    }else if ([(NSString *)noti.object isEqualToString:@"3"])
    {
        
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:goodsInfoDetailsDTO.defaultPicUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectPicSize];
        
        [self.view makeMessage:@"请在“本地手机相册”中查看下载完成的图片" duration:2.0 position:@"center"];

        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:_goodsInfoDetailsDTO.defaultPicUrl];
        
        
        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString windowFigureUrl:windowString pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];
    }
}


-(void)getdownloadImageInfo{
    //获取图片信息
    if (showNetWork) {
        return;
    }
    showNetWork = YES;
    if (_goodsInfoDetailsDTO.goodsNo == nil||[_goodsInfoDetailsDTO.goodsNo isEqualToString:@""]) {
        
        [self.view makeMessage:@"没有获取到商品信息" duration:2.0f position:@"center"];
        return;
    }
    
    [self progressHUDShowWithString:@"正在获取图片资料"];
    
    NSDictionary *firstImage = @{@"goodsNo":_goodsInfoDetailsDTO.goodsNo,@"downLoadType":@"3"};
    
    NSMutableArray *imageDownloadArray = [[NSMutableArray alloc] init];
    [imageDownloadArray addObject:firstImage];
    
    [HttpManager sendHttpRequestForGetDownloadImageList:imageDownloadArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        showNetWork = NO;

        [self.progressHUD hide:YES];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            id data = [dic objectForKey:@"data"];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                self.residueDownload = ((NSNumber *)[data objectForKey:@"remainCount"]).integerValue;
                
                id list = [data objectForKey:@"list"];
                
                if ([list isKindOfClass:[NSArray class]]&&((NSArray *)list).count) {
                    
                    GetDownloadImageListDTO* getDownloadImageListDTO = [[GetDownloadImageListDTO alloc] init];
                    
                    getDownloadImageListDTO.downloadImageDTOList = list;
                    
                    self.listArray = getDownloadImageListDTO.downloadImageDTOList;
                    
                    if (![[AppDelegate currentAppDelegate]isWifiReach]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"为节省流量,建议开启wifi后进行下载！" message:@"尚未开启wifi,是否继续下载" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        [alert show];
                    }else{
                        
                        [self showDownloadView];
                    }
                    
                }else{
                     [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
                }
                
            }
            
        }else if ([[dic objectForKey:@"code"]isEqualToString:@"107"]){
            
            [self showsevenDayError];
            
        }else if ([[dic objectForKey:@"code"]isEqualToString:@"120"]){
            
            [self showNoDownloadTimes];
        }else{
            
            [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        showNetWork = NO;

        [self.progressHUD hide:YES];
        [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
    }];
    
}



#pragma mark - 询单结算
- (void)updateConsultData{
    
     totalPrice = [self calculatePresentTotalPrice:totalCount withStepList:nil];
    NSString *totalP = [NSString stringWithFormat:@"%0.2f",totalPrice];
    NSString *totolColorCount = [NSString stringWithFormat:@"%zi",[self totalCountAdd]];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"合计:¥ %@",totalP] ];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.0] range:NSMakeRange(0, 5)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0x666666 alpha:1] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Tw Cen MT" size:20.0-([totalP length] >7?([totalP length]-2):0)] range:NSMakeRange(5, [totalP length])];
    
    [_bottomView.startNumL setAttributedText:str];
    _bottomView.hasSelectedNumL.font = [UIFont systemFontOfSize:14-([totolColorCount length]>5?[totolColorCount length]-5:0)];
    _bottomView.hasSelectedNumL.text = [NSString stringWithFormat:@"共:%@件",totolColorCount];
//    BOOL showConsult = YES;
//    for (GoodsInfoDetailsDTO *goodsInfo in _arrColorItems) {
//        if (goodsInfo.buyNum <[goodsInfo.batchNumLimit integerValue]&&!goodsInfo.buyMode&&goodsInfo.buyNum) {
//            showConsult = NO;
//        }
//    }
//    if (showConsult) {
//        [_bottomView.button setEnabled:YES];
//        [_bottomView.button setBackgroundColor:[UIColor blackColor]];
//    }else{
//        [_bottomView.button setEnabled:NO];
//        [_bottomView.button setBackgroundColor:[UIColor grayColor]];
//    }
//
    
    //[self updateHasSelectedModel];
}

//- (void)updateHasSelectedModel{
//    
//    if (_modeStateSelected) {
//        
//       // _bottomView.startNumL.text = [NSString stringWithFormat:@"发版：1"];
//        _bottomView.hasSelectedNumL.hidden = YES;
//        _bottomView.lineView.hidden = YES;
//        [_bottomView.button setTitle:@"发版结算" forState:UIControlStateNormal];
//        [_bottomView.button setTitle:@"发版结算" forState:UIControlStateHighlighted];
//        [_bottomView.button setEnabled:YES];
//        [_bottomView.button setBackgroundColor:[UIColor blackColor]];
//        
//    }else{
//        
//        //_bottomView.startNumL.text = [NSString stringWithFormat:@"起批：%@",_goodsInfoDetailsDTO.batchNumLimit];
//        _bottomView.hasSelectedNumL.hidden = NO;
//        _bottomView.lineView.hidden = NO;
//        [_bottomView.button setTitle:@"询单结算" forState:UIControlStateNormal];
//        [_bottomView.button setTitle:@"询单结算" forState:UIControlStateHighlighted];
//    }
//}
-(void)showCarList{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
    shopVC.isBlockUp = YES;
    shopVC.fromPersonCenterShopCart = YES;//!从 我的-》采购车进入的时候，这个值为yes
    [self.navigationController pushViewController:shopVC animated:YES];
}

-(void)medmberMessage{
    //[self getShareUrl];
    //获取会员信息
    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
  
//    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
//    
//    [refreshHeader addToScrollView:self.tableView];
//    self.refreshHeader = refreshHeader;
//    
//    refreshHeader.beginRefreshingOperation = ^{
//        
//        [[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataNotification object:nil];
//    };
//    
//    hud = [[MBProgressHUD alloc]initWithView:self.view];
//    [self.view addSubview:hud];
//    
//    [hud show:YES];
//    
//    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
//    
//    naviViewTag = timeInterval;
    

}
//计算 总件数
-(NSInteger)totalCountAdd{
    NSInteger totalAdd = 0;
    for (GoodsInfoDetailsDTO *goodsInfo in _arrColorItems) {
        if (goodsInfo.buyMode) {
            totalAdd +=1;
        }else {
            totalAdd  +=goodsInfo.buyNum;
        }
        
       
    }
    return totalAdd;
}

//计算当前总价
- (float)calculatePresentTotalPrice:(NSInteger)total withStepList:(NSArray*)stepList{
    presentPrice = 0;
    for (GoodsInfoDetailsDTO *dto in _arrColorItems) {
        if (dto.buyMode) {
            presentPrice += [dto.samplePrice floatValue];
        }else {
            presentPrice += dto.buyNum *[dto.price floatValue];
        }
        
    }
    return presentPrice;
    
//    for (StepListDTO *tmpDTO in stepList) {
//        
//        NSInteger min = [tmpDTO.minNum integerValue];
//        NSInteger max ;
//        
//        NSString *maxStr = [NSString stringWithFormat:@"%@",tmpDTO.maxNum];
//        
//        if ([maxStr isEqualToString:@""]) {
//            
//            max = 2147483640;
//        }else{
//            
//            max = [tmpDTO.maxNum integerValue];
//        }
//        
//        if (total>=min&&total<=max) {
//            
//            presentPrice = [tmpDTO.price floatValue];
//            return presentPrice*total;
//        }
//    }
    
    return 0;
}



//- (void)getShareUrl{
//    
//    NSString *goodsNo = _goodsNo;
//    
//    [HttpManager sendHttpRequestForGetGoodsShareLink:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        
//        NSLog(@"dic = %@",dic);
//        
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            
//            //参数需要保存
//            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
//            {
//                getGoodsShareLinkDTO = [[GetGoodsShareLinkDTO alloc ]init];
//                [getGoodsShareLinkDTO setDictFrom:[dic objectForKey:@"data"]];
//            }
//        }else{
//            
//            
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        
//    }];
//}





#pragma mark 分享 下载  收藏

#pragma mark - Animation 动画
//隐藏
- (void)hideThreeAnimationButton:(BOOL)hide{
    
    for (UIView *tmpView in self.navigationController.view.subviews) {
        
        if (tmpView.tag==naviViewTag) {
            [tmpView setHidden:hide];
        }
    }
}

//移除
- (void)removeThreeAnimationButton{
    
    UIView * tmpView = [self.navigationController.view viewWithTag:naviViewTag];
    [tmpView removeFromSuperview];
 
}

- (void)showThreeAnimationButton{
    
    [self removeThreeAnimationButton];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat naviHeight = 44 +20;
    CGFloat xOffset = 0;
    CGFloat yOffset = naviHeight;
    
    UIView *naviView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth-100,0,100,naviHeight)];
    [naviView setBackgroundColor:[UIColor clearColor]];
    naviView.tag = naviViewTag;
    xOffset += 25+8;
    
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(xOffset,screenWidth , 25, 25)];

    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏"] forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏"] forState:UIControlStateHighlighted];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏选中"] forState:UIControlStateSelected];
    [collectionBtn setAlpha:0];
    [collectionBtn addTarget:self action:@selector(collectButtonNotification) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:collectionBtn];
    
    if ([_goodsInfoDetailsDTO.isFavorite isEqualToString:@"0"]) {
        [collectionBtn setSelected:YES];
    }else{
        [collectionBtn setSelected:NO];
    }
    
    xOffset += 25+8;
    
    InfiniteDownloadButton *downloadBtn = [[InfiniteDownloadButton alloc]initWithFrame:CGRectMake(xOffset,screenWidth , 25, 25)];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateNormal];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateHighlighted];
    [downloadBtn setAlpha:0];
    [downloadBtn addTarget:self action:@selector(showDownloadViewNotification) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:downloadBtn];
    
    [downloadBtn setTileDuration:2.f];
    [downloadBtn setTileImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"]];
    [downloadBtn setDirection:InfiniteDownloadDirectionTopToBottom];
    
    xOffset += 25+8;
    //
    //    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(xOffset,yOffset, 25, 25)];
    //    [shareBtn setBackgroundImage:[UIImage imageNamed:@"顶栏分享"] forState:UIControlStateNormal];
    //    [shareBtn setBackgroundImage:[UIImage imageNamed:@"顶栏分享"] forState:UIControlStateHighlighted];
    //    [shareBtn setAlpha:0];
    //    [shareBtn addTarget:self action:@selector(showShareViewNotification) forControlEvents:UIControlEventTouchUpInside];
    //    [naviView addSubview:shareBtn];
    //
    [self.navigationController.view addSubview:naviView];
    
    yOffset = naviHeight-10-25;
    
    threeButtonArray = @[collectionBtn,downloadBtn];
    
    [self showAllButtons:threeButtonArray withYOffset:yOffset];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    self.title = @"";
    
}

//显示动画
- (void)showAllButtons:(NSArray *)btnArray withYOffset:(CGFloat)yOffset{
    
    leftBackBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBackBtn setImage:[UIImage imageNamed:@"nav_buck_show"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"nav_buck_show"] forState:UIControlStateSelected];
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];
    //顺序出现
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *button = btnArray[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                CGRect rect = button.frame;
                rect.origin.y = yOffset;
                [button setFrame:rect];
                button.alpha = 1;
                if (i==btnArray.count-1) {
                    NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
                    CSPGoodsInfoTopInfoTableViewCell *cell = [self.goodsInfoTableView cellForRowAtIndexPath:topInfoCellIndex];
                    cell.TopBar.hidden = showNavBtn;
                }
                
            } completion:nil];
        });
    }
}


//消失动画
- (void)dismissThreeAnimationButton{
    leftBackBtn.frame = CGRectMake(0, 0, 10, 18);
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    [self dismissAllButtons:threeButtonArray withYOffset:Main_Screen_Width ];
    self.title = @"商品详情";
}

- (void)dismissAllButtons:(NSArray *)btnArray withYOffset:(CGFloat)yOffset{
    
    for (int i = 0; i < btnArray.count; i++) {
        UIButton *button = btnArray[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                
                CGRect rect = button.frame;
                rect.origin.y = yOffset;
                [button setFrame:rect];
                
                button.alpha = 0;
                NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
                CSPGoodsInfoTopInfoTableViewCell *cell = [self.goodsInfoTableView cellForRowAtIndexPath:topInfoCellIndex];
                cell.TopBar.hidden = showNavBtn;
                
            }];
        });
    }
}

//navi收藏按钮选中状态
- (void)setCollectionButtonOfThreeAnimationSelected:(BOOL)selected{
    
    if (threeButtonArray) {
        
        UIButton *collectionButton = [threeButtonArray firstObject];
        
        [collectionButton setSelected:selected];
    }
}

#pragma mark - Collect Download Share
- (void)showsevenDayError{
    
    if (popTitleView == nil) {
        popTitleView = [[[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityTitlePopView" owner:self options:nil] objectAtIndex:0];
        CGRect rect = self.view.frame;
        rect.origin.y =0;
        
        popTitleView.frame = rect;
        popTitleView.delegate = self;
        popTitleView.detailLabel.text = @"商家已限制所有与本店无交易往来的采购商，不可下载7日内新品。";
        popTitleView.buyTimesButton.hidden = YES;
        [self.view addSubview:popTitleView];
        
        [self alertTipsPreInitWithContentView];
    }
    
}

-(void)showNoDownloadTimes{
    
    if (popTitleView == nil) {
        popTitleView = [[[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityTitlePopView" owner:self options:nil] objectAtIndex:0];
        CGRect rect = self.view.frame;
        rect.origin.y =0;
        
        popTitleView.frame = rect;
        popTitleView.delegate = self;
        popTitleView.detailLabel.hidden = NO;
        popTitleView.buyTimesButton.hidden = NO;
         popTitleView.detailLabel.text = @"下载次数不够,请及时充值购买图片";
        popTitleView.titleLabel.text = @"提示";
        [self.view addSubview:popTitleView];
        
        [self alertTipsPreInitWithContentView];
    }
}

#pragma mark - CSPAuthorityTitlePopView Delegate

- (void)actionWhenPopViewDimiss{
    if (popView) {
        popView = nil;
    }
    
    if(popTitleView){
        popTitleView = nil;
    }
    
//    [_contentView setHidden:YES];
//    
//    [_nextWindow beginStateToUP];
}

-(void)gotoBuyDownloadTimes{
    
    [self actionWhenPopViewDimiss];
//    [_nextWindow close];
//    [MWWindow dismissAllMWWindows];
    CSPPayAndDownloadViewController *nextVC = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAndDownloadViewController"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

//弹出自定义警告窗时添加此方法
- (void)alertTipsPreInitWithContentView{
    
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:YES];
    
//    [_contentView setHidden:NO];
//    [_nextWindow close];
 //   [self removeThreeAnimationButton];
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController) threeButtonSetAlphaToShow];
    
}

//等级规则
- (void)showLevelRules {
    
    [self actionWhenPopViewDimiss];
      PrepaiduUpgradeViewController *prepaiduUpgradeVC = [[PrepaiduUpgradeViewController alloc]init];
    
    prepaiduUpgradeVC.file = [HttpManager membershipRequestWebView];
    
    prepaiduUpgradeVC.isOK = YES;
    
    [self.navigationController pushViewController:prepaiduUpgradeVC animated:YES];
    
}
//立即升级
- (void)prepareToUpgradeUserLevel {
    
    [self actionWhenPopViewDimiss];
    
    cc = [[CCWebViewController alloc]init];
    cc.delegate = self;
    cc.file = [HttpManager membershipUpgradeNetworkRequestWebView];
    cc.isTitle = YES;
    [self.navigationController pushViewController:cc animated:YES];
    //    [self performSegueWithIdentifier:@"toVipUpgrade" sender:self];
}




-(void)returnedMerchandisePage
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        [self performSelector:@selector(showDownloadView) withObject:nil afterDelay:0.5];
        //[self showDownloadView];
    }else{
        
    }
}


#pragma mark BUTTON  CLICK

- (void)settleButtonClicked:(id)sender {
    NSString *jid;
    NSMutableArray *arrIMGoods = [[NSMutableArray alloc] initWithCapacity:0];
    for (GoodsInfoDetailsDTO *goodsInfo in _arrColorItems) {
        //GoodsInfoDetailsDTO *goodsInfo = dic[@"list"];
        
        
        //组装信息
        IMGoodsInfoDTO * goodsInfoDTO = [[IMGoodsInfoDTO alloc] init];
        
        goodsInfoDTO.merchantName = goodsInfo.merchantName;
        goodsInfoDTO.sessionType = 1;
        goodsInfoDTO.goodColor = goodsInfo.color;
        if([goodsInfo.goodsType isEqualToString:@"0"]) {
            
            goodsInfoDTO.goodPic = [[[goodsInfo windowImageList] objectAtIndex:0] objectForKey:@"picUrl"];
        }else {
            
            goodsInfoDTO.goodPic = @"04_商品列表_邮费专拍";
        }
        
        goodsInfoDTO.isBuyModel = goodsInfo.buyMode;
        goodsInfoDTO.merchantNo = goodsInfo.merchantNo;
        goodsInfoDTO.goodsNo = goodsInfo.goodsNo;
        goodsInfoDTO.cartType = goodsInfo.goodsType;

        goodsInfoDTO.totalQuantity = [NSNumber numberWithInteger:[goodsInfo totalQuantity]];
        goodsInfoDTO.skuList = goodsInfo.skuList;
        goodsInfoDTO.price = goodsInfo.price;
        goodsInfoDTO.samplePrice = goodsInfo.samplePrice;
        
        if ([goodsInfo.sampleSkuInfo isKindOfClass:[NSDictionary class]]) {
            goodsInfoDTO.sampleSkuNo = goodsInfo.sampleSkuInfo[@"skuNo"];
        }
        
        goodsInfoDTO.batchNumLimit = goodsInfo.batchNumLimit;
        goodsInfoDTO.stepPriceList = goodsInfo.stepList;
        goodsInfoDTO.goodsWillNo = goodsInfo.goodsWillNo;
        goodsInfoDTO.shopLevel =  goodsInfo.shopLevel;
        jid = goodsInfo.JID;
        [arrIMGoods addObject:goodsInfoDTO];
    }
    
    
//    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:_goodsInfoDetailsDTO,@"list",_modeStateSelected?@"0":@"1",@"model",[NSString stringWithFormat:@"%.2f", presentPrice], @"presentPrice", nil];
//    
    
   
    if (jid) {
        ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:_goodsInfoDetailsDTO.merchantName jid:jid withArray:arrIMGoods];
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    }else {
        [self getJID:_goodsInfoDetailsDTO.merchantNo withArray:arrIMGoods];
    }
  
}
//店铺详情
- (void)goodsViewControllerCell{
    
    [hud show:YES];
    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:_goodsInfoDetailsDTO.merchantNo pageNo:nil pageSize:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
            
            if (merchantListDTO.merchantList.count > 0) {
                //[self rebackNextWindow];
                
                MerchantListDetailsDTO *merchantDetailDTO = [merchantListDTO.merchantList lastObject];
               
                MerchantDeatilViewController *vc =[[MerchantDeatilViewController alloc]init];
                vc.merchantNo = merchantDetailDTO.merchantNo;
                [self.navigationController pushViewController:vc animated:YES];
                
    
                
            } else {
                
                [self.view makeMessage:@"查询商家列表失败,查看服务器" duration:2.0f position:@"center"];
                
            }
            
        }
        [hud hide:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hide:YES];
    }];
    
}

- (void)topButtonClick:(UIButton *)sender{
    
    //结束加载
    [self.bottomRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
      self.goodsInfoTableView.contentOffset = CGPointMake(0, 0);
    //下拉
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.scrollView.contentOffset = CGPointMake(0, 0);
      
    } completion:^(BOOL finished) {
        
    }];
}

- (void)tapImage:(NSIndexPath *)indexPath
{
    
    CSPGoodsInfoSubPicsTableViewCell *cell1 =  [_imageTableView cellForRowAtIndexPath:indexPath];
    NSArray *imageList =_showObjectiveImage?_goodsInfoDetailsDTO.objectiveImageList: _goodsInfoDetailsDTO.referImageList;
    
    
    
    //NSDictionary *getReferenceImagesDic = _showObjectiveImage?objectiveImagesDic:referenceImagesDic;
    int count =(int) bottomTableViewRowCount;
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        NSDictionary *getReferenceImagesDic = [imageList objectAtIndex:i];
        
        NSString *urlStr = getReferenceImagesDic[@"picUrl"];
        // 替换为中等尺寸图片
        NSURL *url = [NSURL URLWithString:urlStr];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = url; // 图片路径
        photo.srcImageView = cell1.imgView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
   // browser.showKeyWindow = YES;
    browser.currentPhotoIndex = hasText?indexPath.row-1:indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)backButtonClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)showNotLevelReadTipForCommodityProperty:(NSString*)goodsNo andtype:(CSPAuthorityType)autority{
    NSString *type = @"1";
    if (autority == CSPAuthorityCollection) {
        type = @"4";
    }else if (autority == CSPAuthorityDownload){
        type =@"2";
    }else if (autority == CSPAuthorityShare){
        type = @"3";
    }
    
    [HttpManager sendHttpRequestForGetGoodsNotLevelTipWithGoodsNo:goodsNo authType:type success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            //参数需要保存
            goodsNotLevelTipDTO = [[GoodsNotLevelTipDTO alloc] init];
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                [goodsNotLevelTipDTO setDictFrom:[dic objectForKey:@"data"]];
                if (popView == nil) {
                    popView = [self instanceAuthorityPopView];
                    popView.frame = self.view.bounds;
                    popView.goodsNotLevelTipDTO = goodsNotLevelTipDTO;
                    popView.CSPauthority = autority;
                    popView.delegate = self;
                    
                    
                    [self alertTipsPreInitWithContentView];
                }
                [self.view addSubview:popView];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}
- (void)showDownloadViewNotification{
    
    
    if ([_goodsInfoDetailsDTO.downloadAuth isEqualToString:@"0"]) {
        
        [self showNotLevelReadTipForCommodityProperty:_goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityDownload];
        
    }else{
        
        [self getdownloadImageInfo];
        
    }
    
}
-(void)stopDownloadingNotification{
    [self updateDownloadStateOnDownloading:NO];
}

/*
 更新下载按钮的状态
 */
-(void)updateDownloadStateOnDownloading:(BOOL)downloading
{
     NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
     CSPGoodsInfoTopInfoTableViewCell *cell = [self.goodsInfoTableView cellForRowAtIndexPath:topInfoCellIndex];
    _infiniteDownloadButton = cell.downBtn;
    
      InfiniteDownloadButton *collectionButton = [threeButtonArray objectAtIndex:1];
    
    if (!downloading) {
        [_infiniteDownloadButton setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateNormal];
        [collectionButton setBackgroundImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"] forState:UIControlStateNormal];
        [_infiniteDownloadButton stop];
        [collectionButton stop];
      // [cell.downBtn stop];
    }else{
        [_infiniteDownloadButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [collectionButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
        [collectionButton start];
        [_infiniteDownloadButton start];

       // [cell.downBtn start];

    }
}


- (void)showDownloadView
{
    //    if (![array isKindOfClass:[NSArray class]]) {
    //        array = [(NSDictionary *)array objectForKey:@"list"];
    //    }
    
    UIView *view = [SGActionView showDownloadView:self.listArray];
    [view setFrame:CGRectMake(0,self.view.frame.size.height - view.frame.size.height+64, self.view.frame.size.width,view.frame.size.height)];
    
//    [self.view addSubview:view];
//    [self.view bringSubviewToFront:view];
    _downView.hidden = NO;
    _downView  = view;
  // [downView addSubview:view];
//    [_nextWindow keepDown:YES];
//    [_nextWindow setPanGestureEnabled:NO];
    
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:NO];
//    ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView = view;
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).view bringSubviewToFront:((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView];
    
}
- (void)dismissDownloadViewNotification{
    
    for (id obj in _downView.subviews) {
        
        if ([obj isKindOfClass:[SGActionView class]]) {
            SGActionView *shareOBJ = (SGActionView *)obj;
            [shareOBJ removeFromSuperview];
            shareOBJ = nil;
        }
    }
    _downView.hidden = YES;
//    for (id obj in ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView.subviews) {
//        
//        if ([obj isKindOfClass:[CSPShareView class]]) {
//            CSPShareView *shareOBJ = (CSPShareView *)obj;
//            [shareOBJ removeFromSuperview];
//            shareOBJ = nil;
//        }
//    }
    

}

-(void)collectButtonNotification
{
    
    if ([_goodsInfoDetailsDTO.goodsCollectAuth isEqualToString:@"0"])
    {
        [self showNotLevelReadTipForCommodityProperty:_goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityCollection];
    }else{
        [self collectWithgoodNo:_goodsInfoDetailsDTO.goodsNo];
        
    }
}

- (void)showShareViewNotification{
    
    if ([_goodsInfoDetailsDTO.shareAuth isEqualToString:@"0"])
    {
        [self showNotLevelReadTipForCommodityProperty:_goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityShare];
    }else{
        [self showShareView];
    }
    
}

- (void)showShareView{
    
//    if (!_nextWindow.isDownState) {
//        
//        [_nextWindow keepDown:YES];
//    }
//    
//    
    CGFloat windowHeight = self.view.frame.size.height - self.view.frame.size.width;
//    
//    if ([UIScreen mainScreen].bounds.size.height==480) {
//        
//        windowHeight = _nextWindow.windowHeaderHeight+90;
//        
//        [_nextWindow moveNextViewtoHeight:windowHeight];
//    }
    
    if (nil == shareView) {
        
        shareView = [[[NSBundle mainBundle] loadNibNamed:@"CSPShareView" owner:self options:nil] objectAtIndex:0];
    }
    

    
    
    shareView.delegate = self;
    shareView.hidden = NO;
    shareView.frame = CGRectMake(0, 0,self.view.frame.size.width,windowHeight);
    
//    [_nextWindow setPanGestureEnabled:NO];
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:NO];
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView addSubview: shareView];
//    
//    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).view bringSubviewToFront:((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView];
    
}

#pragma mark  通知 方法
- (void)goodsCountChanged:(NSNotification*)note{
    
    NSDictionary *dic = [note userInfo];
    NSInteger count = [dic[@"totalCount"] integerValue];
    
    if (totalCount!=count) {
        GoodsInfoDetailsDTO *goodsDto = [_arrColorItems objectAtIndex:color_item];
        goodsDto.buyNum = count;
        
        [self calculatePresentTotalPrice:count withStepList:_goodsInfoDetailsDTO.stepList];
        
        totalCount = count;
        
//        if (presentPrice!=oldPrice) {
//            
//            NSIndexPath* topInfoCellIndex = [NSIndexPath indexPathForRow:1 inSection:0];
//            [self.goodsInfoTableView reloadRowsAtIndexPaths:@[topInfoCellIndex] withRowAnimation:UITableViewRowAnimationNone];
//        }
        
        NSIndexPath* countCellIndex ;
        
        if (_hasSampleSku) {
            countCellIndex = [NSIndexPath indexPathForRow:4 inSection:0];
        }else{
            countCellIndex = [NSIndexPath indexPathForRow:3 inSection:0];
        }
        
        [self updateConsultData];
        [self.goodsInfoTableView reloadRowsAtIndexPaths:@[countCellIndex] withRowAnimation:UITableViewRowAnimationNone];
    }
 
}
- (void)goodsColorChanged:(NSNotification*)note{
    [self.view endEditing:YES];
    [hud show:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //刷新完成
        NSDictionary *dic = [note userInfo];
        NSInteger count = [dic[@"colorTag"] integerValue];
        color_item = count;
        _goodsInfoDetailsDTO = nil;
        _goodsInfoDetailsDTO = [_arrColorItems objectAtIndex:count];
        _modeStateSelected = _goodsInfoDetailsDTO.buyMode;
        totalCount = _goodsInfoDetailsDTO.buyNum;
        objectattStyle = ObjectStyleObject;
        [self objectiveState:ObjectStyleObject];
        _showObjectiveImage = YES;
        [self getObjectiveImages];
        //[self objectiveImgBtnClicked:nil];
        
        [self getDataSuccess];
    });
  
}
- (void)modeStateChangedNotification:(NSNotification *)note{
    _modeStateSelected = !_modeStateSelected;
    
     GoodsInfoDetailsDTO *goodsDto = [_arrColorItems objectAtIndex:color_item];
    goodsDto.buyMode = _modeStateSelected;
    [self updateConsultData];
    [self.goodsInfoTableView reloadData];
}

- (void)objectiveOrRefrenceButtonClicked:(NSNotification *)note{
    
    NSDictionary *dic = [note userInfo];
    NSString *buttonType = dic[@"type"];
    
    if ([buttonType isEqualToString:@"objectiveButton"]) {
        
        _showObjectiveImage = YES;
        [self getObjectiveImages];
    }else{
        _showObjectiveImage = NO;
        [self getReferenceImages];
    }
    
    [self.goodsInfoTableView reloadData];
    [self.imageTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma  mark create TableViewCell 
-(CSPGoodsInfoTopTableViewCell *)createCSPGoodsInfoTopTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoTopTableViewCell *topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopTableViewCell"];
    if (!topcell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoTopTableViewCell"];
        topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopTableViewCell"];
    }
    topcell.imagesArr = [self getWindowsImageURLs];
    
    return topcell;
}
-(CSPGoodsInfoTopInfoTableViewCell *)createCSPGoodsInfoTopInfoTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoTopInfoTableViewCell *topInfoCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopInfoNewTableViewCell"];
    if (!topInfoCell)
    {
        topInfoCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsInfoTopInfoTableViewCell" owner:self options:nil]objectAtIndex:1];

    }
    topInfoCell.goodName.text = [NSString stringWithFormat:@"%@\n",_goodsInfoDetailsDTO.goodsName];
    [topInfoCell.saveBtn addTarget:self action:@selector(collectButtonNotification) forControlEvents:UIControlEventTouchUpInside];
     [topInfoCell.downBtn addTarget:self action:@selector(showDownloadViewNotification) forControlEvents:UIControlEventTouchUpInside];
    [topInfoCell.downBtn setTileDuration:2.f];
    [topInfoCell.downBtn setTileImage:[UIImage imageNamed:@"06_商品详情_正常购买_下载箭头"]];
    [topInfoCell.downBtn setDirection:InfiniteDownloadDirectionTopToBottom];
//    if (totalCount>=[_goodsInfoDetailsDTO.batchNumLimit integerValue]) {
//        topInfoCell.price.text = [NSString stringWithFormat:@"%.2lf",presentPrice];
//    }else{
//        topInfoCell.price.text = [NSString stringWithFormat:@"%.2f",[_goodsInfoDetailsDTO.price floatValue]];
//    }
    topInfoCell.price.text = [NSString stringWithFormat:@"%.2f",[_goodsInfoDetailsDTO.price floatValue]];
    topInfoCell.memberLevel.text = [NSString stringWithFormat:@"V%@会员价",_goodsInfoDetailsDTO.shopLevel];
    if ([MyUserDefault loadIsAppleAccount]) {
        topInfoCell.memberLevel.hidden = YES;
    }else{
        topInfoCell.memberLevel.hidden = NO;
    }
    if ([_goodsInfoDetailsDTO.isFavorite isEqualToString:@"0"]) {
        
        [topInfoCell.saveBtn setSelected:YES];
    }else{
        [topInfoCell.saveBtn setSelected:NO];
    }
    topInfoCell.TopBar.tag = 999;
    topInfoCell.TopBar.hidden = showNavBtn;
    topInfoCell.stepList = _goodsInfoDetailsDTO.stepList;
    [topInfoCell setModeState:_modeStateSelected];
    
    topInfoCell.showLine = YES;
    return topInfoCell;
}

-(CSPBaseTableViewCell *)createCSPBaseTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPBaseTableViewCell *colorCell = [tableView dequeueReusableCellWithIdentifier:@"colorCell"];
    UILabel *colorLabel;
    if (!colorCell) {
          colorCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"colorCell"];
        colorLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 200, 14)];
        colorLabel.font = [UIFont systemFontOfSize:14];
        [colorCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [colorCell addSubview:colorLabel];

    }
    colorLabel.text = [NSString stringWithFormat:@"颜色: %@",_goodsInfoDetailsDTO.color];
    UIColor *modeStateColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.35];
    if (_modeStateSelected) {
        colorLabel.textColor = modeStateColor;
    }else{
        colorLabel.textColor = [UIColor blackColor];
    }

    return colorCell;
}
-(CSPColorSizeTableViewCell *)createCSPGoodsInfoSizeTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{

    CSPColorSizeTableViewCell *sizeCell  = [_goodsInfoTableView dequeueReusableCellWithIdentifier:@"CSPColorSizeTableViewCell"];
    if (!sizeCell)
    {
        [_goodsInfoTableView registerNib:[UINib nibWithNibName:@"CSPColorSizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPColorSizeTableViewCell"];
        sizeCell = [_goodsInfoTableView dequeueReusableCellWithIdentifier:@"CSPColorSizeTableViewCell"];
    }
  
    sizeCell.select_itm =  color_item;
    sizeCell.skuList = _goodsInfoDetailsDTO.skuList;
    sizeCell.colorList = _arrColorItems;
    sizeCell.minLabel.text = [NSString stringWithFormat:@"%@起批量%@件",_goodsInfoDetailsDTO.color,_goodsInfoDetailsDTO.batchNumLimit];
    [sizeCell setModeState:_modeStateSelected];
   
    //sizeCell.separatorInset = UIEdgeInsetsMake(0, 600, 0, sizeCell.bounds.size.width);
    
    return sizeCell;
}
-(CSPColorSizeTableViewCell *)createCSPGoodsInfoSizeTableViewCells:(NSIndexPath *)index withTable:(UITableView *)tableView{
    
    CSPColorSizeTableViewCell *sizeCell  = [_goodsInfoTableView dequeueReusableCellWithIdentifier:@"CSPColorSizeTableViewCells"];
    if (!sizeCell)
    {
        [_goodsInfoTableView registerNib:[UINib nibWithNibName:@"CSPColorSizeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPColorSizeTableViewCells"];
        sizeCell = [_goodsInfoTableView dequeueReusableCellWithIdentifier:@"CSPColorSizeTableViewCells"];
    }
    
    sizeCell.select_itm =  color_item;
    sizeCell.skuList = _goodsInfoDetailsDTO.skuList;
    sizeCell.colorList = _arrColorItems;
    sizeCell.minLabel.text = [NSString stringWithFormat:@"%@起批量%@件",_goodsInfoDetailsDTO.color,_goodsInfoDetailsDTO.batchNumLimit];
    [sizeCell setModeState:_modeStateSelected];
    
    //sizeCell.separatorInset = UIEdgeInsetsMake(0, 600, 0, sizeCell.bounds.size.width);
    
    return sizeCell;
}
-(CSPGoodsInfoModelTableViewCell *)createCSPGoodsInfoModelTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoModelTableViewCell *modelCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoModelTableViewCell"];
    if (!modelCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoModelTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoModelTableViewCell"];
        modelCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoModelTableViewCell"];
    }
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@样板价:  ¥ %@",_goodsInfoDetailsDTO.color,_goodsInfoDetailsDTO.samplePrice] ];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(0, 6+[_goodsInfoDetailsDTO.color length])];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10.0] range:NSMakeRange(6+[_goodsInfoDetailsDTO.color length], 1)];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0] range:NSMakeRange(7+[_goodsInfoDetailsDTO.color length], [str length]-7-[_goodsInfoDetailsDTO.color length])];
    // modelCell.priceL.text = strText;//[NSString stringWithFormat:@"样板价:¥ %@",_goodsInfoDetailsDTO.samplePrice];
    modelCell.priceL.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    [modelCell.priceL setAttributedText:str];
    
    [modelCell setModeState:_modeStateSelected];

    return modelCell;
}
-(CSPGoodsInfoCountTableViewCell *)createCSPGoodsInfoCountTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoCountTableViewCell *countCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoCountTableViewCell"];
    if (!countCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoCountTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoCountTableViewCell"];
        countCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoCountTableViewCell"];
    }
    countCell.selectNums = _arrColorItems;
    [countCell setModeState:_modeStateSelected];


    return countCell;
}
-(CSPGoodsInfoMixConditonTableViewCell *)createCSPGoodsInfoMixConditonTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoMixConditonTableViewCell *mixConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
    if (!mixConditionCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoMixConditonTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
        mixConditionCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoMixConditonTableViewCell"];
    }
    if ([_goodsInfoDetailsDTO.batchMsg length] > 0) {
        mixConditionCell.alphaView.hidden = NO;
        mixConditionCell.mixL.hidden = NO;
        mixConditionCell.titleL.hidden = NO;
        [mixConditionCell updateBatchMsg:_goodsInfoDetailsDTO.batchMsg];
        [mixConditionCell setModeState:_modeStateSelected];
    }else{
        mixConditionCell.alphaView.hidden = YES;
        mixConditionCell.mixL.hidden = YES;
        mixConditionCell.titleL.hidden = YES;
    }

    return mixConditionCell;
}
-(CSPGoodsInfoShopTableViewCell *)createCSPGoodsInfoShopTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoShopTableViewCell *shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoShopTableViewCell"];
    if (!shopCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoShopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoShopTableViewCell"];
        shopCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoShopTableViewCell"];
    }
    
    
     NSMutableAttributedString * str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"进入%@", _goodsInfoDetailsDTO.merchantName] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f], NSForegroundColorAttributeName: [UIColor colorWithHexValue:0x000000 alpha:1]}];
    

     [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexValue:0x666666 alpha:1] range:NSMakeRange(0, 2)];
  
    shopCell.shopName = str ; //[NSString stringWithFormat:@"进入%@", _goodsInfoDetailsDTO.merchantName];
    shopCell.termL.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    shopCell.msg = _goodsInfoDetailsDTO.batchMsg;
    shopCell.termL.text = _goodsInfoDetailsDTO.batchMsg;
    shopCell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"10_设置_进入"]];
    return shopCell;
}


-(CSPGoodsInfoSubTipsTableViewCell *)createCSPGoodsInfoSubTipsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoSubTipsTableViewCell *tipsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
    if (!tipsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSubTipsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
        tipsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubTipsTableViewCell"];
    }
    return tipsCell;
}

-(CSPGoodsInfoSubPicsTableViewCell *)createCSPGoodsInfoSubPicsTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoSubPicsTableViewCell *picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    if (!picsCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoSubPicsTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
        picsCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoSubPicsTableViewCell"];
    }
    if (_showObjectiveImage) {
        
        if (bottomTableViewRowCount>0) {
            NSArray *imageList = _goodsInfoDetailsDTO.objectiveImageList;
            
            NSDictionary *getObjectiveImagesDic = [imageList objectAtIndex:hasText?index.row-1:index.row];
            
            NSString *urlStr = getObjectiveImagesDic[@"picUrl"];
            
            picsCell.row = hasText?index.row-1:index.row;
            picsCell.url = urlStr;
            
        }
        
        
    }else{
        
        if (bottomTableViewRowCount>0) {
            NSArray *imageList = _goodsInfoDetailsDTO.referImageList;
            NSDictionary *getReferenceImagesDic = [imageList objectAtIndex:index.row];
            NSString *urlStr = getReferenceImagesDic[@"picUrl"];
            
            picsCell.row = index.row;
            picsCell.url = urlStr;
        }
        
    }
    return picsCell;
}
-(CSPGoodsInfoNoticeTableViewCell *)createCSPGoodsInfoNoticeTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoNoticeTableViewCell *noticeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
    if (!noticeCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoNoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
        noticeCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoNoticeTableViewCell"];
    }
    noticeCell.noticeL.text = noticeMsg;
    noticeCell.showLine = NO;
    return noticeCell;
}


-(CSPBaseTableViewCell *)createRootTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPBaseTableViewCell *rootCell = [tableView dequeueReusableCellWithIdentifier:@"rootCell"];
    if (!rootCell) {
        rootCell = [[CSPBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"rootCell"];
     
    }
  

    
    rootCell.showLine = NO;
    return rootCell;
}
-(CSPGoodsInfoTextTableViewCell *)createCSPGoodsInfoTextTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPGoodsInfoTextTableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTextTableViewCell"];
    if (!textCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoTextTableViewCell"];
        textCell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTextTableViewCell"];
    }

     NSArray *arr = [_goodsInfoDetailsDTO.details componentsSeparatedByString:@"\n"];
//    if (arr.count > 1) {
        textCell.infoLabel.text = _goodsInfoDetailsDTO.details;
        
        textCell.infoString =_goodsInfoDetailsDTO.details;
////    }else {
//        textCell.infoLabel.text = _goodsInfoDetailsDTO.details;
//        
////    }

 
    return textCell;
}
-(CSPAttrTableViewCell *)createCSPAttrTableViewCell:(NSIndexPath *)index withTable:(UITableView *)tableView{
    CSPAttrTableViewCell *attrCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAttrTableViewCell"];
    if (!attrCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPAttrTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPAttrTableViewCell"];
        attrCell = [tableView dequeueReusableCellWithIdentifier:@"CSPAttrTableViewCell"];
    }
   
    AttrListDTO *attrListDTO = [attrImageArray objectAtIndex:index.row];
    [attrCell setAttrListDTO:attrListDTO];
    return attrCell;
}

// 获取当前设备可用内存及所占内存的头文件
// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}
// 获取当前任务所占用的内存（单位：MB）
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO,
                                         (task_info_t)&taskInfo,
                                         &infoCount);
    if (kernReturn != KERN_SUCCESS ) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}


#pragma mark === 暂时不用清除缓存=====
-(void)myClearCacheAction{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}


-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    
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
