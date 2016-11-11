//
//  ManageGoodsViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ManageGoodsViewController.h"
#import "CPSSearchGoodsViewController.h"//!搜索
#import "ManageGoodsView.h"//!单个管理的view
#import "EditGoodsDTO.h"
#import "EditGoodsViewController.h"//!编辑商品页面
#import "GUAAlertView.h"//!提示框
#import "SlidePageManager.h"//!滑动

//!商品状态 的高度
static float statusHeaderHight = 30;


@interface ManageGoodsViewController ()<UIScrollViewDelegate,SlidePageSquareViewDelegate>
{

    UIScrollView * _goodsSc;
    
    //!在售
    ManageGoodsView * onSaleGoodsView;
    NSInteger pageOnSale;
    NSMutableArray * onSaleDataArray;
    
    
    //!新发布
    ManageGoodsView * newSaleGoodsView;
    NSInteger pageNewSale;
    NSMutableArray * newSaleDataArray;

    
    //!已下架
    ManageGoodsView * notOnSaleGoodsView;
    NSInteger pageNotOnSale;
    NSMutableArray * notOnSaleDataArray;
    
    // !提示框
    GUAAlertView * _customAlertView;


}

@property (nonatomic,strong) SlidePageManager *manager ;


//!记录单个商品要上下架的信息dto
@property(strong,nonatomic)UpdateGoodsStatusModel *updateGoodsStatusModel;


@end

@implementation ManageGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建导航
    [self createNav];
    
    //!创建界面
    [self createUI];
    
   
    //!是要进入 新发布
    if (_isIntoNews) {
        
        //!改变sc偏移的位置
        _goodsSc.contentOffset = CGPointMake(self.view.frame.size.width, 0);
        
        //!新发布对应的tableView可以置顶
        [self setScrollerToTopWithOnSale:NO withNewSale:YES withNotSale:NO];
        
        
    }else if(_isIntoUndercarriage){//!进入已下架
        
        //!改变sc偏移的位置
        _goodsSc.contentOffset = CGPointMake(self.view.frame.size.width * 2, 0);
        
        //!新发布对应的tableView可以置顶
        [self setScrollerToTopWithOnSale:NO withNewSale:NO withNotSale:YES];
        

        
    }else{//!在售
    
        //!改变sc偏移的位置
        _goodsSc.contentOffset = CGPointMake(0, 0);
        
        //!在售显示，则在售的列表可点击置顶
        [self setScrollerToTopWithOnSale:YES withNewSale:NO withNotSale:NO];
        

    
    }
    
    //!改变 在售 各个状态的按钮
    [onSaleGoodsView.segmentView setSelectBtnType:self.type];
    onSaleGoodsView.channelType = self.type;
    
    
     
}


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
    // !商家信息 因为商家有可能会在操作过程中改变营业状态 这个时候未发布的商品在 歇业 和关闭的时候是不能上架的
    [self getMerchantInfo];
    
    //!初始化数据
    [self initPageAndArray];
    
    //!请求数据
    [self requestData];
    
    

}


#pragma mark 创建导航
-(void)createNav{

    self.title = @"商品";
    
    [self customBackBarButton];
    
    
    UIBarButtonItem *buttonItem = [self barButtonWithtTitle:@"搜索" font:[UIFont systemFontOfSize:13]];

    UIBarButtonItem * rightBarBtn = buttonItem;
    
    self.navigationItem.rightBarButtonItem = rightBarBtn;

    

}
//!搜索
-(void)rightButtonClick:(UIButton *)sender{

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    CPSSearchGoodsViewController *searchGoodsViewController = [storyboard instantiateViewControllerWithIdentifier:@"CPSSearchGoodsViewController"];
    
    [self.navigationController pushViewController:searchGoodsViewController animated:YES];
    
}
#pragma mark 创建界面
-(void)createUI{

    
    //!顶部的滑动
    self.manager = [[SlidePageManager alloc]init];
    SlidePageSquareView * scView1 = (SlidePageSquareView*)[self.manager createBydataArr:@[@"在售",@"新发布",@"已下架"] slidePageType:SlidePageTypeSquare  bgColor:[UIColor colorWithHex:0x333333] squareViewColor:[UIColor colorWithHex:0xffffff] unSelectTitleColor:[UIColor colorWithHex:0x999999] selectTitleColor:[UIColor blackColor] witTitleFont:[UIFont systemFontOfSize:14]];
    
    
    
    scView1.frame = CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, statusHeaderHight);
    scView1.contentSize = CGSizeMake(self.view.frame.size.width, 0);
    scView1.delegateForSlidePage = self;
    [self.view addSubview:scView1];
    
    
    _goodsSc = [[UIScrollView alloc]initWithFrame:CGRectMake(0,statusHeaderHight, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame) - statusHeaderHight)];
    _goodsSc.contentSize = CGSizeMake(self.view.frame.size.width * 3, _goodsSc.frame.size.height);
    _goodsSc.pagingEnabled = YES;
    _goodsSc.scrollsToTop = NO;
    _goodsSc.delegate = self;
    [self.view addSubview:_goodsSc];
    
    //!在售
    onSaleGoodsView = [[ManageGoodsView alloc]initWithFrame:CGRectMake(0, 0, _goodsSc.frame.size.width, _goodsSc.frame.size.height) withGoodsStatus:SalesStatusOnSales];
    
    //!新发布
    newSaleGoodsView = [[ManageGoodsView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(onSaleGoodsView.frame), onSaleGoodsView.frame.origin.y,_goodsSc.frame.size.width, _goodsSc.frame.size.height) withGoodsStatus:SalesStatusNewRelease];
    
    
    //!已下架
    notOnSaleGoodsView = [[ManageGoodsView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(newSaleGoodsView.frame), onSaleGoodsView.frame.origin.y,_goodsSc.frame.size.width, _goodsSc.frame.size.height) withGoodsStatus:SalesStatusUndercarriage];

    //!添加到view
    [_goodsSc addSubview:onSaleGoodsView];
    [_goodsSc addSubview:newSaleGoodsView];
    [_goodsSc addSubview:notOnSaleGoodsView];
    
    
    //!刷新的block
    [self realizeRefreshBlocks];
    
    //!进入商品详情的block
    [self realizeIntoDetailBlock];
    
    //!单个商品上下架的block
    [self singleGoodsOperationBlock];
    
    //!商品不能上下架的原因提示
    [self goodsLimitOperationBlockAlert];
    
    //!多个商品上下架
    [self multiGoodsOperationBlock];
    
    //!在售状态下 修改销售渠道的block实现
    [self realizeChangeChannelBlock];
    
}
#pragma mark 刷新的block实现
-(void)realizeRefreshBlocks{

    //!刷新的block实现
    __weak ManageGoodsViewController * goodsVC = self;
    onSaleGoodsView.refreshBlock = ^(BOOL isHeader,NSInteger goodsStatus,NSString * onSaleChannelType){
        
        //!下拉刷新
        if (isHeader) {
            
            pageOnSale = 1;
            onSaleDataArray = [NSMutableArray arrayWithCapacity:0];
            
            
        }else{
            
            pageOnSale = pageOnSale +1;
            
        }
        
        goodsVC.type = onSaleChannelType;//!在售商品的销售渠道
        
        [goodsVC requestWithGoodsStatus:SalesStatusOnSales];
        
        
    };
    
    newSaleGoodsView.refreshBlock = ^(BOOL isHeader,NSInteger goodsStatus,NSString * onSaleChannelType){
        
        
        //!下拉刷新
        if (isHeader) {
            
            pageNewSale = 1;
            newSaleDataArray = [NSMutableArray arrayWithCapacity:0];
            
            
        }else{
            
            pageNewSale = pageNewSale +1;
            
        }
        [goodsVC requestWithGoodsStatus:SalesStatusNewRelease];
        
        
    };
    
    notOnSaleGoodsView.refreshBlock = ^(BOOL isHeader,NSInteger goodsStatus,NSString * onSaleChannelType){
        
        
        //!下拉刷新
        if (isHeader) {
            
            pageNotOnSale = 1;
            notOnSaleDataArray = [NSMutableArray arrayWithCapacity:0];
            
            
        }else{
            
            pageNotOnSale = pageNotOnSale +1;
            
        }
        
        [goodsVC requestWithGoodsStatus:SalesStatusUndercarriage];
        
    };

    


}

#pragma mark 点击cell 进入商品详情 的block实现
-(void)realizeIntoDetailBlock{

    __weak ManageGoodsViewController * goodsVC = self;

    onSaleGoodsView.intoDetailBlock = ^(NSString * goodsNo){
    
        [goodsVC intoDetailWithGoodsNo:goodsNo];

    };
    
    newSaleGoodsView.intoDetailBlock = ^(NSString * goodsNo){
        
        [goodsVC intoDetailWithGoodsNo:goodsNo];

    };
    
    notOnSaleGoodsView.intoDetailBlock = ^(NSString * goodsNo){
        
        [goodsVC intoDetailWithGoodsNo:goodsNo];

    };

}
-(void)intoDetailWithGoodsNo:(NSString * )goodsNo{

    
    EditGoodsViewController * editVC = [[EditGoodsViewController alloc]init];
    editVC.goodsNo = goodsNo;
    [self.navigationController pushViewController:editVC animated:YES];

}

#pragma mark 单个商品上下架的block实现
-(void)singleGoodsOperationBlock{

    __weak ManageGoodsViewController * goodsVC = self;

    onSaleGoodsView.goodsOperationBlock = ^(NSString *goodsNo,NSString *goodsStatus){
        
        [goodsVC singleGoodsOperationWithGoodsNo:goodsNo withGoodsStatus:goodsStatus];
        
    };
    
    newSaleGoodsView.goodsOperationBlock = ^(NSString *goodsNo,NSString *goodsStatus){
        
        [goodsVC singleGoodsOperationWithGoodsNo:goodsNo withGoodsStatus:goodsStatus];

    };
    
    notOnSaleGoodsView.goodsOperationBlock = ^(NSString *goodsNo,NSString *goodsStatus){
        
        [goodsVC singleGoodsOperationWithGoodsNo:goodsNo withGoodsStatus:goodsStatus];

    };

}

-(void)singleGoodsOperationWithGoodsNo:(NSString *)goodsNo withGoodsStatus:(NSString *)goodsStatus{
    
    self.updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc]init];
    
    self.updateGoodsStatusModel.goodsStatus = goodsStatus;
    self.updateGoodsStatusModel.goodsNo = goodsNo;
    
    NSString * alertMessage = @"";
    
    if ([goodsStatus isEqualToString:@"3"]) {
        alertMessage = @"下架";
    }else if([goodsStatus isEqualToString:@"2"]){
        alertMessage = @"上架";
    }
    
    if (_customAlertView) {
        
        [_customAlertView removeFromSuperview];
        
    }
    
    _customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:[NSString stringWithFormat:@"确定%@此商品?",alertMessage] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        // !单个商品上下架
        [self singleGoodsOperationRequest];
        
    } dismissAction:nil];
    
    [_customAlertView show];
    
    

}
//!单个商品上下架的请求
-(void)singleGoodsOperationRequest{
    
    [self progressHUDShowWithString:@"请求中"];

    [HttpManager sendHttpRequestForGetUpdateGoodsStatus:self.updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            [self progressHUDHiddenTipSuccessWithString:@"请求成功"];
            
            //!修改商品状态后刷新状态
            //!初始化数据
            [self initPageAndArray];
            
            //!请求数据
            [self requestData];
            
            
            
        }else{
            
            [self progressHUDHiddenWidthString:responseDic[ERRORMESSAGE]];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self progressHUDHiddenWidthString:@"请求失败"];

        
    }];
    
    


}

#pragma mark 商品不能上下架的原因提示
-(void)goodsLimitOperationBlockAlert{
    
    __weak ManageGoodsViewController * managerVC = self;
    onSaleGoodsView.cannotChangeStatus = ^(NSString *resason){
    
        [managerVC.view makeMessage:resason duration:2.0 position:@"center"];
        
    };
    
    newSaleGoodsView.cannotChangeStatus = ^(NSString *resason){
    
        [managerVC.view makeMessage:resason duration:2.0 position:@"center"];

    };
    
    notOnSaleGoodsView.cannotChangeStatus =  ^(NSString *resason){
        
        [managerVC.view makeMessage:resason duration:2.0 position:@"center"];
        
    };

    
}

#pragma mark 多个商品上下架的block实现
-(void)multiGoodsOperationBlock{

    __weak ManageGoodsViewController * goodsVC = self;
    
    onSaleGoodsView.multiGoodsOperationBlock = ^(NSMutableArray *selectGoodsArray,NSString *goodsStatus){//!goodsStatus：是商品要成为的状态
    
        [goodsVC multiGoodsOperation:selectGoodsArray withGoodsStatus:goodsStatus];
        
    };
    
    newSaleGoodsView.multiGoodsOperationBlock = ^(NSMutableArray *selectGoodsArray,NSString *goodsStatus){
        
        
        [goodsVC multiGoodsOperation:selectGoodsArray withGoodsStatus:goodsStatus];

    };
    
    notOnSaleGoodsView.multiGoodsOperationBlock = ^(NSMutableArray *selectGoodsArray,NSString *goodsStatus){
        
        [goodsVC multiGoodsOperation:selectGoodsArray withGoodsStatus:goodsStatus];

        
    };
    
}

-(void)multiGoodsOperation:(NSMutableArray *)selectGoodsArray withGoodsStatus:(NSString *)goodsStatus{

    
    NSString * alertMessage = @"";
    if ([goodsStatus isEqualToString:@"3"]) {
        
        alertMessage = @"下架";

    }else{
    
        alertMessage = @"上架";

    }
    
    if (_customAlertView) {
        
        [_customAlertView removeFromSuperview];
        
    }
    
    _customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:[NSString stringWithFormat:@"已选择%lu个商品，是否确定%@商品?",(unsigned long)selectGoodsArray.count,alertMessage] withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        [self multiGoodsOperationRequest:selectGoodsArray withGoodsStatus:goodsStatus];
        
        
    } dismissAction:nil];
    
    [_customAlertView show];

    
    
    

}
-(void)multiGoodsOperationRequest:(NSMutableArray *)selectGoodsArray withGoodsStatus:(NSString *)goodsStatus{
    
    
    self.updateGoodsStatusModel = [[UpdateGoodsStatusModel alloc]init];
    self.updateGoodsStatusModel.goodsStatus = goodsStatus;
    
    NSMutableArray *goodsNosArray = [[NSMutableArray alloc]init];
    
    for (EditGoodsDTO *editGoods in selectGoodsArray) {
        
        [goodsNosArray addObject:editGoods.goodsNo];
    }
    self.updateGoodsStatusModel.goodsNo = [self getStringWithArray:goodsNosArray];
    
    
    [self progressHUDShowWithString:@"请求中"];
    
    [HttpManager sendHttpRequestForGetUpdateGoodsStatus:self.updateGoodsStatusModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            
            [self progressHUDHiddenWidthString:@"请求成功"];
           
            //!修改商品状态后刷新状态
            //!初始化数据
            [self initPageAndArray];
            
            //!请求数据
            [self requestData];

            
            
        }else{
            
           
            [self progressHUDHiddenWidthString:responseDic[ERRORMESSAGE]];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self progressHUDHiddenWidthString:@"请求失败"];

    }];
    

    
}

#pragma mark 在售状态下 修改销售渠道的block实现
-(void)realizeChangeChannelBlock{

    //!销售渠道 -1 全部； 0 批发； 1 零售 ；2批发和零售
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    onSaleGoodsView.leftChangeChannelBlock = ^(NSMutableArray * selectArray){
    
        if (!selectArray.count) {
            
            [weakSelf.view makeMessage:@"请勾选商品" duration:2.0 position:@"center"];
            
            return ;
        }
        
        if ([weakSelf.type isEqualToString:@"0"]) {//!批发： 加入零售渠道
            
            [weakSelf addToChannelRetail:selectArray];
            
            
        }else if([weakSelf.type isEqualToString:@"1"]){//!零售：加入批发渠道
        
            [weakSelf addToChannelWholse:selectArray];
        
        }else if ([weakSelf.type isEqualToString:@"2"]){//!批发/零售：从批发渠道移除
        
            [weakSelf remmoveFromChannelWholse:selectArray];
        
        }
        
        
        
    };
    
    
    onSaleGoodsView.rightChangeChannelBlock = ^(NSMutableArray * selectArray){
    
        if (!selectArray.count) {
            
            [weakSelf.view makeMessage:@"请勾选商品" duration:2.0 position:@"center"];
            
            return ;
        }

        
        if([weakSelf.type isEqualToString:@"0"]) {//!批发： 加入零售渠道 并从批发渠道移除
          
            [weakSelf addToChannelRetialAndRemoveFremWholse:selectArray];
            
        }else if([weakSelf.type isEqualToString:@"1"]){//!零售：加入批发渠道 并从零售渠道移除
            
            [weakSelf addToChannelWholseAndRemoveFromRetail:selectArray];
            
            
        }else if ([weakSelf.type isEqualToString:@"2"]){//!批发/零售：从零售渠道移除
            
            [weakSelf removeFromChannelRetail:selectArray];
            
            
        }
    
    };
    
    
    
    

}


#pragma mark 加入零售渠道，并从批发渠道移除
-(void)addToChannelRetialAndRemoveFremWholse:(NSArray *)selectArray{


    //!1、判断是否在零售里面
    //!2、判断是否有零售价格
    /*
     需求/思路：
     
     不管是否在零售，填写了零售价就修改为 仅零售；没有填写价钱的 渠道不变
     
     
     if、全部已经在零售里面了 ---
        
        显示有部分已经在零售里面
        再弹出框提示，全部渠道改为“仅零售”
     
     else 没有在零售里面的/部分在零售里面的
     
     A：部分在零售里面的---
     
        显示有部分已经在零售里面
     
     ---------------------------
     
     B：没有在零售里面的----
     
     
     显示可以加入的商品：
     
     判断是否填写零售价格，全部填写 1）全部渠道改为“仅零售”
     
     部分没有填写 2)部分没有填写零售价格、显示出来，把填写零售价格的变为“仅零售”，没有填写价格的不变
    
     
     */
    
    //!获取已经在零售里面的商品：
    NSArray * inRetailArray = [self getGoodsIn:selectArray isInWholse:NO];
    
    if (inRetailArray.count == selectArray.count) {//!选择的商品都在零售渠道里面
        
        //!直接把所有商品修改为 “仅零售” 0 批发 1零售
        
        [self showAdd:[NSString stringWithFormat:@"确定将已选择的%ld件商品从批发渠道移除？",(unsigned long)selectArray.count] msg:@"您选择的商品均已在零售渠道销售" requestArray:selectArray withChannelListStr:@"1"];


        
    }else if (inRetailArray.count == 0){//!没有商品在零售里面,全部都“仅批发”
    
        [self showCanAddRetialAndRemoveFromWholse:selectArray];

    
    }else{//!部分在零售里面
    
        [self.view makeMessage:[NSString stringWithFormat:@"您选择的商品中有%ld件已经是零售商品",(unsigned long)inRetailArray.count] duration:2.0 position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showAddRetailAndRemoveFromWholseAlertTimeClick:) userInfo:@{@"canArray":selectArray} repeats:NO];
    
    }
    

}
-(void)showAddRetailAndRemoveFromWholseAlertTimeClick:(NSTimer *)timer{
    
    NSArray * array = timer.userInfo[@"canArray"];
    
    [self showCanAddRetialAndRemoveFromWholse:array];
    
    
}

-(void)showCanAddRetialAndRemoveFromWholse:(NSArray *)selectArray{

    //!获取已填写零售价格的商品
    NSArray * withRetailPriceArray = [self getGoodsWithRetailPrice:selectArray];
    
    //!获取未填写零售价格的商品
    NSArray * noRetailPriceArray = [self getGoodsNoRetailPrice:selectArray];
    
    
    if (withRetailPriceArray.count == selectArray.count) {//!所有商品都填写零售价格
        
        [self showAdd:@"确定加入零售并从批发渠道移除？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"1"];
        
        
    }else if(withRetailPriceArray.count == 0){//!全部未填写零售价格
    
        [self.view makeMessage:@"未加入零售渠道的商品均无零售价，\n不可加入零售渠道" duration:3.0 position:@"center"];
    
    
    }else{//!部分未填写价格
        
        //!拼接未填写零售价商品的货号
        NSMutableString * noRetailPriceStr = [NSMutableString stringWithString:@""];
        
        for (int i = 0; i< noRetailPriceArray.count; i++) {
            
            EditGoodsDTO * goodsDTO = noRetailPriceArray[i];
            
            [noRetailPriceStr appendString:goodsDTO.goodsWillNo];
            
            if ((i != noRetailPriceArray.count - 1 ) && noRetailPriceArray.count != 1) {
                
                [noRetailPriceStr appendString:@"、"];
            }
            
        }
        
        
        NSString * msg = [NSString stringWithFormat:@"已选择%ld个商品\n其中%ld个商品未填零售价：%@",(unsigned long)selectArray.count,noRetailPriceArray.count,noRetailPriceStr];
        
        
        [self showAdd:@"确定加入零售并从批发渠道移除？" msg:msg requestArray:withRetailPriceArray withChannelListStr:@"1"];
        
        
        
    }

    


}


#pragma mark 加入零售渠道
-(void)addToChannelRetail:(NSArray *)selectArray{


    //!1、判断是否在零售里面
    //!2、判断是否有零售价格
    
    /*
     需求/思路：
    
     if、全部已经在零售里面了
     
     else 没有在零售里面的/部分在零售里面的
     
        A：部分在零售里面的
     
            显示有部分已经在零售里面
     
        B：没有在零售里面的
     
     
     显示可以加入的商品：
     
     判断是否填写零售价格，全部填写 1）可以全部加入
     
     部分没有填写 2)部分没有填写零售价格、显示出来，告诉用户有几个可以加入
     
     */
    
    //!获取已经在零售里面的商品：
    NSArray * inRetailArray = [self getGoodsIn:selectArray isInWholse:NO];
    
    //!获取不在零售里面的商品
    NSArray * notInRetailArray = [self getGoodsNotIn:selectArray isInWholse:NO];
    
    
    if (inRetailArray.count == selectArray.count) {//!已经在零售里面的商品数量 == 全部选择的商品数量，说明全部已经在零售里面
 
        [self.view makeMessage:@"您选择的商品均已在零售渠道销售" duration:2.0 position:@"center"];
        
    
    }else if(inRetailArray.count == 0){//!没有在零售里面的
        
        //!全部都可以判断
        [self showCanAddRetail:selectArray];
        

    }else{//!部分在零售里面
    
        [self.view makeMessage:[NSString stringWithFormat:@"您选择的商品中有%ld件已经是零售商品",(unsigned long)inRetailArray.count] duration:2.0 position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(showJustAddRetailAlertTimeClick:) userInfo:@{@"canArray":notInRetailArray} repeats:NO];
    
    
    }


}
-(void)showJustAddRetailAlertTimeClick:(NSTimer *)timer{
    
    NSArray * notInRetailArray = timer.userInfo[@"canArray"];
    
    [self showCanAddRetail:notInRetailArray];
    
    
}

//!加入零售渠道：没有在零售里面的/部分在零售里面的 情况处理
-(void)showCanAddRetail:(NSArray *)selectArray{

    //！判断是否填写零售价格， 1）全部填写,可以全部加入
    
    //  2)部分没有填写零售价格、显示出来，告诉用户有几个可以加入
    
    //!获取填写零售价格的商品
    NSArray * hasRetailPriceArray = [self getGoodsWithRetailPrice:selectArray];
    
    //!获取未填写零售价格的商品
    NSArray * noRetailPriceArray = [self getGoodsNoRetailPrice:selectArray];
    
    
    if (hasRetailPriceArray.count == selectArray.count) {//!全部填写零售价格，说明全部可以加入零售渠道
        
        [self showAdd:@"确定加入零售渠道？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"0,1"];
        
    }else if (hasRetailPriceArray.count == 0){//!全部没有填写零售价格
    
        [self.view makeMessage:@"未加入零售渠道的商品均无零售价，\n不可加入零售渠道" duration:2.0 position:@"center"];
    
    }else{
        
        
        //!拼接未填写零售价商品的货号
        NSMutableString * noRetailPriceStr = [NSMutableString stringWithString:@""];
        
        for (int i = 0; i< noRetailPriceArray.count; i++) {
            
            EditGoodsDTO * goodsDTO = noRetailPriceArray[i];
            
            [noRetailPriceStr appendString:goodsDTO.goodsWillNo];
            
            if ((i != noRetailPriceArray.count - 1 ) && noRetailPriceArray.count != 1) {
                
                [noRetailPriceStr appendString:@"、"];
            }
            
        }
        
        
        NSString * msg = [NSString stringWithFormat:@"已选择%ld个商品\n其中%ld个商品未填零售价：%@",(unsigned long)selectArray.count,noRetailPriceArray.count,noRetailPriceStr];
        
        
        [self showAdd:@"确定将已填零售价的商品加入零售渠道？" msg:msg requestArray:hasRetailPriceArray withChannelListStr:@"0,1"];
        
        
        
    }
    


}


//!返回的是不在“零售”/"批发"里面的数组
-(NSMutableArray *)getGoodsNotIn:(NSArray *)selectArray isInWholse:(BOOL)inWholse{

    NSString * getChannelStr = @"";
    
    if (inWholse) {//!判断是否在批发里面
        
        getChannelStr = @"0";

        
    }else{ //!判断是否在零售里面
    
        getChannelStr = @"1";

    }


    NSMutableArray * getArray = [NSMutableArray arrayWithArray:selectArray];
    
    for (EditGoodsDTO * goodsDTO in selectArray) {
        
        //!获取销售渠道
        NSArray * channelArray = [goodsDTO.channelList componentsSeparatedByString:@","];
        
        for (NSString * channelStr in channelArray) {
            
            if ([getChannelStr isEqualToString:channelStr]) {
                
                [getArray removeObject:goodsDTO];
                
            }
            
            
        }
        
    }
    
    return getArray;

}

//!返回的是在“零售”/"批发"里面的数组
-(NSMutableArray *)getGoodsIn:(NSArray *)selectArray isInWholse:(BOOL)inWholse{
    
    NSString * getChannelStr = @"";
    
    if (inWholse) {//!判断是否在批发里面
        
        getChannelStr = @"0";
        
        
    }else{ //!判断是否在零售里面
        
        getChannelStr = @"1";
        
    }
    
    
    NSMutableArray * getArray = [NSMutableArray arrayWithCapacity:0];
    
    for (EditGoodsDTO * goodsDTO in selectArray) {
        
        //!获取销售渠道
        NSArray * channelArray = [goodsDTO.channelList componentsSeparatedByString:@","];
        
        for (NSString * channelStr in channelArray) {
            
            if ([getChannelStr isEqualToString:channelStr]) {
                
                if (![getArray containsObject:goodsDTO]) {
                    
                    [getArray addObject:goodsDTO];

                }
                
            }
            
            
        }
        
    }
    
    return getArray;
    
}



//!获取没有零售价格的商品
-(NSMutableArray *)getGoodsNoRetailPrice:(NSArray *)notInretailArray {

    NSMutableArray * noRetailPriceArray = [NSMutableArray arrayWithCapacity:0];
    

    for (EditGoodsDTO * goodsDTO in notInretailArray) {
        
        if (![goodsDTO.retailPrice floatValue]) {
            
            [noRetailPriceArray addObject:goodsDTO];
            
        }
    
        
    }
    
    return noRetailPriceArray;
    
}

//!获取填写零售价格的商品
-(NSMutableArray *)getGoodsWithRetailPrice:(NSArray *)array{

    
    NSMutableArray * withRetailPriceArray = [NSMutableArray arrayWithCapacity:0];
    
    
    for (EditGoodsDTO * goodsDTO in array) {
        
        if ([goodsDTO.retailPrice floatValue]) {
            
            [withRetailPriceArray addObject:goodsDTO];
            
        }
        
        
    }
    
    return withRetailPriceArray;



}

#pragma mark 加入批发渠道
-(void)addToChannelWholse:(NSArray *)selectArray{
    
    //!判断是否有商品已经在批发里面
    NSArray * inWholseArray = [self getGoodsIn:selectArray isInWholse:YES];
    if (inWholseArray.count == selectArray.count) {//!选择的所有商品都已经在批发里面
        
        [self.view makeMessage:@"您选择的商品均已在批发渠道销售" duration:2.0 position:@"center"];
        
    }else if (inWholseArray.count == 0){//!选择的商品在批发里面的数量 = 0,全部加入批发
        
        
        [self showAdd:@"确定加入批发渠道？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"0,1"];
        
        
    }else{
        //!部分在批发里面了
        
        [self.view makeMessage:[NSString stringWithFormat:@"您选择的商品中有%ld件已经是批发商品",(unsigned long)inWholseArray.count] duration:2.0 position:@"center"];

        //!获取不在批发里面的商品
        NSArray * notInWholseArray = [self getGoodsNotIn:selectArray isInWholse:YES];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showJustAddWholseAlertTimeClick:) userInfo:@{@"canArray":notInWholseArray} repeats:NO];
    
    
    }
    
    
}
-(void)showJustAddWholseAlertTimeClick:(NSTimer *)timer{

    NSArray * notInWholseArray = timer.userInfo[@"canArray"];

    
    [self showAdd:@"确定加入批发渠道？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)notInWholseArray.count] requestArray:notInWholseArray withChannelListStr:@"0,1"];
    

}


#pragma mark 加入批发渠道并从零售渠道移除
-(void)addToChannelWholseAndRemoveFromRetail:(NSArray *)selectArray{

    //!所有的都在批发渠道
    NSArray * inWholseArray = [self getGoodsIn:selectArray isInWholse:YES];
    
    if (inWholseArray.count == selectArray.count) {//!所有的都已经在批发渠道
        
        //!从零售渠道移除
        [self showAdd:[NSString stringWithFormat:@"确定将已选择的%ld件商品从零售渠道移除？",selectArray.count] msg:@"您选择的商品均已在批发渠道销售" requestArray:selectArray withChannelListStr:@"0"];

        
        
    }else if(inWholseArray.count == 0){//!全部都不在批发,全部修改为“仅批发”
    
        [self showAdd:@"确定加入批发渠道并从零售渠道移除？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"0"];
        
    
    }else{//!部分在批发、部分不在批发
    
        [self.view makeMessage:[NSString stringWithFormat:@"您选择的商品中有%ld件已经是批发商品",(unsigned long)inWholseArray.count] duration:2.0 position:@"center"];
        
        [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(showAddWholseAndRemoveFreomRetailAlertTimeClick:) userInfo:@{@"canArray":selectArray} repeats:NO];

    
    }
    


}
-(void)showAddWholseAndRemoveFreomRetailAlertTimeClick:(NSTimer *)timer{
    
    
    //!0 批发 1零售 （修改为仅批发）

    NSArray * selectArray = timer.userInfo[@"canArray"];
    
    [self showAdd:@"确定加入批发渠道并从零售渠道移除？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"0"];
    
    
}


//!显示最终的提示，让用户选择
-(void)showAdd:(NSString *)title msg:(NSString *)msg requestArray:(NSArray *)requestArray withChannelListStr:(NSString *)channelStr{
    
    if (_customAlertView) {
        
        [_customAlertView removeFromSuperview];
        
    }
    
    _customAlertView = [GUAAlertView alertViewWithTitle:title withTitleClor:nil message:msg withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        if (requestArray.count == 0) {
            
            return ;
        }
        //!0 批发 1零售 （修改为仅批发）
        [self changeChannelRequest:requestArray withChannelList:channelStr];
        
    } dismissAction:nil];
    
    [_customAlertView show];
    
    
    
}


#pragma mark 从批发渠道移除
-(void)remmoveFromChannelWholse:(NSArray *)selectArray{

    //!0 批发 1零售 （修改为仅零售）
    [self showAdd:@"确定从批发渠道移除？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"1"];

//    [self changeChannelRequest:selectArray withChannelList:@"1"];

    
}

#pragma mark 从零售渠道移除
-(void)removeFromChannelRetail:(NSArray *)selectArray{

    
    //!0 批发 1零售 （修改为仅批发）
    [self showAdd:@"确定从零售渠道移除？" msg:[NSString stringWithFormat:@"已选择%ld个商品",(unsigned long)selectArray.count] requestArray:selectArray withChannelListStr:@"0"];

//    [self changeChannelRequest:selectArray withChannelList:@"0"];

    
}


#pragma mark 修改销售渠道的请求
//!0 批发 1零售
-(void)changeChannelRequest:(NSArray *)lastGoodsArray withChannelList:(NSString *)channelList{

    NSMutableString * goodsNoStr = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i <lastGoodsArray.count; i++) {
        
        EditGoodsDTO * goodsDTO = lastGoodsArray[i];
        
        [goodsNoStr appendString:goodsDTO.goodsNo];
        
        if ((i != lastGoodsArray.count - 1) && lastGoodsArray.count != 1) {
            
            [goodsNoStr appendString:@","];
            
        }
        
        
    }
    
   
    [self progressHUDShowWithString:@"请求中"];
    [HttpManager sendHttpRequestForSaleChannelUpdate:goodsNoStr channelListStr:channelList Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {

            [self progressHUDHiddenWidthString:@"商品销售渠道批量更改成功"];
            //!修改商品状态后刷新状态
            //!初始化数据
            [self initPageAndArray];
            
            //!请求数据
            [self requestData];
            
        }else{
        
            [self progressHUDHiddenWidthString:responseDic[@"errorMessage"]];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [self progressHUDHiddenWidthString:@"请求失败"];
        
    }];
    
    


}

#pragma mark 请求数据
//!初始化数据
-(void)initPageAndArray{

    pageOnSale = 1;
    pageNewSale = 1;
    pageNotOnSale = 1;
    
    onSaleDataArray = [NSMutableArray arrayWithCapacity:0];
    newSaleDataArray = [NSMutableArray arrayWithCapacity:0];
    notOnSaleDataArray = [NSMutableArray arrayWithCapacity:0];
    
    onSaleGoodsView.selectArray = [NSMutableArray arrayWithCapacity:0];
    newSaleGoodsView.selectArray = [NSMutableArray arrayWithCapacity:0];
    notOnSaleGoodsView.selectArray = [NSMutableArray arrayWithCapacity:0];
    
    
}
-(void)requestData{

    
    //!在售
    [self requestWithGoodsStatus:SalesStatusOnSales];
    
    //!新发布
    [self requestWithGoodsStatus:SalesStatusNewRelease];
    
    //!已下架
    [self requestWithGoodsStatus:SalesStatusUndercarriage];
    
    
}


-(void)requestWithGoodsStatus:(GoodsSalesStatus)goodsSaleStatus{

    EditGoodsModel *editGoodsModel = [[EditGoodsModel alloc]init];

    if (goodsSaleStatus == SalesStatusOnSales) {//!在售
        
        editGoodsModel.goodsStatus = @"2";
        editGoodsModel.pageNo = [NSNumber numberWithInteger:pageOnSale];
        
        //!销售渠道
        NSInteger  channelTypeInt = [self.type integerValue];
        editGoodsModel.channelType = [NSNumber numberWithInteger:channelTypeInt];
        
        
    }else if (goodsSaleStatus == SalesStatusNewRelease){//!新发布
    
        editGoodsModel.goodsStatus = @"1";
        editGoodsModel.pageNo = [NSNumber numberWithInteger:pageNewSale];

        //!销售渠道
        editGoodsModel.channelType = [NSNumber numberWithInteger:-1];

    }else{//!已下架
    
        editGoodsModel.goodsStatus = @"3";
        editGoodsModel.pageNo = [NSNumber numberWithInteger:pageNotOnSale];
        
        //!销售渠道
        editGoodsModel.channelType = [NSNumber numberWithInteger:-1];


    }
    editGoodsModel.pageSize = [NSNumber numberWithInt:20];
    editGoodsModel.queryType = @"";
    editGoodsModel.param = @"";
    
    
    [HttpManager sendHttpRequestForGetEditGoodsList:editGoodsModel success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
       NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            
            //!不区分请求的状态，先把数据存放到临时数组
            NSMutableArray * getArray = [NSMutableArray arrayWithCapacity:0];
            
            for (NSDictionary * goodsDic in responseDic[@"data"][@"goodslist"]) {
                
                EditGoodsDTO *editGoods = [[EditGoodsDTO alloc]init];
                
                [editGoods setDictFrom:goodsDic];
                
                [getArray addObject:editGoods];
                
            }
            
            NSInteger totalCount = [responseDic[@"data"][@"totalCount"] integerValue];
            
            //!把数据存放到对应的数组
            [self addOnArrayWithGoodsStatus:goodsSaleStatus andGetArray:getArray withTotalCount:totalCount];
            
            
        }else{
        
            [self.view makeMessage:responseDic[@"errorMessage"] duration:2.0 position:@"center"];
            //!结束刷新
            [self goodsViewEndRefresh:goodsSaleStatus];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:@"请求失败" duration:2.0 position:@"center"];

        //!结束刷新
        [self goodsViewEndRefresh:goodsSaleStatus];

        
    }];

}
-(void)addOnArrayWithGoodsStatus:(GoodsSalesStatus)goodsSaleStatus andGetArray:(NSMutableArray *)getDataArray withTotalCount:(NSInteger)totalCount{

    
    if (goodsSaleStatus == SalesStatusOnSales) {//!在售
        
        [onSaleDataArray addObjectsFromArray:getDataArray];
        
        [onSaleGoodsView reloadData:onSaleDataArray withTotalCount:totalCount];
        
    }else if (goodsSaleStatus == SalesStatusNewRelease){//!新发布
        
        [newSaleDataArray addObjectsFromArray:getDataArray];
        
        [newSaleGoodsView reloadData:newSaleDataArray withTotalCount:totalCount];
        
    }else{//!已下架
        
        [notOnSaleDataArray addObjectsFromArray:getDataArray];
        
        [notOnSaleGoodsView reloadData:notOnSaleDataArray withTotalCount:totalCount];

    }
    
    

}

-(void)goodsViewEndRefresh:(GoodsSalesStatus)goodsSaleStatus{

    if (goodsSaleStatus == SalesStatusOnSales) {//!在售
        
        
        [onSaleGoodsView endRefresh];
        
    }else if (goodsSaleStatus == SalesStatusNewRelease){//!新发布
        
        
        [newSaleGoodsView endRefresh];
        
    }else{//!已下架
        
        
        [notOnSaleGoodsView endRefresh];
        
    }
    
    


}

#pragma mark //!设置列表是否可以置顶
-(void)setScrollerToTopWithOnSale:(BOOL)saleTop withNewSale:(BOOL)newTop withNotSale:(BOOL)notSale{

    [onSaleGoodsView setTableViewScrollToTop:saleTop];
    [newSaleGoodsView setTableViewScrollToTop:newTop];
    [notOnSaleGoodsView setTableViewScrollToTop:notSale];
    
}
#pragma mark SlidePageSquareViewDelegate
//!点击顶部按钮，进行滑动
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index{

    
    CGFloat screenWith = [UIScreen mainScreen].bounds.size.width;
    [_goodsSc  setContentOffset:CGPointMake(screenWith*index,0 ) animated:YES];

}

#pragma mark scrollerViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //!改变顶部的偏移
    self.manager.contentOffsetX = scrollView.contentOffset.x;

    //!根据页码选择哪个tableView可以滑动至顶部
    int page = scrollView.contentOffset.x/_goodsSc.frame.size.width;
    
    if (page == 0) {
        
        [self setScrollerToTopWithOnSale:YES withNewSale:NO withNotSale:NO];
        
    }else if(page == 1){
        
        [self setScrollerToTopWithOnSale:NO withNewSale:YES withNotSale:YES];
        
    }else{
        
        [self setScrollerToTopWithOnSale:NO withNewSale:NO withNotSale:YES];
        
    }

}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //!顶部偏移记录结束滑动的位置
    self.manager.endcontentOffsetX = scrollView.contentOffset.x;

}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
   
    //!顶部偏移记录结束滑动的位置
    self.manager.endcontentOffsetX = scrollView.contentOffset.x;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
