//
//  CPSMyOrderViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSMyOrderViewController.h"
#import "CPSMyOrderTopView.h"
#import "CSPOrderInfoTableViewCell.h"
#import "OrderTopView.h"
#import "GetOrderDTO.h"
#import "orderGoodsItemDTO.h"
#import "CSPModifyPriceView.h"
#import "UIImage+Compression.h"
#import "CSPCustomSkuLabel.h"
#import "CPSOrderDetailsViewController.h"
#import "ConversationWindowViewController.h"
#import "RefreshControl.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "PhotoAndCamerSelectView.h"//!相机、相册选择view
#import "Masonry.h"


static CGFloat const topViewHeight = 30.0f;

static CGFloat const topViewInterval = 22.0f;

static NSInteger const tableViewTag = 101;

static NSString *const lastMenuString = @"完成交易";

static NSString *const lastMenuString1 = @"订单取消";

static NSString *const lastMenuString2 = @"交易取消";


@interface CPSMyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,RefreshControlDelegate,CPSOrderDetailsDelegate>

@property(nonatomic,strong)CPSMyOrderTopView *myOrderTopView;

@property(nonatomic,strong)UIScrollView *scrollView;

//订单详情进去以后 修改或者拍照成功以后需要刷新 标记要刷新的状态 （price）价格  photo (拍照)
@property (nonatomic ,copy) NSString *detailChangeName;


//存放所有数组
@property(nonatomic,strong)NSMutableArray *resourceDataArray;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;


@end

@implementation CPSMyOrderViewController{
    
    NSMutableArray *_titleArray;
    
    
    /**
     *  标记是否修改成功
     */
    BOOL _isChangePriceSuccess;
    
    /**
     *  判断上传快递单是否成功
     */
    BOOL _isUploadImageSuccess;
    
    /**
     *  控制只改变一次scrollview的frame
     */
    BOOL _isSetUIFrame;
    
    /**
     *  订单id
     */
    NSString *_orderCode;
    
    BOOL _isTakePhoto;
    //全部
    RefreshControl *_allOrderRefresh;
    //待付款
    RefreshControl *_waitPayOrderRefresh;
    //待发货
    RefreshControl *_waitDeliverOrderRefresh;
    //待收货
    RefreshControl *_waitGoodsReceiptOrderRefresh;
    //交易完成
    RefreshControl *_completionOrderRefresh;
    //订单取消
    RefreshControl *_cancelOrderRefresh;
    //交易取消
    RefreshControl *_dealOrderRefresh;
    
    /**
     *  重点＊＊＊＊＊＊标示几种状态当前的页面
     */
    NSInteger _pageNoForAllOrder;
    NSInteger _pageNoForWaitPayOrder;
    NSInteger _pageNoForWaitDeliver;
    NSInteger _pageNoForGoodsReceipt;
    NSInteger _pageNoForCompletion;
    NSInteger _pageNoForCancel;
    NSInteger _pageNoForDeal;
    
    //控制是否在上拉
    BOOL _isRefresh;
    //控制是否第一次加载
    BOOL _isFirstRequest;
    
    NSMutableArray *_refreshControlArray;
    
   
    
    
}

- (void)refreshControlBottomEnabledDefaultAllow
{
    _allOrderRefresh.bottomEnabled = YES;
    _waitPayOrderRefresh.bottomEnabled = YES;
    _waitDeliverOrderRefresh.bottomEnabled = YES;
    _waitGoodsReceiptOrderRefresh.bottomEnabled = YES;
    _completionOrderRefresh.bottomEnabled = YES;
    _cancelOrderRefresh.bottomEnabled = YES;
    _dealOrderRefresh.bottomEnabled = YES;
    
}
- (void)refreshControlBottomEnabledDefault
{
    _allOrderRefresh.bottomEnabled = NO;
    _waitPayOrderRefresh.bottomEnabled = NO;
    _waitDeliverOrderRefresh.bottomEnabled = NO;
    _waitGoodsReceiptOrderRefresh.bottomEnabled = NO;
    _completionOrderRefresh.bottomEnabled = NO;
    _cancelOrderRefresh.bottomEnabled = NO;
    _dealOrderRefresh.bottomEnabled = NO;
 
}
- (void)refreshControldataEableDefault
{
    
//    _allOrderRefresh.dataEnable = NO;
    _allOrderRefresh.dataEnable = NO;
    _waitPayOrderRefresh.dataEnable = NO;
    _waitDeliverOrderRefresh.dataEnable = NO;
    _waitGoodsReceiptOrderRefresh.dataEnable = NO;
    _completionOrderRefresh.dataEnable = NO;
    _cancelOrderRefresh.dataEnable = NO;
    _dealOrderRefresh.dataEnable = NO;

    
    
}

- (void)refreshControldataEableAllowDefault
{
    _allOrderRefresh.dataEnable = YES;
    _waitPayOrderRefresh.dataEnable = YES;
    _waitDeliverOrderRefresh.dataEnable = YES;
    _waitGoodsReceiptOrderRefresh.dataEnable = YES;
    _completionOrderRefresh.dataEnable = YES;
    _cancelOrderRefresh.dataEnable = YES;
    _dealOrderRefresh.dataEnable = YES;

}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"我的订单";
    
    [self pageNoInit];
    
    [self customBackBarButton];
    
    //设置标题的内容
    [self initArray];
    
    //创建标题内容
    [self initTopView];
    //创建列表显示的内容
    [self initScrollView];
    
    //!创建拍照发货 选择相册 相机的view
    [self initPhotoView];
    
}

- (void)pageNoInit{
    _pageNoForAllOrder = 1;
    _pageNoForWaitPayOrder = 1;
    _pageNoForWaitDeliver = 1;
    _pageNoForGoodsReceipt = 1;
    _pageNoForCompletion = 1;
    _pageNoForCancel = 1;
    _pageNoForDeal = 1;
}

#pragma mark-请求全部的订单
- (void)requestOrderListWithOrderStatus:(NSString *)orderStatus pageNo:(NSInteger)pageNo{
    
    [self progressHUDShowWithString:@"加载中"];
    
    [HttpManager sendHttpRequestForGetOrderList:orderStatus pageNo:[NSNumber numberWithInteger:pageNo] pageSize:[NSNumber numberWithInteger:PAGESIZE] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //完成上拉
        [self refreshComplete];
        
        _isChangePriceSuccess = NO;
        
        _isUploadImageSuccess = NO;
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                id orderList = [data objectForKey:@"orderList"];
                
                //判断数据合法
                if ([self checkData:orderList class:[NSArray class]]) {
                    
                    NSMutableArray *array = [[NSMutableArray alloc]init];
                    
                    for (NSDictionary *dataDic in orderList) {
                        
                        GetOrderDTO *getOrderDTO = [[GetOrderDTO alloc]init];
                        
                        [getOrderDTO setDictFrom:dataDic];
                        
                        id orderGoodsItems = [dataDic objectForKey:@"orderGoodsItems"];
                        
                        //判断数据合法
                        if ([self checkData:orderGoodsItems class:[NSArray class]]) {
                            
                            for (NSDictionary *orderGoodsItemsDic in orderGoodsItems) {
                                
                                orderGoodsItemDTO *orderItemDTO = [[orderGoodsItemDTO alloc]init];
                                
                                [orderItemDTO setDictFrom:orderGoodsItemsDic];
                                
                                [getOrderDTO.orderGoodsItemsList addObject:orderItemDTO];
                            }
                        }
                        [array addObject:getOrderDTO];
                    }
                    
                    NSMutableArray *orderArray;
                    
                    //订单状态(空为全部)0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
                    if (![orderStatus isEqualToString:@""]&&orderStatus) {
                        
                        if ([orderStatus isEqualToString:@"0"]) {
                            //订单取消
                            orderArray = [self.resourceDataArray objectAtIndex:5];
                            
                        }else if ([orderStatus isEqualToString:@"1"]){
                            //未付款
                            orderArray = [self.resourceDataArray objectAtIndex:1];
                            
                        }else if ([orderStatus isEqualToString:@"2"]){
                            //未发货
                            orderArray = [self.resourceDataArray objectAtIndex:2];
                            
                        }else if ([orderStatus isEqualToString:@"3"]){
                            //已发货
                            orderArray = [self.resourceDataArray objectAtIndex:3];
                            
                        }else if ([orderStatus isEqualToString:@"4"]){
                            //交易取消
                            orderArray = [self.resourceDataArray objectAtIndex:6];
                            
                        }else if ([orderStatus isEqualToString:@"5"]){
                            //已签收
                            orderArray = [self.resourceDataArray objectAtIndex:4];
                        }
                        
                    }else{
                        
                        orderArray = [self.resourceDataArray objectAtIndex:0];
                    }
                    
                    if (!_isRefresh) {
                        [orderArray  removeAllObjects];
                        _isRefresh = NO;
                    }
                    [orderArray addObjectsFromArray:array];
                    
                    //刷新数据
                    if (![orderStatus isEqualToString:@""]&&orderStatus) {
                        
                        if ([orderStatus isEqualToString:@"0"]) {
                            //订单取消
                            [self reloadTableViewWithTag:tableViewTag+5];
                            
                        }else if ([orderStatus isEqualToString:@"1"]){
                            //未付款
                            [self reloadTableViewWithTag:tableViewTag+1];
                            
                        }else if ([orderStatus isEqualToString:@"2"]){
                            //未发货
                            [self reloadTableViewWithTag:tableViewTag+2];
                            
                        }else if ([orderStatus isEqualToString:@"3"]){
                            //已发货
                            [self reloadTableViewWithTag:tableViewTag+3];
                            
                        }else if ([orderStatus isEqualToString:@"4"]){
                            //交易取消
                            [self reloadTableViewWithTag:tableViewTag+6];
                            
                        }else if ([orderStatus isEqualToString:@"5"]){
                            //已签收
                            [self reloadTableViewWithTag:tableViewTag+4];
                        }
                        
                    }else{
                        
                        [self reloadTableViewWithTag:tableViewTag];
                    }
                
                    
                    
                    
                    //判断是否显示上拉加载
                    //全部
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:0]).count>=PAGESIZE) {
                        
                        _allOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _allOrderRefresh.bottomEnabled = NO;
                    }
                    
                    //待付款
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:1]).count>=PAGESIZE) {
                        
                        _waitPayOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _waitPayOrderRefresh.bottomEnabled = NO;
                    }
                    
                    //待发货
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:2]).count>=PAGESIZE) {
                        
                        _waitDeliverOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _waitDeliverOrderRefresh.bottomEnabled = NO;
                    }
                    
                    //待收货
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:3]).count>=PAGESIZE) {
                        
                        _waitGoodsReceiptOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _waitGoodsReceiptOrderRefresh.bottomEnabled = NO;
                    }
                    
                    //交易完成
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:4]).count>=PAGESIZE) {
                        
                        _completionOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _completionOrderRefresh.bottomEnabled = NO;
                    }
                    
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:5]).count>=PAGESIZE) {
                        
                        _cancelOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _cancelOrderRefresh.bottomEnabled = NO;
                    }
                    
                    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:6]).count>=PAGESIZE) {
                        
                        _dealOrderRefresh.bottomEnabled = YES;
                    }else{
                        
//                        _dealOrderRefresh.bottomEnabled = NO;
                    }
                    
                    
 
                    if (orderArray.count != 0) {
                        [self refreshControlBottomEnabledDefaultAllow];
                        [self refreshControldataEableAllowDefault];

                    }
                    NSNumber *numberCount =responseDic[@"data"][@"totalCount"];
                    
                    if (orderArray.count == numberCount.integerValue ) {
//                        _allOrderRefresh.bottomEnabled = NO;

                        if (orderArray.count == 0) {
                            [self refreshControldataEableDefault];
                            
                        }
                        
                        [self refreshControlBottomEnabledDefault];
                    }

                }
            }
            
        }else{
            
            [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self refreshComplete];
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
}

#pragma mark-完成刷新
- (void)refreshComplete{
    [_allOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_waitPayOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_waitDeliverOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_waitGoodsReceiptOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_completionOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_cancelOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    [_dealOrderRefresh finishRefreshingDirection:RefreshDirectionBottom];
    
    [_allOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_waitPayOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_waitDeliverOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_waitGoodsReceiptOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_completionOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_cancelOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
    [_dealOrderRefresh finishRefreshingDirection:RefreshDirectionTop];
}


#pragma mark-刷新某一个tableview
- (void)reloadTableViewWithTag:(NSInteger)tag{
    UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:tag];
    [tableView reloadData];
}

#pragma mark-处理数据,将数据分类
- (void)handleOrderDataWithArray:(NSArray *)array{
    
    DebugLog(@"-------->array = %@", array);
    
    //清空数据
    for (NSMutableArray *resourceArray in self.resourceDataArray) {
        
        [resourceArray removeAllObjects];
    }
    //全部
    [[self.resourceDataArray objectAtIndex:0]addObjectsFromArray:array];
    
    for (GetOrderDTO *getOrderDTO in array) {
        //订单状态(0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收)
        if (getOrderDTO.status.integerValue == 0) {
            //订单取消
            [[self.resourceDataArray objectAtIndex:5] addObject:getOrderDTO];
            
        }else if (getOrderDTO.status.integerValue == 1){
            //未付款
            [[self.resourceDataArray objectAtIndex:1] addObject:getOrderDTO];
            
        }else if (getOrderDTO.status.integerValue == 2){
            //未发货
            [[self.resourceDataArray objectAtIndex:2] addObject:getOrderDTO];
            
        }else if (getOrderDTO.status.integerValue == 3){
            //已发货
            [[self.resourceDataArray objectAtIndex:3] addObject:getOrderDTO];
            
        }else if (getOrderDTO.status.integerValue == 4) {
            //交易取消
            [[self.resourceDataArray objectAtIndex:6] addObject:getOrderDTO];
        }else if (getOrderDTO.status.integerValue == 5) {
            //已签收
            [[self.resourceDataArray objectAtIndex:4] addObject:getOrderDTO];
        }
    }
    
    //判断是否显示上拉加载
    //全部
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:0]).count>=PAGESIZE) {
        
        _allOrderRefresh.bottomEnabled = YES;
    }else{
        
        _allOrderRefresh.bottomEnabled = NO;
    }
    
    //待付款
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:1]).count>=PAGESIZE) {
        
        _waitPayOrderRefresh.bottomEnabled = YES;
    }else{
        
        _waitPayOrderRefresh.bottomEnabled = NO;
    }
    
    //待发货
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:2]).count>=PAGESIZE) {
        
        _waitDeliverOrderRefresh.bottomEnabled = YES;
    }else{
        
        _waitDeliverOrderRefresh.bottomEnabled = NO;
    }
    
    //待收货
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:3]).count>=PAGESIZE) {
        
        _waitGoodsReceiptOrderRefresh.bottomEnabled = YES;
    }else{
        
        _waitGoodsReceiptOrderRefresh.bottomEnabled = NO;
    }
    
    //交易完成
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:4]).count>=PAGESIZE) {
        
        _completionOrderRefresh.bottomEnabled = YES;
    }else{
        
        _completionOrderRefresh.bottomEnabled = NO;
    }
    
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:5]).count>=PAGESIZE) {
        
        _cancelOrderRefresh.bottomEnabled = YES;
    }else{
        
        _cancelOrderRefresh.bottomEnabled = NO;
    }
    
    if (((NSMutableArray *)[self.resourceDataArray objectAtIndex:6]).count>=PAGESIZE) {
        
        _dealOrderRefresh.bottomEnabled = YES;
    }else{
        
        _dealOrderRefresh.bottomEnabled = NO;
    }
    
    //刷新所有的tableview
    [self reloadData];
}

#pragma mark-刷新所有的tableview
- (void)reloadData{
    
    for (UIView *view in self.scrollView.subviews) {
        
        if ([view isKindOfClass:[UITableView class]]) {
            
            [((UITableView *)view) reloadData];
        }
    }
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    if (!_isSetUIFrame) {
        
        _isSetUIFrame = YES;
        
        [self setScrollViewFrame];
    }
}

#pragma mark-修改坐标
- (void)setScrollViewFrame{
    
    self.scrollView.frame = CGRectMake(0, topViewHeight+topViewInterval, self.view.frame.size.width, self.view.frame.size.height-(topViewHeight+topViewInterval));
    self.scrollView.scrollEnabled = NO;
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*_titleArray.count, self.scrollView.frame.size.height);
    
    for (int i = 0; i<self.scrollView.subviews.count; i++) {
        
        UITableView *tableView = (UITableView *)[self.scrollView viewWithTag:tableViewTag+i];
        
        tableView.frame = CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    }
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    
    if ([self.detailChangeName isEqualToString:@"photo"]) {
        
        
        //待发货
//        _pageNoForWaitDeliver=1;
//        [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitPayOrder];
    
        [_waitDeliverOrderRefresh startRefreshingDirection:RefreshDirectionTop];
        
        
        
        
    }else if ([self.detailChangeName isEqualToString:@"price"])
    {
        
        [_waitPayOrderRefresh startRefreshingDirection:RefreshDirectionTop];
        
//        //待付款
//        _pageNoForWaitPayOrder = 1;
//        [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];

    }
    
    _isFirstRequest = YES;
    
    if (!_isTakePhoto) {
        _isTakePhoto = YES;
        
        
        [self.myOrderTopView showButtonWithIndex:self.menuBar];
        
        CGPoint point = CGPointMake(self.view.frame.size.width*self.menuBar, 0);
        
        [self.scrollView setContentOffset:point];
        
        [self.view bringSubviewToFront:self.progressHUD];
        
        self.progressHUD.delegate = self;
        
        //待付款,待发货、待收货,订单状态(空为全部)0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
        if (self.menuBar == MenuWaitPayOrder) {
            
            [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
            
            
        }else if (self.menuBar == MenuWaitDeliverGoodsOrder){
            [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
            
        }else if (self.menuBar == MenuWaitGoodsReceiptOrder){
            [self requestOrderListWithOrderStatus:@"3" pageNo:_pageNoForGoodsReceipt];
        }else if (self.menuBar == MenuALLOrder)
        {
            [self requestOrderListWithOrderStatus:@"" pageNo:_pageNoForAllOrder];
            
        }
    }
    
    self.navigationController.navigationBar.translucent = NO;
    [self tabbarHidden:YES];
    
    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    

    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [self tabbarHidden:NO];

}

- (UIBarButtonItem *)getButtonItemWithTitle:(NSString *)title{
    
    UIBarButtonItem *buttonItem = [self barButtonWithtTitle:title font:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13]];
    
    return buttonItem;
}
/**
 *  设置显示的标题
 */
- (void)initArray{
    
    _titleArray = [[NSMutableArray alloc]initWithObjects:@"全部",@"待付款",@"待发货",@"待收货",@"交易完成",@"订单取消",@"交易取消", nil];
    
    self.resourceDataArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 7; i++) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [self.resourceDataArray addObject:array];
    }
}

/**
 *  创建标题视图
 */
- (void)initTopView{
    
    //创建一个滚动视图
    self.myOrderTopView = [[CPSMyOrderTopView alloc]initWithScrollView:CGRectMake(0, 0, self.view.frame.size.width, topViewHeight)];
    //设置滚动视图的内容
    self.myOrderTopView.titleArray = _titleArray;
    //设置初始化每个按钮
    [self.myOrderTopView initButton];
    
    //
    __weak CPSMyOrderViewController *weakSelf = self;
    
    self.myOrderTopView.chooseOrderTypeBlock = ^(NSInteger integer){
        //跳转CPSMyOrderViewController 的位置
        CGPoint point = CGPointMake(self.view.frame.size.width*integer, 0);
        
        [((CPSMyOrderViewController *)weakSelf).scrollView setContentOffset:point animated:YES];
        
        weakSelf.menuBar = integer;
    };
    
    //添加到顶部视图
    [self.view addSubview:self.myOrderTopView];
    
    [self.myOrderTopView showButtonWithIndex:0];
}

- (void)orderRefreshSetNil{
    _allOrderRefresh = nil;
    _waitPayOrderRefresh = nil;
    _waitDeliverOrderRefresh = nil;
    _waitGoodsReceiptOrderRefresh = nil;
    _completionOrderRefresh = nil;
    _cancelOrderRefresh = nil;
    _dealOrderRefresh = nil;
}
/**
 *  显示列表内容
 */
- (void)initScrollView{
    
    //创建滚动视图
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, topViewHeight+topViewInterval, self.view.frame.size.width, self.view.frame.size.height-(topViewHeight+topViewInterval))];
    //设置显示的内容
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*_titleArray.count, self.scrollView.frame.size.height);
    //设置代理和允许交互
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    //添加到View上
    [self.view addSubview:self.scrollView];
    
    [self orderRefreshSetNil];
    //创建_titleArray.count个tableview
    for (int i = 0; i<_titleArray.count; i++) {
        
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) style:UITableViewStyleGrouped];
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        tableView.tag = tableViewTag+i;
        
        if (i == 0) {//所有
            
            _allOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            
            _allOrderRefresh.topEnabled = YES;
        }
        
        if (i == 1) {//待支付
            
            _waitPayOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
//            autoRefreshTop

            _waitPayOrderRefresh.topEnabled = YES;
        }
        
        if (i == 2) {//
            _waitDeliverOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            _waitDeliverOrderRefresh.topEnabled = YES;
        }
        
        if (i == 3) {
            _waitGoodsReceiptOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            _waitGoodsReceiptOrderRefresh.topEnabled = YES;
        }
        
        if (i == 4) {
            _completionOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            _completionOrderRefresh.topEnabled = YES;
        }
        
        if (i == 5) {
            _cancelOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            _cancelOrderRefresh.topEnabled = YES;
        }
        
        if (i == 6) {
            _dealOrderRefresh = [[RefreshControl alloc]initWithScrollView:tableView delegate:self];
            _dealOrderRefresh.topEnabled = YES;
        }
        
        [self.scrollView addSubview:tableView];
    }
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        [self.myOrderTopView showButtonWithIndex:page];
        NSLog(@"屏幕的宽度 === %f",self.view.frame.size.width*2);
        
        if (page>=1&&scrollView.contentOffset.x<self.view.frame.size.width*4) {
            [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(self.view.frame.size.width/5.0*(scrollView.contentOffset.x/pageWidth)-self.view.frame.size.width/5.0, 0) animated:YES];
        }
        
        //
        //        if (page<4) {
        //            [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        //        }else{
        //
        //
        //        }
        
        self.menuBar = page;
        
        //请求数据
        //0,1,2,3,4,5,6,
        NSMutableArray *array = [self.resourceDataArray objectAtIndex:page];
        
        
            if (page == 0) {
                //全部
                [self requestOrderListWithOrderStatus:nil pageNo:_pageNoForAllOrder];
                
            }else if (page == 1){
                [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
                
            }else if (page == 2){
                [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
                
            }else if (page == 3){
                [self requestOrderListWithOrderStatus:@"3" pageNo:_pageNoForGoodsReceipt];
                
            }else if (page == 4){
                [self requestOrderListWithOrderStatus:@"5" pageNo:_pageNoForCompletion];
                
            }else if (page == 5){
                [self requestOrderListWithOrderStatus:@"0" pageNo:_pageNoForCancel];
                
            }else if (page == 6){
                [self requestOrderListWithOrderStatus:@"4" pageNo:_pageNoForDeal];
            }
        }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        [self.myOrderTopView showButtonWithIndex:page];
        
        //        if (page<4) {
        //            [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        //        }else{
        //
        //            [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(self.view.frame.size.width/5.0*2, 0) animated:YES];
        //
        //        }
        
        self.menuBar = page;
        if (page>=1&&scrollView.contentOffset.x<self.view.frame.size.width*4) {
            [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(self.view.frame.size.width/5.0*(scrollView.contentOffset.x/pageWidth)-self.view.frame.size.width/5.0, 0) animated:YES];
        }
        //请求数据
        //0,1,2,3,4,5,6,
        NSMutableArray *array = [self.resourceDataArray objectAtIndex:page];
        
        //初始化所有请求pageNo
        [self pageNoInit];
        
        
        _isRefresh = NO;
        
            if (page == 0) {
                //全部
                [self requestOrderListWithOrderStatus:nil pageNo:_pageNoForAllOrder];
                
            }else if (page == 1){
                [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
                
            }else if (page == 2){
                [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
                
            }else if (page == 3){
                [self requestOrderListWithOrderStatus:@"3" pageNo:_pageNoForGoodsReceipt];
                
            }else if (page == 4){
                [self requestOrderListWithOrderStatus:@"5" pageNo:_pageNoForCompletion];
                
            }else if (page == 5){
                [self requestOrderListWithOrderStatus:@"0" pageNo:_pageNoForCancel];
                
            }else if (page == 6){
                [self requestOrderListWithOrderStatus:@"4" pageNo:_pageNoForDeal];
            }
        
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = self.scrollView.frame.size.width;

    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSLog(@"屏幕的宽度 === %f",self.view.frame.size.width*2);
    
    if (page>=1&&scrollView.contentOffset.x<self.view.frame.size.width*4) {
//        [self.myOrderTopView.btnScrollView setContentOffset:CGPointMake(self.view.frame.size.width/5.0*(scrollView.contentOffset.x/pageWidth)-self.view.frame.size.width/5.0, 0) animated:YES];
    }
    UITableView *tableView = [self.scrollView viewWithTag:page +tableViewTag];
    NSLog(@"*******************%f",tableView.contentSize.height);
    if (tableView.frame.size.height >=tableView.contentSize.height) {
        
            [self refreshControldataEableDefault];
        
        [self refreshControlBottomEnabledDefault];
    }
    

    }

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count>0) {
        return array.count;
    }else {
        return 1;
        
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count>0) {
        GetOrderDTO *getOrder = [array objectAtIndex:section];
        
        NSArray *orderGoodsItemsList = getOrder.orderGoodsItemsList;
        
        return orderGoodsItemsList.count+2;
    }else {
        return 1;
    }
    
}

- (CSPOrderInfoTableViewCell *)getCellWithIndex:(NSInteger)index{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"CSPOrderInfoTableViewCell" owner:self options:nil]objectAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count>0) {
        static NSString *cellOneID = @"CSPOrderInfoTableViewCellID1";
        
        static NSString *cellTwoID = @"CSPOrderInfoTableViewCellID2";
        
        static NSString *cellThreeID = @"CSPOrderInfoTableViewCellID3";
        
        CSPOrderInfoTableViewCell *cell;
        
        NSString *cellID;
        
        NSInteger integer = 0;
        
        
        GetOrderDTO *getOrder = [array objectAtIndex:indexPath.section];
        
        orderGoodsItemDTO *orderGoodsItem;
        
        NSArray *orderGoodsItemsList = getOrder.orderGoodsItemsList;
        
        
        if (indexPath.row != 0 && indexPath.row != orderGoodsItemsList.count+1) {
            
            orderGoodsItem = [getOrder.orderGoodsItemsList objectAtIndex:indexPath.row-1];
            
            cellID = cellTwoID;
            
            integer = 1;
            
        }else if (indexPath.row == 0){
            
            cellID = cellOneID;
            
            integer = 0;
            
        }else if (indexPath.row == orderGoodsItemsList.count+1){
            
            cellID = cellThreeID;
            
            integer = 2;
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [self getCellWithIndex:integer];
        }
        
        NSString *orderType;
        
        //现货还是期货
        if (getOrder.type.integerValue == 1) {
            //现货
            orderType = @"【现货单】";
            
            cell.goodsTypeLabel.textColor = HEX_COLOR(0x5677fcFF);
            
        }else if (getOrder.type.integerValue == 0){
            //期货
            orderType = @"【期货单】";
            
            cell.goodsTypeLabel.textColor = HEX_COLOR(0x673ab7FF);
            
        }else{
            orderType = @"未知";
        }
        
        cell.goodsTypeLabel.text = orderType;
        
        //待发货还是待付款
        if (getOrder.status.integerValue == 1) {
            //待付款
            cell.tradingStateLabel.text = @"待付款";
        }else if(getOrder.status.integerValue == 2){
            //待发货
            cell.tradingStateLabel.text = @"待发货";
        }else if(getOrder.status.integerValue == 3){
            cell.tradingStateLabel.text = @"待收货";
        }else if(getOrder.status.integerValue == 4){
            cell.tradingStateLabel.text = @"交易取消";
        }else if(getOrder.status.integerValue == 5){
            cell.tradingStateLabel.text = @"交易完成";
        } else if (getOrder.status.integerValue == 0) {
            cell.tradingStateLabel.text = @"订单取消";
        }
        
        /*
         0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
         */
        
        //创建尺码，一行2个
        NSArray *sizesArray;
        
        //去掉空格
        if ([orderGoodsItem.sizes stringByReplacingOccurrencesOfString:@" " withString:@""].length>1) {
            
            sizesArray = [orderGoodsItem.sizes componentsSeparatedByString:@","];
            
        }
        
        //CSPCustomSkuLabel
        CGFloat interval = 5;
        
        CGFloat width = 70;
        
        CGFloat height = 13;
        
        CGFloat top = 57;
        
        CGFloat lead = 118;
        
        NSInteger sizesRow;
        
        //计算需要创建多少行
        if (sizesArray.count%2 == 0) {
            sizesRow = sizesArray.count/2;
        }else{
            sizesRow = sizesArray.count/2+1;
        }
        
        //创建之前先remove掉之前的CSPCustomSkuLabel
        NSMutableArray *subviewArray = [[NSMutableArray alloc]init];
        
        [subviewArray addObjectsFromArray:cell.subviews];
        
        for (UIView *view in subviewArray) {
            
            if ([view isKindOfClass:[CSPCustomSkuLabel class]]) {
                
                [view removeFromSuperview];
                
            }
        }
        
        //然后在创建
        for (int i = 0; i<sizesArray.count; i++) {
            
            CSPCustomSkuLabel *customSkuLabel = [[CSPCustomSkuLabel alloc]initWithFrame:CGRectMake(lead+(i%2)*(width+interval), top+(i/2)*(height+interval), width, height)];
            
            NSString *skuStr = [sizesArray objectAtIndex:i];
            
            skuStr = [skuStr stringByReplacingOccurrencesOfString:@":" withString:@" x "];
            
            customSkuLabel.text = skuStr;
            
            [cell addSubview:customSkuLabel];
            if ([orderGoodsItem.cartType isEqualToString:@"2"]) {
                customSkuLabel.hidden = YES;
                
                
            }else{
                customSkuLabel.hidden = NO;
                
            }
        }
        
        //图片
        [cell.swearImageView sd_setImageWithURL:[NSURL URLWithString:orderGoodsItem.picUrl] placeholderImage:[UIImage imageNamed:@""]];
        
        //商品名称
        cell.swearTitleText = orderGoodsItem.goodsName;
        
        
        //颜色
        cell.colorText = [NSString stringWithFormat:@"颜色：%@",orderGoodsItem.color];
        
        //价格
        cell.priceText = [NSString stringWithFormat:@"￥%0.2lf",orderGoodsItem.price.doubleValue ];
        
        //数量
        cell.amountText = [NSString stringWithFormat:@"x%lu",orderGoodsItem.quantity.integerValue];
        
        //共几件商品
        cell.totalGoodsNumText =[NSString stringWithFormat:@"共%lu件商品",getOrder.quantity.integerValue];
      
        
        //订单总价
        
       double orderTotalPrice =  [getOrder.originalTotalAmount doubleValue];
        
        cell.totalOrderPriceText = [NSString stringWithFormat:@"订单总价：￥%0.2lf",orderTotalPrice];
        NSLog(@"====%@",orderGoodsItem.cartType);
        
        if ([orderGoodsItem.cartType isEqualToString:@"2"]) {
            cell.colorLabel.hidden = YES;
            cell.tagliaLabel.hidden = YES;
            [cell changeView];
            CGPoint swearTitleViewPoint = cell.swearTitleLabel.center;
            swearTitleViewPoint.y = cell.swearImageView.center.y;
            cell.swearTitleLabel.center = swearTitleViewPoint;
            
            
        }else
        {
            [cell normalView];
            
            cell.tagliaLabel.hidden = NO;
            
            cell.colorLabel.hidden = NO;
            
        }
        //判断是 '待付款' 和 '待发货'
        if (getOrder.status.integerValue == 1) {
            
            //待付款
            cell.shouldPayText = [NSString stringWithFormat:@"应付: ￥%.2lf",getOrder.totalAmount.doubleValue];
            
            cell.tipModifyOrTakePhoneLabel.hidden = NO;
            
            cell.modifyOrTakePhoneButton.hidden = NO;
            
            cell.tipModifyOrTakePhoneLabel.text = @"修改应付金额：";
            
            [cell.modifyOrTakePhoneButton setTitle:@"修改" forState:UIControlStateNormal];
            
        }else if (getOrder.status.integerValue == 2){
            //待发货
            cell.shouldPayText = [NSString stringWithFormat:@"实付: ￥%.2lf",getOrder.paidTotalAmount.doubleValue];
            
            cell.tipModifyOrTakePhoneLabel.hidden = NO;
            
            cell.modifyOrTakePhoneButton.hidden = NO;
            
            cell.tipModifyOrTakePhoneLabel.text = @"快递单拍照后发货：";
            
            [cell.modifyOrTakePhoneButton setTitle:@"拍照发货" forState:UIControlStateNormal];
            
        }else if(getOrder.status.integerValue == 0)
        {
            cell.shouldPayText = [NSString stringWithFormat:@"应付: ￥%0.2lf",getOrder.totalAmount.doubleValue];
            
            //            cell.shouldPayLabel.text = [NSString stringWithFormat:@"实付：￥%@",[self transformationData:getOrder.totalAmount]];
            
            cell.tipModifyOrTakePhoneLabel.hidden = YES;
            
            cell.modifyOrTakePhoneButton.hidden = YES;

            
        }else
        
        {
            
            cell.shouldPayText = [NSString stringWithFormat:@"实付: ￥%0.2lf",getOrder.paidTotalAmount.doubleValue];
            
            //            cell.shouldPayLabel.text = [NSString stringWithFormat:@"实付：￥%@",[self transformationData:getOrder.totalAmount]];
            
            cell.tipModifyOrTakePhoneLabel.hidden = YES;
            
            cell.modifyOrTakePhoneButton.hidden = YES;
        }
        
        
        
        
        cell.modifyOrTakePhoneButtonBlock = ^(){
            //判断是修改 还是拍照
            if (getOrder.status.integerValue == 1) {
                //待付款
                //修改--弹出修改页面
                
                //            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
                
                __weak CSPModifyPriceView *modifyPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CSPModifyPriceView" owner:self options:nil]lastObject];
                modifyPriceView.requestType = @"block";
                
                
                modifyPriceView.titleLabel.text = [NSString stringWithFormat:@"%@    %@    %@",orderType,getOrder.nickName,getOrder.memberPhone];
                
                modifyPriceView.originalTotalAmountLabel.text = [NSString stringWithFormat:@"订单总价：￥%.2f",getOrder.originalTotalAmount.doubleValue];
                
                modifyPriceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                modifyPriceView.requestType = @"block";
                
                
                modifyPriceView.confirmBlock = ^(){
                    
                    
                    [self progressHUDShowWithString:@"修改中"];
                    
                    NSString * amountText = modifyPriceView.amoutTextField.text;
                    [HttpManager sendHttpRequestForGetModifyOrderAmount:getOrder.orderCode newAmount:modifyPriceView.amoutTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSDictionary *responseDic = [self conversionWithData:responseObject];
                        NSLog(@"responseDic===%@",responseDic);
                        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                            
//                            _isChangePriceSuccess = YES;
//                            应付: ￥%.2lf
                            getOrder.totalAmount = [NSNumber numberWithFloat:amountText.floatValue];
                            
                            cell.shouldPayText= [NSString stringWithFormat:@"应付: ￥%.2lf",getOrder.totalAmount.floatValue];
                            
                            
                            //修改成功
                            [self progressHUDHiddenTipSuccessWithString:@"修改完成"];
                            
                        }else{
                            
                            [self.progressHUD hide:YES];
                            
                            [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
                        }
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        [self tipRequestFailureWithErrorCode:error.code];
                    }];
                    
                };
                
                [self.view addSubview:modifyPriceView];
                
            }else if (getOrder.status.integerValue == 2){
                
                if (getOrder.orderCode) {
                    _orderCode = getOrder.orderCode;

                }
                //!显示选择的view
                self.blackAlphaView.hidden = NO;
                self.photoAndCamerSelectView.hidden = NO;
              
                
                
                /*
                _isTakePhoto = YES;
                //待发货
                //拍照发货
                //判断是否可以打开相机，模拟器此功能无法使用
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    
                    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                    picker.delegate = self;
                    picker.allowsEditing = YES;  //是否可编辑
                    //摄像头
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:picker animated:YES completion:^{
                    }];
                }else{
                    //如果没有提示用户
                    [self alertViewWithTitle:@"提示" message:@"缺少摄像头"];
                }
                 
                */
                
                
                
                
            }
        };
        
        return cell;
        
    }else
    {
        static NSString *cellId = @"TitleZoneGoodsTableViewCell";
        TitleZoneGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (cell == nil) {
            cell = [[TitleZoneGoodsTableViewCell alloc] init];
            
        }
        cell.titleLabel.text = @"暂无相关订单";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.view.backgroundColor = [UIColor whiteColor];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        
        
        return cell;
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    
    if (array.count>0) {
        
        
        GetOrderDTO *getOrder = [array objectAtIndex:section];
        
        OrderTopView *orderTopView = (OrderTopView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderTopView"];
        
        if (!orderTopView) {
            
            orderTopView = [[[NSBundle mainBundle]loadNibNamed:@"OrderTopView" owner:self options:nil]firstObject];
            
        }
        
        orderTopView.nameWithPhoneNumLabel.text = [NSString stringWithFormat:@"%@    %@",getOrder.nickName,getOrder.memberPhone];
        
        orderTopView.contactCustomerServiceBlock = ^(){
            
            DebugLog(@"联系客服");
            
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initWithName:getOrder.nickName withJID:getOrder.chatAccount];
            
            
            
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        };
        
        return orderTopView;
    }
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count>0) {
        
        
        GetOrderDTO *getOrder = [array objectAtIndex:indexPath.section];
        
        orderGoodsItemDTO *orderGoodsItem;
        
        NSArray *orderGoodsItemsList = getOrder.orderGoodsItemsList;
        
        if (indexPath.row == 0) {
            
            return 44.0f;
            
        }else if (indexPath.row == orderGoodsItemsList.count+1){
            
            if (getOrder.status.integerValue == 1 || getOrder.status.integerValue  == 2) {
                
                return 110;
            }else{
                return 60;
            }
            
        }else{
            
            orderGoodsItem = [getOrder.orderGoodsItemsList objectAtIndex:indexPath.row-1];
            
            NSArray *sizesArray;
            
            //去掉空格
            if ([orderGoodsItem.sizes stringByReplacingOccurrencesOfString:@" " withString:@""].length>1) {
                
                sizesArray = [orderGoodsItem.sizes componentsSeparatedByString:@","];
                
            }
            
            CGFloat top = 57;
            
            NSInteger sizesRow;
            
            //计算需要创建多少行
            if (sizesArray.count%2 == 0) {
                
                sizesRow = sizesArray.count/2;
                
            }else{
                sizesRow = sizesArray.count/2+1;
            }
            
            return MAX(top + sizesRow*(13+5)+5, 80);
        }
    }
    
    return self.view.frame.size.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count>0) {
        
        return 30.0f;
    }
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableArray *array = [self.resourceDataArray objectAtIndex:tableView.tag-tableViewTag];
    if (array.count >0) {
        
        
        GetOrderDTO *getOrder = [array objectAtIndex:indexPath.section];
        
        NSArray *orderGoodsItemsList = getOrder.orderGoodsItemsList;
        
        if (indexPath.row != 0 && indexPath.row != orderGoodsItemsList.count+1) {
            
            orderGoodsItemDTO *orderGoodsItem = [getOrder.orderGoodsItemsList objectAtIndex:indexPath.row-1];
            
            CPSOrderDetailsViewController *orderDetailsViewController = [[CPSOrderDetailsViewController alloc]init];
            orderDetailsViewController.delegate = self;
            
            orderDetailsViewController.orderCode = getOrder.orderCode;
            
            orderDetailsViewController.goodsNo = orderGoodsItem.goodsNo;
            
            // 0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
            orderDetailsViewController.orderStatus =  getOrder.status.integerValue;
            
            [self.navigationController pushViewController:orderDetailsViewController animated:YES];
            
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    //修改、拍照
    if (_isChangePriceSuccess  || _isUploadImageSuccess) {
        
        [self pageNoInit];
        
        //判断当前是那一页
        CGFloat pageWidth = self.scrollView.frame.size.width;
        
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        [self removeDataWithPage:page];
        
        if (page == 0) {
            [self requestOrderListWithOrderStatus:nil pageNo:_pageNoForAllOrder];
            
            
        }else if (page == 1){

//            [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
            

            
        }else if (page == 2){
            
//                        [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitPayOrder];
            
            [_waitDeliverOrderRefresh startRefreshingDirection:RefreshDirectionTop];


//            [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
            
        }
    }
}

- (void)removeDataWithPage:(NSInteger)page{
    for (int i = 0; i<self.resourceDataArray.count; i++) {
        
        if (i != page) {
            NSMutableArray *array = [self.resourceDataArray objectAtIndex:i];
            
            [array removeAllObjects];
        }
    }
}



#pragma mark-RefreshControlDelegate
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop){
        _isRefresh = NO;

        if (refreshControl == _allOrderRefresh) {
            //全部
            _pageNoForAllOrder = 1;
            
            
            [self requestOrderListWithOrderStatus:nil pageNo:_pageNoForAllOrder];
            
        }else if(refreshControl == _waitPayOrderRefresh){
            //待付款
            _pageNoForWaitPayOrder = 1;
            [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
            
        }else if(refreshControl == _waitDeliverOrderRefresh){
            //待发货
            _pageNoForWaitDeliver=1;
            [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
            
            
        }else if(refreshControl == _waitGoodsReceiptOrderRefresh){
            //待收货
            _pageNoForGoodsReceipt=1;
            [self handleOrderDataWithArray:nil];
            [self requestOrderListWithOrderStatus:@"3" pageNo:_pageNoForGoodsReceipt];
            
            
        }else if(refreshControl == _completionOrderRefresh){
            //交易完成
            _pageNoForCompletion=1;
            [self requestOrderListWithOrderStatus:@"5" pageNo:_pageNoForCompletion];
            
            
        }else if(refreshControl == _cancelOrderRefresh){
            //订单取消
            _pageNoForCancel=1;
            [self requestOrderListWithOrderStatus:@"0" pageNo:_pageNoForCancel];
            
            
        }else if(refreshControl == _dealOrderRefresh){
            //交易取消
            _pageNoForDeal=1;
            [self requestOrderListWithOrderStatus:@"4" pageNo:_pageNoForDeal];
            
            
        }
        
    }else if (direction == RefreshDirectionBottom){
        
        _isRefresh = YES;
        //订单状态(空为全部)0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
        if (refreshControl == _allOrderRefresh) {
            //全部
            _pageNoForAllOrder++;
            [self requestOrderListWithOrderStatus:nil pageNo:_pageNoForAllOrder];
            
        }else if(refreshControl == _waitPayOrderRefresh){
            //待付款
            _pageNoForWaitPayOrder++;
            [self requestOrderListWithOrderStatus:@"1" pageNo:_pageNoForWaitPayOrder];
            
        }else if(refreshControl == _waitDeliverOrderRefresh){
            //待发货
            _pageNoForWaitDeliver++;
            [self requestOrderListWithOrderStatus:@"2" pageNo:_pageNoForWaitDeliver];
            
            
        }else if(refreshControl == _waitGoodsReceiptOrderRefresh){
            //待收货
            _pageNoForGoodsReceipt++;
            [self requestOrderListWithOrderStatus:@"3" pageNo:_pageNoForGoodsReceipt];
            
            
        }else if(refreshControl == _completionOrderRefresh){
            //交易完成
            _pageNoForCompletion++;
            [self requestOrderListWithOrderStatus:@"5" pageNo:_pageNoForCompletion];
            
            
        }else if(refreshControl == _cancelOrderRefresh){
            //订单取消
            _pageNoForCancel++;
            [self requestOrderListWithOrderStatus:@"0" pageNo:_pageNoForCancel];
            
            
        }else if(refreshControl == _dealOrderRefresh){
            //交易取消
            _pageNoForDeal++;
            [self requestOrderListWithOrderStatus:@"4" pageNo:_pageNoForDeal];
            
            
        }
    }
}
#pragma mark 拍照发货
//!创建拍照发货 选择相册 相机的view
-(void)initPhotoView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20;
    float selectHight = 106;
    
    //!透明的view
    self.blackAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight - selectHight)];
    
    [self.blackAlphaView setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:0.25]];
    [self.view addSubview:self.blackAlphaView];
    
    UITapGestureRecognizer * selectHideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePhotoSelectView)];
    [self.blackAlphaView addGestureRecognizer:selectHideTap];
    
    
    //!相册选择的view
    self.photoAndCamerSelectView= [[[NSBundle mainBundle]loadNibNamed:@"PhotoAndCamerSelectView" owner:self options:nil]firstObject];
    
    [self.photoAndCamerSelectView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:self.photoAndCamerSelectView];
    
    [self.photoAndCamerSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@106);
        
        
    }];
    
    __weak CPSMyOrderViewController * orderVC = self;
    //!拍照发货的事件
    self.photoAndCamerSelectView.photoBlock = ^(){
        
        //!相机的时候，传yes
        [orderVC showPhoto:NO];
        
    };
    
    self.photoAndCamerSelectView.camerBlock = ^(){
        
        
        [orderVC showPhoto:YES];

    };
    
    //!先隐藏，点击拍照发货的时候显示
    self.blackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
    
}
//!隐藏相册选择的view 以及上半部分的灰色半透明部分
-(void)hidePhotoSelectView{
    
    self.blackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
    
}
//!掉起相册 相机:isCamer=yes
-(void)showPhoto:(BOOL)isCamer{

    _isTakePhoto = YES;
    //待发货
    //拍照发货
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    picker.navigationBar.tintColor = [UIColor blackColor];
    
    //如果选择的是相机，则判断是否可以吊起相机
    if (isCamer && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    

    
    //!吊起相机、相册的时候 修改状态栏的颜色，在这个界面将要出现的时候改回白色
    [self presentViewController:picker animated:YES completion:^{
        
        
    }];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
}
#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self progressHUDShowWithString:@"上传中"];
        
        //隐藏拍照发货选中的View
        [self hidePhotoSelectView];
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0000001f);
        
        //上传图片,修改
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"5" orderCode:_orderCode goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            _isTakePhoto = NO;
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            DebugLog(@"dic = %@", responseDic);
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                _isUploadImageSuccess = YES;
                
                [self progressHUDHiddenTipSuccessWithString:@"上传成功"];
                
            }else{
                
                [self.progressHUD hide:YES];
                
                [self alertViewWithTitle:@"上传失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            _isTakePhoto = NO;
            
            [self tipRequestFailureWithErrorCode:error.code];
            
        }];
    }];
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,CGImageGetBitsPerComponent(aImage.CGImage), 0,CGImageGetColorSpace(aImage.CGImage),CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
        default:              CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);              break;
    }       // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];

}

#pragma mark - CPSOrderDetailsDelegate

//订单详情  修改价格 或者拍照完成以后刷新
- (void)orderDetailsChangeRequestDataName:(NSString *)name
{
    
    self.detailChangeName = name;
    
    
}


@end
