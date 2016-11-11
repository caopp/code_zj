//
//  MyOrderDetailViewController.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "MyOrderDetailViewController.h"
//view
#import "OrderDetailHeadView.h"//headView

#import "MyOrderParentTableViewCell.h"//cell的基类

#import "AccordOrderDetailTableViewCell.h"//拍照发货cell
#import "ExpressSingleTableViewCell.h"//录入快递单cell
#import "StayDeliverBtnView.h"//确认收货
#import "WaitPaymentBtnView.h"//付款/取消采购单
#import "WaitPaymentBottomView.h"//退款
#import "WaitAcceptGoodsBottomView.h"//确认收货
#import "SeeEextGoodsDetailView.h"//查看退换货按钮
#import "OrderCustomBtnView.h"



//model
#import "OrderDeliveryDTO.h"//快递单显示
#import "GoodsInfoDTO.h"//客服model
#import "OrderDetailDTO.h"

//controller
#import "CSPPayAvailabelViewController.h"//支付
#import "ConversationWindowViewController.h"//客服
#import "MerchantDeatilViewController.h"//店铺详情
#import "CSPPostageViewController.h"//邮费专拍
#import "GoodDetailViewController.h"//商品详情
#import "CourierViewController.h"//物流
#import "ExitChangeGoodsViewController.h"//查看退/换货详情
//!退换货选择列表
#import "ReturnViewController.h"

//!退换货申请
#import "ReturnApplyViewController.h"

#import "JustChangeGoodsDealView.h"



//other
#import "Masonry.h"
#import "MJExtension.h"




@interface MyOrderDetailViewController ()<UITableViewDataSource ,UITableViewDelegate ,StayDeliverDelegate ,WaitPaymentDelegate ,MyOrderParentTableViewDelegate,MBProgressHUDDelegate>

//tableView
@property (nonatomic ,strong)UITableView *tableView;

//顶部视图
@property (nonatomic ,strong) OrderDetailHeadView *headView;

//采购单详情
@property (nonatomic ,strong) OrderDetailDTO *orderDetailInfo;

//跳转到客服
@property (nonatomic,strong) NSDictionary *orderMerchantDic;

//合并再次付款
@property (nonatomic ,strong) OrderAddDTO *orderAddDTO;

//确认收货按钮
@property (nonatomic ,strong)StayDeliverBtnView *stayDeliberBtn;

//待付款按钮
@property (nonatomic ,strong) WaitPaymentBtnView *waitPayBtn;

@property (nonatomic ,strong) SeeEextGoodsDetailView *seeExitView;

@property (nonatomic ,strong) UIView *requestView;











@end

@implementation MyOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOrderList) name:@"RefreshOrderList" object:nil];

    //创建tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    self.tableView.delegate= self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    
    //取消默认 cell的line
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.requestView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.requestView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.requestView];
    
    
    //请求所有订单信息
    [self loadOrderDetailInfo];
    
    //添加返回按钮
    [self addCustombackButtonItem];
    self.title = @"采购单详情";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -UITableViewDelegate&&dataSource
//section
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//number
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        

        return self.orderDetailInfo.goodsList.count+1;

    }else if(section == 1)
    {
        if (self.orderDetailInfo.orderDeliveryList.count>0) {
            return self.orderDetailInfo.orderDeliveryList.count;
        }else if (self.orderDetailInfo != nil)
        {
            return 0;
        }
    }
    return 0;
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    
    static NSString *topOtherOrderTableViewCellId = @"TopOtherOrderTableViewCellId";
    //1> 普通商品
    static NSString *centerNormalShopMessageCellId= @"CenterNormalShopMessageTableViewCellId";
    //2> 邮费专拍
    static NSString *centerPostageShopMessageCellId = @"CenterPostageShopMessageTableViewCellId";
    //3> 样板
    static NSString *centerSampleShopMessageCellId = @"CenterSampleShopMessageCellTableViewCellId";
    
  
    MyOrderParentTableViewCell *myOrderCell;
    myOrderCell = [tableView dequeueReusableCellWithIdentifier:cellId];
    //判断是订单内容
    if (indexPath.section == 0) {
        
        //顶部
        if (indexPath.row == 0) {
            myOrderCell = [tableView dequeueReusableCellWithIdentifier:topOtherOrderTableViewCellId];
            
            //显示伪headView
            if (!myOrderCell) {
                myOrderCell = [[[NSBundle mainBundle] loadNibNamed:@"TopOtherOrderTableViewCell" owner:nil options:nil]lastObject];

            }
            
                myOrderCell.orderDetailDto = self.orderDetailInfo;
                myOrderCell.delegate = self;
                myOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
                return myOrderCell;
            
        }else {

    OrderGoodsItem *orderGoodsDto = self.orderDetailInfo.goodsList[indexPath.row-1];
    //普通商品
    if ([orderGoodsDto.cartType isEqualToString:@"0"]) {
        myOrderCell = [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
        myOrderCell = [[[NSBundle mainBundle]loadNibNamed:@"CenterNormalShopMessageTableViewCell" owner:nil options:nil]lastObject];
        
//        myOrderCell.
        
    }else if ([orderGoodsDto.cartType isEqualToString:@"1"])//样板
    {
        myOrderCell = [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
        myOrderCell = [[[NSBundle mainBundle]loadNibNamed:@"CenterSampleShopMessageCellTableViewCell" owner:nil options:nil]lastObject];
        
    }else if ([orderGoodsDto.cartType isEqualToString:@"2"])//邮费专拍
    {
       
        myOrderCell = [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
        myOrderCell = [[[NSBundle mainBundle]loadNibNamed:@"CenterPostageShopMessageTableViewCell" owner:nil options:nil]lastObject];
    }
     
    //显示底部的View
    myOrderCell.hideLine = @"YES";
    myOrderCell.goodsItemDto =orderGoodsDto;
    myOrderCell.delegate = self;
    myOrderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return myOrderCell;
        
        }
    }else
    
    {
    //拍照发货
    static NSString *accordOrderDetailTableViewCellId = @"AccordOrderDetailTableViewCellId";
    //录入快递单发货
    static NSString *expressSingleTableViewCellId = @"ExpressSingleTableViewCellId";

    
    if (self.orderDetailInfo.orderDelivery.count>0) {
        
        OrderDeliveryDTO *detailDto = self.orderDetailInfo.orderDelivery[indexPath.row];
        
        if (detailDto.type.integerValue == 1  ) {
            //拍照发货
            AccordOrderDetailTableViewCell *accordCell = [tableView dequeueReusableCellWithIdentifier:accordOrderDetailTableViewCellId];
            if (!accordCell) {
                accordCell = [[[NSBundle mainBundle]loadNibNamed:@"AccordOrderDetailTableViewCell" owner:nil options:nil]lastObject];
                accordCell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            if (indexPath.row == 0) {
                
                accordCell.changeTop = @"YES";

            }else
            {
                accordCell.changeTop = @"NO";

            }
            accordCell.number = indexPath.row+1;
            
            accordCell.deliverDto = detailDto;
            return accordCell;
        
            
        }else if (detailDto.type.integerValue ==2)
        {
            
            //录入快递单发货
            ExpressSingleTableViewCell *expressCell = [tableView dequeueReusableCellWithIdentifier:expressSingleTableViewCellId];
            if (!expressCell) {
            expressCell = [[[NSBundle mainBundle]loadNibNamed:@"ExpressSingleTableViewCell" owner:nil options:nil] lastObject];
                 expressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            expressCell.number = indexPath.row+1;
            
            expressCell.orderDeliverDto = detailDto;
             expressCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return expressCell;
        }
    
    }else if (self.orderDetailInfo != nil)//应该没有用了。
    {
        //拍照发货
        AccordOrderDetailTableViewCell *accordCell = [tableView dequeueReusableCellWithIdentifier:accordOrderDetailTableViewCellId];
        if (!accordCell) {
            accordCell = [[[NSBundle mainBundle]loadNibNamed:@"AccordOrderDetailTableViewCell" owner:nil options:nil]lastObject];
             accordCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }
        accordCell.detailDto = self.orderDetailInfo;;
        return accordCell;
    }
}
    
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL"];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        CGSize size =  [self accordingContentFont:self.orderDetailInfo.detailAddress fontSize:14];
        
        
        if ([self.orderDetailInfo.refundStatus isKindOfClass:[NSNumber class]]) {
            
            if (self.orderDetailInfo.refundStatus.integerValue == 1||self.orderDetailInfo.refundStatus.integerValue == 3) {
                return 271+size.height;

            }
        }
        
        
        return 251+size.height;
    }else if (section == 1)
    {        
                NSArray *arr =  self.orderDetailInfo.mailTimesArr;
                if (arr.count >0) {
        
                CGFloat cellHeight = 0;
                for (int i = 0; i<arr.count; i++) {
                    NSString *orderTimeStr = arr[i];
                    CGSize orderSize = [self accordingContentFont:orderTimeStr fontSize:12];
                    cellHeight =  cellHeight+orderSize.height+4;
        
                }
                if (self.orderDetailInfo!=nil) {
                    
                    if (self.orderDetailInfo.status == 1) {
                        return cellHeight + 30;
                    
                    }
                    return cellHeight +15;
                        
                    }
                }
        return 10;
    }
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            return 30;
            
        }else {
            
        
    OrderGoodsItem *orderGoodsDto = self.orderDetailInfo.goodsList[indexPath.row-1];
            
            NSArray *sizeArr = orderGoodsDto.sizes;
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

            
            return 75+CGRectGetMaxY(recoreSizeFrame);
            
//        return cellHeight+59;
        }
    }else if(indexPath.section==1)
    {

        
        
        if (indexPath.row == 0) {
            return 85;
            
        }
        OrderDeliveryDTO *detailDto = self.orderDetailInfo.orderDelivery[indexPath.row];

        if (detailDto.type.integerValue == 1) {
            return 122;
            
        }else if(detailDto.type.integerValue ==2)
        {
            return 80;
        }
            
        }
//    }
    return 0;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0   ) {
        
        if (indexPath.row == 0) {
            return;
            
        }
    
    OrderGoodsItem* orderGoodsInfo = self.orderDetailInfo.goodsList[indexPath.row-1];
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = orderGoodsInfo.goodsNo;
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    if ([orderGoodsInfo.cartType isEqualToString:@"2"]) {
        CSPPostageViewController* destViewController = [main instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        destViewController.merchantNo = self.orderDetailInfo.merchantNo;
        
        [self.navigationController pushViewController:destViewController animated:YES];
        
        
    }else{
        
        GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        
        [self.navigationController pushViewController:goodsInfo animated:YES];
        }
    }
    else
    {
        OrderDeliveryDTO *detailDto = self.orderDetailInfo.orderDelivery[indexPath.row];

        if(detailDto.type.integerValue == 2 ) {
            //拍照发货

        CourierViewController *courierVC = [[CourierViewController alloc] init];
        courierVC.expressCompanyCode = detailDto.logisticCode;
        courierVC.CourierName = detailDto.logisticName;

        courierVC.expressNO = detailDto.logisticTrackNo;
        [self.navigationController pushViewController:courierVC animated:YES];
        }
    }
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
    
    self.headView  = [[[NSBundle mainBundle] loadNibNamed:@"OrderDetailHeadView" owner:nil options:nil]lastObject];
        if (self.orderState == 0 || self.orderState == 4) {
            self.headView.backgroundColor = [UIColor grayColor];
        }else
        {
            self.headView.backgroundColor = [UIColor blackColor];
        }

    self.headView.detailDto = self.orderDetailInfo;
    
    return self.headView;
    }else if (section == 1)
    {
        AccordOrderDetailTableViewCell *accordCell = [[[NSBundle mainBundle]loadNibNamed:@"AccordOrderDetailTableViewCell" owner:nil options:nil]lastObject];
        accordCell.orderType = @"header";
        accordCell.detailDto = self.orderDetailInfo;
        return accordCell;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (section == 1) {
        
    NSArray *arr =  self.orderDetailInfo.mailEndTimesArr;
    if (arr.count >0) {
        
        CGFloat cellHeight = 0;
        for (int i = 0; i<arr.count; i++) {
            NSString *orderTimeStr = arr[i];
            CGSize orderSize = [self accordingContentFont:orderTimeStr fontSize:12];
            cellHeight =  cellHeight+orderSize.height+4;
            
        }
        if (self.orderDetailInfo!=nil) {
            if (self.orderDetailInfo.status == 0) {
                return cellHeight+15;
            }
            return cellHeight+40;
        }
    }
}

    return 1;
}


//
 -(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
    
    NSArray *arr =  self.orderDetailInfo.mailEndTimesArr;

    if (arr.count>0) {
        
    
    AccordOrderDetailTableViewCell *accordCell = [[[NSBundle mainBundle]loadNibNamed:@"AccordOrderDetailTableViewCell" owner:nil options:nil]lastObject];
    accordCell.orderType = @"footer";
    accordCell.detailFooterDto = self.orderDetailInfo;
    
    
    return accordCell;
        }
    }
    return nil;
    

}

#pragma mark - request
//请求订单详情的数据

- (void)loadOrderDetailInfo {
    
    if (self.requestView) {
        [MBProgressHUD showHUDAddedTo:self.requestView animated:YES];
    }else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }

    [HttpManager sendHttpRequestForOrderDetailWithOrderCode:self.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
       
            self.orderDetailInfo = [[OrderDetailDTO alloc]initWithDictionary:dic[@"data"]];
                if(self.orderDetailInfo.status == 1)
                    
            {
                WaitPaymentBtnView *waitPayBtn = [[[NSBundle mainBundle]loadNibNamed:@"WaitPaymentBtnView" owner:nil options:nil]lastObject];
                self.waitPayBtn = waitPayBtn;
           
                waitPayBtn.delegate = self;
                [self.view addSubview:waitPayBtn];
                [waitPayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.height.equalTo(@49);
                    
                }];
                
                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                }];
            }else if (self.orderDetailInfo.status == 2)//待发货
            {
                
                if ([self.orderDetailInfo.refundStatus isKindOfClass:[NSNumber class]]) {
                    if (!self.seeExitView) {
                        
                    
                    self.seeExitView = [[[NSBundle mainBundle] loadNibNamed:@"SeeEextGoodsDetailView" owner:self options:nil]lastObject];
                    self.seeExitView.blockSeeExitChangeDetail  = ^(NSString *type)
                    {
                        if ([type isEqualToString:@"1"]) {
                            
                            [self IntoExitChangeGoodsVC];
                            
                        }else if([type isEqualToString:@"0"])
                        {
                            //客服
                            [self waitPaymentCustomService];
                            
//                            [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                            self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
                            
                        }

                    };
                    
                    [self.view addSubview:self.seeExitView];
                    [self.seeExitView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left);
                        make.right.equalTo(self.view.mas_right);
                        make.bottom.equalTo(self.view.mas_bottom);
                        make.height.equalTo(@49);

                    }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];

                }
                    
                }else
                {
         
                WaitPaymentBottomView *waitPayView = [[[NSBundle mainBundle]loadNibNamed:@"WaitPaymentBottomView" owner:nil options:nil] lastObject];
                waitPayView.blockExitMoney =  ^(NSInteger type)
                {
                    if (type == 0) {
                        
                        [self waitPaymentCustomService];
                        
//                        //客服
//                        [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                        self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;

                        
                    }else if(type == 1)
                    {
                        //other*********

                        //!待发货的情况：直接接入“仅退款”
                        ReturnApplyViewController * applyVC = [[ReturnApplyViewController alloc]init];
                        applyVC.refundType = @"1";//!0-退货退款 1-仅退款 2-换货
                        applyVC.orderDetailInfo = self.orderDetailInfo;
                        [self.navigationController pushViewController:applyVC animated:YES];
                        
                    }
                    
                };
                
                [self.view addSubview:waitPayView];
                [waitPayView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.height.equalTo(@49);

                }];
                    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                    }];

                
                }

            }else if (self.orderDetailInfo.status == 3)
            {
                
                if ([self.orderDetailInfo.refundStatus isKindOfClass:[NSNumber class]]) {
                    
                    
                    if (self.orderDetailInfo.refundStatus.integerValue == 4) {
                        JustChangeGoodsDealView *just = [[[NSBundle mainBundle] loadNibNamed:@"JustChangeGoodsDealView" owner:nil options:nil] lastObject];
                        just.blockJustChangeGoodsDealView = ^(NSInteger type)
                        {
                            
                            if (type == 0) {
                                //客服
//                                [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                                self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
                                [self waitPaymentCustomService];
                                
                                
                            }else if (type == 1)
                            {
                                [self IntoExitChangeGoodsVC];
                            }else if (type == 2)
                            {
                                [self deliverConfirmation];
                            }
                        };
                        
                        
                        [self.view addSubview:just];
                        [just mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.left.equalTo(self.view.mas_left);
                            make.right.equalTo(self.view.mas_right);
                            make.bottom.equalTo(self.view.mas_bottom);
                            make.height.equalTo(@49);
                            
                        }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];

                    }else{
                    
                    if (!self.seeExitView) {
                        
                    
                    
                    self.seeExitView = [[[NSBundle mainBundle] loadNibNamed:@"SeeEextGoodsDetailView" owner:self options:nil]lastObject];
                    self.seeExitView.blockSeeExitChangeDetail  = ^(NSString *type)
                    {
                        if ([type isEqualToString:@"1"]) {
                            
                            
                            [self IntoExitChangeGoodsVC];
                        }else if([type isEqualToString:@"0"])
                        {
                             //客服
//                            [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                            self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
                            [self waitPaymentCustomService];
                            

                        }
                        
                    };
                    
                    [self.view addSubview:self.seeExitView];
                    [self.seeExitView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left);
                        make.right.equalTo(self.view.mas_right);
                        make.bottom.equalTo(self.view.mas_bottom);
                        make.height.equalTo(@49);
                        
                    }];
                        
                        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                        }];
                        
                        }
                    }
                }else
                {
                    //待收货
                    WaitAcceptGoodsBottomView  *acceptGoodsView = [[[NSBundle mainBundle]loadNibNamed:@"WaitAcceptGoodsBottomView" owner:nil options:nil] lastObject];
                    acceptGoodsView.blockWaitAcceptGoods = ^(NSInteger type)
                    {
                        if (type == 0) {
                            //客服
//                            [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                            self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
                            [self waitPaymentCustomService];
                            
                            
                        }else if (type == 1)
                        {
                                                        
                            //******************
                            //!待收货，进入选择申请类型的界面
                            ReturnViewController * returnSelectVC = [[ReturnViewController alloc]init];
                            returnSelectVC.orderDetailInfo = self.orderDetailInfo;
                            
                            [self.navigationController pushViewController:returnSelectVC animated:YES];

                            
                        }else if (type == 2)
                        {
                            [self deliverConfirmation];
                        }
                    };
                    [self.view addSubview:acceptGoodsView];
                    [acceptGoodsView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.view.mas_left);
                        make.right.equalTo(self.view.mas_right);
                        make.bottom.equalTo(self.view.mas_bottom);
                        make.height.equalTo(@49);
                        
                    }];
                    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.bottom.equalTo(self.view).offset(-49);
                    }];
                    

                }
                           }
            else
            {
                
                OrderCustomBtnView *orderCustom = [[[NSBundle mainBundle]loadNibNamed:@"OrderCustomBtnView" owner:nil options:nil] lastObject];
                
                [self.view addSubview:orderCustom];
                
                orderCustom.blockOrderCustomBtnView =  ^()
                {
//                        //客服
                    [self waitPaymentCustomService];
                    
//                        [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//                        self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
                    
                };

                [orderCustom mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom);
                    make.height.equalTo(@49);
                    
                }];

                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self.view.mas_bottom).offset(-49);
                }];

                
                
                if (self.stayDeliberBtn) {
                    self.stayDeliberBtn.hidden = YES;
                   
                    
                }
                if (self.waitPayBtn) {
                    self.waitPayBtn.hidden = YES;


                }
            }

            [self.tableView reloadData];
            
            
        } else {
            [self.view makeMessage:[NSString stringWithFormat:@"查询采购单详情失败, %@", [dic objectForKey:@"errorMessage"]]   duration:2.0f position:@"center"];
        }
        
        
        
        if (self.requestView) {
            [MBProgressHUD hideHUDForView:self.requestView animated:YES];
            
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        [self.requestView removeFromSuperview];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"网络连接异常"   duration:2.0f position:@"center"];
        

        
        if (self.requestView) {
            [MBProgressHUD hideHUDForView:self.requestView animated:YES];
            
        }else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        }
        [self.requestView removeFromSuperview];
        

        }];
}
//跳转到客服对话
- (void)enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString *)merchantNo {
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];

            
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            
            DebugLog(@"orderMerchantDic===%@", self.orderMerchantDic);
            
//            erWithName:(NSString *)name jid:(NSString *)receiverJid withMerchanNo:(NSString *)merchantNo withDic:(NSDictionary *)dtoDic
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:merchantName jid:jid withMerchanNo:merchantNo withDic:self.orderMerchantDic];
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

/**
 *  确认收货
 */
- (void)deliverConfirmation
{
    GUAAlertView *alertViwe = [GUAAlertView alertViewWithTitle:@"确定已收货？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForOrderReceived:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                //                [self.navigationController popViewControllerAnimated:YES];
                [self loadOrderDetailInfo];
                
                [self.view makeMessage:@"确认收货成功" duration:2.0f position:@"center"];
                
                //刷新上一页面的数据
                if (self.blockdetail) {
                    
                    self.blockdetail();
                    
                }
                
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


#pragma  mark - StayDeliverDelegate
/**
 *  确认收货
 */
- (void)StayDeliverConfirmation
{
    GUAAlertView *alertViwe = [GUAAlertView alertViewWithTitle:@"确定已收货？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForOrderReceived:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
//                [self.navigationController popViewControllerAnimated:YES];
                [self loadOrderDetailInfo];
                
                [self.view makeMessage:@"确认收货成功" duration:2.0f position:@"center"];
                
                //刷新上一页面的数据
                if (self.blockdetail) {
                    
                    self.blockdetail();
                    
                }
                
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
- (void)viewWillAppear:(BOOL)animated
{
    [self loadOrderDetailInfo];
    
}
#pragma mark - MyOrderParentTableViewDelegate
- (void)MyOrderParentClickCustomerService:(OrderInfoListDTO *)orderInfo
{
//    [self enquiryWithMerchantName:orderInfo.merchantName andMerchantNo:orderInfo.merchantNo];
//    self.orderMerchantDic = orderInfo.mj_keyValues;
//    
}

- (void)MyOrderParentClickCustomerServiceDetail:(OrderDetailDTO *)detailInfo
{
//    [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
//    self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;

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




#pragma Mark - WaitPaymentBtnView

/**
 *  付款
 */
- (void)waitPaymentConfirm
    {
    
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForMulitiConfirmPayOrderCodes:self.orderCode Success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            DebugLog(@"%@", dic);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([dic[@"code"]isEqualToString:@"000"]) {
                //            PayMulitiConfirmPayDTO *firmPayDto = [[PayMulitiConfirmPayDTO alloc] init];
                //            [firmPayDto setDictFrom:dic[@"code"]];
                OrderAddDTO *orderDto = [[OrderAddDTO alloc] init];
                [orderDto setDictFrom:dic[@"data"]];
                self.orderAddDTO = orderDto;
                if (orderDto.cannotPayOrdersArr.count>0) {
                    [self.view makeMessage:@"采购单内商品已失效或价格已变化采购单失效，请重新下单购买！" duration:2.0f position:@"center"];

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
}


/**
 *  取消采购单
 */
- (void)waitPaymentCancelOrder
{
    GUAAlertView *alert= [GUAAlertView alertViewWithTitle:@"确定取消采购单？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForOrderCancelUnpaid:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                //            [self.refreshHeader beginRefreshing];
//                [self.navigationController popViewControllerAnimated:YES];
                
                [self loadOrderDetailInfo];
                
                
                [self.view makeMessage:@"取消采购单成功"   duration:2.0f position:@"center"];
                if (self.blockdetail) {
                    
                    self.blockdetail();
                }
                
                
                
            } else {
                
                [self.view makeMessage:[NSString stringWithFormat:@"取消采购单失败, %@", [dic objectForKey:@"errorMessage"]]   duration:2.0f position:@"center"];
                
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.view makeMessage:@"网络连接异常"   duration:2.0f position:@"center"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
        

        
    } dismissAction:^{
        
    }];
    [alert show];
    
   }

/**
 *  客服
 */
- (void)waitPaymentCustomService
{
    if (!self.isChat) {
        //客服
        [self enquiryWithMerchantName:self.orderDetailInfo.merchantName andMerchantNo:self.orderDetailInfo.merchantNo];
        self.orderMerchantDic = self.orderDetailInfo.mj_keyValues;
        
        
    }else
    {
        if (self.blockMyOrderDetailChatMessage) {
        self.blockMyOrderDetailChatMessage(self.orderDetailInfo.mj_keyValues);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

//查看退换货详情
- (void)IntoExitChangeGoodsVC
{
    ExitChangeGoodsViewController *exitVC = [[ExitChangeGoodsViewController alloc] init];
    exitVC.orderCode = self.orderDetailInfo.orderCode;
    exitVC.detailDto = self.orderDetailInfo;
    
    [self.navigationController pushViewController:exitVC animated:YES];

}

/**
 *  计算字体的高度
 *
 *  @param str  内容
 *  @param font 字体大小
 *
 *  @return size:height/width
 */
- (CGSize)accordingContentFont:(NSString *)str fontSize:(CGFloat)font
{
    CGSize size;
    if (font==0) {
        font = 13;
        
    }
    CGFloat viewWidth  =    [UIScreen mainScreen].bounds.size.width - 98;
    
    size=[str boundingRectWithSize:CGSizeMake(viewWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}

- (void)refreshOrderList
{
    [self loadOrderDetailInfo];
    
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
/*
 
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
