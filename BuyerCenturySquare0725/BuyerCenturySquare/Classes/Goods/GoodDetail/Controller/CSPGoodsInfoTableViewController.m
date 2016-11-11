//
//  CSPGoodsInfoTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/7/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "MWWindow.h"

#import "WXApi.h"

#import "CSPGoodsInfoTableViewController.h"
#import "CSPGoodsInfoTopTableViewCell.h"
#import "CSPGoodsInfoSubViewController.h"
#import "ConversationWindowViewController.h"
#import "CSPGoodsInfoSubAccountTableViewCell.h"

#import "HttpManager.h"
#import "GoodsInfoDetailsDTO.h"
#import "StepListDTO.h"
#import "ImageListDTO.h"
#import "SkuListDTO.h"
#import "GoodsInfoDTO.h"
#import "CartAddDTO.h"
#import "MerchantListDetailsDTO.h"

#import "MerchantDeatilViewController.h"//!商家商品列表
#import "CSPShareView.h"
#import "SGActionView.h"
#import "BasicSkuDTO.h"

#import "ReplenishmentByMerchantDTO.h"

#import "CSPPicDownloadView.h"
#import "CSPAuthorityTitlePopView.h"
#import "MerchantListDTO.h"
#import "AppDelegate.h"
#import "CSPAuthorityPopView.h"
#import "CommodityListPropertyDTO.h"
#import "CommodityGroupListDTO.h"
#import "GetGoodsShareLinkDTO.h"
#import "MemberInfoDTO.h"
#import "CSPVIPUpdateViewController.h"

#import "DownloadLogControl.h"
#import "GetDownloadImageListDTO.h"
#import "DownloadImageDTO.h"
#import "PictureDTO.h"
#import "InfiniteDownloadButton.h"


#import "MembershipUpgradeViewController.h"
#import "MembershipGradeRulesViewController.h"
#import "CustomBarButtonItem.h"

#import "CSPPayAvailabelViewController.h"

@interface CSPGoodsInfoTableViewController ()<CSPShareViewDelegate,CSPAuthorityPopViewDelegate,CSPShareViewDelegate,CSPAuthorityTitlePopViewDelegate,RefreshControlDelegate,MembershipUpgradeViewControllerDelegate>
{
    GoodsInfoDetailsDTO *goodsInfoDetailsDTO;
    CSPShareView *shareView;
    CSPGoodsInfoSubViewController *vc;
    CSPGoodsInfoSubViewController *contentVC;
    GoodsNotLevelTipDTO *goodsNotLevelTipDTO;
    //分享链接
    GetGoodsShareLinkDTO *getGoodsShareLinkDTO;
    BOOL nextWindowFullScreenState;
    
    CSPAuthorityPopView* popView;
    CSPAuthorityTitlePopView *popTitleView;
    
    MBProgressHUD *hud;
    
    NSArray *threeButtonArray;
    NSInteger naviViewTag;
    
    UIButton * leftBackBtn;//!导航左按钮
    CGPoint pointScrollPoint ;
    CGPoint pointTablePoint;
    
    MembershipUpgradeViewController *membershipUpgradeVC;
    
    
}
@property (nonatomic, strong) MWWindow *nextWindow;
@property (nonatomic, strong) NSMutableArray *listArray;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@property (nonatomic,strong) InfiniteDownloadButton *infiniteDownloadButton;

@property (nonatomic, assign) BOOL isDownloading;

/**
 *  剩余下载次数
 */
@property(nonatomic,assign)NSInteger residueDownload;

/**
 *  如果选择窗口图=1，如果选择客观图=1，如果选择窗口图和客观图=0
 */
@property(nonatomic,assign)NSInteger cancelDownloadCount;

@end

@implementation CSPGoodsInfoTableViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self prePush];
        nextWindowFullScreenState = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"goodsDetailTitle", @"商品详情");
    
    
    leftBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBackBtn.frame = CGRectMake(0, 0, 10, 18);
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@"public_nav_back"] forState:UIControlStateSelected];
    [leftBackBtn addTarget:self action:@selector(backBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];

    
    [self getShareUrl];
    
    contentVC = [[CSPGoodsInfoSubViewController alloc]init];
    
    [_contentView addSubview:contentVC.view];
    
    
    
    //获取会员信息
    [HttpManager sendHttpRequestGetMemberInfoSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            [[MemberInfoDTO sharedInstance] setDictFrom:[dic objectForKey:@"data"]];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    _contentViewTopConstraint.constant = [UIScreen mainScreen].bounds.size.height - [UIScreen mainScreen].bounds.size.width-64;
    
    [_contentView setHidden:YES];
    
    [self.tableView setScrollEnabled:NO];
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    refreshHeader.beginRefreshingOperation = ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kMJRefreshDataNotification object:nil];
    };
    
    hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud show:YES];
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    
    naviViewTag = timeInterval;
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(consultAndSettleButtonClicked:) name:kConsultAndSettleButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(MJRefreshRefreshing:) name:kNextWindowPanDownNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshFinished) name:kMJRefreshDataFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissDownloadViewNotification) name:kSGActionViewDismissNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showDownloadViewNotification) name:kDownloadButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(collectButtonNotification) name:kCollectButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showShareViewNotification) name:kShareButtonClickedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goodsViewControllerCell) name:kGoodsInfoShopTableViewCellClicked object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showThreeAnimationButton) name:kNextWindwoUpToNaviAnimationBegin object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissThreeAnimationButton) name:kNextWindwoDownAnimationBegin object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenWindown) name:kNextWindowHiddenAnimation object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showWindown) name:kNextWindowShowAnimation object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopDownloadingNotification) name:kStopDownAnimation object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(WMPanEnable:) name:kWMPanEnable object:nil];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downloadPic:) name:kSGActionViewDownload object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(overWindown) name:kNextWindowOverAnimation object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fullWindown) name:kNextWindowFullAnimation object:nil];


}



- (void)MJRefreshRefreshing:(NSNotification *)note{
    
    if ([note userInfo]) {
        _nextWindow.refreshState = YES;
        [self.refreshHeader beginRefreshing];
    }
}

- (void)refreshFinished{
    
    _nextWindow.refreshState = NO;
    [self.refreshHeader endRefreshing];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self push];
    //    [self requestForGetDownloadImageList];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    _nextWindow.hidden = NO;
    
    [self hideThreeAnimationButton:NO];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataSuccess) name:kGoodsInfoHttpSuccessNotification object:nil];
   
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self hideThreeAnimationButton:YES];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindowPanDownNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMJRefreshDataFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kConsultAndSettleButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kWMPanEnable object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSGActionViewDismissNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDownloadButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kCollectButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kShareButtonClickedNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsInfoShopTableViewCellClicked object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kGoodsInfoHttpSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindwoUpToNaviAnimationBegin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindwoDownAnimationBegin object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindowShowAnimation object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindowHiddenAnimation object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kStopDownAnimation object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kSGActionViewDownload object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindowFullAnimation object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNextWindowOverAnimation object:nil];

}

- (void)viewDidDisappear:(BOOL)animated{
    _nextWindow.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CSPAuthorityPopView*)instanceAuthorityPopView {
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityPopView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

#pragma mark - Private Functions

//MWWindow
- (void)push{
    
    if (nextWindowFullScreenState) {
        [_nextWindow fullUpState];
        nextWindowFullScreenState = NO;
    }else{
        [self dismissThreeAnimationButton];
        [_nextWindow beginStateToUP];
        
    }
}

- (void)prePush{
    
    if (_nextWindow) {
        [_nextWindow removeFromSuperview];
    }
    
    _nextWindow = [[MWWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _nextWindow.windowLevel = UIWindowLevelAlert;
    vc = [[CSPGoodsInfoSubViewController alloc]init];
    _nextWindow.rootViewController = vc;
    [_nextWindow makeKeyAndVisible];
}
- (void)backBarButtonClick{
    
    [self removeThreeAnimationButton];
    [self backButtonClicked];
    
    
}

- (void)backButtonClicked{
    _nextWindow.hidden = YES;
    [_nextWindow close];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataSuccess{
    
    goodsInfoDetailsDTO = [GoodsInfoDTO sharedInstance].goodsInfoDetailsInfo;
    
    [self.tableView reloadData];
    
    [hud hide:YES];
    
}

//- (void)requestForGetDownloadImageList{
//
//    if (!goodsInfoDetailsDTO.goodsNo) {
//        return;
//    }
//
//    //获取图片信息
//    NSDictionary *firstImage = @{@"goodsNo":goodsInfoDetailsDTO.goodsNo,@"downLoadType":@"3"};
//
//    NSMutableArray *imageDownloadArray = [[NSMutableArray alloc] init];
//    [imageDownloadArray addObject:firstImage];
//
//    [HttpManager sendHttpRequestForGetDownloadImageList:imageDownloadArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//
//        NSLog(@"dic = %@",dic);
//
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//
//            GetDownloadImageListDTO* getDownloadImageListDTO = [[GetDownloadImageListDTO alloc] init];
//
//            getDownloadImageListDTO.downloadImageDTOList = [dic objectForKey:@"data"];
//
//            self.listArray = getDownloadImageListDTO.downloadImageDTOList;
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
//    }];
//
//}

//询单结算
- (void)consultAndSettleButtonClicked:(NSNotification*)note{
    
    nextWindowFullScreenState = NO;
    
    NSDictionary *dic = [note userInfo];
    
    GoodsInfoDetailsDTO *goodsInfo = dic[@"list"];
    BOOL hasSelectedModel = [dic[@"model"] isEqualToString:@"0"]?YES:NO;
    
    [MWWindow dismissAllMWWindows];
    
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
    
    goodsInfoDTO.isBuyModel = hasSelectedModel;
    goodsInfoDTO.merchantNo = goodsInfo.merchantNo;
    goodsInfoDTO.goodsNo = goodsInfo.goodsNo;
    goodsInfoDTO.cartType = goodsInfo.goodsType;
    goodsInfoDTO.price = [NSNumber numberWithFloat:[dic[@"presentPrice"] floatValue]];
    goodsInfoDTO.totalQuantity = [NSNumber numberWithInteger:[goodsInfo totalQuantity]];
    goodsInfoDTO.skuList = goodsInfo.skuList;
    goodsInfoDTO.samplePrice = goodsInfo.samplePrice;
    if ([goodsInfo.sampleSkuInfo isKindOfClass:[NSDictionary class]]) {
        goodsInfoDTO.sampleSkuNo = goodsInfo.sampleSkuInfo[@"skuNo"];
    }
    NSLog(@"dic===%@",goodsInfo.sampleSkuInfo);
    //    else{
    //
    ////        [self alertWithAlertTip:@"接口数据sampleSkuInfo缺失"];
    //
    //    }
    goodsInfoDTO.batchNumLimit = goodsInfo.batchNumLimit;
    goodsInfoDTO.stepPriceList = goodsInfo.stepList;
    
    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:goodsInfo.merchantName jid:goodsInfo.JID withGood:goodsInfoDTO];
    
    [self.navigationController pushViewController:conversationVC animated:YES];
}


//店铺详情
- (void)goodsViewControllerCell{
    
    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:goodsInfoDetailsDTO.merchantNo pageNo:nil pageSize:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            
            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
            
            if (merchantListDTO.merchantList.count > 0) {
                [self rebackNextWindow];
                
                MerchantListDetailsDTO *merchantDetailDTO = [merchantListDTO.merchantList lastObject];

                
                MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
                detailVC.merchantNo = merchantDetailDTO.merchantNo;
                
                [MWWindow dismissAllMWWindows];

                [self.navigationController pushViewController:detailVC animated:YES];

        
                
            } else {
                
                [self.view makeMessage:@"查询商家列表失败,查看服务器" duration:2.0f position:@"center"];
               
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)getGoodsViewData{
    
    
}

- (NSArray *)getWindowsImageURLs{
    
    NSArray *imageList = goodsInfoDetailsDTO.windowImageList;
    
    
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
- (void)WMPanEnable:(NSNotification *)note{
    
    BOOL enablePan = [[[note userInfo] objectForKey:@"enable"] isEqualToString:@"0"]?YES:NO;
    
    [_nextWindow setPanGestureEnabled:enablePan];
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPGoodsInfoTopTableViewCell *topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopTableViewCell"];
    
    if (!topcell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPGoodsInfoTopTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPGoodsInfoTopTableViewCell"];
        topcell = [tableView dequeueReusableCellWithIdentifier:@"CSPGoodsInfoTopTableViewCell"];
    }
    
    
    switch (indexPath.row) {
        case 0:
            topcell.imagesArr = [self getWindowsImageURLs];
            return topcell;
            break;
        default:
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark - Collect Download Share
- (void)showsevenDayError{
    
    if (popTitleView == nil) {
        popTitleView = [[[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityTitlePopView" owner:self options:nil] objectAtIndex:0];
        CGRect rect = self.tableView.frame;
        rect.origin.y =0;
        
        popTitleView.frame = rect;
        popTitleView.delegate = self;
        popTitleView.detailLabel.text = @"商家已限制所有与本店无交易往来的采购商，不可下载7日内新品。";
        [self.view addSubview:popTitleView];
        
        [self alertTipsPreInitWithContentView];
    }
    
}

-(void)showNoDownloadTimes{
    
    if (popTitleView == nil) {
        popTitleView = [[[NSBundle mainBundle] loadNibNamed:@"CSPAuthorityTitlePopView" owner:self options:nil] objectAtIndex:0];
        CGRect rect = self.tableView.frame;
        rect.origin.y =0;
        
        popTitleView.frame = rect;
        popTitleView.delegate = self;
        popTitleView.detailLabel.hidden = YES;
        popTitleView.buyTimesButton.hidden = NO;
        popTitleView.titleLabel.text = @"商品下载次数已用完";
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
    
    [_contentView setHidden:YES];
    
    [_nextWindow beginStateToUP];
}

-(void)gotoBuyDownloadTimes{
    
    [self actionWhenPopViewDimiss];
    [_nextWindow close];
    [MWWindow dismissAllMWWindows];
    
    [self performSegueWithIdentifier:@"toPayAndDownload" sender:self];
}

//弹出自定义警告窗时添加此方法
- (void)alertTipsPreInitWithContentView{
    
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
    
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:YES];
    
    [_contentView setHidden:NO];
    
    [_nextWindow close];
    
    [self removeThreeAnimationButton];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController) threeButtonSetAlphaToShow];
    
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
                    [self.view addSubview:popView];
                    
                    [self alertTipsPreInitWithContentView];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)showDownloadViewNotification{
    
    
    if ([goodsInfoDetailsDTO.downloadAuth isEqualToString:@"0"]) {
        
        [self showNotLevelReadTipForCommodityProperty:goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityDownload];
    
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
    if (!downloading) {
        [_infiniteDownloadButton stop];
        [((CSPGoodsInfoSubViewController *)_nextWindow.rootViewController).downloadButton stop];
    }else{
        [_infiniteDownloadButton start];
        [((CSPGoodsInfoSubViewController *)_nextWindow.rootViewController).downloadButton start];
    }
}


- (void)showDownloadView
{
//    if (![array isKindOfClass:[NSArray class]]) {
//        array = [(NSDictionary *)array objectForKey:@"list"];
//    }
    
    UIView *view = [SGActionView showDownloadView:self.listArray];
    [view setFrame:CGRectMake(0,_nextWindow.windowHeaderHeight-view.frame.size.height, self.view.frame.size.width,view.frame.size.height)];
    
    
   
    
    [_nextWindow keepDown:YES];
    [_nextWindow setPanGestureEnabled:NO];
    
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:NO];
    ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView = view;
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).view bringSubviewToFront:((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView];
    
}

-(void)collectButtonNotification
{
    
    if ([goodsInfoDetailsDTO.goodsCollectAuth isEqualToString:@"0"])
    {
        [self showNotLevelReadTipForCommodityProperty:goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityCollection];
    }else{
        [self collectWithgoodNo:goodsInfoDetailsDTO.goodsNo];
        
    }
}

- (void)showShareViewNotification{
    
    if ([goodsInfoDetailsDTO.shareAuth isEqualToString:@"0"])
    {
        [self showNotLevelReadTipForCommodityProperty:goodsInfoDetailsDTO.goodsNo andtype:CSPAuthorityShare];
    }else{
        [self showShareView];
    }
    
}

- (void)showShareView{
    
    if (!_nextWindow.isDownState) {
        
        [_nextWindow keepDown:YES];
    }
    
    
    CGFloat windowHeight = _nextWindow.windowHeaderHeight;
    
    if ([UIScreen mainScreen].bounds.size.height==480) {
        
        windowHeight = _nextWindow.windowHeaderHeight+90;
        
        [_nextWindow moveNextViewtoHeight:windowHeight];
    }
    
    if (nil == shareView) {
        
        shareView = [[[NSBundle mainBundle] loadNibNamed:@"CSPShareView" owner:self options:nil] objectAtIndex:0];
    }
    
    if (_nextWindow.frame.origin.y>=_nextWindow.windowHeaderHeight-10) {
        _nextWindow.refreshState = YES;//禁止动画
    }
    
    
    shareView.delegate = self;
    shareView.hidden = NO;
    shareView.frame = CGRectMake(0, 0,self.view.frame.size.width,windowHeight);
    
    [_nextWindow setPanGestureEnabled:NO];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:NO];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView addSubview: shareView];
    
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).view bringSubviewToFront:((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView];
    
}
-(void)rebackNextWindow{
    if (!_nextWindow.isDownState) {
        
        [_nextWindow keepDown:YES];
    }
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:YES];
}

- (void)getShareUrl{
    
    NSString *goodsNo = _goodsNo;
    
    [HttpManager sendHttpRequestForGetGoodsShareLink:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                getGoodsShareLinkDTO = [[GetGoodsShareLinkDTO alloc ]init];
                [getGoodsShareLinkDTO setDictFrom:[dic objectForKey:@"data"]];
            }
        }else{
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
    }];
}

- (void)dismissDownloadViewNotification{
    
    for (id obj in ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView.subviews) {
        
        if ([obj isKindOfClass:[SGActionView class]]) {
            SGActionView *shareOBJ = (SGActionView *)obj;
            [shareOBJ removeFromSuperview];
            shareOBJ = nil;
        }
    }
    
    for (id obj in ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView.subviews) {
        
        if ([obj isKindOfClass:[CSPShareView class]]) {
            CSPShareView *shareOBJ = (CSPShareView *)obj;
            [shareOBJ removeFromSuperview];
            shareOBJ = nil;
        }
    }
    
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).downloadView setHidden:YES];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).shareView setHidden:YES];
    [((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).view bringSubviewToFront:((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).navBarView];
    [_nextWindow setPanGestureEnabled:YES];
    
    _nextWindow.refreshState = NO;//允许动画
    
    if ([UIScreen mainScreen].bounds.size.height==480) {
        
        [_nextWindow moveNextViewtoHeight:_nextWindow.windowHeaderHeight];
    }
}

#pragma mark - 分享 CSPShareView Delegate

-(void)shareToWeChatFriend{
    
    BOOL isweChat = [WXApi isWXAppInstalled];
    if (isweChat){
        [self shareWXWithType:1];
    }else{
        [self alertWithAlertTip:@"您的手机未安装微信客户端"];
    }
    
}

-(void)shareToWeChatMoments{
    
    if ([WXApi isWXAppInstalled]){
        [self shareWXWithType:0];
    }else{
        [self alertWithAlertTip:@"您的手机未安装微信客户端"];
    }
}

-(void)dismissShareView
{
    [self dismissDownloadViewNotification];
}

#pragma mark--
#pragma UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self showDownloadView];
    }
}

#pragma mark -
#pragma mark CSPAuthorityPopViewDelegate

- (void)showLevelRules {
    
    [self actionWhenPopViewDimiss];
    [_nextWindow close];
    
    [MWWindow dismissAllMWWindows];
    MembershipGradeRulesViewController *membershipGradeRulesVC = [[MembershipGradeRulesViewController alloc]init];
    [self.navigationController pushViewController:membershipGradeRulesVC animated:YES];

  
//    [self performSegueWithIdentifier:@"toMemberVip" sender:self];
}

- (void)prepareToUpgradeUserLevel {
    
    [self actionWhenPopViewDimiss];
    [_nextWindow close];
    
    [MWWindow dismissAllMWWindows];
    
    
    membershipUpgradeVC = [[MembershipUpgradeViewController alloc]init];
    membershipUpgradeVC.delegate = self;
    
    [self.navigationController pushViewController:membershipUpgradeVC animated:YES];
  
//    [self performSegueWithIdentifier:@"toVipUpgrade" sender:self];
}

-(void)returnedMerchandisePage
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)jumpToPayInterfaceDic:(NSDictionary *)dic
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CSPPayAvailabelViewController *payAvailabelViewC = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
    payAvailabelViewC.dic = dic;
    //status true表示成功，false表示失败
    
    payAvailabelViewC.payStatus = ^(BOOL status)
    
    {
        
        DebugLog(@"%d", status);
        
    };
    
    [self.navigationController pushViewController:payAvailabelViewC animated:YES];
}



#pragma mark -

/*
 1 == type 微信好友
 其他  微信朋友圈
 */

- (void)shareWXWithType:(NSInteger)type{
    
    if (getGoodsShareLinkDTO) {
        
        UIImage *image = getGoodsShareLinkDTO.shareImage;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc]init];
        req.bText = NO;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = getGoodsShareLinkDTO.shareUrl;
        
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.mediaObject = ext;
        req.message = message;
        
        [message setThumbImage:image];
        
        if (type == 1) {
            req.scene = WXSceneSession;
            message.description = getGoodsShareLinkDTO.title;
        }else{
            req.scene = WXSceneTimeline;
            message.title = getGoodsShareLinkDTO.title;
        }
        [WXApi sendReq:req];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toVipUpgrade"]) {
        CSPVIPUpdateViewController *nextVC = (CSPVIPUpdateViewController *)segue.destinationViewController;
    }
    
}


-(void)collectWithgoodNo:(NSString*)goodsNo
{
    __block UIButton *collectButton = ((CSPGoodsInfoSubViewController*)_nextWindow.rootViewController).collectButton;
    
    //    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if ([goodsInfoDetailsDTO.isFavorite  isEqualToString:@"1"]) {
        [HttpManager  sendHttpRequestForAddGoodsFavoriteWithGoodsNo:goodsNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                goodsInfoDetailsDTO.isFavorite = @"0";
                
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
            
            NSLog(@"dic = %@",dic);
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                goodsInfoDetailsDTO.isFavorite = @"1";
                
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
        
        //判断下载按钮的状态
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
        
        
        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:nil objectiveFigureItems:nil windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];

//        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:nil windowFigureUrl:windowString pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];
        
        
        
    }else if([(NSString *)noti.object isEqualToString:@"1"])
    {
        
//        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:goodsInfoDetailsDTO.defaultPicUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectPicSize];

        
        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:nil windowFigureItems:nil pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];

        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString windowFigureUrl:nil pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];

        
    
    }else if ([(NSString *)noti.object isEqualToString:@"2"]){
        
        
        
    }else if ([(NSString *)noti.object isEqualToString:@"3"])
    {
        
        
//        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:goodsInfoDetailsDTO.defaultPicUrl withWindowPicSize:windowPicSize withObjectivePicSize:objectPicSize];
        
        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString objectiveFigureItems:objectImageItems windowFigureUrl:windowString windowFigureItems:windowImageItems pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];

        //        [[DownloadLogControl sharedInstance]addLogItemByGoodsNo:downloadImageDTO.goodsNo objectiveFigureUrl:imterString windowFigureUrl:windowString pictureUrl:goodsInfoDetailsDTO.defaultPicUrl];

        
    }
    
}

-(void)getdownloadImageInfo{
    //获取图片信息
    
    if (goodsInfoDetailsDTO.goodsNo == nil||[goodsInfoDetailsDTO.goodsNo isEqualToString:@""]) {
        
         [self.view makeMessage:@"没有获取到商品信息" duration:2.0f position:@"center"];
        return;
    }
    [self progressHUDShowWithString:@"正在获取图片资料"];
    NSDictionary *firstImage = @{@"goodsNo":goodsInfoDetailsDTO.goodsNo,@"downLoadType":@"3"};
    
    NSMutableArray *imageDownloadArray = [[NSMutableArray alloc] init];
    [imageDownloadArray addObject:firstImage];
    
    [HttpManager sendHttpRequestForGetDownloadImageList:imageDownloadArray success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.progressHUD hide:YES];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            id data = [dic objectForKey:@"data"];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                
                self.residueDownload = ((NSNumber *)[data objectForKey:@"remainCount"]).integerValue;
                
                id list = [data objectForKey:@"list"];
                
                if ([list isKindOfClass:[NSArray class]]) {
                    
                    GetDownloadImageListDTO* getDownloadImageListDTO = [[GetDownloadImageListDTO alloc] init];
                    
                    getDownloadImageListDTO.downloadImageDTOList = list;
                    
                    self.listArray = getDownloadImageListDTO.downloadImageDTOList;
                    
                    
                    if (![[AppDelegate currentAppDelegate]isWifiReach]) {
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"为节省流量,建议开启wifi后进行下载！" message:@"尚未开启wifi,是否继续下载" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
                        [alert show];
                    }else{
                        
                        [self showDownloadView];
                        
                    }
                    
                }
            }

            
//            [self.progressHUD hide:YES];
//            
//            GetDownloadImageListDTO* getDownloadImageListDTO = [[GetDownloadImageListDTO alloc] init];
//            
//            getDownloadImageListDTO.downloadImageDTOList = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            
//            self.listArray = getDownloadImageListDTO.downloadImageDTOList;
//            
//            if (![[AppDelegate currentAppDelegate]isWifiReach]) {
//                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"为节省流量,建议开启wifi后进行下载！" message:@"尚未开启wifi,是否继续下载" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
//                [alert show];
//            }else{
//                
//                [self showDownloadView];
//                
//            }
            
        }else if ([[dic objectForKey:@"code"]isEqualToString:@"107"]){
            
            [self showsevenDayError];
            
        }else if ([[dic objectForKey:@"code"]isEqualToString:@"120"]){
            
            [self showNoDownloadTimes];
        }else{
            
            [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        [self.progressHUD hide:YES];
        [self.view makeMessage:@"获取失败" duration:2.0f position:@"center"];
    }];
    
}

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
    
    for (UIView *tmpView in self.navigationController.view.subviews) {
        
        if (tmpView.tag==naviViewTag) {
            [tmpView removeFromSuperview];
        }
    }
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
    
    UIButton *collectionBtn = [[UIButton alloc]initWithFrame:CGRectMake(xOffset,yOffset, 25, 25)];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏"] forState:UIControlStateNormal];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏"] forState:UIControlStateHighlighted];
    [collectionBtn setBackgroundImage:[UIImage imageNamed:@"顶栏收藏选中"] forState:UIControlStateSelected];
    [collectionBtn setAlpha:0];
    [collectionBtn addTarget:self action:@selector(collectButtonNotification) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:collectionBtn];
    
    if ([goodsInfoDetailsDTO.isFavorite isEqualToString:@"0"]) {
        [collectionBtn setSelected:YES];
    }else{
        [collectionBtn setSelected:NO];
    }
  
    
    
    xOffset += 25+8;
    
    UIButton *downloadBtn = [[UIButton alloc]initWithFrame:CGRectMake(xOffset,yOffset, 25, 25)];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"顶栏下载"] forState:UIControlStateNormal];
    [downloadBtn setBackgroundImage:[UIImage imageNamed:@"顶栏下载"] forState:UIControlStateHighlighted];
    [downloadBtn setAlpha:0];
    [downloadBtn addTarget:self action:@selector(showDownloadView) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:downloadBtn];
    
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
    
    yOffset = naviHeight-4-25;
    
    threeButtonArray = @[collectionBtn,downloadBtn];
    
    [self showAllButtons:threeButtonArray withYOffset:yOffset];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [[NSNotificationCenter defaultCenter]postNotificationName:kScrollUNEnableAllNotification object:nil];
    
    self.title = @"";
    
}
-(void)hiddenWindown{
    [self dismissDownloadViewNotification];
    [_nextWindow hiddenStateToUP];
}
-(void)showWindown{
    [_nextWindow beginStateToUP];
}
-(void)overWindown{
    [self dismissThreeAnimationButton];
    self.title = @"";
//    [_nextWindow overState];
//     pointScrollPoint = vc.scrollView.contentOffset;
//    pointTablePoint = vc.tableView.contentOffset;
    leftBackBtn.frame = CGRectMake(0, 0, 25, 25);
    [leftBackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [leftBackBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:leftBackBtn];
}
-(void)fullWindown{
    [self showThreeAnimationButton];
//    [_nextWindow fullUpState];
//    vc.scrollView.contentOffset = pointScrollPoint;
//    vc.tableView.contentOffset = pointTablePoint;
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
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                
                CGRect rect = button.frame;
                rect.origin.y = yOffset;
                [button setFrame:rect];
                button.alpha = 1;
                
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
    
    [self dismissAllButtons:threeButtonArray withYOffset:screenHeight-_nextWindow.windowHeaderHeight];
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
@end
