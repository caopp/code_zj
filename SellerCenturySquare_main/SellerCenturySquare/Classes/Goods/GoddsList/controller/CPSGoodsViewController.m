//
//  CPSGoodsViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/7/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

/*
 更改了商品默认图片
 更改提示框
 
 */
#import "CPSGoodsViewController.h"
#import "CPSSearchGoodsViewController.h"
#import "CPSMyOrderTopView.h"
#import "CSPGoodsScrollView.h"
#import "CSPGoodsButtomView.h"
#import "EditGoodsModel.h"
#import "GetEditGoodsListDTO.h"
#import "EditGoodsDTO.h"
#import "UpdateGoodsStatusModel.h"
#import "CPSGoodsDetailsEditViewController.h"
#import "MyUserDefault.h"
#import "RDVTabBarItem.h"
#import "GUAAlertView.h"// !提示的view

#import "EditGoodsViewController.h"//!编辑商品
#import "ExpressDeliverViewController.h"//!录入快递单发货


static CGFloat const orderTopViewHeight = 30.0f;

static CGFloat const orderButtomViewHeight = 45.0f;

static CGFloat const interval = 15.0f;

static NSInteger const listNum = 3;

static NSString *const goodsStatusWithOnSale = @"2";

static NSString *const goodsStatusWithNewRelease = @"1";

static NSString *const goodsStatusWithUndercarriage = @"3";

static NSInteger const aloneAlertViewTag = 1001;

static NSInteger const multipleAlertViewTag = 1002;

@interface CPSGoodsViewController ()<UIScrollViewDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>

@property(strong,nonatomic)CPSMyOrderTopView *orderTopView;

@property(strong,nonatomic)CSPGoodsScrollView *scrollView;
//多选
@property(strong,nonatomic)CSPGoodsButtomView *goodsButtomView;

//!保存商品数据的数组
@property(strong,nonatomic)NSMutableArray *resourceDataArray;

//!保存商品数量的数组
@property(strong,nonatomic)NSMutableDictionary *numDic;

@property(strong,nonatomic)UpdateGoodsStatusModel *updateGoodsStatusModel;

/**
 *  判断在售、新发布、已下架
 */
@property(assign,nonatomic)GoodsSalesStatus goodsSalesStatus;

@property(strong,nonatomic)NSMutableArray *selectedArray;

/**
 *  是否选择全部
 */
@property(assign,nonatomic)BOOL isSelectedAll;

/**
 *  用于上拉加载页码
 */
@property(assign,nonatomic)NSInteger pageNoForOnSales;

@property(assign,nonatomic)NSInteger pageNoForNewRelease;

@property(assign,nonatomic)NSInteger pageNoForUndercarriage;

@end

@implementation CPSGoodsViewController{
    /**
     *  标记是否请求到在售中的商品
     */
    BOOL _isRequestOnSale;
    /**
     *  标记是否请求到新发布的商品
     */
    BOOL _isRequestNewRelease;
    /**
     *  标记是否请求到已下架的商品
     */
    BOOL _isRequestUndercarriage;
    
    BOOL _isUploadSuccess;
    
    
    /**
     *  在售多少
     */
    NSInteger _salesStatusOnSalesNum;
    
    /**
     *  新发布多少
     */
    NSInteger _salesStatusNewReleaseNum;
    /**
     *  已下架多少
     */
    NSInteger _salesStatusUndercarriageNum;
    
   
    
    /**
     *  用于上拉加载一页显示多少条目
     */
    NSInteger _pageSize;
    
    BOOL _isRefresh;
    
    
    // !提示框
    GUAAlertView *customAlertView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"商品";
    
    // !页面初始化
    [self pageNoInit];
    
    _pageSize = PAGESIZE;

    UIBarButtonItem *buttonItem = [self getButtonItemWithTitle:@"搜索"];
    
    if (buttonItem) {
        
        self.navigationItem.rightBarButtonItem  = buttonItem;
        
    }

    
    // !如果是子账号 就不进去请求
    if ([self isNotMatser]) {
        
        
        return ;
        
    }

    
    // !初始化数据数组 存放 在售 未发布 已下架 的数组
    [self initArray];
    // !顶部的view
    [self initOrderTopView];
    // !sc
    [self initScrollView];
    // !控制多选、全部上架、下架底部的view
    [self initOrderButtomView];

    [self.view bringSubviewToFront:self.progressHUD];
    
    
    
}

#pragma mark-控制全部下架、全部上架按钮
- (void)goodsStateOperationButtonIsEnable:(BOOL)isEnable{
    
    self.goodsButtomView.operationBtn.enabled = isEnable;
    
    if (isEnable) {
        self.goodsButtomView.operationBtn.backgroundColor = HEX_COLOR(0xeb301eFF);
    }else{
        self.goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];

    }
}

#pragma mark-刷新状态
- (void)reloadState{
    
    //判断当前是在售、新发布、已下架
    if (self.goodsSalesStatus == SalesStatusOnSales) {
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:0]).count == _salesStatusOnSalesNum && ((NSMutableArray *)[self.selectedArray objectAtIndex:0]).count) {
            self.goodsButtomView.selectedButton.selected = YES;
        }else{
            self.goodsButtomView.selectedButton.selected = NO;
            
        }
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:0]).count>0) {
            
            self.goodsButtomView.operationBtn.enabled = YES;
            
            self.goodsButtomView.operationBtn.backgroundColor = HEX_COLOR(0xeb301eFF);
        }else{
            
            self.goodsButtomView.operationBtn.enabled = NO;
            
            self.goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];
            
        }
        
    }else if (self.goodsSalesStatus == SalesStatusNewRelease){
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:1]).count == _salesStatusNewReleaseNum &&((NSMutableArray *)[self.selectedArray objectAtIndex:1]).count) {
            self.goodsButtomView.selectedButton.selected = YES;
            
        }else{
            self.goodsButtomView.selectedButton.selected = NO;
            
        }
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:1]).count>0) {
            
            self.goodsButtomView.operationBtn.enabled = YES;
            
            self.goodsButtomView.operationBtn.backgroundColor = HEX_COLOR(0xeb301eFF);
        }else{
            
            self.goodsButtomView.operationBtn.enabled = NO;
            
            self.goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];
            
        }
        
    }else if (self.goodsSalesStatus == SalesStatusUndercarriage){
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:2]).count == _salesStatusUndercarriageNum &&((NSMutableArray *)[self.selectedArray objectAtIndex:2]).count) {
            self.goodsButtomView.selectedButton.selected = YES;
            
        }else{
            self.goodsButtomView.selectedButton.selected = NO;
            
        }
        
        if (((NSMutableArray *)[self.selectedArray objectAtIndex:2]).count>0) {
            
            self.goodsButtomView.operationBtn.enabled = YES;
            
            self.goodsButtomView.operationBtn.backgroundColor = HEX_COLOR(0xeb301eFF);
        }else{
            
            self.goodsButtomView.operationBtn.enabled = NO;
            
            self.goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];
            
        }
        
    }
    
}

#pragma mark-
- (UIBarButtonItem *)getButtonItemWithTitle:(NSString *)title{
    
    UIBarButtonItem *buttonItem = [self barButtonWithtTitle:title font:[UIFont systemFontOfSize:13]];
    
    return buttonItem;
    
}
#pragma mark 初始化数据数组
- (void)initArray{
    
    //!保存商品数据的数组
    self.resourceDataArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<listNum; i++) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [self.resourceDataArray addObject:array];
    }
    
    //!保存商品数量的数组
    
    self.numDic = [NSMutableDictionary dictionaryWithCapacity:0];
    

}

#pragma mark-搜索
- (void)rightButtonClick:(UIButton *)sender{
    
    
    CPSSearchGoodsViewController *searchGoodsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CPSSearchGoodsViewController"];
    
    [self.navigationController pushViewController:searchGoodsViewController animated:YES];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    //!录入快递单发货
//    ExpressDeliverViewController * expressDeliverVC = [[ExpressDeliverViewController alloc]init];
//    [self.navigationController pushViewController:expressDeliverVC animated:YES];
    
    
    
}

#pragma mark 顶部的view
- (void)initOrderTopView{
    
    self.orderTopView = [[CPSMyOrderTopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, orderTopViewHeight)];
    
    __weak CPSGoodsViewController *weakSelf = self;
    
    self.orderTopView.chooseOrderTypeBlock = ^(NSInteger integer){
        
        [weakSelf.orderTopView showButtonWithIndex:integer];
        
        CGPoint point = CGPointMake(self.view.frame.size.width*integer, 0);
        
        [weakSelf.scrollView setContentOffset:point animated:YES];
    };
    
    self.orderTopView.titleArray = [[NSMutableArray alloc]initWithObjects:@"在售",@"新发布",@"已下架", nil];
    
    [self.orderTopView initButton];
    
    
    [self.view addSubview:self.orderTopView];
    
    
}

#pragma mark-控制多选、全部上架、下架
- (void)initOrderButtomView{
    
    self.goodsButtomView = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsButtomView" owner:self options:nil]firstObject];
    
    self.goodsButtomView.frame = CGRectMake(0, self.view.frame.size.height-orderButtomViewHeight, self.view.frame.size.width, orderButtomViewHeight);
    
    __weak CPSGoodsViewController *weakSelf = self;
    //多选事件
    self.goodsButtomView.selectedAllGoods = ^(){
        
         NSMutableArray *array = [weakSelf.resourceDataArray objectAtIndex:weakSelf.goodsSalesStatus];
        
        if (array.count) {
            
            weakSelf.goodsButtomView.selectedButton.selected = !weakSelf.goodsButtomView.selectedButton.selected;
            
            if (weakSelf.goodsButtomView.selectedButton.selected) {
                
                [weakSelf.scrollView selectAllWithGoodsSalesStatus:weakSelf.goodsSalesStatus];
                
                //启动按钮
                [weakSelf goodsStateOperationButtonIsEnable:YES];
                
            }else{
                
                [weakSelf.scrollView selectNothingWithGoodsSalesStatus:weakSelf.goodsSalesStatus];
                
                //禁用按钮
                [weakSelf goodsStateOperationButtonIsEnable:NO];
            }
            
        }else{
            return;
        }
    };
    
    //全部下架、全部上架
    self.goodsButtomView.goodsOperation = ^(){
        
        NSString *message;
        
        if (self.goodsSalesStatus == SalesStatusOnSales) {
            
            message = @"下架";
            
        }else{
            
            message = @"上架";
        }
        
        NSInteger number = ((NSMutableArray*)[weakSelf.selectedArray objectAtIndex:weakSelf.goodsSalesStatus]).count;
        
        //已选择X个商品，是否确定下架商品？
        
        if (customAlertView) {
            
            [customAlertView removeFromSuperview];
            
        }
        
        customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:[NSString stringWithFormat:@"已选择%ld个商品，是否确定%@商品?",(long)number,message] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //!把请求的页码更改
            [self pageNoInit];
            
            [self multipleUpdateGoodsStatus];
            
        } dismissAction:nil];
        
        [customAlertView show];
        
        
        
    };
    
    [self.view addSubview:self.goodsButtomView];
    
}

#pragma mark-
- (void)initScrollView{
    
    self.scrollView  = [[CSPGoodsScrollView alloc]initWithFrame:CGRectMake(0,orderTopViewHeight+interval, self.view.frame.size.width, self.view.frame.size.height-orderButtomViewHeight-orderTopViewHeight-interval)];
    
    __weak CPSGoodsViewController *weakSelf = self;
    
    //选择商品
    self.scrollView.selectedGoodsBlock = ^(NSMutableArray *array){
        
        weakSelf.selectedArray = array;
        
        [weakSelf reloadState];
    };
    
    // !全选或者全部选之后的数组
    self.scrollView.undercarriageBlock = ^(NSMutableArray *array){
        
        weakSelf.selectedArray = array;
        
    };
    
    //上架、下架
    self.scrollView.goodsOperationBlock = ^(NSString *goodsNo,NSString *goodsStatus){
        
        if (!weakSelf.updateGoodsStatusModel) {
            
            weakSelf.updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc]init];
        }
        
        weakSelf.updateGoodsStatusModel.goodsStatus = goodsStatus;
        
        weakSelf.updateGoodsStatusModel.goodsNo = goodsNo;
        
        NSString *message;
        
        if ([goodsStatus isEqualToString:@"3"]) {
            message = @"下架";
        }else if([goodsStatus isEqualToString:@"2"]){
            message = @"上架";
        }
        
        if (customAlertView) {
            
            [customAlertView removeFromSuperview];
            
        }
        
        customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:[NSString stringWithFormat:@"确定%@此商品?",message] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
          
            //!要重新请求，就需要把页码改变
            [self pageNoInit];
            
            // !单个商品上下架
            [self singleUpdateGoodsStatus];
            
        } dismissAction:nil];
        
        [customAlertView show];
        
        

    };
    
    
    CPSGoodsViewController * goodsVC = self;
    
     // !商家歇业和关闭的时候不能上架商品 把原因传过来
    self.scrollView.cannotChangeStatus = ^(NSString *reason){
    
        
        [goodsVC.view makeMessage:reason duration:3 position:@"center"];
        
    
    };
    
    
    //商品详情编辑
    self.scrollView.goodsDetailsEditBlock = ^(NSString *goodsNo){
        
        EditGoodsViewController * editVC = [[EditGoodsViewController alloc]init];
        editVC.goodsNo = goodsNo;
        [weakSelf.navigationController pushViewController:editVC animated:YES];
        [weakSelf tabbarHidden:YES];
        
        
    };
    
    //上拉
    self.scrollView.refreshBlock = ^(NSString *goodsStatus,GoodsSalesStatus salesStatus){
        
        _isRefresh = YES;
        
        //判断是哪一个上拉加载
        if (salesStatus == SalesStatusOnSales) {
            //已上架
            weakSelf.pageNoForOnSales++;
            
        }else if (salesStatus == SalesStatusNewRelease){
            //新发布
            weakSelf.pageNoForNewRelease++;
            
        }else if (salesStatus == SalesStatusUndercarriage){
            //已下架
            weakSelf.pageNoForUndercarriage++;
        }
 
        [weakSelf requestSaleDataWithGoodsStatus:goodsStatus salesStatus:salesStatus];
        
    };
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.delegate = self;
    
    self.scrollView.tipNoDataArray = [NSMutableArray arrayWithObjects:@"暂无在售商品",@"暂无新发布商品",@"暂无已下架商品", nil];
    
    self.scrollView.titleArray = [NSMutableArray arrayWithObjects:@"在售",@"新发布",@"已下架", nil];
    
    [self.view addSubview:self.scrollView];
    
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.orderTopView.frame = CGRectMake(0, 0, self.view.frame.size.width, orderTopViewHeight);
    
//    self.scrollView.frame = CGRectMake(0,orderTopViewHeight+interval, self.view.frame.size.width, self.view.frame.size.height-orderButtomViewHeight-orderTopViewHeight-interval);
    
    self.scrollView.frame = CGRectMake(0,orderTopViewHeight, self.view.frame.size.width, self.view.frame.size.height-orderButtomViewHeight-orderTopViewHeight);

    self.goodsButtomView.frame = CGRectMake(0, self.view.frame.size.height-orderButtomViewHeight, self.view.frame.size.width, orderButtomViewHeight);
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    self.progressHUD.delegate = self;
    
    // !如果是子账号 就提示
    if ([self isNotMatser]) {
        
        [self.view makeMessage:@"您暂无商品管理权力" duration:2.0f position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(changeSelectVc) userInfo:nil repeats:NO];
        
        return;
        
    }else{// !主账号
        
        // !移除bage
        
        RDVTabBarItem * barItem = [self rdv_tabBarItem] ;
        
        barItem.badgeValue = @"";
    
    }

    [self pageNoInit];
    
}

#pragma mark 判断是否是子账号
- (BOOL)isNotMatser{

    NSString * isMaster = [MyUserDefault JudgeUserAccount];

    // !(0/YES:主账户 1/NO:子账户)
    if ([isMaster isKindOfClass:[NSString class]] && isMaster != nil) {
        
        // !如果是子账号登录，则返回上一次点击index
        if ([isMaster isEqualToString:@"1"]) {
            
            return YES;
            
        }
        
        
    }
    
    return NO;
    
}

// !当用户无权利查看时，返回上一个选择的界面
- (void)changeSelectVc{
    
    // !当前选中的tabbar是商品
    if (self.rdv_tabBarController.selectedIndex == 4) {
        
        [self.rdv_tabBarController setSelectedIndex:self.rdv_tabBarController.lastSelectedIndex];

    }
    
}

#pragma mark 页面初始化
- (void)pageNoInit{
    self.pageNoForOnSales = 1;
    
    self.pageNoForNewRelease = 1;
    
    self.pageNoForUndercarriage = 1;
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.scrollView addViewOnScrollViewWithNumber:listNum];
    
    //!如果有新上架的商品 刚进来的时候显示新发布
    if ([MyUserDefault defaultLoad_upGoods]) {
        
        [MyUserDefault removeUpGoods];
        
        [self.orderTopView showButtonWithIndex:1];
        
        //!状态置为 新发布
        self.goodsSalesStatus =  SalesStatusNewRelease;
        
        //!改变sc偏移的位置
        self.scrollView.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
        //!新发布对应的tableView可以置顶
        [self.scrollView setScToTopWithGrounding:NO withNew:YES withUnGrounding:NO];
        
    }else{
        
        [self.orderTopView showButtonWithIndex:0];
        //开始置为在售
        self.goodsSalesStatus = SalesStatusOnSales;
        
        //!改变sc偏移的位置
        self.scrollView.contentOffset = CGPointMake(0, 0);

        //!在售对应的tableView可以置顶
        [self.scrollView setScToTopWithGrounding:YES withNew:NO withUnGrounding:NO];
        
    }

    
    // !如果是子账号 就不进去请求
    if ([self isNotMatser]) {
        
        return ;
    
    }
    
    // !商家信息 因为商家有可能会在操作过程中改变营业状态 这个时候未发布的商品在 歇业 和关闭的时候是不能上架的
    [self getMerchantInfo];
    
    // !列表信息
    [self requestGoodsData];
    
}

#pragma mark-请求数据
- (void)requestGoodsData{
    
    //在售
    [self requestSaleDataWithGoodsStatus:goodsStatusWithOnSale salesStatus:SalesStatusOnSales];
    
    //新发布
    [self requestSaleDataWithGoodsStatus:goodsStatusWithNewRelease salesStatus:SalesStatusNewRelease];
    
    //已下架
    [self requestSaleDataWithGoodsStatus:goodsStatusWithUndercarriage salesStatus:SalesStatusUndercarriage];

}


#pragma mark-请求数据
- (void)requestSaleDataWithGoodsStatus:(NSString *)goodsStatus salesStatus:(GoodsSalesStatus)salesStatus{
    
    [self progressHUDShowWithString:@"加载中"];
    
    EditGoodsModel *editGoodsModel = [[EditGoodsModel alloc]init];
    
    editGoodsModel.goodsStatus = goodsStatus;
    
    if (salesStatus == SalesStatusOnSales) {
        
        editGoodsModel.pageNo = [NSNumber numberWithInteger:self.pageNoForOnSales];
        
    }else if (salesStatus == SalesStatusNewRelease){
        
        editGoodsModel.pageNo = [NSNumber numberWithInteger:self.pageNoForNewRelease];
        
    }else if (salesStatus == SalesStatusUndercarriage){
        
        editGoodsModel.pageNo = [NSNumber numberWithInteger:self.pageNoForUndercarriage];
        
    }
    
    editGoodsModel.pageSize = [NSNumber numberWithInteger:_pageSize];
    
    //queryType和param这两个参数只有查询的时候才用到
    editGoodsModel.queryType = @"";
    
    editGoodsModel.param = @"";
    
    [HttpManager sendHttpRequestForGetEditGoodsList:editGoodsModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSInteger refreshIndex = 0;
        
        if (salesStatus == SalesStatusOnSales) {
            
            _isRequestOnSale = YES;
            
            //!每次请求回来，都需要底部先把状态改成yes
            [self.scrollView changeBottomStatus:0];
            
            refreshIndex = 0;
            
        }else if (salesStatus == SalesStatusNewRelease){
            
            _isRequestNewRelease = YES;
            
            //!每次请求回来，都需要底部先把状态改成yes
            [self.scrollView changeBottomStatus:1];
            
            refreshIndex = 1;

        }else if (salesStatus == SalesStatusUndercarriage){
            
            _isRequestUndercarriage = YES;
            //!每次请求回来，都需要底部先把状态改成yes
            [self.scrollView changeBottomStatus:2];
        
            refreshIndex = 2;

        }
        //!停止对应的刷新
        if (_isRefresh) {
            
            [self.scrollView completeRefresh:refreshIndex];
            
        }
        
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //在售
            NSMutableArray *array = [self.resourceDataArray objectAtIndex:salesStatus];
            
            //!上拉：_isRefresh = yes
            
            if (!_isRefresh) {
                
                [array removeAllObjects];

            }
            
            //判断数据合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                
                GetEditGoodsListDTO *getEditGoodsList = [[GetEditGoodsListDTO alloc]init];
                
                [getEditGoodsList setDictFrom:data];
                
                if (salesStatus == SalesStatusOnSales) {//!在售
                    
                    [self.numDic setObject:getEditGoodsList.totalCount forKey:@"0"];
                    
                }else if (salesStatus == SalesStatusNewRelease){//!新发布
                    
                    [self.numDic setObject:getEditGoodsList.totalCount forKey:@"1"];

                }else if (salesStatus == SalesStatusUndercarriage){//!已下架
                    
                    [self.numDic setObject:getEditGoodsList.totalCount forKey:@"2"];
                
                }
                
                
                id goodsList = [data objectForKey:@"goodslist"];
                
                //判断数据合法
                if ([self checkData:goodsList class:[NSArray class]]) {
                    
                    for (NSDictionary *goodsListDic in goodsList) {
                        
                        EditGoodsDTO *editGoods = [[EditGoodsDTO alloc]init];
                        
                        [editGoods setDictFrom:goodsListDic];
                        
                        [array addObject:editGoods];
                        
                    }
                    
                   
                    
                }
                
                //用于多选逻辑
                _salesStatusOnSalesNum = ((NSMutableArray *)[self.resourceDataArray objectAtIndex:0]).count;
                
                _salesStatusNewReleaseNum = ((NSMutableArray *)[self.resourceDataArray objectAtIndex:1]).count;

                
                _salesStatusUndercarriageNum = ((NSMutableArray *)[self.resourceDataArray objectAtIndex:2]).count;
           
            }
            
            
        }else{
            
            if (salesStatus == SalesStatusOnSales) {
                [self alertViewWithTitle:@"在售商品获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];

            }else if(salesStatus == SalesStatusNewRelease){
                [self alertViewWithTitle:@"新发布商品获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];

            }else if (salesStatus == SalesStatusUndercarriage){
                [self alertViewWithTitle:@"已下架商品获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];

            }
            
        }
        
        
        if ((_isRequestUndercarriage && _isRequestOnSale && _isRequestNewRelease) || _isRefresh) {
            
            _isRefresh = NO;
            
            //刷新数据
            self.scrollView.resourceData = self.resourceDataArray;
            
            self.scrollView.numDic = self.numDic;//!商品数量
                        
            //!给数据，判断是否显示底部的刷新提示
            [self.scrollView reloadData];
            
            [self.scrollView hiddenTipNoDataLabel];
            
            [self.progressHUD hide:YES];
            
            //复位
            [self resetForGoodsButtomView];
            
        }
        
        //! 当请求回来的数量为0时候，去掉上拉刷新提示;请求完成全部数据的时候，修改底部状态为“已经到底啦！” （因为上面的方法是sc上面的3个tableView都请求才会进入，所以这个：单个tableView请求数据的时候判断是否还有数据请求回来）
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
        
            id goodsList = [data objectForKey:@"goodslist"];
            
            //判断数据合法
            if ([self checkData:goodsList class:[NSArray class]]) {
                
                //刷新数据
                self.scrollView.resourceData = self.resourceDataArray;
                
                //!在方法里面做出如下判断  1、判断根本就没有数据 2、需要判断已经到底了
                [self.scrollView stopFooterRefreshAlert:salesStatus withNumDic:self.numDic];

                
            }

        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (_isRefresh) {
            
            [self.scrollView completeRefresh];

        }
        
        if (!_isRequestNewRelease) {
            
            _isRequestNewRelease = YES;
        }
        
        if (!_isRequestOnSale) {
            _isRequestOnSale = YES;
        }
        
        if (!_isRequestUndercarriage) {
            _isRequestUndercarriage = YES;
        }
        
        if ((_isRequestUndercarriage && _isRequestOnSale && _isRequestNewRelease)  || _isRefresh) {
            
            _isRefresh = NO;
            
            //如果请求失败了
            //不刷新数据,判断数据是否为空，如果为空显示暂无数据，如果不为空，就显示之前加载的数据
            self.scrollView.resourceData = self.resourceDataArray;
            
            [self.scrollView hiddenTipNoDataLabel];
            
           [self tipRequestFailureWithErrorCode:error.code];
        }
    }];
    
    
}

#pragma mark-复位
- (void)resetForGoodsButtomView{
    
    for (NSMutableArray *array in self.selectedArray) {
        
        [array removeAllObjects];
    }
    
    self.goodsButtomView.selectedButton.selected = NO;
    
    self.goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];
    
    self.goodsButtomView.operationBtn.enabled = NO;
}

#pragma mark-UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [self.orderTopView showButtonWithIndex:page];
    
    [self reloadButtomWithPage:page];
}

#pragma mark-判断哪一页选择了全部
- (BOOL)isSelectedAllWithPage:(NSInteger)page{
    
    NSMutableArray *array = [self.selectedArray objectAtIndex:self.goodsSalesStatus];
    
    
    if (self.goodsSalesStatus == SalesStatusOnSales  && array.count == _salesStatusOnSalesNum && array.count) {
        
        return YES;
        
    }else if (self.goodsSalesStatus == SalesStatusNewRelease  && array.count == _salesStatusNewReleaseNum && array.count){
        
        return YES;
        
    }else if (self.goodsSalesStatus == SalesStatusUndercarriage  && array.count == _salesStatusUndercarriageNum && array.count){
        
        return YES;
        
    }else{
        
        return NO;
    }
}

#pragma mark-刷新底部view
- (void)reloadButtomWithPage:(NSInteger)page{
    
    if (page == 0) {
        
        self.goodsSalesStatus = SalesStatusOnSales;
        
        [self.goodsButtomView.operationBtn setTitle:@"下架" forState:UIControlStateNormal];
        
    }else{
        
        if (page == 1) {
            
            self.goodsSalesStatus = SalesStatusNewRelease;
            
        }else if (page == 2){
            
            self.goodsSalesStatus = SalesStatusUndercarriage;
            
        }
        [self.goodsButtomView.operationBtn setTitle:@"上架" forState:UIControlStateNormal];
    }
    
    if (self.selectedArray.count) {
        
        [self reloadState];
    }
    
    self.isSelectedAll = [self isSelectedAllWithPage:page];
}

#pragma mark 单个商品上下架
-(void)singleUpdateGoodsStatus{

    //上架、下架
    [self progressHUDShowWithString:@"操作中"];
    
    [HttpManager sendHttpRequestForGetUpdateGoodsStatus:self.updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _isUploadSuccess = YES;
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            [self progressHUDHiddenTipSuccessWithString:@"操作成功"];
            
            //!以防止上面的hud失败
//            [self.view makeMessage:@"操作成功" duration:2 position:@"center"];
            
        }else{
            
            self.progressHUD.hidden = YES;
            
            [self alertViewWithTitle:@"操作失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
    
}

#pragma mark 多个商品上下架
-(void)multipleUpdateGoodsStatus{

    //上架、下架
    NSString *showString;
    
    NSMutableArray *array = [self.selectedArray objectAtIndex:self.goodsSalesStatus];
    
    
    NSMutableArray *goodsNosArray = [[NSMutableArray alloc]init];
    
    for (EditGoodsDTO *editGoods in array) {
        
        [goodsNosArray addObject:editGoods.goodsNo];
    }
    
    NSString *goodsNos = [self getStringWithArray:goodsNosArray];
    
    UpdateGoodsStatusModel *updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc]init];
    
    updateGoodsStatusModel.goodsNo = goodsNos;
    
    if (self.goodsSalesStatus == SalesStatusOnSales) {
        
        showString = @"下架";
        
        updateGoodsStatusModel.goodsStatus = @"3";
        
    }else{
        
        showString = @"上架";
        
        updateGoodsStatusModel.goodsStatus = @"2";
    }
    
    [self progressHUDShowWithString:[NSString stringWithFormat:@"%@中",showString]];
    
    [HttpManager sendHttpRequestForGetUpdateGoodsStatus:updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _isUploadSuccess = YES;
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            [self progressHUDHiddenTipSuccessWithString:[NSString stringWithFormat:@"%@成功",showString]];
            
            //!以防止上面的hud失败
//            [self.view makeMessage:@"操作成功" duration:2 position:@"center"];

            
        }else{
            
            self.progressHUD.hidden = YES;
            
            [self alertViewWithTitle:[NSString stringWithFormat:@"%@失败",showString] message:[responseDic objectForKey:ERRORMESSAGE]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
    

}


#pragma mark-UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == aloneAlertViewTag) {
        
        if (buttonIndex) {
            //上架、下架
            
            [self progressHUDShowWithString:@"操作中"];
            
            [HttpManager sendHttpRequestForGetUpdateGoodsStatus:self.updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                _isUploadSuccess = YES;
                
                NSDictionary *responseDic = [self conversionWithData:responseObject];
                
                if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                    
                    [self progressHUDHiddenTipSuccessWithString:@"操作成功"];
                    
                
                }else{
                    
                    self.progressHUD.hidden = YES;
                    
                    [self alertViewWithTitle:@"操作失败" message:[responseDic objectForKey:ERRORMESSAGE]];
                }

                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self tipRequestFailureWithErrorCode:error.code];
                
            }];
            
        }
        
    }else if(alertView.tag == multipleAlertViewTag){
        
        if (buttonIndex) {
            
            //上架、下架
            NSString *showString;
            
            NSMutableArray *array = [self.selectedArray objectAtIndex:self.goodsSalesStatus];
            
            
            NSMutableArray *goodsNosArray = [[NSMutableArray alloc]init];
            
            for (EditGoodsDTO *editGoods in array) {
                
                [goodsNosArray addObject:editGoods.goodsNo];
            }
            
            NSString *goodsNos = [self getStringWithArray:goodsNosArray];
            
            UpdateGoodsStatusModel *updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc]init];
            
            updateGoodsStatusModel.goodsNo = goodsNos;
            
            if (self.goodsSalesStatus == SalesStatusOnSales) {
                
                showString = @"下架";
                
                updateGoodsStatusModel.goodsStatus = @"3";
                
            }else{
                
                showString = @"上架";
                
                updateGoodsStatusModel.goodsStatus = @"2";
            }
            
            [self progressHUDShowWithString:[NSString stringWithFormat:@"%@中",showString]];
            
            [HttpManager sendHttpRequestForGetUpdateGoodsStatus:updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                _isUploadSuccess = YES;
                
                NSDictionary *responseDic = [self conversionWithData:responseObject];
                
                if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                    
                    [self progressHUDHiddenTipSuccessWithString:[NSString stringWithFormat:@"%@成功",showString]];
                    
                }else{
                    
                    self.progressHUD.hidden = YES;
                    
                    [self alertViewWithTitle:[NSString stringWithFormat:@"%@失败",showString] message:[responseDic objectForKey:ERRORMESSAGE]];
                }
                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                [self tipRequestFailureWithErrorCode:error.code];
                
            }];
        }
    }
}

- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (_isUploadSuccess) {
        
        _isUploadSuccess = NO;
        
        //刷新数据
        [self requestGoodsData];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
