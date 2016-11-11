//
//  OrderMainListViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/5/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderMainListViewController.h"
#import "Masonry.h"
#import "GetOrderDTO.h"//采购单数据model
#import "MyOrderParentTableViewCell.h"//基类cell
#import "SDRefreshView.h"
#import "SDRefreshHeaderView.h"//上拉
#import "SDRefreshFooterView.h"//下拉
#import "OrderDetaillViewController.h"//采购单详情--批发
#import "RetailOrderDetailController.h"//!订单详情--零售
#import "TopOrderStateView.h"//顶部每个采购单个数据
#import "GetMerchantMainDTO.h"//采购统计个数model
#import "MyOrderViewController.h"//我的采购单
//#import "CPSMyOrderTopView.h"//
#import "ExpressDeliverViewController.h"//录入快递单发货
#import "CSPModifyPriceView.h"//修改采购单
#import "PhotoAndCamerSelectView.h"//!相机相册选择view
#import "ConversationWindowViewController.h"//聊天
#import "TitleZoneGoodsTableViewCell.h"
#import "SlidePageManager.h"
#import "OrderListHeadView.h"
#import "RDVTabBarItem.h"
#import "ChatManager.h"



@interface OrderMainListViewController ()<MyOrderParentDelegate ,UITableViewDelegate , UITableViewDataSource ,SlidePageSquareViewDelegate,UIScrollViewDelegate>
//
//@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) GetOrderDTO *getOrderDto;
//下拉
@property (nonatomic ,strong)SDRefreshHeaderView *refreshHead;
//上拉
@property (nonatomic ,strong) SDRefreshFooterView *refreshFooter;
//页
@property (nonatomic ,assign) NSInteger pageNo;
//所有采购单
@property (nonatomic ,strong) NSMutableArray *OrderArr;
//采购单所有记录
@property (nonatomic ,strong) TopOrderStateView *topOrderView;
//采购单数据model
@property (nonatomic ,strong) GetMerchantMainDTO *getMerchantMainDTO;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;
//记录采购单
@property (nonatomic ,copy) NSString *orderCode;
//聊天传值
@property (nonatomic ,strong) NSMutableDictionary *orderMerchantDic;

@property (nonatomic ,strong) UIScrollView *rollScrollView;

@property (nonatomic ,strong) UIScrollView *titleScrollView;

@property (nonatomic,strong) SlidePageManager *manager ;

@property (nonatomic ,strong) NSMutableArray *tableViewArr;

//频道 0：小B  1：C端
@property (nonatomic ,assign) NSInteger channelType;

//所有的下拉刷新
@property (nonatomic ,strong) NSMutableArray *refreshHeadArr;
//所有的上拉加载
@property (nonatomic ,strong) NSMutableArray *refreshFootArr;
//所有订单的数组
@property (nonatomic ,strong) NSMutableArray *allOrderArr;

@property (nonatomic ,strong) SlidePageSquareView *slideView;








@end

@implementation OrderMainListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"采购单";
    
    [self initDataTableView];
    
    //初始化相册
    [self initPhotoView];
    //请求采购单信息
    [self requestOrderMessageChannelType:self.channelType];
    // 请求采购单纪录信息
    [self requestForGetMerchantMain];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    //隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    RDVTabBarItem * barItem = [self rdv_tabBarItem] ;
    
    barItem.badgeValue = @"";

}

//初始化列表和数组
- (void)initDataTableView
{
    
    NSArray *arrTitle = @[@"批发订单",@"零售订单"];
    self.tableViewArr = [NSMutableArray array];
    //上拉加载
    self.refreshFootArr = [NSMutableArray array];
    //下拉刷新
    self.refreshHeadArr = [NSMutableArray array];
    
    //所有订单
    self.allOrderArr = [NSMutableArray array];
    for (int i = 0; i<arrTitle.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [self.allOrderArr addObject:arr];
        
    }
    
    //单个采购单数据
    self.OrderArr = [NSMutableArray array];
    
    self.titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    
    [self.view addSubview:self.titleScrollView];
    

    self.manager = [[SlidePageManager alloc]init];
    
    SlidePageSquareView * scView = (SlidePageSquareView*)[self.manager createBydataArr:arrTitle slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHexValue:0x333333 alpha:1] squareViewColor:[UIColor whiteColor] unSelectTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:12]];
    
    
//    SlidePageSquareView * scView = (SlidePageSquareView*)[self.manager createBydataArr:arrTitle slidePageType:SlidePageTypeSquare  bgColor:[UIColor whiteColor] squareViewColor:[UIColor colorWithHexValue:0x333333 alpha:1] unSelectTitleColor:[UIColor blackColor] selectTitleColor:[UIColor colorWithHexValue:0x999999 alpha:1] witTitleFont:[UIFont systemFontOfSize:12]];

    scView.delegateForSlidePage = self;
    self.slideView = scView;
    scView.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    
    
    
    scView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2*arrTitle.count, 0);
    [self.titleScrollView addSubview:scView];

    
    
    self.rollScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-134)];
    self.rollScrollView.delegate = self;
    self.rollScrollView.scrollEnabled = YES;
    self.rollScrollView.pagingEnabled = YES;
    
    

    [self.view addSubview:self.rollScrollView];

    self.rollScrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height-134);
    
    
    
    for (int i = 0; i<arrTitle.count; i++) {
        
        //采购单列表
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0 ,self.view.frame.size.width, self.rollScrollView.frame.size.height) style:UITableViewStyleGrouped];
//        self.tableView = tableView;
        tableView.scrollsToTop = YES;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.rollScrollView addSubview:tableView];
        
        [self.tableViewArr addObject:tableView];
        //下拉刷新
        SDRefreshHeaderView *refreshHead = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
        [refreshHead addToScrollView:tableView];
        
        //上拉加载
        SDRefreshFooterView* refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
        
        
        [refreshFooter addToScrollView:tableView];
        [self.refreshHeadArr addObject:refreshHead];
        [self.refreshFootArr addObject:refreshFooter];
        
        
        
        __weak OrderMainListViewController * vc = self;
        
        //从数组中获取下拉刷新
        refreshHead.beginRefreshingOperation = ^{
            vc.OrderArr = [NSMutableArray array];
            vc.pageNo = 1;
            [vc requestOrderMessageChannelType:self.channelType];
            
        };
        
        
        //从数组获取上拉加载
        //上拉加载
        
        refreshFooter.beginRefreshingOperation= ^{
            [vc requestOrderMessageChannelType:self.channelType];
        };

        
    }
    
    

}

#pragma mark -UITableViewDelegate && dataSource

//section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];

    
    return singleArr.count+1;
    return 1;
}

//number 个数
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
  
    
    if (self.channelType == 0) {
        
    
        if (self.allOrderArr.count>0) {

    if (singleArr.count>0&&section>=1) {
        GetOrderDTO *orderDto = [singleArr objectAtIndex:section-1];
        if (orderDto.goodsList.count>0) {
            if (section == 0) {
                return 0;
            }
            return orderDto.goodsList.count+2;
        }
    }
            if (section == 0&&singleArr.count>0) {
                return 0;
            }
            
        }
}else
{
    if (self.allOrderArr.count>0) {
        
        //获取单个采购单的数组
        NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
        if (singleArr.count>0&&section>=1) {
            GetOrderDTO *orderDto = [singleArr objectAtIndex:section-1];
            if (orderDto.goodsList.count>0) {
                if (section == 0) {
                    return 0;
                }
                return orderDto.goodsList.count+1;
            }
        }
        
        if (section == 0&&singleArr.count>0) {
            return 0;
        }
    }

}
    return 1;
}


//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellId = @"CELL";
    
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
    //待收货，交易完成，采购单取消，交易完成
    static NSString *BottomOtherAccountMessageTableViewCellId = @"BottomOtherAccountMessageTableViewCell";
    
    //采购单取消 交易取消
    static NSString *BottomOrderCancelPayCancelMessageTableViewCellId = @"BottomOrderCancelPayCancelMessageTableViewCellId";

    
    
    
    MyOrderParentTableViewCell *myCell;
    
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
  
    
    if (singleArr.count>0&&indexPath.section>=1) {
        
        if (self.channelType == 0) {
            
        

    GetOrderDTO *orderDto =[singleArr objectAtIndex:indexPath.section-1];
    
    

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
            
            //退款处理中
            if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                
                
                myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                if (!myCell) {
                    myCell = [[[NSBundle mainBundle]loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:self options:nil] lastObject];
                }
                
            }else
            {
            myCell = [tableView dequeueReusableCellWithIdentifier:BottomSendGoodsAccoutsMeessagCellTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomSendGoodsAccoutsMeessagCellTableViewCell" owner:self options:nil]lastObject ];
            }
        }
            
            
        }else if (orderDto.status.integerValue == 0||orderDto.status.integerValue == 3||orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5)
        {
            
            // *  待收货，交易完成，采购单取消，交易完成
            //退款处理中
            if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                
                
                myCell = [tableView dequeueReusableCellWithIdentifier:BottomOrderCancelPayCancelMessageTableViewCellId];
                if (!myCell) {
                    myCell = [[[NSBundle mainBundle]loadNibNamed:@"BottomOrderCancelPayCancelMessageTableViewCell" owner:self options:nil] lastObject];
                }
                
            }else
            {
            
            myCell = [tableView dequeueReusableCellWithIdentifier:BottomOtherAccountMessageTableViewCellId];
            if (!myCell) {
                myCell = [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:self options:nil]lastObject ];
            }
        }
        }

        myCell.delegate = self;
        myCell.orderDto = orderDto;
    }
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;

        return myCell;
        }else
        {
            
            GetOrderDTO *orderDto = singleArr[indexPath.section-1];
            
            if (singleArr.count>0) {
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
    
    static NSString *cellEId = @"CELL";
    TitleZoneGoodsTableViewCell*   cell = [tableView dequeueReusableCellWithIdentifier:cellEId];
    if (!cell) {
        cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId ];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
    
    [cell titleZoneGoodsChannelType:[NSString stringWithFormat:@"%lu",self.channelType]];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.showsHorizontalScrollIndicator = NO;
    
    return cell;


    
}
//cell的height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
    
        if (singleArr.count>0) {
            if (indexPath.section == 0) {
                return 0.05f;
            }
            
            
            
            //第一行默认
            if (indexPath.row == 0) {
                //第二行后倒数第二行
                if (self.channelType == 1) {
                    return 80;
                    
                }
                return 30;
            }
            
            if (singleArr.count>0&&indexPath.section>=1) {
         
                GetOrderDTO *orderDto = singleArr[indexPath.section-1];
                //最后一行 默认
                if (self.channelType == 0) {
                    
                    if (orderDto.goodsList.count+1==indexPath.row) {
                        
                        if (orderDto.status.integerValue == 3 ||orderDto.status.integerValue == 2 ||orderDto.status.integerValue == 4 || orderDto.status.integerValue == 5||orderDto.status.integerValue == 1)
                        {
                            
                            if (orderDto.status.integerValue == 2||orderDto.status.integerValue == 3) {
                                if ([orderDto.refundStatus isKindOfClass:[NSNumber class]]) {
                                    return 44;
                                    
                                }
                            }
                            if (orderDto.status.integerValue == 1||orderDto.status.integerValue == 2 ) {
                                return 100;
                            }
                            
                            return 70;
                        }else if (orderDto.status.integerValue == 0 || orderDto.status.integerValue == 4)
                        {
                            return 44;
                        }
                        
                        
                        return 105;
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
                        
                        return 105;
                    }
                }
                
                
                
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
                    NSLog(@"%f",recoreSizeFrame.size.height);
                    return 60+CGRectGetMaxY(recoreSizeFrame);
                }
                
            }
        }
        else
        {
            return (self.view.frame.size.height-200);
            
        }
    return (self.view.frame.size.height-200);
}


//footerView
-(UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
    
    
    if (singleArr.count>0) {
        
        //默认
        UIView *footerView = [[UIView alloc] init];
        footerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 19);
        footerView.backgroundColor = [UIColor colorWithHex:0xefeff4 alpha:1];
        return footerView;
    }
    return nil;
    
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //获取采购单的tableView
    

    
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
//        if (singleArr.count>0) {
    

            if (section == 0) {
                //跳转到所有采购单列表页面
                __unsafe_unretained __typeof(self)weakSelf = self;

//                __weak UIViewController *weakSelf = self;
                
                _topOrderView = (TopOrderStateView*)[[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateView" owner:self options:nil]lastObject];
                _topOrderView.merchantMainDto = self.getMerchantMainDTO;
                [_topOrderView topOrerStatusChannelType:self.channelType];
                
                //待付款
                _topOrderView.blockwaitPay = ^()
                {
                    
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.currentOrderState = 1;
                    myOrderVC.channelType = weakSelf.channelType;
                    [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
                    
                };
                
                //待发货
                _topOrderView.blockwaitDeliver = ^()
                {
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.currentOrderState = 2;
                    myOrderVC.channelType = weakSelf.channelType;

                    [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
                    
                    

                    
                };
                
                //待收货
                _topOrderView.blockwaitReceipt = ^()
                {
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.currentOrderState = 3;
                    myOrderVC.channelType = weakSelf.channelType;

                    [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
                };
                
                //退换货
                _topOrderView.blockExitChangeOrder = ^(){
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    if (weakSelf.channelType == 0) {
                    myOrderVC.currentOrderState = 7;
                    }else
                    {
                        myOrderVC.currentOrderState = 6;
                    }
                    
                    myOrderVC.channelType = weakSelf.channelType;

                    [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
                };
                //全部订单
                _topOrderView.blockAllOrderState = ^()
                {
                    MyOrderViewController *myOrderVC = [[MyOrderViewController alloc] init];
                    myOrderVC.currentOrderState = 0;
                    myOrderVC.channelType = weakSelf.channelType;

                    [weakSelf.navigationController pushViewController:myOrderVC animated:YES];
                };
                return _topOrderView;
            }
    
    if (singleArr.count+1>=section) {
        
        if (self.channelType == 0) {
            
        
        
            MyOrderParentTableViewCell *headView = [[[NSBundle mainBundle]loadNibNamed:@"TopOtherOrderTableViewCell" owner:self options:nil] lastObject];

            GetOrderDTO *orderDto = singleArr[section-1];
            headView.delegate = self;
            
            
            headView.orderDto = orderDto;
            
            return headView;
            }else
            {
                OrderListHeadView *orderLsitView = [[[NSBundle mainBundle]loadNibNamed:@"OrderListHeadView" owner:nil options:nil]lastObject];
                GetOrderDTO *orderDto = singleArr[section-1];

                [orderLsitView orderListOrderDto:orderDto];
                
                return orderLsitView;

            }
    }
        
//        }
    
    return  nil;
}

//header的height
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

        if (section == 0) {
            return 110.0f;
            
        }
    
        return 30;
}

//footer的height
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    NSArray *singleArr =self.OrderArr;
    if (singleArr.count>0) {
        
        return 9.0f;
    }
    return 0.05f;
}

//选中订单进入订单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *singleArr = [self.allOrderArr objectAtIndex:self.channelType];
    
    //    if (singleArr.count>0) {

    if (singleArr.count) {
        
        
        
    
    GetOrderDTO *orderDto = singleArr[indexPath.section-1];
        
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
            if (indexPath.row == 0) {
                isInto = YES;
            }
            
        }

        
        //判断点击的是第一行和倒数第一行之间
        if (isInto && indexPath.row < numberCell) {
            
            OrderDetaillViewController *orderDetailVC;
            
            if (self.channelType == 0) {
                //!批发单的详情
                orderDetailVC = [[OrderDetaillViewController alloc] init];
                
                orderDetailVC.changeTotalCountBlock = ^(NSString *ordercode,NSString * orderOldStatus,NSString * totalCount)
                {
                    //更改应付金额
                    orderDto.totalAmount = [NSNumber numberWithFloat:totalCount.floatValue];
                    [self requestForGetMerchantMain];
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
                NSArray *singleArr= self.OrderArr;

                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:singleArr];
                
                
                if (singleArr.count>0) {
                    
                    //遍历出来点击的订单
                    for (int i = 0; i<singleArr.count; i++) {
                        GetOrderDTO *orderDto = singleArr[i];
                        if ([orderDto.orderCode isEqualToString:orederCode]) {
                            //移除数组
                            [mutableArr removeObjectAtIndex:i];
                        }
                    }
                    
                    self.OrderArr = mutableArr;
                    
                    [self.allOrderArr replaceObjectAtIndex:self.channelType withObject:self.OrderArr];
                    
                    [self requestForGetMerchantMain];
                    //刷新页面
                    UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                    tableView.scrollsToTop = YES;
                    
                    [tableView reloadData];
                    

//                    [self.tableView reloadData];
                }
            };
            
            orderDetailVC.orderCode = orderDto.orderCode;
            [self.navigationController pushViewController:orderDetailVC animated:YES];
            
        }
        
    }
}


#pragma mark - HttpManager

//请求采购单信息
- (void)requestOrderMessageChannelType:(NSInteger)channelType
{
    [self requestForGetMerchantMain];
    
    NSString *requestStatus;
    if (self.channelType == 0) {
        requestStatus = @"1,2";
    }else
    {
        requestStatus = @"2,9";
    }
    [HttpManager sendHttpRequestForGetOrderList:requestStatus pageNo:[NSNumber numberWithUnsignedInteger:1] pageSize:[NSNumber numberWithInteger:5] channelType:[NSNumber numberWithInteger:self.channelType] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        DebugLog(@"%@", responseDic);
        
        if ([responseDic objectForKey:CODE]) {
            id data = [responseDic objectForKey:@"data"];
            
            if (data &&[data isKindOfClass:[NSDictionary class]]) {
                OrderListAllDTO *orderListDto = [[OrderListAllDTO alloc]init];
                orderListDto.channelType = [NSNumber numberWithInteger:self.channelType];
                
                [orderListDto setDictFrom:data];
                
                self.pageNo++;
                
                //判断当前的数据的个数 是否大于 后台数据的个数，不大于就添加，主要用于下拉加载
                if (self.OrderArr.count<orderListDto.totalCount || orderListDto.totalCount == 0) {
                    
                    [self.OrderArr addObjectsFromArray:orderListDto.orderListArr];
                    
                    [self.allOrderArr replaceObjectAtIndex:self.channelType withObject:self.OrderArr];
                    UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                    tableView.scrollsToTop = YES;
                    
                    [tableView reloadData];
                    
                    
                    //获取当前tableView的上拉刷新 和下拉加载
                    SDRefreshHeaderView * refresh = self.refreshHeadArr[self.channelType];
                    [refresh endRefreshing];
                    
                    SDRefreshFooterView *refoot = self.refreshFootArr[self.channelType];
                    [refoot endRefreshing];



                }
                else
                {
//                    [self.refreshFooter endRefreshing];
//                    [self.refreshFooter noDataRefresh];
//                    [self.refreshHead endRefreshing];
                    
                    SDRefreshFooterView *refoot = self.refreshFootArr[self.channelType];
                    [refoot endRefreshing];
                    [refoot noDataRefresh];
                    
                    SDRefreshHeaderView * refresh = self.refreshHeadArr[self.channelType];
                    [refresh endRefreshing];
                    
                    UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                    [tableView reloadData];

                }
            }
            
//            UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
//            tableView.scrollsToTop = YES;
//            
//            [tableView reloadData];
//            

//                [self.tableView reloadData];
        }else
        {
        [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
            //获取当前tableView的上拉刷新 和下拉加载
            SDRefreshHeaderView * refresh = self.refreshHeadArr[self.channelType];
            [refresh endRefreshing];
            
            SDRefreshFooterView *refoot = self.refreshFootArr[self.channelType];
            [refoot endRefreshing];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self tipRequestFailureWithErrorCode:error.code];

    }];
}

#pragma mark-请求统计数据
- (void)requestForGetMerchantMain{
    
    
    [HttpManager sendHttpRequestForGetMerchantMain:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]){
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据的合法
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                
                GetMerchantMainDTO *getMerchantMainDTO = [GetMerchantMainDTO sharedInstance];
                getMerchantMainDTO.channelType = [NSNumber numberWithInteger:self.channelType];
                
                [getMerchantMainDTO setDictFrom:data];
                
                self.getMerchantMainDTO = getMerchantMainDTO;
                
                
                
                [self.slideView showLittleRedDotxb:getMerchantMainDTO.xbGoodsTotalCount xc:getMerchantMainDTO.xcGoodsTotalCount];
                
                
                self.topOrderView.merchantMainDto = getMerchantMainDTO;
                
//                self.orderTopView.waitPaymentNumLabel.text = getMerchantMainDTO.notPayOrderNum.stringValue;
//                
//                self.orderTopView.waitDeliverGoodsNumLabel.text = getMerchantMainDTO.unshippedNum.stringValue;
//                
//                self.orderTopView.waitGoodsReceiptNumLabel.text = getMerchantMainDTO.untakeOrderNum.stringValue;
//                
//                [self.orderTopView setAllOrderAmount: getMerchantMainDTO.orderNum.integerValue];
                
                UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                [tableView reloadData];
//                [self.tableView reloadData];
                
            }
            
        }else{
            
            //[self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
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
    
    __weak OrderMainListViewController * orderVC = self;
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
    
    //显示导航好
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    
    

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
                [self requestForGetMerchantMain];
                
                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:self.OrderArr];
                
                if (self.OrderArr.count>0) {
                    
                    for (int i = 0; i<self.OrderArr.count; i++) {
                        GetOrderDTO *orderDto = self.OrderArr[i];
                        if ([orderDto.orderCode isEqualToString:_orderCode]) {
                            [mutableArr removeObjectAtIndex:i];
                            
                        }
                    }
                    self.OrderArr = mutableArr;
                                        
                    [self.allOrderArr replaceObjectAtIndex:self.channelType withObject:self.OrderArr];
                    UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                    tableView.scrollsToTop = YES;
                    
                    [tableView reloadData];
                    

//                    [self.tableView reloadData];
                    
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


#pragma mark -MyOrderParentDelegate

//拍摄快递单发货
- (void)myOrderParentSelectShootExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto
{
    //!显示选择的view
    self.blackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    self.orderCode = getOrderdto.orderCode;
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    

}

/**
 *  录入快递单
 *
 *  @param cell
 *  @param orderList
 */
- (void)myOrderParentSelectEntryExpressSingle:(MyOrderParentTableViewCell *)cell getOrderdto:(GetOrderDTO *)getOrderdto
{
    
    ExpressDeliverViewController *expressVC = [[ExpressDeliverViewController alloc] init];
    expressVC.takeExpressSuccessBlock = ^()
    {
//        allOrderArr
        NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:self.OrderArr];
        
        if (self.OrderArr.count>0) {
            
            for (int i = 0; i<mutableArr.count; i++) {
                GetOrderDTO *orderDto = mutableArr[i];
                if ([orderDto.orderCode isEqualToString:getOrderdto.orderCode]) {
                    [self.OrderArr removeObjectAtIndex:i];
                    
                }
            }
            
            [self.allOrderArr replaceObjectAtIndex:self.channelType withObject:self.OrderArr];

            
            [self requestForGetMerchantMain];
            UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
            tableView.scrollsToTop = YES;
            
            [tableView reloadData];
            

            
//            [self.tableView reloadData];
            
        }

    };
    expressVC.orderCode= getOrderdto.orderCode;
    [self.navigationController pushViewController:expressVC animated:YES];
    
}
//修改采购单
-(void)myOrderParentChangeOrderPrice:(GetOrderDTO*)getOrderdto cell:(MyOrderParentTableViewCell *)cell
{
//    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+tableViewTag)];
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

                //修改成功
                [self progressHUDHiddenTipSuccessWithString:@"修改完成"];

                
                //取出当前的采购单所有数据
                NSArray *singleArr= self.OrderArr;
                
                NSMutableArray *mutableArr = [[NSMutableArray alloc] initWithArray:singleArr];
                
                if (singleArr.count>0) {
                    
                    //遍历出来点击的订单
                    for (int i = 0; i<singleArr.count; i++) {
                        GetOrderDTO *orderDto = singleArr[i];
                        if ([orderDto.orderCode isEqualToString:getOrderdto.orderCode]) {
                            //替换数组
                            [mutableArr replaceObjectAtIndex:i withObject:getOrderdto];
                        }
                    }
                }
                
                    self.OrderArr = mutableArr;
                    
                    [self.allOrderArr replaceObjectAtIndex:self.channelType withObject:self.OrderArr];

                
                UITableView *tableView = [self.tableViewArr objectAtIndex:self.channelType];;
                tableView.scrollsToTop = YES;
                
                [tableView reloadData];
                

//                [self.tableView reloadData];
                
                
            }else{
                
                [self.progressHUD hide:YES];
                
                [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self tipRequestFailureWithErrorCode:error.code];
        }];
        
    };

    
}

/**
 *  点击 人名跳转到商家列表
 *
 *  @param memberDto
 */
- (void)myOrderParentSelectMerchantName:(MemberListDTO *)memberDto{
    
}

/**
 *  客服
 *
 *  @param memberDto
 */
-(void)myOrderParentSelectSerViceOrder:(GetOrderDTO *)getOrderDto
{
    DebugLog(@"联系客服");
    self.orderMerchantDic = getOrderDto.mj_keyValues;
    
    
    
//    [ChatManager shareInstance] get 
    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:getOrderDto.nickName jid:getOrderDto.chatAccount withMerchanNo:getOrderDto.merchantNo withDic:self.orderMerchantDic];
    
    
    [self.navigationController pushViewController:conversationVC animated:YES];
//

}

- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index
{
    self.pageNo = 0;
    self.OrderArr = [NSMutableArray array];
    self.channelType = index;
    NSLog(@"index = %lu",index);
    
    [self requestForGetMerchantMain];
    [self requestOrderMessageChannelType:self.channelType];
    [self.rollScrollView  setContentOffset:CGPointMake(self.view.frame.size.width*index,0 ) animated:YES];
}

//计算字体
- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.rollScrollView == scrollView ) {
        self.manager.contentOffsetX = scrollView.contentOffset.x;
    }
    
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (self.rollScrollView == scrollView) {
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
        CGFloat offsetX = scrollView.contentOffset.x;
        CGFloat screenW = CGRectGetWidth(scrollView.bounds);
        NSInteger index = offsetX/screenW;
        self.channelType = index;
        NSLog(@"scrollViewDidEndDecelerating= %lu",index);
        [self slidePageSquareView:nil andBtnClickIndex:index];
        
    }
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    if (self.rollScrollView == scrollView) {
        self.manager.endcontentOffsetX = scrollView.contentOffset.x;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
