//
//  CPSOrderViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSOrderViewController.h"
#import "OrderTopView.h"
#import "CSPOrderInfoTableViewCell.h"
#import "CPSMyOrderViewController.h"
#import "CPSOrderDetailsViewController.h"
#import "GetOrderDTO.h"
#import "orderGoodsItemDTO.h"
#import "CSPModifyPriceView.h"
#import "GetMerchantMainDTO.h"
#import "CSPCustomSkuLabel.h"
#import "UIImage+Compression.h"
#import "RefreshControl.h"
#import "GUAAlertView.h"
#import "ConversationWindowViewController.h"
#import "RDVTabBarItem.h"
#import "PhotoAndCamerSelectView.h"//!相机、相册选择view
#import "Masonry.h"
#import "OrderDetaillViewController.h"//!采购单详情
#import "ExpressDeliverViewController.h"
#import "TopOrderStateView.h"


static NSString *const defaultsImageName = @"";

@interface CPSOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,RefreshControlDelegate>

@property(nonatomic,strong)NSMutableArray *resourceDataArray;

@property(nonatomic,strong)OrderTopView *orderTopView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UILabel *tipNodataLabel;

@property(nonatomic,strong)RefreshControl *refreshControl;
@property (nonatomic ,strong) TopOrderStateView *topOrderView;
@property (nonatomic,strong)  GetMerchantMainDTO *getMerchantMainDTO;



/**
 *  聊天数据
 */
@property (nonatomic ,strong) NSDictionary *orderMerchantDic;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;


@end

@implementation CPSOrderViewController{
    
    /**
     *  判断采购单列表是否请求成功
     */
    BOOL _isRequestForGetOrderListSuccess;
    
    /**
     *  判断统计数据是否请求成功
     */
    BOOL _isRequestForGetMerchantMainSuccess;
    
    /**
     *  判断是否修改成功
     */
    BOOL _isChangePriceSuccess;
    
    NSString *_orderCode;
    
    BOOL _isTakePhoto;
    
    //判断是否上传成功
    BOOL _isUploadImageSuccess;
    
    NSInteger _pageNo;
    
    BOOL _isRefresh;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"采购单";
    
//    [self initOrderTopView];
    
    [self initTableView];
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
    [self initArray];
    
    
    //!创建拍照发货 选择相册 相机的view
    [self initPhotoView];
    
}

/**sd
 *  返回到首页
 *
 *  @param s
 */
- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    [self rdv_tabBarController].selectedIndex = 0;
}

- (void)initOrderTopView{
    
    //顶部显示待付款 待发货 待收货
    
    
    self.orderTopView = [[[NSBundle mainBundle]loadNibNamed:@"OrderTopView" owner:self options:nil]objectAtIndex:1];
    
    //跳转到所有采购单列表页面
    
    __weak UIViewController *weakSelf = self;
    
    //待付款
    self.orderTopView.waitPaymentButtonBlock = ^(){
        CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];

        myOrderViewController.menuBar = MenuWaitPayOrder;
        
        [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];
    };
    
    //待发货
    self.orderTopView.waitDeliverGoodsButtonBlock = ^(){
        CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];

        myOrderViewController.menuBar = MenuWaitDeliverGoodsOrder;
        
        [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];
    };
    
    //待收货
    self.orderTopView.waitGoodsReceiptButtonBlock = ^(){
        CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];

        myOrderViewController.menuBar = MenuWaitGoodsReceiptOrder;
        
        [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];
    };


    //所有
    self.orderTopView.allOrderButtonBlock = ^() {
        CPSMyOrderViewController *myOrderVC = [[CPSMyOrderViewController alloc]init];
        myOrderVC.menuBar = MenuALLOrder;

        [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
    };
    
    //联系采购商
//    self.orderTopView.contactCustomerServiceBlock = ^(){
//        
//        DebugLog(@"联系采购商");
//        
//    };
    
//    [self.view addSubview:self.orderTopView];
}

- (void)initTableView{
    
    self.tipNodataLabel = [[UILabel alloc]init];
    
    self.tipNodataLabel.text = @"暂无数据";
    
    self.tipNodataLabel.backgroundColor = [UIColor clearColor];
    
    self.tipNodataLabel.font = [UIFont systemFontOfSize:13];
    
    self.tipNodataLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.tipNodataLabel];
    
    self.refreshControl = [[RefreshControl alloc]initWithScrollView:self.tableView delegate:self];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.orderTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.orderTopView.frame.size.height);
    
    self.tableView.frame = CGRectMake(0, self.orderTopView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-self.orderTopView.frame.size.height);
    
    self.tipNodataLabel.bounds = CGRectMake(0, 0, self.view.frame.size.width, 15);
    
    self.tipNodataLabel.center = self.tableView.center;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self tabbarHidden:NO];
    
    if (!_isTakePhoto) {
        
        _pageNo = 1;
        
        [self progressHUDShowWithString:@"加载中"];
        
        //请求采购单列表
        [self requestForGetOrderList];
        
        //请求统计数据
        [self requestForGetMerchantMain];
      
    }
    
    
    // !移除bage
    
    RDVTabBarItem * barItem = [self rdv_tabBarItem] ;
    
    barItem.badgeValue = @"";
    
    //!吊起相机、相册的时候 修改状态栏的颜色，在这个界面将要出现的时候改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
}

#pragma mark-请求采购单列表
- (void)requestForGetOrderList{
    
    if (_isChangePriceSuccess || _isUploadImageSuccess) {
        
        [self progressHUDShowWithString:@"加载中"];
    }
    
    //请求'待付款'和'待发货'数据1.2  1#2
    [HttpManager sendHttpRequestForGetOrderList:@"1,2" pageNo:[NSNumber numberWithInteger:_pageNo] pageSize:[NSNumber numberWithInteger:PAGESIZE] channelType:[NSNumber numberWithInteger:1] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        if (responseDic.allKeys ==0) {
            [self.progressHUD hide:YES];
            _isUploadImageSuccess = NO;
            return ;
        }
        
        if (_isUploadImageSuccess) {
            _isUploadImageSuccess = NO;
            [self.progressHUD hide:YES];

        }

        
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        if (_isChangePriceSuccess) {
            
            _isChangePriceSuccess = NO;
            
            //修改价格后刷新列表
            [self.progressHUD hide:YES];
            
        }else{
            //开始进入页面的时候
            _isRequestForGetOrderListSuccess = YES;
            
            if (_isRequestForGetMerchantMainSuccess) {
                
                _isRequestForGetMerchantMainSuccess = NO;
                
                _isRequestForGetOrderListSuccess = NO;
                
                [self.progressHUD hide:YES];
            }
        }
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                id orderList = [data objectForKey:@"orderList"];
                
                if ([self checkData:orderList class:[NSArray class]]) {
                    
                    NSArray *orderListArray = orderList;
                    
                    if (orderListArray.count) {
                        
                        if (!_isRefresh) {
                            [self.resourceDataArray removeAllObjects];
                        }
                        
                        for (NSDictionary *dataDic in orderListArray) {
                            
                            GetOrderDTO *getOrderDTO = [[GetOrderDTO alloc]init];
                            
                            [getOrderDTO setDictFrom:dataDic];
                            
                            id orderGoodsItems = [dataDic objectForKey:@"orderGoodsItems"];
                            
                            //判断数据合法
                            if (orderGoodsItems && [orderGoodsItems isKindOfClass:[NSArray class]]) {
                                
                                NSArray *orderGoodsItemsArray = (NSArray *)orderGoodsItems;
                                
                                for (NSDictionary *orderGoodsItemsDic in orderGoodsItemsArray) {
                                    
                                    orderGoodsItemDTO *orderItemDTO = [[orderGoodsItemDTO alloc]init];
                                    
                                    [orderItemDTO setDictFrom:orderGoodsItemsDic];
                                    
//                                    [getOrderDTO.goodsList addObject:orderItemDTO];
                                }
                            }
                            
                            [self.resourceDataArray addObject:getOrderDTO];
                        }
                        self.tableView.contentOffset = CGPointMake(0, 0);
                        [self.tableView reloadData];
                        
                    }
                }
                
                
            }
            
        }else{
            [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            return;
        }
        
        if (self.resourceDataArray.count) {
            self.tipNodataLabel.hidden = YES;
        }else{
            self.tipNodataLabel.hidden = NO;
        }
        
        if (self.resourceDataArray.count>=PAGESIZE) {
            [self.refreshControl setBottomEnabled:YES];
        }else{
            [self.refreshControl setBottomEnabled:NO];
        }
        
        
        NSNumber *numberCount = responseDic[@"data"][@"totalCount"];
        _refreshControl.bottomEnabled = YES;
        _refreshControl.dataEnable = YES;
        
      
        //判断是否到底了
        if (self.resourceDataArray.count == numberCount.integerValue) {
            
            if (numberCount.integerValue == 0) {
               
                _refreshControl.dataEnable = NO;
                
            }
            
            _refreshControl.bottomEnabled = NO;
            
        }
        
        _isRefresh = NO;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _isRefresh = NO;
        
        _isUploadImageSuccess = NO;

        
        [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView) {
        if (self.tableView.contentSize.height<=self.tableView.frame.size.height) {
            
            _refreshControl.dataEnable = NO;
            _refreshControl.bottomEnabled = NO;
            
        }
    }
   }

#pragma mark-请求统计数据
- (void)requestForGetMerchantMain{
    
    [HttpManager sendHttpRequestForGetMerchantMain:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _isRequestForGetMerchantMainSuccess = YES;
        
        if (_isRequestForGetOrderListSuccess) {
            
            _isRequestForGetOrderListSuccess = NO;
            
            _isRequestForGetMerchantMainSuccess = NO;
            
            [self.progressHUD hide:YES];
        }
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]){
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据的合法
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                
                GetMerchantMainDTO *getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
                
                [getMerchantMainDTO setDictFrom:data];
                
                self.getMerchantMainDTO = getMerchantMainDTO;
                
                
                self.topOrderView.merchantMainDto = getMerchantMainDTO;
                
                self.orderTopView.waitPaymentNumLabel.text = getMerchantMainDTO.notPayOrderNum.stringValue;
                
                self.orderTopView.waitDeliverGoodsNumLabel.text = getMerchantMainDTO.unshippedNum.stringValue;
                
                self.orderTopView.waitGoodsReceiptNumLabel.text = getMerchantMainDTO.untakeOrderNum.stringValue;
                
                [self.orderTopView setAllOrderAmount: getMerchantMainDTO.orderNum.integerValue];
                
                [self.tableView reloadData];
                
            }
            
        }else{
            
            //[self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];

    }];
}

- (void)initArray{
    self.resourceDataArray = [[NSMutableArray alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.resourceDataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {
        
        return 0;
        
    }else
    {
    GetOrderDTO *getOrder = [self.resourceDataArray objectAtIndex:section-1];
    
    NSArray *orderGoodsItemsList = getOrder.goodsList;
    
    return orderGoodsItemsList.count+2;
    }
}

- (CSPOrderInfoTableViewCell *)getCellWithIndex:(NSInteger)index{
    
    return [[[NSBundle mainBundle]loadNibNamed:@"CSPOrderInfoTableViewCell" owner:self options:nil]objectAtIndex:index];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellOneID = @"CSPOrderInfoTableViewCellID1";
    
    static NSString *cellTwoID = @"CSPOrderInfoTableViewCellID2";
    
    static NSString *cellThreeID = @"CSPOrderInfoTableViewCellID3";
    
    CSPOrderInfoTableViewCell *cell;
    
    NSString *cellID;
    
    NSInteger integer = 0;
    
    GetOrderDTO *getOrder = [self.resourceDataArray objectAtIndex:indexPath.section-1];
    
    orderGoodsItemDTO *orderGoodsItem;
    
    
    NSArray *orderGoodsItemsList = getOrder.goodsList;
    
    if (indexPath.row != 0 && indexPath.row != orderGoodsItemsList.count+1) {
        
        orderGoodsItem = [getOrder.goodsList objectAtIndex:indexPath.row-1];
        
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
        cell.tradingStateLabel.text = @"采购单取消";
    }

    
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
    [cell.swearImageView sd_setImageWithURL:[NSURL URLWithString:orderGoodsItem.picUrl] placeholderImage:[UIImage imageNamed:defaultsImageName]];
    
    //商品名称
    cell.swearTitleText = orderGoodsItem.goodsName;
//    cell.swearTitleLabel.text = orderGoodsItem.goodsName;
    
    //颜色
//    cell.colorLabel.text = [NSString stringWithFormat:@"颜色：%@",orderGoodsItem.color];
    cell.colorText = [NSString stringWithFormat:@"颜色：%@",orderGoodsItem.color];
    //价格字体处理
    cell.priceText = [NSString stringWithFormat:@"￥%0.2lf",orderGoodsItem.price.doubleValue ];
//    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderGoodsItem.price.stringValue];
    
    //数量
    cell.amountText = [NSString stringWithFormat:@"x%lu",orderGoodsItem.quantity.integerValue];

//    cell.amountLabel.text = [NSString stringWithFormat:@"x%@",orderGoodsItem.quantity.stringValue];
    
    //共几件商品
    cell.totalGoodsNumText =[NSString stringWithFormat:@"共%lu件商品",getOrder.quantity.integerValue];
//    cell.totalGoodsNumLabel.text = [NSString stringWithFormat:@"共%@件商品",getOrder.quantity.stringValue];
    
    //总价
    double orderTotalPrice =  [getOrder.originalTotalAmount doubleValue];
    
    cell.totalOrderPriceText = [NSString stringWithFormat:@"采购单总价：￥%0.2lf",orderTotalPrice];
    //    cell.TotalOrderPriceLabel.text = [NSString stringWithFormat:@"采购单总价：￥%@", getOrder.originalTotalAmount.stringValue];

    
    
    
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
//        cell.shouldPayLabel.text = [NSString stringWithFormat:@"应付：￥%@",getOrder.totalAmount.stringValue];
        
        cell.tipModifyOrTakePhoneLabel.text = @"修改应付金额：";
        
        [cell.modifyOrTakePhoneButton setTitle:@"修改采购单总价" forState:UIControlStateNormal];
        cell.shootCouriersingleDeliveryBtn.hidden = YES;
        CGFloat width = [self gainFontWidthContent:@"修改采购单总价"];
        cell.modifyOrTakePhoneButtonWitdh.constant = width+6;
        
        
    }else if (getOrder.status.integerValue == 2){
        //待发货
        //
        cell.shouldPayText = [NSString stringWithFormat:@"实付: ￥%0.2lf",getOrder.paidTotalAmount.doubleValue];
//        cell.shouldPayLabel.text = [NSString stringWithFormat:@"实付：￥%@",getOrder.totalAmount.stringValue];
        cell.shootCouriersingleDeliveryBtn.hidden = NO;
//        cell.tipModifyOrTakePhoneLabel.text = @"快递单拍照后发货:";
        CGFloat width = [self gainFontWidthContent:@"录入快递单发货"];
        cell.modifyOrTakePhoneButtonWitdh.constant = width+6;
        cell.shootCouriersingleDeliveryBtnWitdh.constant = width+6;
        

        [cell.modifyOrTakePhoneButton setTitle:@"录入快递单发货" forState:UIControlStateNormal];
        [cell.shootCouriersingleDeliveryBtn setTitle:@"拍摄快递单发货" forState:UIControlStateNormal];
        
    }else{
//        cell.shouldPayLabel.text = @"未知";
    }
    
    cell.selectshootCouriersingleDeliveryBtnBlock = ^()
    {
        
        //待发货
        //拍照发货
        
        self.blackAlphaView.hidden = NO;
        self.photoAndCamerSelectView.hidden = NO;
        
        [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

        _orderCode = getOrder.orderCode;
        
        
    };
    
    
    cell.modifyOrTakePhoneButtonBlock = ^(){
        //判断是修改 还是录入快递单发货
        if (getOrder.status.integerValue == 1) {
            
            //修改--弹出修改页面
            
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            
            __weak CSPModifyPriceView *modifyPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CSPModifyPriceView" owner:self options:nil]lastObject];
            
            modifyPriceView.titleLabel.text = [NSString stringWithFormat:@"%@    %@    %@",orderType,getOrder.consigneeName,getOrder.consigneePhone];
            
            modifyPriceView.originalTotalAmountLabel.text = [NSString stringWithFormat:@"采购单总价：￥%.2f",getOrder.originalTotalAmount.doubleValue];
            modifyPriceView.requestType = @"block";
            
            
            modifyPriceView.frame = CGRectMake(0, 0, window.frame.size.width, window.frame.size.height);
            
            modifyPriceView.confirmBlock = ^(){
                
                [self progressHUDShowWithString:@"修改中"];
                
                NSString * amountText = modifyPriceView.amoutTextField.text;
                
                
                [HttpManager sendHttpRequestForGetModifyOrderAmount:getOrder.orderCode newAmount:modifyPriceView.amoutTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *responseDic = [self conversionWithData:responseObject];
                    
                    DebugLog(@"dic = %@", responseDic);
                    
                    if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                        
                        //                        _isChangePriceSuccess = YES;
                        getOrder.totalAmount = [NSNumber numberWithDouble:amountText.doubleValue];
                        
                        cell.shouldPayText= [NSString stringWithFormat:@"应付: ￥%.2lf",getOrder.totalAmount.doubleValue];
                        
                        
                        //修改成功
                        [self progressHUDHiddenTipSuccessWithString:@"修改完成"];
                        
                    }else{
                        GUAAlertView *alert =  [GUAAlertView alertViewWithTitle:@"修改失败" withTitleClor:nil message:[responseDic objectForKey:ERRORMESSAGE] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                            [self requestForGetOrderList];
                            [self requestForGetMerchantMain];
                            
                        } dismissAction:^{
                            
                        }];
                        
                        [alert show];
                        
                        //                        [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
                        
                        [self.progressHUD hide:YES];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    
                    [self tipRequestFailureWithErrorCode:error.code];
                }];
                
            };
            
            [window addSubview:modifyPriceView];

            
            
        }else if (getOrder.status.integerValue == 2){
            
            
            ExpressDeliverViewController *expressVC = [[ExpressDeliverViewController alloc] init];
            expressVC.orderCode= getOrder.orderCode;
            [self.navigationController pushViewController:expressVC animated:YES];
            
            /*
            //判断是否可以打开相机，模拟器此功能无法使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                _orderCode = getOrder.orderCode;

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
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    if (section == 0) {
        
        //跳转到所有采购单列表页面
        
        __weak UIViewController *weakSelf = self;
        
        _topOrderView = (TopOrderStateView*)[[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateView" owner:self options:nil]lastObject];
        _topOrderView.merchantMainDto = self.getMerchantMainDTO;
        
        //待付款
        _topOrderView.blockwaitPay = ^()
        {
            CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];
            
            myOrderViewController.menuBar = MenuWaitPayOrder;
            
            [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];

            
        };
        
        //待发货
        _topOrderView.blockwaitDeliver = ^()
        {
            CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];
            
            myOrderViewController.menuBar = MenuWaitDeliverGoodsOrder;
            
            [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];

        };
        
        //待收货
        _topOrderView.blockwaitReceipt = ^()
        {
            CPSMyOrderViewController *myOrderViewController = [[CPSMyOrderViewController alloc]init];
            
            myOrderViewController.menuBar = MenuWaitGoodsReceiptOrder;
            
            [weakSelf.navigationController pushViewController:myOrderViewController animated:YES];

        };
        
        //全部订单
        _topOrderView.blockAllOrderState = ^()
        {
            CPSMyOrderViewController *myOrderVC = [[CPSMyOrderViewController alloc]init];
            myOrderVC.menuBar = MenuALLOrder;
            
            [weakSelf.navigationController pushViewController:myOrderVC animated:YES];

            
        };

        
        return _topOrderView;
        
    }else
    {
    
    GetOrderDTO *getOrderDTO = [self.resourceDataArray objectAtIndex:section-1];
    
    OrderTopView *orderTopView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"OrderTopView"];
    
    if (!orderTopView) {
        
        orderTopView = [[[NSBundle mainBundle]loadNibNamed:@"OrderTopView" owner:self options:nil]firstObject];
    }
    
    orderTopView.nameWithPhoneNumLabel.text = [NSString stringWithFormat:@"%@    %@",getOrderDTO.consigneeName,getOrderDTO.consigneePhone];
    
    orderTopView.contactCustomerServiceBlock = ^(){
        
        DebugLog(@"联系客服");
        self.orderMerchantDic = getOrderDTO.mj_keyValues;

        ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:getOrderDTO.nickName jid:getOrderDTO.chatAccount withMerchanNo:getOrderDTO.merchantNo withDic:self.orderMerchantDic];
        
        
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        
    };
    
    return orderTopView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GetOrderDTO *getOrder = [self.resourceDataArray objectAtIndex:indexPath.section-1];
    
    NSArray *orderGoodsItemsList = getOrder.goodsList;
    
    orderGoodsItemDTO *orderGoodsItem;

    if (indexPath.row == 0) {
        
        return 44.0f;
        
    }else if (indexPath.row == orderGoodsItemsList.count+1){
        
        return 110.0f;
        
    }else{
        
        orderGoodsItem = [getOrder.goodsList objectAtIndex:indexPath.row-1];
        
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
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 65.0f;
        
    }
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0.01f;
//    }
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GetOrderDTO *getOrder = [self.resourceDataArray objectAtIndex:indexPath.section-1];
    
    NSArray *orderGoodsItemsList = getOrder.goodsList;
    
    if (indexPath.row != 0 && indexPath.row != orderGoodsItemsList.count+1) {
        
        
        OrderDetaillViewController * detailVC = [[OrderDetaillViewController alloc]init];
        //拍照发货、录入快递单
        detailVC.deliverGoodsInWaitStatusBlock = ^(NSString * orederCode,NSString * orderOldStatus)
        {
            [self requestForGetOrderList];
            [self requestForGetMerchantMain];

            

        };
        _isTakePhoto = YES;
        
        //修改订单金额
        detailVC.changeTotalCountBlock = ^(NSString * orederCode,NSString * orderOldStatus,NSString * totalCount)
        {
            CGFloat totalPrice = totalCount.doubleValue;
            NSNumber *totalNub = [NSNumber numberWithDouble:totalPrice];
            
            getOrder.totalAmount = totalNub;
            [self.tableView reloadData];
            
            
        };
        
        detailVC.orderCode = getOrder.orderCode;

        [self.navigationController pushViewController:detailVC animated:YES];
        
//        CPSOrderDetailsViewController *orderDetailsViewController = [[CPSOrderDetailsViewController alloc]init];
//        
//        orderGoodsItemDTO *orderGoodsItem = [getOrder.orderGoodsItemsList objectAtIndex:indexPath.row-1];
//        
//        orderDetailsViewController.orderCode = getOrder.orderCode;
//        
//        // 0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
//        orderDetailsViewController.orderStatus =  getOrder.status.integerValue;
//        
//        orderDetailsViewController.goodsNo = orderGoodsItem.goodsNo;
//          [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
//        [self.navigationController pushViewController:orderDetailsViewController animated:YES];
        
        
    }
    
}
#pragma mark 拍照发货
//!创建拍照发货 选择相册 相机的view
-(void)initPhotoView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height -self.tabBarController.tabBar.frame.size.height - 20;
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
    
    __weak CPSOrderViewController * orderVC = self;
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
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    
    
    
}
//!隐藏相册选择的view 以及上半部分的灰色半透明部分
-(void)hidePhotoSelectView{
    
    self.blackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    
    
}

//!掉起相册 相机:isCamer=yes
-(void)showPhoto:(BOOL)isCamer{

    //待发货
    //拍照发货
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.translucent = NO;

    //如果选择的是相机，则判断是否可以吊起相机
    if (isCamer && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    
    //!吊起相机、相册的时候 修改状态栏的颜色，在这个界面将要出现的时候改回白色
    [self presentViewController:picker animated:YES completion:^{
    
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
    }];
    
    
}

#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    _isTakePhoto = YES;
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self progressHUDShowWithString:@"上传中"];
        
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];

    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    [self removeFromSuperview];
    [self.view endEditing:YES];
    
    
}

#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
  
    
    if (_isChangePriceSuccess) {
        
        [self requestForGetOrderList];
    }
    
    if (_isUploadImageSuccess) {
        
        _pageNo = 0;
        
        //请求采购单列表
        [self requestForGetOrderList];
        
        //请求统计数据
        [self requestForGetMerchantMain];
    }
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    
    if (direction==RefreshDirectionTop){
        
        
    }else if (direction == RefreshDirectionBottom){
        
        //加载列表
        _pageNo++;
        
        _isRefresh = YES;
        
        [self requestForGetOrderList];
    
    }
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

/**
 *  计算字体宽度
 *
 *  @param content 输入的内容
 *
 *  @return 返回字体的宽度
 */
- (CGFloat)gainFontWidthContent:(NSString *)content
{
    CGSize size;
    
    size=[content boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    return size.width;
    
    
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
