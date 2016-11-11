//
//  CPSOrderDetailsViewController.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSOrderDetailsViewController.h"
#import "CSPOrderDetailsTableViewCell.h"
#import "CSPOrderDetailsBottomView.h"
#import "CPSGoodsDetailsViewController.h"
#import "GetOrderDetailDTO.h"
#import "orderGoodsItemDTO.h"
#import "CSPOrderInfoTableViewCell.h"
#import "UIImage+Compression.h"
#import "CPSOrderDetailsCollectionViewCell.h"
#import "CSPCustomSkuLabel.h"
#import "CPSGoodsDetailsPreviewViewController.h"
#import "UUImageAvatarBrowser.h"
#import "Masonry.h"
#import "CSPModifyPriceView.h"
#import "PhotoAndCamerSelectView.h"//!相机、相册选择view
#import "Masonry.h"

static CGFloat const orderDetailsBottomViewHeight = 49.0f;

@interface CPSOrderDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate,UIAlertViewDelegate ,CSPModifyPriceViewDelegate>

@property(nonatomic,strong)CSPOrderDetailsBottomView *orderDetailsBottomView;

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)UITableView *orderImgaeTableView;

@property(nonatomic,strong)GetOrderDetailDTO *getOrderDetailDTO;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;


@end

@implementation CPSOrderDetailsViewController{
    
    CGFloat _orderTimeLabelHeight;
    
    BOOL _isUploadSuccess;
    
    BOOL _isCancelSuccess;
    
    BOOL _isChangePriceSuccess;
    
    
    //存放快递单号
    NSMutableArray *_imageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    //设置导航返回按钮
    [self customBackBarButton];
    
    
    _imageArray = [[NSMutableArray alloc]init];
    
    //设置底部的视图
    [self initOrderDetailsBottomView];
    
    //显示订单信息
    [self initTableView];
    
    
    [self.view bringSubviewToFront:self.progressHUD];
    
    self.progressHUD.delegate = self;
    
    
    //请求数据
    [self requestOrderDetails];
    
    
    //!创建拍照发货 选择相册 相机的view
    [self initPhotoView];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self isHiddenNavigaitonBarButtomLine:YES];
    
    self.navigationController.navigationBar.translucent = NO;

    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    
}

#pragma mark-请求订单详情
- (void)requestOrderDetails{
    
    if (!_isCancelSuccess) {
        
        [self progressHUDShowWithString:@"加载中"];

    }
    
    
  
    DebugLog(@"^^^^^^^^^^^^^^^%@", self.orderCode );
    
    [HttpManager sendHttpRequestForGetOrderDetail:self.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (_isCancelSuccess) {
            
            _isCancelSuccess = NO;
        }
        if (_isChangePriceSuccess) {
            _isChangePriceSuccess = NO;
        }
        
        [self.progressHUD hide:YES];
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        if (responseDic.allKeys.count == 0) {
            return;
    
        }
        
        DebugLog(@"dic&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& = %@", responseDic);
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            id data = [responseDic objectForKey:@"data"];
            
            //判断数据的合法
            if ([self checkData:data class:[NSDictionary class]]) {
                
                self.getOrderDetailDTO = nil;
                
                self.getOrderDetailDTO = [[GetOrderDetailDTO alloc]init];
                
                [self.getOrderDetailDTO setDictFrom:data];
                
                
                
                id orderGoodsItemsData = [data objectForKey:@"orderGoodsItems"];
                
                
                
                    
                    self.orderStatus = [self.getOrderDetailDTO.status integerValue];
                    
                    [self initOrderDetailsBottomView];
                    
                    
            
                
                //检查数据
                if ([self checkData:orderGoodsItemsData class:[NSArray class]]) {
                    
                    for (NSDictionary *orderGoodsItemsDic in orderGoodsItemsData) {
                        
                        orderGoodsItemDTO *orderGoodsItem = [[orderGoodsItemDTO alloc]init];
                        
                        [orderGoodsItem setDictFrom:orderGoodsItemsDic];
                        
                        [self.getOrderDetailDTO.orderGoodsItemsList addObject:orderGoodsItem];
                        
                    }
                }
                
                [self.getOrderDetailDTO.orderDeliveryDTOList removeAllObjects];
                
                //orderDeliveryDTOList快递单图片列表
                id orderDeliveryData = [data objectForKey:@"orderDelivery"];
                
                if ([self checkData:orderDeliveryData class:[NSArray class]]) {
                    
                    for (NSDictionary *orderDeliveryDic in orderDeliveryData) {
                        
                        OrderDeliveryDTO *orderDeliveryDto = [[OrderDeliveryDTO alloc]init];
                        
                        [orderDeliveryDto setDictFrom:orderDeliveryDic];
                        
                        [self.getOrderDetailDTO.orderDeliveryDTOList addObject:orderDeliveryDto];
                    }
                }
            }
            
            //刷新数据
            [self.tableView reloadData];
            
        }else{
            
            [self alertViewWithTitle:@"加载失败" message:[responseDic objectForKey:ERRORMESSAGE]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _isCancelSuccess = NO;
        
        _isChangePriceSuccess  = NO;
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
}

/**
 *  显示底部的视图
 */
- (void)initOrderDetailsBottomView{
    //判断订单状态
    if (self.orderStatus == OrderStatusWaitDeliverGoods || self.orderStatus == OrderStatusAlreadyShipped || self.orderStatus == OrderStatusTransactionComplete||self.orderStatus == OrderStatusWaitPay){
        
        //待发货 、待收货、待完成
        NSInteger integer;
        
        if (self.orderStatus == OrderStatusWaitDeliverGoods) {
            integer = 1;
            
        }else if (self.orderStatus == OrderStatusAlreadyShipped){
            integer = 0;
        
        }else if (self.orderStatus == OrderStatusTransactionComplete){
            integer = 2;
        }else if (self.orderStatus == OrderStatusWaitPay){
            integer = 3;
            
        }
        
        if (self.orderDetailsBottomView) {
            [self.orderDetailsBottomView removeFromSuperview];
            
        }
        self.orderDetailsBottomView = [[[NSBundle mainBundle]loadNibNamed:@"CSPOrderDetailsBottomView" owner:self options:nil]objectAtIndex:integer];
        
        self.orderDetailsBottomView.frame = CGRectMake(0, self.view.frame.size.height-self.orderDetailsBottomView.frame.size.height, self.view.frame.size.width, self.orderDetailsBottomView.frame.size.height);
        
        __weak CPSOrderDetailsViewController *weakSelf = self;
        
        //功能（取消交易、拍照发货）
        self.orderDetailsBottomView.cancelDeliverGoodsButtonBlock = ^(){
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定取消交易?" message:@"与买家沟通退款后，可在此取消交易，此订单将不计入任何与销售相关的数据统计中。" delegate:weakSelf cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            [alertView show];
            
            
        };
        
        self.orderDetailsBottomView.changeOrderTotalPrice = ^()
        {
            
            
            __weak CSPModifyPriceView *modifyPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CSPModifyPriceView" owner:weakSelf options:nil]lastObject];
            modifyPriceView.requestType = @"delegate";
            
            modifyPriceView.delegate = weakSelf;
            
            [weakSelf.view addSubview:modifyPriceView];
            
            NSString *orderType;
            if (self.getOrderDetailDTO.status.intValue == 0) {
                orderType = @"【期货单】";
                
            }else
            {
                orderType = @"【现货单】";
            }
            modifyPriceView.titleLabel.text = [NSString stringWithFormat:@"%@    %@    %@",orderType,_getOrderDetailDTO.consigneeName,_getOrderDetailDTO.consigneePhone];
            
            
            
            modifyPriceView.originalTotalAmountLabel.text = [NSString stringWithFormat:@"订单总价：￥%@",[weakSelf transformationData:self.getOrderDetailDTO.originalTotalAmount]];
            
            
            
            modifyPriceView.frame = CGRectMake(0, 0, weakSelf.view.frame.size.width, weakSelf.view.frame.size.height);
            
            

            
        };
        
        self.orderDetailsBottomView.takephoneDeliverGoodsButtonBlock = ^(){
            
            
            weakSelf.blackAlphaView.hidden = NO;
            weakSelf.photoAndCamerSelectView.hidden = NO;
            
            [weakSelf.view bringSubviewToFront:weakSelf.blackAlphaView];
            [weakSelf.view bringSubviewToFront:weakSelf.photoAndCamerSelectView];

            /*
            //拍照发货
            //判断是否可以打开相机，模拟器此功能无法使用
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                UIImagePickerController *picker = [[UIImagePickerController alloc]init];
                
                picker.delegate = weakSelf;
                
                picker.allowsEditing = YES;  //是否可编辑
                //摄像头
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                [weakSelf presentViewController:picker animated:YES completion:^{
                }];
            }else{
                //如果没有提示用户
                [weakSelf alertViewWithTitle:@"提示" message:@"缺少摄像头"];
            }
            */
            
            
        };
        
        [self.view addSubview:self.orderDetailsBottomView];
    }
}

- (void)initTableView{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -1, self.view.frame.size.width, self.view.frame.size.height-self.orderDetailsBottomView.frame.size.height+1-64) style:UITableViewStyleGrouped ];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
    self.orderDetailsBottomView.frame = CGRectMake(0, self.view.frame.size.height-orderDetailsBottomViewHeight, self.view.frame.size.width, orderDetailsBottomViewHeight);
    
//    self.tableView.frame = CGRectMake(0,-1, self.view.frame.size.width, self.view.frame.size.height+1-self.orderDetailsBottomView.frame.size.height);
}

#pragma mark-UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.tableView) {
        return 2;
 
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        if (section == 0) {
            return 2;
        }else{
            return self.getOrderDetailDTO.orderGoodsItemsList.count+1;
        }
    }else{
        
        NSInteger row;
        
        if (self.getOrderDetailDTO.orderGoodsItemsList.count%2 == 0) {
            row = self.getOrderDetailDTO.orderDeliveryDTOList.count/2;
        }else{
            row = self.getOrderDetailDTO.orderDeliveryDTOList.count/2+1;
        }
        
        return row;
    }
}

- (UITableViewCell *)loadNibName:(NSString *)name index:(NSInteger)index{
    
   UITableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:name owner:self options:nil]objectAtIndex:index];
    
    if (cell) {
        return cell;
    }else{
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                CSPOrderDetailsTableViewCell * orderDetailsTableViewCell = (CSPOrderDetailsTableViewCell *)[self loadNibName:@"CSPOrderDetailsTableViewCell" index:0];
                
                NSString *payType;
                
                //订单状态(空为全部)0-订单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
                if (self.getOrderDetailDTO.status.integerValue == 0) {
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"订单取消";
                    
                    orderDetailsTableViewCell.contentView.backgroundColor = [UIColor lightGrayColor];
                    
                    orderDetailsTableViewCell.orderStateLabel.textColor = [UIColor lightGrayColor];
                    
                    orderDetailsTableViewCell.totalQuantityLabel.textColor = [UIColor lightGrayColor];
                    
                    payType = @"应付";
                    
                }else if (self.getOrderDetailDTO.status.integerValue == 1){
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"待付款";
                    
                    payType = @"应付";
                    
                }else if (self.getOrderDetailDTO.status.integerValue == 2){
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"未发货";
                    
                    payType = @"实付";
                    
                }else if (self.getOrderDetailDTO.status.integerValue == 3){
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"待收货";
                    
                    payType = @"实付";
                    
                }else if (self.getOrderDetailDTO.status.integerValue == 4){
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"交易取消";
                    
                    payType = @"实付";
                    
                    orderDetailsTableViewCell.contentView.backgroundColor = [UIColor lightGrayColor];
                    
//                    orderDetailsTableViewCell.orderCodeLabel.textColor = [UIColor lightGrayColor];
                    
//                    orderDetailsTableViewCell.totalQuantityLabel.textColor = [UIColor lightGrayColor];
                    
                }else if (self.getOrderDetailDTO.status.integerValue == 5){
                    
                    orderDetailsTableViewCell.orderStateLabel.text = @"交易完成";
                    
                    payType = @"实付";
                }
                
                //订单总数量
                orderDetailsTableViewCell.totalQuantityLabel.text = [NSString stringWithFormat:@"X%@",self.getOrderDetailDTO.quantity.stringValue];
                
                //应付、实付
                NSNumber *priceNum;
                if ([payType isEqualToString:@"实付"]) {
                    priceNum = self.getOrderDetailDTO.paidTotalAmount;
                    
                }else
                {
                    priceNum =  self.getOrderDetailDTO.totalAmount;
                }
                orderDetailsTableViewCell.totalAmoountLabel.text = [NSString stringWithFormat:@"%@：￥%@",payType,[self transformationData:priceNum]];
                
                //现货、期货
                //现货还是期货
                if (self.getOrderDetailDTO.type.integerValue == 1) {
                    //现货
                    orderDetailsTableViewCell.orderTypeLabel.text = @"现货单";
                    
                    orderDetailsTableViewCell.orderTypeBackgroundView.backgroundColor = HEX_COLOR(0x5677fcFF);
                    
                }else if (self.getOrderDetailDTO.type.integerValue == 0){
                    //期货
                    orderDetailsTableViewCell.orderTypeLabel.text = @"期货单";
                    
                    orderDetailsTableViewCell.orderTypeBackgroundView.backgroundColor = HEX_COLOR(0x673ab7FF);
                    
                }else{
                    orderDetailsTableViewCell.orderTypeLabel.text = @"未知";
                }
                
                //订单号
                orderDetailsTableViewCell.orderCodeLabel.text = [NSString stringWithFormat:@"订单号：%@",self.getOrderDetailDTO.orderCode];
                
                //订单原价
                orderDetailsTableViewCell.originalTotalAmountLabel.text = [NSString stringWithFormat:@"订单原价：￥%@",self.getOrderDetailDTO.originalTotalAmount.stringValue];
                
                return orderDetailsTableViewCell;
                
            }else if (indexPath.row == 1){
                
                CSPOrderDetailsTableViewCell *orderDetailsTableViewCell = (CSPOrderDetailsTableViewCell*)[self loadNibName:@"CSPOrderDetailsTableViewCell" index:1];
                
                orderDetailsTableViewCell.consigneeNameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.getOrderDetailDTO.consigneeName];
                
                orderDetailsTableViewCell.consigneePhone.text = self.getOrderDetailDTO.consigneePhone;
                
                //显示省市区
                orderDetailsTableViewCell.detailAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@", self.getOrderDetailDTO.provinceName, self.getOrderDetailDTO.cityName, self.getOrderDetailDTO.countyName, self.getOrderDetailDTO.detailAddress];
                
                return orderDetailsTableViewCell;
            }
            
        }else{
            
            if (indexPath.row != self.getOrderDetailDTO.orderGoodsItemsList.count) {
                
                CSPOrderInfoTableViewCell *orderInfoTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOrderInfoTableViewCellID2"];
                
                if (!orderInfoTableViewCell) {
                    
                    orderInfoTableViewCell = (CSPOrderInfoTableViewCell *)[self loadNibName:@"CSPOrderInfoTableViewCell" index:1];
                    
                }
                
                orderGoodsItemDTO *orderGoodsItem = [self.getOrderDetailDTO.orderGoodsItemsList objectAtIndex:indexPath.row];
                
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
                
                [subviewArray addObjectsFromArray:orderInfoTableViewCell.subviews];
                
                for (UIView *view in subviewArray) {
                    
                    if ([view isKindOfClass:[CSPCustomSkuLabel class]]) {
                        
                        [view removeFromSuperview];
                        
                    }
                }
                
                //然后在创建
                for (int i = 0; i<sizesArray.count; i++) {
                    
                    CSPCustomSkuLabel *customSkuLabel = [[CSPCustomSkuLabel alloc]initWithFrame:CGRectMake(lead+(i%2)*(width+interval), top+(i/2)*(interval + height), width, height)];
                    
                    NSString *skuStr = [sizesArray objectAtIndex:i];
                    
                    skuStr = [skuStr stringByReplacingOccurrencesOfString:@":" withString:@" x "];

                    customSkuLabel.text = skuStr;
                    
                    [orderInfoTableViewCell addSubview:customSkuLabel];
                    
                }

                
                //图片
                [orderInfoTableViewCell.swearImageView sd_setImageWithURL:[NSURL URLWithString:orderGoodsItem.picUrl] placeholderImage:[UIImage imageNamed:@""]];
                
                //商品名称
                orderInfoTableViewCell.swearTitleLabel.text = orderGoodsItem.goodsName;
                
                //颜色
                orderInfoTableViewCell.colorLabel.text = [NSString stringWithFormat:@"颜色：%@",orderGoodsItem.color];
                
                //价格
                orderInfoTableViewCell.priceLabel.text = [NSString stringWithFormat:@"￥%0.2lf",orderGoodsItem.price.doubleValue ];
                
                //数量
                orderInfoTableViewCell.amountText = [NSString stringWithFormat:@"x%lu",orderGoodsItem.quantity.integerValue];
                
                //共几件商品
                orderInfoTableViewCell.totalGoodsNumLabel.text = [NSString stringWithFormat:@"共%lu件商品",orderGoodsItem.quantity. integerValue];
                

                
                return orderInfoTableViewCell;
                
            }else{
                
                //下单时间等、快递单照片
                //拼接时间
                NSString *creatTime;
                
                if (self.getOrderDetailDTO.createTime.length<1) {
                    
                    creatTime = @"";
                    
                }else{
                    
                    creatTime = [NSString stringWithFormat:@"下单时间：%@\n\n",self.getOrderDetailDTO.createTime];
                }
                
                NSString *paymentTime;
                
                if (self.getOrderDetailDTO.paymentTime.length<1) {
                    paymentTime = @"";
                }else{
                    paymentTime = [NSString stringWithFormat:@"付款时间：%@\n\n",self.getOrderDetailDTO.paymentTime];
                }
                
                NSString *deliveryTime;
                
                if (self.getOrderDetailDTO.deliveryTime.length<1) {
                    deliveryTime = @"";
                }else{
                    deliveryTime = [NSString stringWithFormat:@"发货时间：%@\n\n",self.getOrderDetailDTO.deliveryTime];
                }
                
                NSString *receiveTime;
                
                if (self.getOrderDetailDTO.receiveTime.length<1) {
                    receiveTime = @"";
                }else{
                    receiveTime = [NSString stringWithFormat:@"收货时间：%@\n\n",self.getOrderDetailDTO.receiveTime];
                }
                
                NSString *orderCancelTime;
                if (self.getOrderDetailDTO.orderCancelTime.length<1) {
                    orderCancelTime = @"";
                }else{
                    orderCancelTime = [NSString stringWithFormat:@"订单取消时间：%@\n\n",self.getOrderDetailDTO.orderCancelTime];
                }
                
                NSString *dealCancelTime;
                
                if (self.getOrderDetailDTO.dealCancelTime.length<1) {
                    dealCancelTime = @"";
                }else{
                    dealCancelTime = [NSString stringWithFormat:@"交易取消时间：%@\n\n",self.getOrderDetailDTO.dealCancelTime];
                }
                
                NSString *orderTimeStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",creatTime,paymentTime,deliveryTime,receiveTime,orderCancelTime,dealCancelTime];
                
                //计算高度
                float leading = 15.0f;
                float trailing = 0.0f;
                float top = 8.0f;
                float width = self.view.frame.size.width-leading-trailing;
                
                NSDictionary *attributesDic = @{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:11],NSForegroundColorAttributeName:[UIColor blackColor]};
                
                NSAttributedString *locationAttributedString = [[NSAttributedString alloc] initWithString:orderTimeStr attributes:attributesDic];
                
                CGSize constraint = CGSizeMake(width, MAXFLOAT);
                
                CGRect rect = [locationAttributedString.string boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributesDic context:nil];
                
                _orderTimeLabelHeight = rect.size.height;
                
                
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellImage"];
                
                if (!cell) {
                    
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellImage"];
                    
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UILabel *orderTimeLabel = (UILabel *)[cell viewWithTag:101];
                
                [orderTimeLabel removeFromSuperview];
                    
                orderTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(leading, top, width, rect.size.height)];
                    
                orderTimeLabel.textColor = [UIColor blackColor];
                    
                orderTimeLabel.numberOfLines = 0;
                    
                orderTimeLabel.tag = 101;
                    
                orderTimeLabel.backgroundColor = [UIColor clearColor];
                    
                [cell addSubview:orderTimeLabel];
                    
                orderTimeLabel.attributedText = locationAttributedString;
                
                if (self.getOrderDetailDTO.orderDeliveryDTOList.count > 0) {
                    
                    //创建快递单照片
                    NSInteger orderImageRow;
                    
                    if (self.getOrderDetailDTO.orderDeliveryDTOList.count%2 == 0) {
                        orderImageRow = self.getOrderDetailDTO.orderDeliveryDTOList.count/2;
                    }else{
                        orderImageRow = self.getOrderDetailDTO.orderDeliveryDTOList.count/2+1;
                    }
                    
                    if ([cell viewWithTag:102]) {
                        
                        UIView *view = [cell viewWithTag:102];
                        
                        [view removeFromSuperview];
                    }
                    
                    UITableView *orderImageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, rect.size.height+8+10, self.view.frame.size.width, orderImageRow*(10+64))];
                    
                    _orderTimeLabelHeight = _orderTimeLabelHeight+orderImageTableView.frame.size.height;
                    
                    orderImageTableView.delegate = self;
                    
                    orderImageTableView.dataSource = self;
                    
                    orderImageTableView.scrollEnabled = NO;
                    
                    orderImageTableView.tag = 102;
                    
                    orderImageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                    
                    [cell addSubview:orderImageTableView];
                
                }
                
                return cell;
            }
        }
        
    }else{
        
        CSPOrderDetailsTableViewCell *orderDetailsTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOrderDetailsTableViewCellID1"];
        
        orderDetailsTableViewCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPOrderDetailsTableViewCell" owner:self options:nil]objectAtIndex:2];
        
        orderDetailsTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
//        if (!orderDetailsTableViewCell) {
//            
//            orderDetailsTableViewCell = [[[NSBundle mainBundle]loadNibNamed:@"CSPOrderDetailsTableViewCell" owner:self options:nil]objectAtIndex:2];
//            
//            orderDetailsTableViewCell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        }
//        
        
        for (int i = 0; i < self.getOrderDetailDTO.orderDeliveryDTOList.count; i++) {
            
            OrderDeliveryDTO * dto = [self.getOrderDetailDTO.orderDeliveryDTOList objectAtIndex:i];
            
            CGRect rect;
            
            if (i % 2 == 0) {
                rect = CGRectMake(15, (i / 2) * 10 + (i / 2) * 64, 120, 64);
            }else {
                rect = CGRectMake(155, (i / 2) * 10 + (i / 2) * 64, 120, 64);
            }
            
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:rect];
            imageView.tag = 1000 + i;
            [imageView sd_setImageWithURL:[NSURL URLWithString:dto.deliveryReceiptImage] placeholderImage:[UIImage imageNamed:@"goods_placeholder"]];
            
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClick:)];
            
            [imageView addGestureRecognizer:tap];
            
            [orderDetailsTableViewCell addSubview:imageView];
        }
 
        return orderDetailsTableViewCell;
    }

    return nil;
}

- (void)imageViewClick:(id)sender {
    
    UITapGestureRecognizer * tap = (UITapGestureRecognizer *)sender;
    [UUImageAvatarBrowser showImage:(UIImageView *)tap.view];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                return 142.0f;
                
            }else if (indexPath.row == 1){
                
                return 90.0f;
            }
            
        }else{
            
            if (indexPath.row != self.getOrderDetailDTO.orderGoodsItemsList.count) {
                
               orderGoodsItemDTO *orderGoodsItem = [self.getOrderDetailDTO.orderGoodsItemsList objectAtIndex:indexPath.row];
                
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

            }else{
                
                return _orderTimeLabelHeight + 18;
            }
        }
    }else{
        
        //创建快递单照片
        NSInteger orderImageRow;
        
        if (self.getOrderDetailDTO.orderDeliveryDTOList.count%2 == 0) {
            orderImageRow = self.getOrderDetailDTO.orderDeliveryDTOList.count/2;
        }else{
            orderImageRow = self.getOrderDetailDTO.orderDeliveryDTOList.count/2+1;
        }
        
        return 74 * orderImageRow + 1000;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        if (section == 0) {
            return 0.01f;
        }else{
            return 5.0f;
        }
    }else{
        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 5.0f;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section != 0) {
        
        if (indexPath.row != self.getOrderDetailDTO.orderGoodsItemsList.count) {
            
            orderGoodsItemDTO *orderGoodsItem = [self.getOrderDetailDTO.orderGoodsItemsList objectAtIndex:indexPath.row];
            
            //商品详情
            CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
                        
            goodsDetailsPreviewViewController.isPreview = NO;
            
            goodsDetailsPreviewViewController.goodsNo = orderGoodsItem.goodsNo;
            
            [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
            
        }
    }
}


#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //!隐藏相册选择的view 以及上半部分的灰色半透明部分
    [self hidePhotoSelectView];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0000001f);
        
        [self progressHUDShowWithString:@"上传中"];
        
        //上传图片
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"5" orderCode:self.orderCode goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            DebugLog(@"dic = %@", responseDic);
            
            if ([responseDic objectForKey:CODE]) {
                _isUploadSuccess = YES;
                
                [self progressHUDHiddenTipSuccessWithString:@"上传成功"];
                
                //上传成功以后请求订单
                if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailsChangeRequestDataName:)]) {
                    
                    [self.delegate orderDetailsChangeRequestDataName:@"photo"];
                    
                }
                
                [self requestOrderDetails];
            }else
            {
                [self.progressHUD hide:YES];
                
                [self alertViewWithTitle:@"上传失败" message:[responseDic objectForKey:ERRORMESSAGE]];
                
            }
            
            
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                DebugLog(@"***************OK************");
                
                
            }else{
                
                DebugLog(@"***************NO************");

                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self tipRequestFailureWithErrorCode:error.code];
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    //!隐藏相册选择的view 以及上半部分的灰色半透明部分
    [self hidePhotoSelectView];

    
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


#pragma mark-MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud{
    
    if (_isUploadSuccess) {
        
        _isUploadSuccess = NO;
        
        [self requestOrderDetails];
    }
    
    if (_isCancelSuccess) {
        
        [self requestOrderDetails];
    }
    
    if (_isChangePriceSuccess) {
        [self requestOrderDetails];
        
        
        
    }
}

#pragma mark-UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex) {
        //取消订单/取消交易
        [self progressHUDShowWithString:@"订单取消中"];
        
        //取消交易
        [HttpManager sendHttpRequestForGetCancelOrder:self.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            DebugLog(@"dic = %@", responseDic);
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                [self.orderDetailsBottomView removeFromSuperview];
                
                self.tableView.frame = CGRectMake(0, -1, self.view.frame.size.width, self.view.frame.size.height+1);
                
                _isCancelSuccess = YES;
                
                [self requestOrderDetails];
                
            }else{
                
                [self alertViewWithTitle:@"订单取消失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self tipRequestFailureWithErrorCode:error.code];
            
        }];
        
    }

}

#pragma mark -  CSPModifyPriceView delegate
//修改订单提示框的代理方法
- (void)cspModifyPricechangeOrderTotal:(UIView *)priceView
{
    
    CSPModifyPriceView *cspModify = (CSPModifyPriceView *)priceView;
    
    
    
    
    [self progressHUDShowWithString:@"修改中"];
    
    
    
    [HttpManager sendHttpRequestForGetModifyOrderAmount:self.getOrderDetailDTO.orderCode newAmount:cspModify.amoutTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSDictionary *responseDic = [self conversionWithData:responseObject];
        
        
        
        if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
            
            
            
            _isChangePriceSuccess = YES;

            //修改成功
            
            //修改完成以后请求订单
            if (self.delegate && [self.delegate respondsToSelector:@selector(orderDetailsChangeRequestDataName:)]) {
                
                [self.delegate orderDetailsChangeRequestDataName:@"price"];
                
            }

            
            [self progressHUDHiddenTipSuccessWithString:@"修改完成"];
            
            
            
        }else{
            
            
            
            [self.progressHUD hide:YES];
            
            
            
            [self alertViewWithTitle:@"获取失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
        [self tipRequestFailureWithErrorCode:error.code];
        
    }];
    

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
    
    __weak CPSOrderDetailsViewController * orderVC = self;
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
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    }];

    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
