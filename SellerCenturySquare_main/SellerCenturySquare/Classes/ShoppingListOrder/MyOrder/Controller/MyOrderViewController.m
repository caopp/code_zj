//
//  MyOrderViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/7.
//  Copyright © 2016年
//
//View
#import "SDRefreshView.h"
#import "SDRefreshHeaderView.h"//上拉
#import "SDRefreshFooterView.h"//下拉
#import "CSPModifyPriceView.h"//更改价格
#import "PhotoAndCamerSelectView.h"//相册的View
#import "MyOrderParentTableViewCell.h"//基类cell

//Model
#import "GetOrderDTO.h"//所有订单的model
#import "orderGoodsItemDTO.h"//单个商品详细信息model


//Controller
#import "MyOrderViewController.h"
#import "ExpressDeliverViewController.h"//录入快递单发货
#import "OrderDetaillViewController.h"//订单详情
#import "TitleZoneGoodsTableViewCell.h"
#import "ConversationWindowViewController.h"
#import "CombinedShippingViewController.h"

#import "ConsultTitleCollectionCell.h"

#import "RetailOrderDetailController.h"//!零售单详情
#import "OrderListHeadView.h"


//Other
#import "Masonry.h"

//头部按钮Tag
#define  titleBtnTag 123456
//订单TableViewTag
#define tableViewTag 10000
//头部宽度
#define titleBtnWidth ([UIScreen mainScreen].bounds.size.width/4)
//头部高度
#define titleBtnHeight 30




@interface MyOrderViewController ()<UITableViewDataSource ,UITableViewDelegate ,MyOrderParentDelegate,UIImagePickerControllerDelegate,UINavigationBarDelegate,MBProgressHUDDelegate,UICollectionViewDelegate, UICollectionViewDataSource>

{
    
    NSInteger leftIndex;
    CGFloat leftPercent;
    NSInteger selectIndex;
}
//头部ScrollView
@property (nonatomic ,strong) UIScrollView *topScrollView;
//底部ScrollView
@property (nonatomic ,strong) UIScrollView *bottomScrollView;
//记录头部按钮
@property (nonatomic ,strong) UIButton *recordTitleBtn;
//所有订单的数组
@property (nonatomic ,strong) NSMutableArray *allOrderArr;
//单个采购单的所有数据
@property (nonatomic ,strong) NSMutableArray *singleArr;
//请求记录页
@property (nonatomic ,assign) NSInteger pageNo;
//当前的tableView
@property (nonatomic ,strong) UITableView *currentTableView;

/**
 *  所有顶部的按钮
 */
@property (nonatomic ,strong) NSMutableArray *topBtnArr;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;
//记录订单
@property (nonatomic ,copy) NSString *orderCode;

@property (nonatomic ,strong) GetOrderDTO *getOrderdto;

//所有的下拉刷新
@property (nonatomic ,strong) NSMutableArray *refreshHeadArr;
//所有的上拉加载
@property (nonatomic ,strong) NSMutableArray *refreshFootArr;

@property (nonatomic ,strong) NSMutableArray *tableViewArr;

@property (nonatomic ,strong) NSArray *titleArr;



/**
 *  当前要请求的采购单状态
 */
@property (nonatomic ,assign) NSInteger currentRequestSate;

@property (nonatomic ,strong) NSDictionary *orderMerchantDic;

@property (nonatomic ,strong) UIButton *bottomBtn;

@property (nonatomic ,strong) UICollectionView *topCollection;






@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//tableViewWidth
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList:) name:@"RefreshOrderList" object:nil];
    
    [self customBackBarButton];


    //初始化所有数据和View
    [self initDataSourceAndView];
    
    //初始化 相册
    [self initPhotoView];
    
    
    //根据传过来的值进行选择
//    [self clickChangeTitleBtn:self.recordTitleBtn];
    
}

//初始化所有数据和View
- (void)initDataSourceAndView
{
    
    NSArray *titleArr;
    
    if (self.channelType == 0) {
        titleArr= @[@"全部",@"待付款",@"待发货",@"待收货",@"交易完成",@"采购单取消",@"交易取消",@"退/换货"];
        self.title = @"批发订单";


    }else
    {
        titleArr= @[@"全部",@"待付款",@"待发货",@"待收货",@"交易完成",@"订单取消",@"退/换货"];
        self.title = @"零售订单";

    }
    
    
    self.titleArr = titleArr;
    
    
    //上拉加载
    self.refreshFootArr = [NSMutableArray array];
    //下拉刷新
    self.refreshHeadArr = [NSMutableArray array];
    //所有订单
    self.allOrderArr = [NSMutableArray array];
    //单个订单的数据
    self.singleArr = [NSMutableArray array];
    //所有tableView
    self.tableViewArr = [NSMutableArray array];
    
    //顶部按钮
    self.topBtnArr = [NSMutableArray array];
    //初始化请求页
    self.pageNo = 1;
    
    for (int i = 0; i<titleArr.count; i++) {
        NSMutableArray *singleArr = [NSMutableArray array];
        [self.allOrderArr addObject:singleArr];
        
    }
 
    //顶部head
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    //隐藏滚动条
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    self.topScrollView.showsVerticalScrollIndicator = NO;
    
//    scrollView.showsHorizontalScrollIndicator
    self.topScrollView.delegate = self;
    self.topScrollView.scrollsToTop = NO;
    
    [self.view addSubview:self.topScrollView];
    //布局
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(titleBtnHeight));
    }];
    
    //设置不要超越界限
    self.topScrollView.bounces = NO;
    self.topCollection.showsHorizontalScrollIndicator = NO;
    //所有标题
    //head按钮的宽度
    
    //tableView的高度
    CGFloat tableViewWidth  = [UIScreen mainScreen].bounds.size.width;
    self.topScrollView.contentSize = CGSizeMake(titleBtnWidth*titleArr.count, 0);
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.topCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(titleBtnWidth, 30);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumLineSpacing= 0;
    flowLayout.minimumInteritemSpacing = 0;
    [self.topCollection registerNib:[UINib nibWithNibName:@"ConsultTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ConsultTitleCollectionCelliD"];
    self.topCollection.delegate = self;
    self.topCollection.dataSource = self;
    self.topCollection.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    self.topCollection.contentOffset = CGPointMake(titleArr.count*titleBtnWidth, 0);
    self.topCollection.bounces = NO;
    [self.view addSubview: self.topCollection];
    
    
    //底部contentView内容
    //创建
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    self.bottomScrollView.pagingEnabled  = YES;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.scrollsToTop = NO;
    
    self.bottomScrollView.delegate =self;
    
    
    [self.view addSubview:self.bottomScrollView];
    //滚动范围
    self.bottomScrollView.contentSize = CGSizeMake(tableViewWidth*titleArr.count, 0);
    //布局
    [self.bottomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topScrollView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    //记录后一个tableView
    UITableView *lastTableView;
    
    //初始化所有订单的tableView
    for (int  i = 0; i<titleArr.count; i++) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStyleGrouped];
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
        if (i == self.currentOrderState) {
            self.currentTableView = tableView;
        }
        //设置代理，tag，隐藏cell线条
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollsToTop = NO;
        tableView.tag = tableViewTag + i;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.bottomScrollView addSubview:tableView];
        [self.tableViewArr addObject:tableView];
        
        
        if (i == 2 && self.channelType == 0) {
            self.bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.bottomBtn setTitle:@"合并采购商发货" forState:UIControlStateNormal];
            [self.view addSubview:self.bottomBtn];
            self.bottomBtn.backgroundColor = [UIColor blackColor];
            [self.bottomBtn addTarget:self action:@selector(clickTotalGoodsBtn:) forControlEvents:UIControlEventTouchUpInside];
//            self.bottomBtn.hidden = YES;
            self.bottomBtn.userInteractionEnabled= YES;
            
            [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tableView.mas_left);
                make.right.equalTo(tableView.mas_right);
                make.bottom.equalTo(self.view.mas_bottom);
                make.height.equalTo(@46);
                
            }];
        }
        
        //布局
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomScrollView.mas_top);
            make.left.equalTo(lastTableView?lastTableView.mas_right:self.bottomScrollView.mas_left);
            make.bottom.equalTo(self.view.mas_bottom).offset(i==2 && self.channelType == 0?-46:0);
            make.width.equalTo(@(tableViewWidth));
        }];
        
        //记录
        lastTableView = tableView;
        
        //下拉刷新
        SDRefreshHeaderView *refreshHead = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
        [refreshHead addToScrollView:tableView];
        [self.refreshHeadArr addObject:refreshHead];
        
        //上拉加载
        SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
        [refreshFooter addToScrollView:tableView];
        [self.refreshFootArr addObject:refreshFooter];
    }
    
    
    
    
    [UIView animateWithDuration:0.5f animations:^{
        self.topCollection.contentOffset = CGPointMake(self.titleArr.count*titleBtnWidth, 0);
        
        
    } completion:^(BOOL finished) {
        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentOrderState inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self collectionView:self.topCollection  didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentOrderState inSection:0]];
        
    }];
    

    

}

- (void)viewWillAppear:(BOOL)animated
{
    
    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
//    //隐藏tabbar
//    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

#pragma mark - Action
- (void)chooseOrderState:(NSInteger )tag
{
    
    
    if (self.channelType == 0) {
        
    
    self.currentOrderState = tag;
    
    /**
     *   根据按钮的tag 判断当前采购单的状态
     *    btn.tag = self.currentOrderState :0.全部，1.待付款，2，待发货，3，待收货，4，交易完成，5，采购单取消，6，交易取消
     *   currentRequestSate : 0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成 6-全部采购单
     */
    switch (self.currentOrderState) {
        case 0:
            self.currentRequestSate = 7;
            break;
        case 1:
        {
            self.currentRequestSate = 1;
        }
            break;
        case 2:
            self.currentRequestSate = 2;
            break;
        case 3:
            self.currentRequestSate = 3;
            break;
        case 4:
            self.currentRequestSate = 5;
            break;
        case 5:
            self.currentRequestSate = 0;
            break;
        case 6:
            self.currentRequestSate = 4;
            break;
        case 7:
            self.currentRequestSate = 6;
            break;
        default:
            break;
    }
}else
{
    self.currentOrderState = tag;
    
    /**
     *   根据按钮的tag 判断当前采购单的状态
     [@"全部",@"待付款",@"待发货",@"待收货",@"交易完成",@"订单取消",@"退/换货"
     *    btn.tag = self.currentOrderState :0.全部，1.待付款，2，待发货，3，待收货，4，交易完成，5，采购单取消,6,退换货
     *   currentRequestSate : 0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成;6-退/换货
     
     
     */
    switch (self.currentOrderState) {
        case 0:
            self.currentRequestSate = 7;
            break;
        case 1:
        {
            self.currentRequestSate = 1;
        }
            break;
        case 2:
            self.currentRequestSate = 2;
            break;
        case 3:
            self.currentRequestSate = 3;
            break;
        case 4:
            self.currentRequestSate = 5;
            break;
        case 5:
            self.currentRequestSate = 0;
            break;
        case 6:
            self.currentRequestSate = 6;
            break;
            //        case 7:
            //            self.currentRequestSate = 6;
            //            break;
        default:
            break;
    }
}
    
    for (UITableView *tableView in self.tableViewArr) {
        tableView.scrollsToTop = NO;
    }
    
    //点击按钮以后刷新操作
    self.singleArr = [NSMutableArray array];
    self.pageNo = 1;
    [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];

    
    //从数组中获取下拉刷新
    SDRefreshHeaderView *refreshHeader = self.refreshHeadArr[self.currentOrderState];
    refreshHeader.beginRefreshingOperation = ^{
        self.singleArr = [NSMutableArray array];
        self.pageNo = 1;
        [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
    };

    
    //从数组获取上拉加载
    __weak MyOrderViewController * vc = self;
    
    //上拉加载
    SDRefreshFooterView *refreshFooter = self.refreshFootArr[self.currentOrderState];
    
    refreshFooter.beginRefreshingOperation= ^{
        
        [vc requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
    };
    

}


- (void)clickTotalGoodsBtn:(UIButton*)btn
{
    CombinedShippingViewController *combinedVC = [[CombinedShippingViewController alloc] init];
    combinedVC.merchantNo = self.getOrderdto.merchantNo;
    
    combinedVC.requestBlock= ^()
    {
        
        
        //点击按钮以后刷新操作
        self.singleArr = [NSMutableArray array];
        self.pageNo = 1;
        [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
    };
    
    [self.navigationController pushViewController:combinedVC animated:YES];
    
}

- (void)contentCollectionDidScrollAtIndex:(NSInteger)index atCurrentItemPercent:(CGFloat)percent {
    NSLog(@"index = %ld, percent = %f", index, percent);
    leftIndex = index;
    leftPercent = percent;
    [self.topCollection reloadData];
}

#pragma mark - UITableViewDataSource ,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //获取当前采购单的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    
    if (tableView == selecttableView) {
        
    if (self.allOrderArr.count>0) {
        
        //获取单个采购单的数组
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
        if (singleArr.count>0) {
        return singleArr.count ;
        }
        return 1;
    }
        
}
    
    return 0;
    

}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
    

    if (singleArr.count>0) {
        
    GetOrderDTO *OrderDto = singleArr[section];
        
        if (self.channelType == 0) {
            
        
        return OrderDto.goodsList.count+2;
        }else
        {
            return OrderDto.goodsList.count+1;

        }
    }
    
    return 1;

    
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    if (selecttableView == tableView) {
    //顶部
    static NSString *TopOrderStateTableViewableViewCellId = @"TopOrderStateTableViewableViewCellId";

    //中间
        //普通商品
    static NSString *CenterNormalShopMessageTableViewCellId = @"CenterNormalShopMessageTableViewCellId";
        //邮费专拍
    static NSString *CenterPostageShopMessageTableViewCellId = @"CenterPostageShopMessageTableViewCellId";
        //样板
    static NSString *CenterSampleShopMessageCellTableViewCellId = @"CenterSampleShopMessageCellTableViewCellId";
    
    //底部
        //待付款
    static NSString *BottomPaymentAccountsMessageCellTableViewCellId = @"BottomPaymentAccountsMessageCellTableViewCellId";
        //待发货
    static NSString *BottomSendGoodsAccoutsMeessagCellTableViewCellId = @"BottomSendGoodsAccoutsMeessagCellTableViewCellId";
        //待收货，交易完成，，交易完成
    static NSString *BottomOtherAccountMessageTableViewCellId = @"BottomOtherAccountMessageTableViewCell"
        ;
        //采购单取消 交易取消
    static NSString *BottomOrderCancelPayCancelMessageTableViewCellId = @"BottomOrderCancelPayCancelMessageTableViewCellId";
        
    MyOrderParentTableViewCell *myCell;
        //获取采购单的tableView
        UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
        
        
        if (tableView == selecttableView) {

    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
            if (singleArr.count>0) {
                
            
            
            
    GetOrderDTO *orderDto = singleArr[indexPath.section];
                
                if (self.channelType == 0) {
                    
                
    // ** 显示采购单状态
    if (indexPath.row == 0) {
        
        myCell = [tableView dequeueReusableCellWithIdentifier:TopOrderStateTableViewableViewCellId];
        if (!myCell) {
        myCell = [[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateTableViewableViewCell" owner:self options:nil] lastObject];
        }
        myCell.orderDto = orderDto;

    }else if (indexPath.row!=0 && indexPath.row < orderDto.goodsList.count+1)
    {
        // ** 显示所有商品信息
        NSLog(@"index.row = %ld",(long)indexPath.row);
        
        orderGoodsItemDTO *goodsItemDto = orderDto.goodsList[indexPath.row - 1];
        if ([goodsItemDto.cartType isEqualToString:@"0"]) {
            
            // *  普通商品
            myCell = [tableView dequeueReusableCellWithIdentifier:CenterNormalShopMessageTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:self options:nil] lastObject];
            }
            
            
        }else if ([goodsItemDto.cartType isEqualToString:@"1"])
        {
            
            // * 样板
            myCell = [tableView dequeueReusableCellWithIdentifier:CenterSampleShopMessageCellTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:self options:nil] lastObject];
            }
            
        }else if ([goodsItemDto.cartType isEqualToString:@"2"])
        {
            
            // * 邮费专拍
            myCell = [tableView dequeueReusableCellWithIdentifier:CenterPostageShopMessageTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:self options:nil] lastObject];
            }
 
        }
        
        myCell.goodsItemDto = goodsItemDto;
        
    } else if  (indexPath.row == orderDto.goodsList.count+1)
    {
        // **  显示商品总价，件数
        if (orderDto.status.integerValue == 1 ) {
            
            // * 待付款
            myCell = [tableView dequeueReusableCellWithIdentifier:BottomPaymentAccountsMessageCellTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomPaymentAccountsMessageCellTableViewCell" owner:self options:nil]lastObject ];
            }
 
        }else if (orderDto.status.integerValue == 2)
        {
            //* 待发货
            
            //* 待发货
            
            if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                if (!myCell) {
                    myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:nil options:nil]lastObject];
                }
                
            }else
            {
                myCell = [tableView dequeueReusableCellWithIdentifier:BottomSendGoodsAccoutsMeessagCellTableViewCellId];
                if (!myCell) {
                    myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomSendGoodsAccoutsMeessagCellTableViewCell" owner:nil options:nil]lastObject];
                }
                
            }
            
            
            
        }else if (orderDto.status.integerValue == 3 || orderDto.status.integerValue == 5)
        {
            
            // *  待收货，交易完成,交易完成
            
            
            if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                if (!myCell) {
                    myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:nil options:nil]lastObject];
                }
                
            }else
            {
            
            myCell = [tableView dequeueReusableCellWithIdentifier:BottomOtherAccountMessageTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:self options:nil]lastObject ];
            }
        }
        }else if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 4)
        {
            myCell = [tableView dequeueReusableCellWithIdentifier:@"BottomOrderCancelPayCancelMessageTableViewCellId"];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:self options:nil] lastObject];
            }
            
            
        }

        myCell.delegate = self;
        
        myCell.orderDto = orderDto;
        
        
    }
            
        myCell.selectionStyle =  UITableViewCellSelectionStyleNone;
            
    return myCell;
            }else
            {
                if (indexPath.row != orderDto.goodsList.count) {
                    
                    orderGoodsItemDTO *goodsItemDto = orderDto.goodsList[indexPath.row];
                    // *  普通商品
                    myCell = [tableView dequeueReusableCellWithIdentifier:CenterNormalShopMessageTableViewCellId];
                    if (!myCell) {
                        myCell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:self options:nil] lastObject];
                    }
                    
                    
                    
                    myCell.goodsItemDto = goodsItemDto;
                    myCell.selectionStyle =  UITableViewCellSelectionStyleNone;

                    return myCell;
                }
                
                else if  (indexPath.row == orderDto.goodsList.count)
                {
                    // **  显示商品总价，件数
                    if (orderDto.status.integerValue == 1 ) {
                        
                        // * 待付款
                        myCell = [tableView dequeueReusableCellWithIdentifier:BottomPaymentAccountsMessageCellTableViewCellId];
                        if (!myCell) {
                            myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomPaymentAccountsMessageCellTableViewCell" owner:self options:nil]lastObject ];
                        }
                        
                    }else if (orderDto.status.integerValue == 2)
                    {
                        //* 待发货
                        
                        //* 待发货
                        
                        if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                            myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                            if (!myCell) {
                                myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:nil options:nil]lastObject];
                            }
                            
                        }else
                        {
                            myCell = [tableView dequeueReusableCellWithIdentifier:BottomSendGoodsAccoutsMeessagCellTableViewCellId];
                            if (!myCell) {
                                myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomSendGoodsAccoutsMeessagCellTableViewCell" owner:nil options:nil]lastObject];
                            }
                            
                        }
                        

                        
                    }else if (orderDto.status.integerValue == 3 || orderDto.status.integerValue == 5)
                    {
                        
                        // *  待收货，交易完成,交易完成
                        if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                            myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                            if (!myCell) {
                                myCell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:nil options:nil]lastObject];
                            }
                            
                        }else
                        {

                        myCell = [tableView dequeueReusableCellWithIdentifier:BottomOtherAccountMessageTableViewCellId];
                        if (!myCell) {
                            myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:self options:nil]lastObject ];
                        }
                    }
                    }else if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 4)
                    {
                        myCell = [tableView dequeueReusableCellWithIdentifier:@"BottomOrderCancelPayCancelMessageTableViewCellId"];
                        if (!myCell) {
                            myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:self options:nil] lastObject];
                        }
                        
                        
                    }
                        
                    
                    myCell.delegate = self;
                    myCell.orderDto = orderDto;
                    
                    myCell.selectionStyle =  UITableViewCellSelectionStyleNone;

                    return myCell;
                }
            }
        }
    }
}
    
    static NSString *cellId = @"CELL";
TitleZoneGoodsTableViewCell*   cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    
    //判断是否是大B
    if (self.channelType == 0) {
        
        [cell titleZoneGoodsChannelType:@"2"];
    }else
    {
        [cell titleZoneGoodsChannelType:@"3"];
    }
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //获取采购单的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    
    if (tableView == selecttableView) {
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
        if (singleArr.count>0) {
            
        

    //第一行默认
    if (indexPath.row == 0) {
        if (self.channelType == 0) {
            
        
        return 30;
            }
        return 80;
    }
    

    if (singleArr.count>0) {
        //
        GetOrderDTO *orderDto = singleArr[indexPath.section];
        //最后一行 默认
        if (self.channelType == 0) {
            
        
        if (orderDto.goodsList.count+1==indexPath.row) {
            
            if (orderDto.status.integerValue == 3 ||orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5)
            {
                
                if (orderDto.status.integerValue == 2||orderDto.status.integerValue == 3) {
                    if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                        return 44;
                        
                    }
                }

                return 70;
            }else if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 4)
            {
                return 44;
            }
            
            if (orderDto.status.integerValue == 1||orderDto.status.integerValue == 2 ) {
                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    
                    return 44;
                }
                
                return 100;
            }
            
            return 100;
        }
        }else
        {
            if (orderDto.goodsList.count ==indexPath.row) {
                
                
                if (orderDto.status.integerValue == 3||orderDto.status.integerValue == 2||orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5||orderDto.status.integerValue == 1)
                {
                    
                    if (orderDto.status.integerValue == 2||orderDto.status.integerValue == 3) {
                        if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                            return 44;
                            
                        }
                    }
                    if (orderDto.status.integerValue == 2) {
                        return 100;
                    }
                    
                    return 70;
                }else if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 4)
                {
                    return 44;
                }
                
                
                
                return 100;
            }
        }
        //第二行后倒数第二行

        if (indexPath.row != 0 && indexPath.row<orderDto.goodsList.count +1) {
        orderGoodsItemDTO *goodsItemDto = orderDto.goodsList[indexPath.row - 1];

        NSString *sizes = goodsItemDto.sizes;
        NSArray *sizeArr =[sizes componentsSeparatedByString:@","];
        
            
            CGFloat viewWidth = [UIScreen mainScreen].bounds.size.width-138;
            
            
            CGFloat lastWidth;
            CGFloat indexX = 0;
            CGFloat indexY = 0;
            

        
        //根据尺寸的个数 判断大小
        CGRect recoreSizeFrame;
        if ( sizeArr.count>0) {
            
            for (int i = 0; i<sizeArr.count; i++) {
                
                if (i >0) {
                    lastWidth = [self accordingContentFont:sizeArr[(i-1)]].width;
                }else
                {
                    lastWidth = [self accordingContentFont:sizeArr[i]].width;
                    
                }
                CGFloat orginX =(recoreSizeFrame.size.width!=0?(CGRectGetMaxX(recoreSizeFrame)+10):0);

                
                if (viewWidth<CGRectGetMaxX(recoreSizeFrame)) {
                    indexX = 0;
                    orginX = 0;
                    indexY++;
                }


                
                CGRect labelFrame =   CGRectMake(orginX, 22*indexY, [self accordingContentFont:sizeArr[i]].width+15, 15);
                if (viewWidth<CGRectGetMaxX(labelFrame)) {
                    indexX = 0;
                    indexY++;
                    orginX = 0;

                    CGRect frame = labelFrame;
                    frame = CGRectMake(orginX, 22*indexY, labelFrame.size.width, 15);
                    labelFrame = frame;
                    
                }
                
                
                recoreSizeFrame= labelFrame;
                indexX++;
                
                }
            }
        return 60+CGRectGetMaxY(recoreSizeFrame);
        }
        }
        }
        else
        {
            return self.view.frame.size.height;
            
        }
}
    return 0;
}

-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
    if (singleArr.count>0) {

    //默认
    UIView *footerView = [[UIView alloc] init];
    footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 19);
    footerView.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
    return footerView;
    }
    return nil;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //获取采购单的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    
    
    if (tableView == selecttableView) {
        
            NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
            if (singleArr.count>0) {
    if (self.channelType == 0) {

    MyOrderParentTableViewCell *headView = [[[NSBundle mainBundle]loadNibNamed:@"TopOtherOrderTableViewCell" owner:self options:nil] lastObject];
        headView.delegate = self;

            
        
    GetOrderDTO *orderDto = singleArr[section];

    headView.orderDto = orderDto;
    
    return headView;
        }
        else
        {
            OrderListHeadView *orderLsitView = [[[NSBundle mainBundle]loadNibNamed:@"OrderListHeadView" owner:nil options:nil]lastObject];
            GetOrderDTO *orderDto = singleArr[section];
            
            [orderLsitView orderListOrderDto:orderDto];
            
            return orderLsitView;
            
        }

        }
    }
    return  nil;
    
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
    if (singleArr.count>0) {

    return 30;
    }
    return 0.05f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
    if (singleArr.count>0) {

    return 9.0f;
    }
    return 0.05f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //获取采购单的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    
    
    if (tableView == selecttableView) {
        
        
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
        if (singleArr.count>0) {
         GetOrderDTO *orderDto = singleArr[indexPath.section];

        
        
    //判断点击的是第一行和倒数第一行之间
            
            NSInteger numberCell;
            BOOL isInto = NO;
            
            if (self.channelType == 0) {
                numberCell = orderDto.goodsList.count+1;
                if (indexPath.row != 0) {
                    isInto = YES;
                }
            }else
            {
                numberCell = orderDto.goodsList.count;
                if (indexPath.row < orderDto.goodsList.count) {
                    isInto = YES;
                }

            }
            
            
        
    if (isInto && indexPath.row < numberCell) {
        OrderDetaillViewController *orderDetailVC;

        
        if (self.channelType == 0) {
            //!批发单的详情
            orderDetailVC = [[OrderDetaillViewController alloc] init];
            
            orderDetailVC.changeTotalCountBlock = ^(NSString *ordercode,NSString * orderOldStatus,NSString * totalCount)
            {
                //更改应付金额
                orderDto.totalAmount = [NSNumber numberWithFloat:totalCount.floatValue];
                //刷新
                [tableView reloadData];
            };
            
        }else
        {
            //!零售单的详情
            orderDetailVC = [[RetailOrderDetailController alloc]init];
            
            
        }
        
    //拍照发货完成以后
    orderDetailVC.deliverGoodsInWaitStatusBlock = ^(NSString * orederCode,NSString * orderOldStatus)
    {
        //取出当前的采购单所有数据
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:singleArr];
        
        if (singleArr.count>0) {
            
            //遍历出来点击的订单
            for (int i = 0; i<singleArr.count; i++) {
                GetOrderDTO *orderDto = self.singleArr[i];
                if ([orderDto.orderCode isEqualToString:orederCode]) {
                    //移除数组
                    [mutableArr removeObjectAtIndex:i];
                    
                }
            }
            
            
            UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
            
            //替换，将删除数据的那个数组替换过来
            [self.allOrderArr replaceObjectAtIndex:self.currentOrderState withObject:mutableArr];
            //如果待发货没有订单的时候
            if (mutableArr.count== 0) {
                
                
                //点击按钮以后刷新操作
                self.singleArr = [NSMutableArray array];
                self.pageNo = 1;
                [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentOrderState] pageNo:[NSNumber numberWithInteger:self.pageNo]];

            }
            
            //刷新页面
            [selecttableView reloadData];
        }
    };
    
    orderDetailVC.orderCode = orderDto.orderCode;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
    
        }
    }
}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (self.bottomScrollView == scrollView) {
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat screenW = CGRectGetWidth(scrollView.bounds);
        NSInteger index = offsetX/screenW;
        CGFloat percent = (offsetX-screenW*index)/screenW;
        [self contentCollectionDidScrollAtIndex:index atCurrentItemPercent:percent];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger expectIndex = scrollView.contentOffset.x/CGRectGetWidth(self.topCollection.bounds);
        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:expectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        [self collectionView:self.topCollection  didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:expectIndex inSection:0]];
        }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView == self.bottomScrollView) {
        
        NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(self.topCollection.bounds);
        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

    }
}


#pragma mark -UICollectionViewDelegate&&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.titleArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ConsultTitleCollectionCelliD";
    ConsultTitleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.titleLabel.text = self.titleArr[indexPath.row];
    
    
    cell.titleLabel.isMainLabel = cell.multiColorLine.isMainView = leftIndex == indexPath.item;
    
    if (leftIndex == indexPath.row) {
        
        cell.titleLabel.progress = leftPercent;
        cell.multiColorLine.progress = leftPercent;
        
    }else if (leftIndex + 1 == indexPath.row){
        
        cell.titleLabel.progress = leftPercent;
        cell.multiColorLine.progress = leftPercent;
        
    }else{
        
        cell.titleLabel.progress = 0;
        
        cell.multiColorLine.progress = 0;
    }
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView ==self.topCollection) {
        
        
        [UIView animateWithDuration:0.4f animations:^{
            self.bottomScrollView.contentOffset = CGPointMake(indexPath.row*self.view.frame.size.width, 0);
            [self  scrollViewDidEndScrollingAnimation:self.bottomScrollView];
            
        }];
        
        
        [self chooseOrderState:indexPath.row];
        
        
    }
}



#pragma mark -  拍照发货
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
    
    __weak MyOrderViewController * orderVC = self;
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
    
//    _isTakePhoto = YES;
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
            
//            _isTakePhoto = NO;
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            DebugLog(@"dic = %@", responseDic);
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
//                _isUploadImageSuccess = YES;
                
                [self progressHUDHiddenTipSuccessWithString:@"上传成功"];
                NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
                
                if (singleArr.count>0) {
                    
                    for (int i = 0; i<singleArr.count; i++) {
                        GetOrderDTO *orderDto = singleArr[i];
                        if ([orderDto.orderCode isEqualToString:_orderCode]) {
                            [self.singleArr removeObjectAtIndex:i];

                        }
                    }
                    
                    
                    //如果待发货没有订单的时候
                    if (self.singleArr.count== 0) {
                        
                        
                        //点击按钮以后刷新操作
                        self.singleArr = [NSMutableArray array];
                        self.pageNo = 1;
                        [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
                        
                    }
                    
                    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];

                    [self.allOrderArr replaceObjectAtIndex:self.currentOrderState withObject:self.singleArr];
                    [selecttableView reloadData];
                    
                }
                
            }else{
                
                [self.progressHUD hide:YES];
                
                [self alertViewWithTitle:@"上传失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
//            _isTakePhoto = NO;
            
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
#pragma mark - MyOrderParentDelegate

//录入快递单
- (void)myOrderParentSelectEntryExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto
{
    
    ExpressDeliverViewController *expressVC = [[ExpressDeliverViewController alloc] init];
    expressVC.takeExpressSuccessBlock = ^()
    {
        
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.currentOrderState];
//        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:singleArr];
        
        if (singleArr.count>0) {
            
            for (int i = 0; i<singleArr.count; i++) {
                GetOrderDTO *orderDto = singleArr[i];
                if ([orderDto.orderCode isEqualToString:getOrderdto.orderCode]) {
                    [self.singleArr removeObjectAtIndex:i];
                    
                }
                
            }
            
            if (self.singleArr.count == 0) {
                
                //点击按钮以后刷新操作
                self.singleArr = [NSMutableArray array];
                self.pageNo = 1;
                [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
                
            }
            
            UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
            
            
            [self.allOrderArr replaceObjectAtIndex:self.currentOrderState withObject:self.singleArr];
            [selecttableView reloadData];
            
        }
        
        

    };
    expressVC.orderCode= getOrderdto.orderCode;
    [self.navigationController pushViewController:expressVC animated:YES];
 
    
}

//拍摄快递单
- (void)myOrderParentSelectShootExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto
{
    //!显示选择的view
    self.blackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    self.orderCode = getOrderdto.orderCode;
    

}


//更改采购单价格
- (void)myOrderParentChangeOrderPrice:(GetOrderDTO *)getOrderdto cell:(MyOrderParentTableViewCell *)cell
{
    
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
    CSPModifyPriceView *modifyPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CSPModifyPriceView" owner:self options:nil]lastObject];
    
    NSString *orderType;
    if (getOrderdto.type.integerValue == 0) {
        orderType = @"【期货单】";
    }else if (getOrderdto.type.integerValue == 1)
    {
        orderType = @"【现货单】";
    }
    
    modifyPriceView.requestType = @"block";
    
    modifyPriceView.titleLabel.text = [NSString stringWithFormat:@"%@    %@    %@",orderType,getOrderdto.consigneeName,getOrderdto.consigneePhone];
    modifyPriceView.originalTotalAmountLabel.text = [NSString stringWithFormat:@"采购单总价：￥%.2f",getOrderdto.originalTotalAmount.doubleValue];
    modifyPriceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:modifyPriceView];

    modifyPriceView.confirmBlock = ^(){
        [self progressHUDShowWithString:@"修改中"];
        
        NSString * amountText = modifyPriceView.amoutTextField.text;
        [HttpManager sendHttpRequestForGetModifyOrderAmount:getOrderdto.orderCode newAmount:modifyPriceView.amoutTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                //                            _isChangePriceSuccess = YES;
                //                            应付: ￥%.2lf
                getOrderdto.totalAmount = [NSNumber numberWithFloat:amountText.floatValue];
                
                [selecttableView reloadData];
                
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
}





#pragma mark -  HttpManager
- (void) requestForGetOrderList:(NSString *)orderStatus pageNo:(NSNumber *)pageNo
{
    
    [self progressHUDShowWithString:@""];
    
    [HttpManager sendHttpRequestForGetOrderList:orderStatus pageNo:pageNo pageSize:[NSNumber numberWithInteger:5] channelType:[NSNumber numberWithInteger:self.channelType] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([responseDic[@"code"]isEqualToString:@"000"]) {
            
            
            OrderListAllDTO *orderDto = [[OrderListAllDTO alloc] init];
            orderDto.channelType = [NSNumber numberWithInteger:self.channelType];
            
            [orderDto setDictFrom:responseDic[@"data"]];
            
            //当前页面加1；
            self.pageNo++;
            
            DebugLog(@"/db/order/list = %@", responseDic);
            
            //判断当前的数据的个数 是否大于 后台数据的个数，不大于就添加，主要用于下拉加载
            if (self.singleArr.count<orderDto.totalCount || orderDto.totalCount == 0) {
                
                if (self.currentOrderState == 2) {
                    //合并发货用
                    self.getOrderdto = orderDto.orderListArr.lastObject;
                    
                    
                    if (orderDto.orderListArr.count==0) {
                        self.bottomBtn.enabled = NO;
                        self.bottomBtn.backgroundColor = [UIColor grayColor];
                        
                    }else
                    {
                        self.bottomBtn.enabled = YES;
                        self.bottomBtn.backgroundColor = [UIColor blackColor];
                        
                    }
                    
                }
                
                [self.singleArr addObjectsFromArray:orderDto.orderListArr];
                [self.allOrderArr replaceObjectAtIndex:self.currentOrderState withObject:self.singleArr];
                
                UITableView *tableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
                tableView.scrollsToTop = YES;
                
                [tableView reloadData];
                if (self.pageNo<=2) {
                    tableView.contentOffset = CGPointMake(0, 0);
                }
            
                
                
                //获取当前tableView的上拉刷新 和下拉加载
                SDRefreshHeaderView * refresh = self.refreshHeadArr[self.currentOrderState];
                [refresh endRefreshing];
                
                SDRefreshFooterView *refoot = self.refreshFootArr[self.currentOrderState];
                [refoot endRefreshing];
                
            }
            else
            {
                SDRefreshFooterView *refoot = self.refreshFootArr[self.currentOrderState];
                [refoot endRefreshing];
                [refoot noDataRefresh];
                
                SDRefreshHeaderView * refresh = self.refreshHeadArr[self.currentOrderState];
                [refresh endRefreshing];
            }
            
            UITableView *tableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
            [tableView reloadData];
            [self.progressHUD hide:YES];
            
            
            
        }else
        {
            [self.view makeMessage:[NSString stringWithFormat:@"请求失败, %@", [responseDic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            //获取当前tableView的上拉刷新 和下拉加载
            SDRefreshHeaderView * refresh = self.refreshHeadArr[self.currentOrderState];
            [refresh endRefreshing];
            
            SDRefreshFooterView *refoot = self.refreshFootArr[self.currentOrderState];
            [refoot endRefreshing];
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)myOrderParentSelectSerViceOrder:(GetOrderDTO *)getOrderDto
{
    DebugLog(@"联系客服");
    self.orderMerchantDic = getOrderDto.mj_keyValues;
    
    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:getOrderDto.nickName jid:getOrderDto.chatAccount withMerchanNo:getOrderDto.merchantNo withDic:self.orderMerchantDic];
    
    
    [self.navigationController pushViewController:conversationVC animated:YES];
    //

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
}

- (void)refreshOrderList:(NSNotification *)not
{
//    NSDictionary *notDict =  not.userInfo;
    
    
    //点击按钮以后刷新操作
    self.singleArr = [NSMutableArray array];
    self.pageNo = 1;
    [self requestForGetOrderList:[NSString stringWithFormat:@"%ld",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo]];
}
//计算字体
 - (CGSize)accordingContentFont:(NSString *)str
{
                    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
                    
    return size;
                    
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
