 //
//  MyOrderViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//


#import "MyOrderViewController.h"

//view
#import "MyOrderParentTableViewCell.h"//cell的基类
#import "TopOtherOrderTableViewCell.h"//headView
#import "CenterPostageShopMessageTableViewCell.h"//中间邮费专拍
#import "TopMerchantNameTableViewCell.h"//合并付款专用
#import "MyOrderPromptView.h"//合并付款有错误订单
#import "CustomBarButtonItem.h"//导航返回按钮就
#import "TitleZoneGoodsTableViewCell.h"//没有数据显示此cell
#import "ConsultTitleCollectionCell.h"


//model
#import "OrderAddDTO.h"//合并采购单再次支付接口
#import "OrderAllListDTO.h"//采购单列表

//controller
#import "MerchantDeatilViewController.h"//商家店铺
#import "CSPPayAvailabelViewController.h"//支付
#import "MyOrderDetailViewController.h"//订单详情
#import "ConversationWindowViewController.h"//跳转到客服
#import "CSPShoppingCartViewController.h"// 返回到购物车
#import "CSPPersonCenterMainViewController.h"//返回到个人中

//other
#import "HttpManager.h"
#import "Masonry.h"//布局
#import "MJExtension.h"//数据解析




//按钮的Tag
#define topNameBtnTag 10000

#define moreTableViewTag 100000

#define topNameBtnWith ([UIScreen mainScreen].bounds.size.width/4)

@interface MyOrderViewController ()<UITableViewDataSource ,UITableViewDelegate,MyOrderParentTableViewDelegate,MyOrderPromptDelegate ,UICollectionViewDelegate,UICollectionViewDataSource>
{
    
    NSInteger leftIndex;
    CGFloat leftPercent;
    NSInteger selectIndex;
}
/**
 *  顶部标签
 */
@property (nonatomic ,strong) UICollectionView *topCollection;

/**
 *  底部视图
 */
@property (nonatomic ,strong) UIScrollView *bottomScrollView;

/**
 *  存放所有数据源
 */
@property (nonatomic ,strong) NSMutableArray *dataArr;

/**
 *  记录选中的标签
 */
@property (nonatomic ,strong) UIButton *recordSelectBtn;


/**
 *  当前要请求的采购单状态
 */
@property (nonatomic ,assign) NSInteger currentRequestSate;

/**
 *  每个单独采购单的数据
 */
@property (nonatomic ,strong) NSMutableArray *singleOrderArr;

/**
 *  所有下拉刷新
 */
@property (nonatomic ,strong) NSMutableArray *refreshHeaderArr;

/**
 *  所有底部上拉加载
 */
@property (nonatomic ,strong) NSMutableArray *refreshFooterArr;

/**
 *  所有顶部的按钮
 */
@property (nonatomic ,strong) NSMutableArray *topBtnArr;


/**
 *  记录档期当前的页数
 */
@property (nonatomic ,assign) NSInteger pageNo;


//是否更改tableView的point
@property (nonatomic ,assign) BOOL changeTablePoint;


/**
 *  合并采购单按钮
 */
@property (nonatomic ,strong) UIButton *orderTotalBtn;

//所有合并付款的订单
@property (nonatomic ,strong) NSMutableArray *totalOrderArrs;

//传给客服对话的数据
@property (nonatomic,strong) NSDictionary *orderMerchantDic;

//记录tableView的View
@property (nonatomic ,strong) UITableView *recordTableView;

//采购商再次付款View
@property (nonatomic ,strong)  OrderAddDTO *orderAddDto;

//合并付款的弹出框
@property (nonatomic ,strong) MyOrderPromptView *myPromptView;

@property (nonatomic ,strong) NSArray *topNameArr;

@property (nonatomic ,strong) NSMutableArray *tableViewArr;




@end

@implementation MyOrderViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:@"RefreshOrderList" object:nil];
    
    //1.  设置视图的背景色
    self.view.backgroundColor = [UIColor whiteColor];
    //2.  设置标题title
    self.title = @"我的采购单";
    
    //3. 初始化所有数据
    //3.1 下拉
    self.refreshHeaderArr = [NSMutableArray array];
    //3.2 上拉
    self.refreshFooterArr = [NSMutableArray array];
    
    self.tableViewArr = [NSMutableArray array];
    
    //3.3 所有采购单，都默认为你一个数组
    self.dataArr = [NSMutableArray array];
    //3.4 存放所有的顶部按钮
    self.topBtnArr = [NSMutableArray array];
    
    
    for (int i = 0; i<8; i++) {
        NSMutableArray *array = [NSMutableArray array];
        [self.dataArr addObject:array];
        
    }
    //初始化选中的所有采购单
    self.totalOrderArrs = [NSMutableArray array];
    //3.4 初始化单个采购单
    self.singleOrderArr = [NSMutableArray array];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.topCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30) collectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(topNameBtnWith, 30);
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    flowLayout.minimumLineSpacing= 0;
    flowLayout.minimumInteritemSpacing = 0;
    [self.topCollection registerNib:[UINib nibWithNibName:@"ConsultTitleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ConsultTitleCollectionCelliD"];
    self.topCollection.delegate = self;
    self.topCollection.dataSource = self;
    self.topCollection.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
    self.topCollection.contentOffset = CGPointMake(self.topNameArr.count*topNameBtnWith, 0);
    self.topCollection.scrollsToTop = NO;
    self.topCollection.scrollsToTop = NO;
    self.topCollection.showsHorizontalScrollIndicator = NO;
    self.topCollection.bounces = NO;
    
    
    [self.view addSubview: self.topCollection];
    
    


    //4.7 初始化所有标题
    self.topNameArr = @[@"全部",@"待付款",@"待发货",@"待收货",@"交易完成",@"采购单取消",@"交易取消",@"退／换货"];


//    
//    [HttpManager sendHttpRequestForTempPhoneAndTypeMerchant:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        DebugLog(@"%@", dic);
//
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//    }];
//    
//    
    
    //5. 创建底部视图
    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height)];
    //5.1 设置可滑动的大小
    self.bottomScrollView.contentSize = CGSizeMake(self.view.frame.size.width*self.topNameArr.count, self.view.frame.size.height);
    //5.2 设置scroll不滑动
//    self.bottomScrollView.scrollEnabled = NO;
    self.bottomScrollView.scrollsToTop = NO;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.pagingEnabled = YES;
    self.bottomScrollView.delegate = self;
    
    //5.3 添加到主视图
    [self.view addSubview:self.bottomScrollView];
    
    
    /**
     *  6. 循环创建底部视图的内容
     */
    for (int i = 0; i<8; i++) {
        //6.1 创建table
        UITableView *moreTableView = [[UITableView alloc] initWithFrame:CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
        //6.2 添加代理
        moreTableView.delegate = self;
        moreTableView.dataSource = self;
        //6.3 设置tag
        moreTableView.tag = moreTableViewTag+i;
        moreTableView.scrollsToTop = NO;
        [self.tableViewArr addObject:moreTableView];
        
        //6.4 取消cell默认的分割线
        moreTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //6.4 添加到底部视图中
        [self.bottomScrollView addSubview:moreTableView];
        //采购单为1，待付款状态记录下来了
        if (i == 1) {
            self.recordTableView = moreTableView;
        }
        
        
        //6.5 为每个tableView添加下拉刷新
        SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
        [refreshHeader addToScrollView:moreTableView];
        
        //6.7 存放到数组中
        [self.refreshHeaderArr addObject:refreshHeader];
        
        //6.8 添加上拉加载
        SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
        [refreshFooter addToScrollView:moreTableView];
        
        //6.9 存放到数组中
        [self.refreshFooterArr addObject:refreshFooter];
    }
    
    //8. 设置返回按钮
    [self addCustombackButtonItem];
    
    //9. 合并采购单按钮
    
    
    self.orderTotalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.orderTotalBtn setTitle:@"合并付款" forState:UIControlStateNormal];
//    self.orderTotalBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    self.orderTotalBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    self.orderTotalBtn.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    [self.orderTotalBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
    [self.orderTotalBtn addTarget:self action:@selector(selectOrderTotalBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.orderTotalBtn.hidden = YES;
    [self.view addSubview:self.orderTotalBtn];
    [self.orderTotalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@46);
        
    }];
    
    //合并订单付款，有实效商品的时，调用此View
    MyOrderPromptView *myPromptView = [[MyOrderPromptView alloc] init];
    self.myPromptView = myPromptView;
    myPromptView.hidden = YES;
    
    myPromptView.delegate = self;
    
    myPromptView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    myPromptView.backgroundColor = [UIColor colorWithHexValue:0x000000 alpha:0.3];
    [self.view addSubview:myPromptView];
    
    
    [UIView animateWithDuration:0.5f animations:^{
        self.topCollection.contentOffset = CGPointMake(self.topNameArr.count*topNameBtnWith, 0);

        
    } completion:^(BOOL finished) {
        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentOrderState inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        [self collectionView:self.topCollection  didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:self.currentOrderState inSection:0]];

    }];

    }


#pragma mark - Action点击事件

/**
 *  点击标题按钮触发的方法
 */
- (void)chooseOrderState:(NSInteger )tag
{
    // 如果存在记录按钮 将记录按钮更改为初始化状态
    if (self.recordSelectBtn) {
        self.recordSelectBtn.selected = NO;
        self.recordSelectBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        
    }
    self.currentOrderState = tag;
    /**
     *   根据按钮的tag 判断当前采购单的状态
     *    btn.tag = self.currentOrderState :0.全部，1.待付款，2，待发货，3，待收货，4，交易完成，5，采购单取消，6，交易取消 7退换货
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
    
    if (self.recordTableView &&!self.orderTotalBtn.hidden) {
        CGRect frame = self.recordTableView.frame;
        frame.size.height = self.view.frame.size.height ;
        self.recordTableView.frame = frame;
    }

    for (UITableView *tableView in self.tableViewArr) {
        tableView.scrollsToTop = NO;
        
        
    }
    //请求单个采购单
    self.singleOrderArr = [NSMutableArray array];
    //初始页数为1
    self.pageNo = 1;
    //请求数据
    [self requestOrderMessage];
    self.changeTablePoint = YES;
    
    //从数组中获取上拉刷新
    SDRefreshHeaderView *refreshHeader = self.refreshHeaderArr[self.currentOrderState];
    refreshHeader.beginRefreshingOperation = ^{
        self.singleOrderArr = [NSMutableArray array];
        self.pageNo = 1;
        [self requestOrderMessage];
        self.changeTablePoint = NO;
    
        
    };
    
    //从数组获取下拉加载
    __weak MyOrderViewController * vc = self;

    SDRefreshFooterView *refreshFooter = self.refreshFooterArr[self.currentOrderState];
    
    refreshFooter.beginRefreshingOperation= ^{
        
        [vc requestOrderMessage];
    };
    
}

- (void) topChooseStateBtn:(UITapGestureRecognizer *)tap
{
    
}



- (void)contentCollectionDidScrollAtIndex:(NSInteger)index atCurrentItemPercent:(CGFloat)percent {
    NSLog(@"index = %ld, percent = %f", index, percent);
    leftIndex = index;
    leftPercent = percent;
    [self.topCollection reloadData];
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
        
        
//        if (_delegate && [_delegate respondsToSelector:@selector(contentCollectionDidScrollToIndex:)]) {
//            [_delegate contentCollectionDidScrollToIndex:expectIndex];
//        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (scrollView == self.bottomScrollView) {
        NSInteger index = scrollView.contentOffset.x/CGRectGetWidth(self.topCollection.bounds);
        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
     
//        if (_delegate && [_delegate respondsToSelector:@selector(contentCollectionDidScrollToIndex:)]) {
//            [_delegate contentCollectionDidScrollToIndex:index];
//        }
    }
}

//滑动结束后执行此方法。
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
    //判读滑动的对象
//    if (self.bottomScrollView == scrollView) {
//        DebugLog(@"contentOffset.x = %f", self.bottomScrollView.contentOffset.x);
//        NSInteger index = self.bottomScrollView.contentOffset.x/self.view.frame.size.width;
//        DebugLog(@"index = %lu", (long)index);
//        
//        
////        self.topScrollView.contentOffset = CGPointMake(topNameBtnWith*index, 0);
//        UIButton *selectBtn = (UIButton *)self.topBtnArr[index];
//        [self chooseOrderStateBtn:selectBtn];
//
//        //更改标题的位置
//        if ((selectBtn.tag-topNameBtnTag)!=0 &&  (selectBtn.tag-topNameBtnTag)*topNameBtnWith<self.topScrollView.contentSize.width-topNameBtnWith*2) {
//            
//            
//            [UIView animateWithDuration:0.4f animations:^{
//                
//                self.topScrollView.contentOffset = CGPointMake((selectBtn.tag-topNameBtnTag)*selectBtn.frame.size.width-selectBtn.frame.size.width, 0);
//            }];
//        }
//    }
    

//}


#pragma mark - httpRequest
/**
 *  请求采购单的数据
 */
- (void)requestOrderMessage
{
    if (self.pageNo==1) {
        self.orderTotalBtn.hidden = YES;
        self.totalOrderArrs = [NSMutableArray array];
    }

    
    /**
     *  3.40 采购单列表
     *
     *  @param orderStatus 采购单状态
     *  @param pageNo      当前页码(默认1)
     *  @param pageSize    每页显示数量（默认20）
     *  @param success     请求成功，responseObject为请求到的数据
     *  @param failure     请求失败，错误为error
     *
     *  @return 如果返回 BCSHttpRequestStatusStable 请求正常，如果返回BCSHttpRequestParameterIsLack 说明传入参数异常
     */
    
    DebugLog(@"self.currentRequestSate = %ld",(long)self.currentRequestSate);

    [HttpManager sendHttpRequestForOrderListWithOrderStatus:[NSString stringWithFormat:@"%lu",self.currentRequestSate] pageNo:[NSNumber numberWithInteger:self.pageNo] pageSize:[NSNumber numberWithInteger:5] success:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        if ([dic[@"code"]isEqualToString:@"000"]) {
            //请求过来的数据 放到模型中
            OrderAllListDTO *orderList = [[OrderAllListDTO alloc] init];
            [orderList setDictFrom:dic[@"data"]];
            
            //当前页面加1；
            self.pageNo++;
            
            //判断当前的数据的个数 是否大于 后台数据的个数，不大于就添加，主要用于下拉加载
            if (self.singleOrderArr.count<orderList.totalCount.integerValue || orderList.totalCount.integerValue == 0) {
 
                [self.singleOrderArr addObjectsFromArray:orderList.orderInfoListArr];
                [self.dataArr replaceObjectAtIndex:self.currentRequestSate withObject:self.singleOrderArr];
                
                UITableView *tableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
                [tableView reloadData];
                
                //判读是否滚动到第一条数据
                if (self.changeTablePoint) {
                    
                tableView.contentOffset = CGPointMake(0, 0);
                    self.changeTablePoint = NO;
                }
               
                
                
                //获取当前tableView的上拉刷新 和下拉加载
                SDRefreshHeaderView * refresh = self.refreshHeaderArr[self.currentOrderState];
                [refresh endRefreshing];
                
                SDRefreshFooterView *refoot = self.refreshFooterArr[self.currentOrderState];
                [refoot endRefreshing];
                
            }
            else
            {
                SDRefreshFooterView *refoot = self.refreshFooterArr[self.currentOrderState];
                [refoot endRefreshing];
                [refoot noDataRefresh];
                
                SDRefreshHeaderView * refresh = self.refreshHeaderArr[self.currentOrderState];
                [refresh endRefreshing];
                

                
            }
            
            UITableView *tableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
            tableView.scrollsToTop = YES;
            [tableView reloadData];
            
        }else
        {
            [self.view makeMessage:[NSString stringWithFormat:@"请求失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

            //获取当前tableView的上拉刷新 和下拉加载
            SDRefreshHeaderView * refresh = self.refreshHeaderArr[self.currentOrderState];
            [refresh endRefreshing];
            
            SDRefreshFooterView *refoot = self.refreshFooterArr[self.currentOrderState];
            [refoot endRefreshing];
        }
        
      

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        SDRefreshHeaderView * refresh = self.refreshHeaderArr[self.currentOrderState];
        [refresh endRefreshing];
        
        SDRefreshFooterView *refoot = self.refreshFooterArr[self.currentOrderState];
        [refoot endRefreshing];

    }];

}
// 合并付款按钮

- (void)selectOrderTotalBtn:(UIButton*) btn
{
        NSString *orderStatus;

        if (self.totalOrderArrs.count>0) {
            for (int i = 0; i<self.totalOrderArrs.count; i++) {
                if (i == 0) {
                    orderStatus = self.totalOrderArrs[i];
                }else
                {
                    orderStatus = [NSString stringWithFormat:@"%@,%@",orderStatus,self.totalOrderArrs[i]];
    
                }
            }
    
        }else
        {
            return;
        }

    [self requestMergerPaymentorderStatus:orderStatus];
    
}

- (void)requestMergerPaymentorderStatus:(NSString *)orderStatus
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpManager sendHttpRequestForMulitiConfirmPayOrderCodes:orderStatus Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([dic[@"code"]isEqualToString:@"000"]) {
            OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
            [orderDto setDictFrom:dic[@"data"]];
            self.orderAddDto = orderDto;
            if (orderDto.cannotPayOrdersArr.count>0) {
                self.myPromptView.hidden = NO;
                self.myPromptView.orderDto = orderDto;
                return ;
            }
            
            
            
            
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CSPPayAvailabelViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.orderAddDTO = orderDto;

            
            destViewController.isAvailable = YES;
            
            [self.navigationController pushViewController:destViewController animated:YES];
        }else
        {
            [self.view makeMessage:[NSString stringWithFormat:@"合并付款失败:, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        
        
    }];
//    +(BCSHttpRequestStatus)sendHttpRequestForMulitiConfirmPayOrderCodes:(NSString *)orderCodes  Success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
}

//跳转到客服对话
- (void)enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString *)merchantNo {
    DebugLog(@"orderMerchantDic===%@", _orderMerchantDic);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];

            NSNumber *isExit = dic[@"data"][@"isExit"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:merchantName jid:jid withMerchanNo:merchantNo withDic:_orderMerchantDic];
            conversationVC.timeStart = time;
            // 是否在等待中
            conversationVC.isWaite = isExit.doubleValue;


            [self.navigationController pushViewController:conversationVC animated:YES];
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询商家聊天账号失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
            
        }
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}
#pragma mark - tableViewDelegate&&DataSource

//cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    //判断当前采购单下的数据是否为空
    NSArray *sectionArr = self.dataArr[self.self.currentRequestSate];
    if (sectionArr.count>0) {
        OrderInfoListDTO *detailDto = sectionArr[section];
        return detailDto.goodsList.count+2;
    }
    return 1;
    
}

// section的个数
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    
        //获取采购单的tableView
        UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
        //判断是否是当前的tableView
        if (selecttableView == tableView) {
        //判断当前采购单下的数据是否为空
        NSArray *sectionArr = self.dataArr[self.self.currentRequestSate];
            if (sectionArr.count>0) {
        
        return sectionArr.count;
         
              
        }
    }
    return 1;
    return 0;
}

//创建好多个cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    //顶部采购单状体
   static  NSString *TopOrderStateTableViewId = @"TopOrderStateTableViewableViewCellId";
    //中间商品信息
        //1> 普通商品
    static NSString *centerNormalShopMessageCellId= @"CenterNormalShopMessageTableViewCellId";
        //2> 邮费专拍
    static NSString *centerPostageShopMessageCellId = @"CenterPostageShopMessageTableViewCellId";
        //3> 样板
    static NSString *centerSampleShopMessageCellId = @"CenterSampleShopMessageCellTableViewCellId";
    
    //底部结算 信息
        //1>待付款
    static NSString *bottomPaymentAccountsMessageCellId= @"BottomPaymentAccountsMessageCellTableViewCell";
    
        //2>待收货
    static NSString *bottomReceipAccountsMessageCellId = @"BottomReceipAccountsMessageCellTableViewCellId";
    static NSString *otherCellId = @"cellId";
        //3>其他（交易取消，交易完成，采购单取消,待发货)
    static NSString *bottomOtherAccountMessageCellId = @"BottomOtherAccountMessageTableViewCellId";
    
    /**
     *  所有cell包括headView的基类
     */
    MyOrderParentTableViewCell *cell;
    
    //创建件一个空的cell，防止没有数据的时候崩溃
    cell = [tableView dequeueReusableCellWithIdentifier:otherCellId];
    if (!cell) {
        cell = [[MyOrderParentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:otherCellId];
        
    }
    
    
    //取出当前的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
    //D判断是否是当期的tableView
    if (selecttableView == tableView) {
     
        NSArray *cellArr = self.dataArr[self.self.currentRequestSate];
         //判断当前采购单下的数据是否为空
        if (cellArr.count>0) {
            //取出采购单列表的模型
    OrderInfoListDTO *infolDto = cellArr[indexPath.section];
            
            //根据采购单列表的status 判断采购单状态,根据不同的状态取出cell 0-采购单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成
            
    switch (infolDto.status.integerValue) {
         case 1:
        {
            /**
             *  待付款
             */
            //第一行默认
            if (indexPath.row == 0) {
                cell =  [tableView dequeueReusableCellWithIdentifier:TopOrderStateTableViewId];
                //顶部视图
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateTableViewableViewCell" owner:nil options:nil]lastObject];
                }
                cell.orderInfoDto = infolDto;

                
            
            }else if(indexPath.row != 0 && indexPath.row != (infolDto.goodsList.count+1))
            {
                
                
                OrderDetailMesssageDTO *detailDto = infolDto.goodsList[indexPath.row-1];
                /**
                 *  根据商品列表的商品类型:0普通商品 , 1样板商品 2邮费专拍 取出不同的cell
                 */
                

                //普通商品
                if (detailDto.cartType.integerValue == 0) {
                    
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
                    //    中间pt视图
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    //样板商品
                }else if (detailDto.cartType.integerValue == 1)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                    //邮费专拍
                }else if (detailDto.cartType.integerValue == 2)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }

                    
                }
                /**
                 *  赋值给cell的基类 （采购单列表）
                 */
                cell.orderDetailMessageDto = detailDto;

                
            }else if (indexPath.row == (infolDto.goodsList.count+1))
            {
                
                cell = [tableView dequeueReusableCellWithIdentifier:bottomPaymentAccountsMessageCellId];
                if (!cell) {
                    cell= [[[NSBundle mainBundle] loadNibNamed:@"BottomPaymentAccountsMessageCellTableViewCell" owner:nil options:nil]lastObject];
                }
                /**
                 *  赋值给cell的基类（商品列表）
                 */
                cell.orderInfoDto = infolDto;
            }
        }
            break;

            /**
             *  待发货
             */
        case 2:
        {
            if (indexPath.row == 0) {
                
                cell =  [tableView dequeueReusableCellWithIdentifier:TopOrderStateTableViewId];
                //顶部视图
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateTableViewableViewCell" owner:nil options:nil]lastObject];
                }
                
                cell.orderInfoDto = infolDto;
                
                
            }else if(indexPath.row != 0 && indexPath.row != (infolDto.goodsList.count+1))
            {    OrderDetailMesssageDTO *detailDto = infolDto.goodsList[indexPath.row-1];

            
                //普通商品
                if (detailDto.cartType.integerValue == 0) {
                    
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
                    //    中间pt视图
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    //样板商品
                }else if (detailDto.cartType.integerValue == 1)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                    //邮费专拍
                }else if (detailDto.cartType.integerValue == 2)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                    
                }
                cell.orderDetailMessageDto = detailDto;
                

                
            }else if (indexPath.row == (infolDto.goodsList.count+1))
            {
                
                cell = [tableView dequeueReusableCellWithIdentifier:bottomOtherAccountMessageCellId];
                if (!cell) {
                    cell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:nil options:nil]lastObject];
                }
                cell.orderInfoDto = infolDto;

                
            }
        }
            break;

            /**
             *  待收货
             */
        case 3:
        {
            if (indexPath.row == 0) {
                
                cell =  [tableView dequeueReusableCellWithIdentifier:TopOrderStateTableViewId];
                //顶部视图
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateTableViewableViewCell" owner:nil options:nil]lastObject];
                }
                
                cell.orderInfoDto = infolDto;
                
            }else if(indexPath.row != 0 && indexPath.row != (infolDto.goodsList.count+1))
            {    OrderDetailMesssageDTO *detailDto = infolDto.goodsList[indexPath.row-1];

                //普通商品
                if (detailDto.cartType.integerValue == 0) {
                    
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
                    //    中间pt视图
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    //样板商品
                }else if (detailDto.cartType.integerValue == 1)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                    //邮费专拍
                }else if (detailDto.cartType.integerValue == 2)
                {
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                    
                }
                cell.orderDetailMessageDto = detailDto;

                
            }else if (indexPath.row == (infolDto.goodsList.count+1))
            {
                
                if ([infolDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    cell = [tableView dequeueReusableCellWithIdentifier:bottomOtherAccountMessageCellId];
                    if (!cell) {
                        cell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    
                }else
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:bottomReceipAccountsMessageCellId];
                    if (!cell) {
                        cell= [[[NSBundle mainBundle] loadNibNamed:@"BottomReceipAccountsMessageCellTableViewCell" owner:nil options:nil]lastObject];
                    }

                }
                cell.orderInfoDto = infolDto;
            }
        }
            break;

            
            
        default:
        {
            //detailDto.status.integerValue
            if (infolDto.status.integerValue ==4||infolDto.status.integerValue==5||infolDto.status.integerValue==0) {
                
                if (indexPath.row == 0) {
                    
                    cell =  [tableView dequeueReusableCellWithIdentifier:TopOrderStateTableViewId];
                    //顶部视图
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"TopOrderStateTableViewableViewCell" owner:nil options:nil]lastObject];
                    }
                    cell.orderInfoDto = infolDto;
                    
                    
                }else if(indexPath.row != 0 && indexPath.row != (infolDto.goodsList.count+1))
                {
                    OrderDetailMesssageDTO *detailDto = infolDto.goodsList[indexPath.row-1];

                    //普通商品
                    if (detailDto.cartType.integerValue == 0) {
                        
                        cell =  [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
                        //    中间pt视图
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:nil options:nil]lastObject];
                        }
                        //样板商品
                    }else if (detailDto.cartType.integerValue == 1)
                    {
                        cell =  [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:nil options:nil]lastObject];
                        }
                        
                        //邮费专拍
                    }else if (detailDto.cartType.integerValue == 2)
                    {
                        cell =  [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
                        if (!cell) {
                            cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:nil options:nil]lastObject];
                        }
                        
                        
                    }
                    cell.orderDetailMessageDto = detailDto;

                    
                }else if (indexPath.row == (infolDto.goodsList.count+1))
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:bottomOtherAccountMessageCellId];
                    if (!cell) {
                        cell= [[[NSBundle mainBundle] loadNibNamed:@"BottomOtherAccountMessageTableViewCell" owner:nil options:nil]lastObject];
                    }
                    cell.orderInfoDto = infolDto;
                    
                    
                }

                
            }
            
            
        }
            break;
    }
            /**
             *  给每一个cell设置代理
             */
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
            
            
            cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
//            cell.titleLabel.text = @"暂无相关采购单";
            cell.contentView.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setBackgroundColor:[UIColor clearColor]];
            
            tableView.showsVerticalScrollIndicator = NO;
            tableView.showsHorizontalScrollIndicator = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;

        }
        
}
    
    
    
    return cell;
    
    
}

/**
 *  给每一个cell设置高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取当前的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
    //判断是否是当前的tableVeiw
    if (selecttableView == tableView) {
    //判断当前的采购单数据是否为空
    NSArray *cellArr = self.dataArr[self.self.currentRequestSate];
        if (cellArr.count>0) {

    OrderInfoListDTO *infolDto = cellArr[indexPath.section];
    //第一行默认为30
    if (indexPath.row ==0) {
        return 30;
    }else if (indexPath.row == (infolDto.goodsList.count+1))
    {
        //最后一行根据采购单不同 分别为77，40
        if (infolDto.status.integerValue == 1||infolDto.status.integerValue == 3) {
            if ([infolDto.refundStatus isKindOfClass:[NSNumber class]]) {
                return 40;
                
            }
             return 77;
        }else
        {
            return 40;
        }
       
    }else if (indexPath.row != 0 &&indexPath.row!=(infolDto.goodsList.count+1))
    {
        OrderDetailMesssageDTO *detailDto = infolDto.goodsList[indexPath.row-1];

        //普通商品
        if (detailDto.cartType.integerValue == 0) {
            
            NSArray *sizeArr = detailDto.sizes;
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

  
            
            //样板商品
        }else if (detailDto.cartType.integerValue == 1)
        {
            return 80;
            //邮费专拍
        }else if (detailDto.cartType.integerValue == 2)
        {
            return 80;
        }
        }
    }
        else
        {
            return tableView.frame.size.height-200;
            
        }

}
    return 0;
}

//headView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //取出当前的tableView
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
    //判断是否是当前的tableView
    if (selecttableView == tableView) {
    
        
    NSArray *cellArr = self.dataArr[self.currentRequestSate];
        //判断当前的采购单数据是否为空
        if (cellArr.count>0) {
        //取出当前的采购单列表
    OrderInfoListDTO *infolDto = cellArr[section];
        //判断采购单状体为1(待付款) 当前状态 不为0（全部）
    if (infolDto.status.integerValue == 1&&self.currentOrderState != 0) {
        
        TopMerchantNameTableViewCell *paymantTop=[[[NSBundle mainBundle] loadNibNamed:@"TopMerchantNameTableViewCell" owner:nil options:nil]lastObject];
        
        paymantTop.orderInfoDto = infolDto;
//        [paymantTop setA:infolDto];
        
        paymantTop.delegate = self;
        return paymantTop;

        }else
        {
  
            TopOtherOrderTableViewCell *otherTop = [[[NSBundle mainBundle] loadNibNamed:@"TopOtherOrderTableViewCell" owner:nil options:nil]lastObject];
            otherTop.delegate = self;
            
            otherTop.orderInfoDto = infolDto;
            return otherTop;
            

        }
    }
};
    UIView *view= [[UIView alloc] init];
    return view;
    
}

//默认head的高度为30
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 30;
    
}

//点击cell 跳转采购单详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出当前的tableview
    UITableView *selecttableView = [self.bottomScrollView viewWithTag:(self.currentOrderState+moreTableViewTag)];
    //判断是否是当前的tableView
    if (selecttableView == tableView) {
        //取出当前采购单的所有数据
        NSArray *cellArr = self.dataArr[self.self.currentRequestSate];
        //判断数据是否为空
        if (cellArr.count>0) {
            OrderInfoListDTO *infolDto = cellArr[indexPath.section];
            //判断是否不为第1行 和最后一行
            if (indexPath.row !=0 && indexPath.row != (infolDto.goodsList.count+1)) {
                //跳转到采购单详情
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//                CSPOrderDetailViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPOrderDetailViewController"];
//                destViewController.orderCode = infolDto.orderCode;
                
//                [self.navigationController pushViewController:destViewController animated:YES];
                
                
                MyOrderDetailViewController *myorderDetailVC = [[MyOrderDetailViewController alloc] init];
                myorderDetailVC.orderCode = infolDto.orderCode;
                myorderDetailVC.orderState = infolDto.status.integerValue;
                myorderDetailVC.blockdetail = ^()
                {
                    
                    self.singleOrderArr = [NSMutableArray array];
                    self.pageNo = 1;
                    self.changeTablePoint = YES;
                    [self requestOrderMessage];
                    
                };
                
    

                [self.navigationController pushViewController:myorderDetailVC animated:YES];
                
            }

        }
    }

}

#pragma mark -UICollectionViewDelegate&&UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.topNameArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ConsultTitleCollectionCelliD";
    ConsultTitleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.titleLabel.text = self.topNameArr[indexPath.row];
    
    
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

//        NSInteger expectIndex = collectionView.contentOffset.x/CGRectGetWidth(self.topCollection.bounds);
//
//        if (indexPath.row !=expectIndex) {
//        [self.topCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:expectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//        }
        
        
        
    }
}
#pragma mark - MyOrderPromptDelegate
- (void)myOrderPromptPayMoney:(NSArray *)moneyArr view:(UIView *)view
{
    if (moneyArr.count >0) {
        NSString *canOrder;
        for (int i = 0; i<moneyArr.count; i++) {
            CanPayOrdersDTO *canPayDto = moneyArr[i];
            
            if (i == 0) {
                canOrder = canPayDto.orderCode;
            }else
            {
                canOrder = [NSString stringWithFormat:@"%@,%@",canOrder,canPayDto.orderCode];
            }
        }
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForMulitiConfirmPayOrderCodes:canOrder Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            DebugLog(@"%@", dic);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([dic[@"code"]isEqualToString:@"000"]) {
                //            PayMulitiConfirmPayDTO *firmPayDto = [[PayMulitiConfirmPayDTO alloc] init];
                //            [firmPayDto setDictFrom:dic[@"code"]];
                OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
                [orderDto setDictFrom:dic[@"data"]];
                self.orderAddDto = orderDto;
                if (orderDto.cannotPayOrdersArr.count>0) {
                    self.myPromptView.hidden = NO;
                    self.myPromptView.orderDto = orderDto;
                    return ;
                }
                
                
                
                
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                CSPPayAvailabelViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
                destViewController.orderAddDTO = orderDto;
                
                
                destViewController.isAvailable = YES;
                
                [self.navigationController pushViewController:destViewController animated:YES];
            }else
            {
                [self.view makeMessage:[NSString stringWithFormat:@"合并付款失败:, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
            
            
            
        }];
 
//        
//        MyOrderDetailViewController *myorderDetailVC = [[MyOrderDetailViewController alloc] init];
//        myorderDetailVC.orderCode = canOrder;
//        myorderDetailVC.orderState = 1;
//        
//        
//        [self.navigationController pushViewController:myorderDetailVC animated:YES];

        
        
    }
}


- (void)myOrderPromptClearView:(UIView *)view
{
    view.hidden =YES;
    //从数组中获取上拉刷新
//    SDRefreshHeaderView *refreshHeader = self.refreshHeaderArr[self.currentOrderState];
//    refreshHeader.beginRefreshingOperation = ^{
        self.singleOrderArr = [NSMutableArray array];
        self.pageNo = 1;
        self.changeTablePoint = YES;

        [self requestOrderMessage];        
//    };

    
}

/**
 *  点击商家名称，进入商家店铺
 */
- (void)MyOrderParentClickMerchantName:(NSString *)merchantNo
{
    
    MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
    detailVC.merchantNo = merchantNo;
    [self.navigationController pushViewController:detailVC animated:YES];
}

/**
 *  取消采购单
 */
- (void)MyOrderParentClickCancelGoodsOrderMemberNo:(NSString *)memberNo orderCode:(NSString *)orderCode
{
    GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"是否取消采购单？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确认" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [HttpManager sendHttpRequestForOrderCancelUnpaid:orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                self.singleOrderArr = [NSMutableArray array];
                self.pageNo = 1;
                self.changeTablePoint = YES;
                [self requestOrderMessage];
                
                
                [self.view makeMessage:@"取消采购单成功" duration:2.0f position:@"center"];
                
            } else {
                
                [self.view makeMessage:[NSString stringWithFormat:@"取消采购单失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
                
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        }];

        
    } dismissAction:^{
        
    }];
    [alert show];
    
    }

//确认收货
- (void)MyOrderParentClickConfirmOrderCode:(NSString *)orderCode
{
    GUAAlertView *alertViwe = [GUAAlertView alertViewWithTitle:@"确定已收货？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForOrderReceived:orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                self.singleOrderArr = [NSMutableArray array];
                self.pageNo = 1;
                self.changeTablePoint = YES;
                [self requestOrderMessage];
                
                
                
                [self.view makeMessage:@"确认收货成功" duration:2.0f position:@"center"];
            } else {
                
                [self.view makeMessage:[NSString stringWithFormat:@"确认收货失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
                
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        }];
        
        
    } dismissAction:^{
        
    }];
    [alertViwe show];
    

}


/**
 *  延期收货
 */
- (void)MyOrderParentClickDelayGoodsOrderCode:(NSString *)orderCode balanceQuantity:(NSNumber *)balanceQuantity
{
    
  NSString *messageStr = [NSString stringWithFormat:@"剩余延期次数: %lu",(long)balanceQuantity.integerValue];
    GUAAlertView *al = [GUAAlertView alertViewWithTitle:@"确定延长时间收货？" withTitleClor:nil message:messageStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [HttpManager sendHttpRequestForSetOrderAutoConfirm:orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            
            DebugLog(@"%@", dic);
            if ([dic[@"code"] isEqualToString:@"000"]) {
                self.singleOrderArr = [NSMutableArray array];
                self.pageNo = 1;
                [self requestOrderMessage];
                [self.view makeMessage:@"操作成功" duration:2.0f position:@"center"];

                
            }else
            {
                [self.view makeMessage:dic[@"errorMessage"] duration:2.0f position:@"center"];
                return;
                
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }];
        
        
    } dismissAction:^{
        
        
    }];
    al.lastTextColor = [UIColor redColor];
    
    [al show];
}

/**
 *  为采购单付款，待付款
 */
- (void)MyOrderParentClickPaymentGoodOrderCodes:(NSString *)orderCode
{
//    self.totalOrderArrs = [NSMutableArray array];
//    [self.totalOrderArrs addObject:orderCode];
    [self requestMergerPaymentorderStatus:orderCode];
    
    
//    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//    CSPPayAvailabelViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
//    destViewController.orderCode = orderCode;
//    destViewController.isAvailable = YES;
//    
//    [self.navigationController pushViewController:destViewController animated:YES];
}
//MyOrderParentClickMerchantName
//MyOrderParentClickCustomerService
- (void)MyOrderParentClickCustomerService:(OrderInfoListDTO *)orderInfo
{
    [self enquiryWithMerchantName:orderInfo.merchantName andMerchantNo:orderInfo.merchantNo];
    self.orderMerchantDic = orderInfo.mj_keyValues;
}


/**
 *  合并采购单
 *
 *  @param orderCode 采购单数据
 */
- (void)MyOrderParentClickTotalPayMentOrderCode:(NSString *)orderCode
{
    
    NSString *recordOrder;
    if (self.totalOrderArrs.count>0) {
        
        for (NSString *order in self.totalOrderArrs) {
            if ([order isEqualToString:orderCode]) {
                recordOrder = order;
                break;
            }
        }
    }
    if (recordOrder.length>0) {
        [self.totalOrderArrs removeObject:orderCode];
    }else
    {
        [self.totalOrderArrs addObject:orderCode];
        
    }
    if (self.totalOrderArrs.count>0) {
        self.orderTotalBtn.hidden = NO;
        if (self.recordTableView) {
            CGRect frame = self.recordTableView.frame;
            frame.size.height = self.view.frame.size.height - 46;
            self.recordTableView.frame = frame;
        }
    }else
    {
        CGRect frame = self.recordTableView.frame;
        frame.size.height = self.view.frame.size.height;
        self.recordTableView.frame = frame;
        self.orderTotalBtn.hidden = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick:) target:self]];
    
}

- (void)backBarButtonClick:(UIBarButtonItem *)sender{
    
    if ([self.goodsShopping isEqualToString:@"shopping"]) {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        CSPShoppingCartViewController *shopVC = [storyboard instantiateViewControllerWithIdentifier:@"CSPShoppingCartViewController"];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[CSPShoppingCartViewController class]]) {
                
                [self.navigationController popToViewController:controller animated:YES];
                
            }
            
        }
   
    }else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            
            if ([controller isKindOfClass:[CSPPersonCenterMainViewController class]]) {
                
                [self.navigationController popToViewController:controller animated:YES];
                
            }
        }
    }
}

//通知刷新列表
- (void)refreshOrderList
{
    self.singleOrderArr = [NSMutableArray array];
    self.pageNo = 1;
    self.changeTablePoint = YES;
    [self requestOrderMessage];
    
}

//计算字体
- (CGSize)accordingContentFont:(NSString *)str
{
    
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:@"refreshOrderList"];
    
}
/**

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
