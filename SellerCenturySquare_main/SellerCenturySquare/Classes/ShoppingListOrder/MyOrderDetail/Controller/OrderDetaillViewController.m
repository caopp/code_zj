//
//  OrderDetaillViewController.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/30.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDetaillViewController.h"

#import "ChatManager.h"


#import "CSPModifyPriceView.h"//!修改采购单价格view
#import "PhotoAndCamerSelectView.h"//!拍照发货的view
#import "Masonry.h"

#import "ExpressDeliverViewController.h"//!拍摄快递单发货
#import "CourierViewController.h"//!物流查询界面
#import "CPSGoodsDetailsPreviewViewController.h"//! 商品详情
#import "CPSPostageViewController.h"//!邮费专拍
#import "ConversationWindowViewController.h" //聊天
#import "ExitChangeGoodsViewController.h"//退换货详情

@interface OrderDetaillViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>


//!拍照发货
//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;
/**
 *  聊天数据
 */
@property (nonatomic ,strong) NSDictionary *orderMerchantDic;

//!待付款时：修改的价格
@property(nonatomic,copy)NSString * changePriceStr;

//!将要出现的时候刷新界面，如果是从相册回来就不需要刷新了
@property(nonatomic,assign)BOOL backFromPhoto;


@end


@implementation OrderDetaillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!创建导航
    [self createNav];
    
    //!创建界面
    [self createUI];
    

}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    if (self.backFromPhoto) {
        
        self.backFromPhoto = NO;
        return;
    }else{
    
        //!请求数据
        [self requeOrderDeatil];
    
    }
    
    
}
#pragma mark 创建导航
-(void)createNav{

    [self customBackBarButton];

    self.title = @"采购单详情";
    
    [self.view setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
    
}
#pragma mark 创建界面
-(void)createUI{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    //!创建拍照发货 选择相册 相机的view
    [self initPhotoView];
    
}
//!请求数据回来之后，创建底部发bottom
-(void)makeBottom{

    //采购单状态（类型:int)(0-采购单取消;1-待付款;2-未发货;3-待收货;4-交易取消;5-已签收)
    int orderStatusInt  = [orderStatus intValue];
    
    if (orderStatusInt !=  1 && orderStatusInt != 2 && orderStatusInt != 3) {//!不是以下情况就返回
        
        return ;
    }
    
    
    [obligationBottomView removeFromSuperview];
    [waitCommitBottomView removeFromSuperview];
    [waitTakeBottomView removeFromSuperview];
    [refundDeailBottomView removeFromSuperview];
    
    __weak OrderDetaillViewController * vc = self;
    //!订单提交退换货申请、并且没有取消申请
    if ([self isApplyRefund]) {
    
        refundDeailBottomView = [[[NSBundle mainBundle]loadNibNamed:@"RefundDeailBottomView" owner:nil options:nil]lastObject];
        
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - refundDeailBottomView.frame.size.height);
        
        refundDeailBottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) , self.view.frame.size.width, refundDeailBottomView.frame.size.height);
        
        [self.view addSubview:refundDeailBottomView];

        //!查看退换货详情
        refundDeailBottomView.toSeeRefundDeatilBlock = ^(){
            ExitChangeGoodsViewController *exitChangeVC = [[ExitChangeGoodsViewController alloc] init];
            exitChangeVC.orderCode = detailDTO.orderCode;
            exitChangeVC.orderStatus =detailDTO.status;
            
            
            exitChangeVC.detailDto = detailDTO;
            [vc.navigationController pushViewController:exitChangeVC animated:YES];
            
        
        };
        
        return ;
        
    }
    
    
    //!改变tablView的高度
    if (orderStatusInt == 1) {//!待付款
        
        obligationBottomView = [[[NSBundle mainBundle]loadNibNamed:@"DetailObligationBottomView" owner:nil options:nil]lastObject];
        
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - obligationBottomView.frame.size.height);

        obligationBottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) , self.view.frame.size.width, obligationBottomView.frame.size.height);
        
        [self.view addSubview:obligationBottomView];
        
        //!修改采购单价格
        obligationBottomView.changePriceBlock = ^(){
            
            [vc changePrice];
        
        };
        
        
    }else if (orderStatusInt == 2){//!待发货
    
        waitCommitBottomView = [[[NSBundle mainBundle]loadNibNamed:@"DetailWaitCommitBottomView" owner:nil options:nil]lastObject];
        
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - waitCommitBottomView.frame.size.height);

        waitCommitBottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) , self.view.frame.size.width, waitCommitBottomView.frame.size.height);
        
        [self.view addSubview:waitCommitBottomView];

        //!拍照发货
        waitCommitBottomView.takePhotoSenedBlock = ^(){
        
            [vc takePhotoSendGoods];
        };
        
        //!录入快递单发货
        waitCommitBottomView.takeExpressSendBlock = ^(){
        
            [vc takeExpressSendGoods];
            
        };
        
    }else if (orderStatusInt == 3){//!待收货
    
        waitTakeBottomView = [[[NSBundle mainBundle]loadNibNamed:@"DetailWaitTakeBottomView" owner:nil options:nil]lastObject];

        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - waitTakeBottomView.frame.size.height);

        waitTakeBottomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) , self.view.frame.size.width, waitTakeBottomView.frame.size.height);
        
        [self.view addSubview:waitTakeBottomView];
        
        //!拍照发货
        waitTakeBottomView.takePhotoSenedBlock = ^(){
            
            [vc takePhotoSendGoods];

        };
        
        //!录入快递单发货
        waitTakeBottomView.takeExpressSendBlock = ^(){
            
            [vc takeExpressSendGoods];
            
        };
        


    }
    

}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;//!一段是商品的、一段 是发货信息的
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    if (section == 1) {//!发货信息段
        
        UIView * sectionTwoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 9)];
        
        [sectionTwoView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
        
        return sectionTwoView;
        
    }
    
    if (!headerView) {
        
        headerView = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailHeaderView" owner:nil options:nil]lastObject];
        
        __weak OrderDetaillViewController * detailVC = self;
        //!客服按钮
        headerView.customBtnClickBlock = ^(){
        
            [detailVC customService];
        
        };
        
    }
    [headerView configData:detailDTO];
    
   
    return headerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    if (section == 1) {//!发货信息段
        
        return 9;
        
    }
    
    return [self addressHeaderViewHight];//!收货地址headerView的高度

    
}
//!收货地址headerView的高度
-(CGFloat)addressHeaderViewHight{

    //!计算收货地址的高度
    CGSize addressSize = [detailDTO.detailAddress boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 15 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    //!271、246
    BOOL showOldPayView = [headerView showOldPayView:detailDTO];
    CGFloat showHight = 0;
    
    if (showOldPayView) {//!判断是否显示“原交易金额”这一行
        
        showHight = 293 - 21 + addressSize.height;//!xib高度 - 地址在xib中的高度 + 地址实际高度
    }else{
        
        showHight = 268 - 21 + addressSize.height;//!xib高度 - 地址在xib中的高度 + 地址实际高度
        
    }
    
    
    return showHight;


}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    return footerView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.00001;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{


    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
    }
    if (indexPath.section == 0) {//!商品信息段
        
        if (detailDTO.goodsList.count > 0) {
            
            return [self goodsTableViewCell:indexPath isFremRetail:NO];
        }
        
    }else{//!发货信息
    
        return [self alertTableViewCell:indexPath];
        
    }
    
    
    
    return cell;

}
//!商品信息cell isFromRetail:是否是零售
-(UITableViewCell *)goodsTableViewCell:(NSIndexPath *)indexPath isFremRetail:(BOOL)isFromRetail{

    orderGoodsItemDTO * goodsDTO = detailDTO.goodsList[indexPath.row];
    
    if ([goodsDTO.cartType isEqualToString:@"1"]) {//!样板
        
        OrderDetailSampleCell * sampleCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSampleCell" owner:nil options:nil]lastObject];
        
        [sampleCell configData:goodsDTO];
        
        //!如果是最后商品信息的最后一行，分割线不显示
        if (indexPath.row == detailDTO.goodsList.count -1) {
            
            sampleCell.filterLabel.hidden = YES;
            
        }else{
            
            sampleCell.filterLabel.hidden = NO;
            
        }
        
        return sampleCell;
        
    }else{
        
        OrderDeatiGoodsViewCell *  detailGoodsViewCell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDeatiGoodsViewCell" owner:nil options:nil]lastObject];
        
        [detailGoodsViewCell configData:goodsDTO isRetail:isFromRetail];
        
        //!如果是最后商品信息的最后一行，分割线不显示
        if (indexPath.row == detailDTO.goodsList.count -1) {
            
            detailGoodsViewCell.filterLabel.hidden = YES;
        }else{
            
            detailGoodsViewCell.filterLabel.hidden = NO;
            
        }
        return detailGoodsViewCell;
        
    }


}

//!提醒信息、发货信息cell
-(UITableViewCell *)alertTableViewCell:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//!显示信息
        
        DeliverAlertViewCell * alertCell = [[[NSBundle mainBundle]loadNibNamed:@"DeliverAlertViewCell" owner:nil options:nil]lastObject];
        alertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * showStr = [self sectionTwoFirstCellText];
        alertCell.alertLabel.text = showStr;
        
        if ([orderStatus intValue] == 3 && ![self isApplyRefund]) {//!待收货时，没有提交了退换货申请：显示"自动确认收货时间" 并且红色显示，所以需要对字体颜色进行处理 ;
            
            alertCell.alertLabel.text = nil;
            
            alertCell.alertLabel.attributedText = [self waitTakeAlertText];
            
        }
        
        return alertCell;
        
        
        
    }else if(([orderStatus intValue] == 4 && indexPath.row == returnRow - 1 ) || ([orderStatus intValue] == 5 && indexPath.row == returnRow -1 )){//!4-交易取消; 5-已签收 的时候，如果是这两种情况 并且是最后一行，显示提示信息
        
        DeliverAlertViewCell * alertCell = [[[NSBundle mainBundle]loadNibNamed:@"DeliverAlertViewCell" owner:nil options:nil]lastObject];
        alertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * showStr = [self sectionTwoLastText];
        alertCell.alertLabel.text = showStr;
        
        
        return alertCell;
        
        
    }else if ([self isApplyRefundWitTakeInfo] && indexPath.row == returnRow - 1){//!申请退换货，中间有发货信息行，把申请退换货的时间显示出来
        
        DeliverAlertViewCell * alertCell = [[[NSBundle mainBundle]loadNibNamed:@"DeliverAlertViewCell" owner:nil options:nil]lastObject];
        alertCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSString * showStr = [self showApplyTime];
        alertCell.alertLabel.text = showStr;
        
        return alertCell;
        
        
    }else{
        
        OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[indexPath.row - 1];
        //1拍照发货，2快递单号发货
        if ([deliverDTO.type intValue] == 1) {
            
            PhotoDeliverViewCell * photoCell = [[[NSBundle mainBundle]loadNibNamed:@"PhotoDeliverViewCell" owner:nil options:nil]lastObject];
            [photoCell configData:deliverDTO withNum:indexPath.row - 1];
            
            return photoCell;
            
            
        }else{
            
            ExpressDeliverViewCell * expressCell = [[[NSBundle mainBundle]loadNibNamed:@"ExpressDeliverViewCell" owner:nil options:nil]lastObject];
            
            [expressCell configData:deliverDTO withNum:indexPath.row - 1];
            
            
            return expressCell;
            
        }
        
        
    }




}

-(NSMutableAttributedString *)waitTakeAlertText{

    //!1、自动确认收货时间
    NSMutableAttributedString * autoStr = [[NSMutableAttributedString alloc]initWithString:@"自动确认收货时间:" attributes:
                                               @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999 alpha:1],
                                                 NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    NSMutableAttributedString * timeStr = [[NSMutableAttributedString alloc]initWithString:detailDTO.confirmRemainingTime  attributes:@{NSForegroundColorAttributeName: [UIColor colorWithHex:0xef6c64 alpha:1],
                                                                                                                                           NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    [autoStr appendAttributedString:timeStr];

    //2、其他部分
    //下单时间
    NSString * putTimeStr = [NSString stringWithFormat:@"\n下单时间：%@",detailDTO.createTime];
    //!付款时间
    NSString * payTimeStr = [NSString stringWithFormat:@"\n付款时间：%@",detailDTO.paymentTime];
    
    //!发货时间
    //!发货时间
    NSString * sendOutTimeStr = @"";
    if (detailDTO && detailDTO.orderDeliveryDTOList.count) {
        
        OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[0];
        
        sendOutTimeStr = [NSString stringWithFormat:@"\n发货时间：%@",deliverDTO.createTime];
        
    }
    
    
    NSString * nextStr = [NSString stringWithFormat:@"%@%@%@",putTimeStr,payTimeStr,sendOutTimeStr];
    
    //!提交退换货申请，没有取消申请，并且没有发货信息行要显示（则tableView行数不变，在第0行添加上申请退货的信息）
    if ([self isApplyRefundNoTakeInfo]) {
        
        
        nextStr = [NSString stringWithFormat:@"%@\n%@",nextStr,[self showApplyTime]];
        
    }
    
    NSMutableAttributedString * nextAttStr = [[NSMutableAttributedString alloc]initWithString:nextStr attributes:
                                           @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x999999 alpha:1],
                                             NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    //!拼接
    [autoStr appendAttributedString:nextAttStr];
    
    return autoStr;
    

}

//!批发是：采购单取消时间  零售是：订单取消时间
-(NSString *)getCanacelStr{

    return @"采购单取消时间：";
    
}

-(NSString *)sectionTwoFirstCellText{

    if (detailDTO == nil) {
        
        return @"";
    }
    
    NSString * showText;
    //(0-采购单取消;1-待付款;2-未发货;3-待收货;4-交易取消;5-已签收)
    switch ([orderStatus intValue]) {
        case 0://!采购单取消
        {
            //下单时间
            NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@",detailDTO.createTime];
            
            //采购单取消时间
            NSString * cancleTimeStr = [NSString stringWithFormat:@"\n%@%@",[self getCanacelStr],detailDTO.orderCancelTime];
            
            showText = [NSString stringWithFormat:@"%@%@",putTimeStr,cancleTimeStr];
            
        }
            break;
            
        case 1://!待付款
        {
            
            //下单时间
            NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@",detailDTO.createTime];
            
            showText = putTimeStr;
            
        }
            break;
        case 2://!待发货
        {
            //下单时间
            NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@",detailDTO.createTime];
            //!付款时间
            NSString * payTimeStr = [NSString stringWithFormat:@"\n付款时间：%@",detailDTO.paymentTime];
            
            showText = [NSString stringWithFormat:@"%@%@",putTimeStr,payTimeStr];

        }
            break;
        case 3:{//!待收货
            
            //!自动确认收货时间
            NSString * autoTimeStr = [NSString stringWithFormat:@"自动确认收货时间：还剩%@\n",detailDTO.confirmRemainingTime];
            
            showText = [NSString stringWithFormat:@"%@%@",autoTimeStr,[self waitTakeOtherTime]];
            

        }
            break;
        case 4://!交易取消
        {
            //下单时间
            NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@",detailDTO.createTime];
            //!付款时间
            NSString * payTimeStr = [NSString stringWithFormat:@"\n付款时间：%@",detailDTO.paymentTime];
            
            //!发货时间
            NSString * sendOutTimeStr = @"";
            if (detailDTO && detailDTO.orderDeliveryDTOList.count) {
                
                OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[0];
                
                sendOutTimeStr = [NSString stringWithFormat:@"\n发货时间：%@",deliverDTO.createTime];
                
                
            }
            
            showText = [NSString stringWithFormat:@"%@%@%@",putTimeStr,payTimeStr,sendOutTimeStr];
        
        }
            break;
        
        case 5://!已签收、交易完成
        {
            
            //下单时间
            NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@",detailDTO.createTime];
            //!付款时间
            NSString * payTimeStr = [NSString stringWithFormat:@"\n付款时间：%@",detailDTO.paymentTime];
            //!发货时间
            NSString * sendOutTimeStr = @"";
            if (detailDTO && detailDTO.orderDeliveryDTOList.count) {
                
                OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[0];
                
                sendOutTimeStr = [NSString stringWithFormat:@"\n发货时间：%@",deliverDTO.createTime];
                
                
            }
            showText = [NSString stringWithFormat:@"%@%@%@",putTimeStr,payTimeStr,sendOutTimeStr];

            
        }
            break;
        default:
            break;
    }
    
    /*
     提交退换货申请：
      未发货：下单时间、付款时间、+申请时间（前面判断给出的字符串满足）
      已发货：下单时间、付款时间、发货时间、
     */
    
    if ([self isApplyRefund] && [orderStatus intValue] == 3) {//!已发货
        
        showText = [self waitTakeOtherTime];
        
    }
    
    //!提交退换货申请，没有取消申请，并且没有发货信息行要显示（则tableView行数不变，在第0行添加上申请退货的信息）
    if ([self isApplyRefundNoTakeInfo]) {
        
    
        showText = [NSString stringWithFormat:@"%@\n%@",showText,[self showApplyTime]];
        
        
    }

    
    return showText;
    
}
//!待收货状态 除去“自动确认收货时间”的其他时间
-(NSString *)waitTakeOtherTime{

    //下单时间
    NSString * putTimeStr = [NSString stringWithFormat:@"下单时间：%@\n",detailDTO.createTime];
    //!付款时间
    NSString * payTimeStr = [NSString stringWithFormat:@"付款时间：%@\n",detailDTO.paymentTime];
    
    //!发货时间
    NSString * sendOutTimeStr = @"";
    if (detailDTO && detailDTO.orderDeliveryDTOList.count) {
        
        OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[0];
        
        sendOutTimeStr = [NSString stringWithFormat:@"发货时间：%@",deliverDTO.createTime];
        
    }
    
    return [NSString stringWithFormat:@"%@%@%@",putTimeStr,payTimeStr,sendOutTimeStr];
    
    

}


//!4-交易取消; 5-已签收 时 第二段最后一行的 信息
-(NSString *)sectionTwoLastText{
    
    NSString * showText;
    
    if ([orderStatus intValue] == 4) {
        
        NSString * getTimeStr = [NSString stringWithFormat:@"收货时间：%@",detailDTO.receiveTime];
        NSString * dealCancelTimeStr = [NSString stringWithFormat:@"\n交易取消时间：%@",detailDTO.dealCancelTime];
        
        showText = [NSString stringWithFormat:@"%@%@",getTimeStr,dealCancelTimeStr];
        
    }else{
    
        NSString * getTimeStr = [NSString stringWithFormat:@"收货时间：%@",detailDTO.receiveTime];
        showText = [NSString stringWithFormat:@"%@",getTimeStr];
    
    }
      return showText;
    
}
//!提交申请的时间显示
-(NSString *)showApplyTime{

    NSMutableString * showText = [NSMutableString stringWithFormat:@""];

    [showText appendString:[NSString stringWithFormat:@"退换货申请时间：%@",detailDTO.refundCreateTime]];
    
    if (![detailDTO.refundDealTime isEqualToString:@""]) {
        
        [showText appendString:[NSString stringWithFormat:@"\n处理完成时间：%@",detailDTO.refundDealTime]];
    }
    
    
    return showText;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 ) {//!商品信息段
        
        return [self goodsCellHight:indexPath];
        
    }else{//!发货信息
    
        return [self alertCellHight:indexPath];
    
    }
    
    return 100;


}
//!提示信息行的高度
-(CGFloat)alertCellHight:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {//!信息行
        
        CGSize showSize = [[self sectionTwoFirstCellText] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;
        
        return showSize.height + 20;//!20是让文字距离cell的上下有距离
        
    }else if(([orderStatus intValue] == 4 && indexPath.row == detailDTO.orderDeliveryDTOList.count +1 ) || ([orderStatus intValue] == 5 && indexPath.row == detailDTO.orderDeliveryDTOList.count +1 )){//!4-交易取消; 5-已签收 的时候 有count +2 行，如果是这两种情况 并且是最后一行，显示提示信息
        
        CGSize showSize = [[self sectionTwoLastText] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;
        
        return showSize.height + 20;//!20是让文字距离cell的上下有距离
        
    }else if ([self isApplyRefundWitTakeInfo] && indexPath.row == returnRow - 1){//!申请退换货，中间有发货信息行，把申请退换货的时间显示出来
        
        CGSize showSize = [[self showApplyTime] boundingRectWithSize:CGSizeMake(self.view.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:12]} context:nil].size;
        
        return showSize.height + 20;//!20是让文字距离cell的上下有距离
        
        
    }
    
    //!其他行
    OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[indexPath.row - 1];
    //1拍照发货，2快递单号发货
    if ([deliverDTO.type intValue] == 1) {
        
        if (indexPath.row == 1) {//!第一行不显示时间，要把时间部分的高度去掉
            
            return 115 - 37;
        }
        
        return 115;
        
    }else{
        
        if (indexPath.row == 1) {//!第一行不显示时间，要把时间部分的高度去掉
            
            return 80 - 37;
        }
        
        return 80;
    }


}

//!商品cell的高度
-(CGFloat)goodsCellHight:(NSIndexPath *)indexPath{

    orderGoodsItemDTO * goodsDTO = detailDTO.goodsList[indexPath.row];
    
    if ([goodsDTO.cartType isEqualToString:@"0"]) {//!普通商品 需要计算尺寸地方的高度
        
        CGFloat hight = 87 - 20 ;
        
        hight = hight + [self goodsSizeHight:goodsDTO];
        
        return hight;
        
    }else{//!样板、邮费
        
        return 87;
    }

}

//!商品信息尺码的高度
-(CGFloat)goodsSizeHight:(orderGoodsItemDTO *)orderGoodsItemDTO{

    //!组合出尺码数组
    NSArray * sizeArray = [orderGoodsItemDTO.sizes componentsSeparatedByString:@","];
    NSMutableArray * finallySizeArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSString * sizeStr in sizeArray) {
        
        NSArray * sizeNewStrArray = [sizeStr componentsSeparatedByString:@":"];
        
        NSString * sizeNewStr = [NSString stringWithFormat:@"%@x%@",sizeNewStrArray[0],sizeNewStrArray[1]];
        
        [finallySizeArray addObject:sizeNewStr];
        
    }
    
    float sizeWidth = SCREEN_WIDTH - 15 - 60 - 15 - 45 - 50;
    float labelHight = 15;

    //!创建尺码
    CGRect sizeRect;
    
    for (int i = 0; i < finallySizeArray.count; i++) {
        
        CGRect rect = CGRectMake(0, 0, 0, 0);
        
        //!计算大小
        CGSize labelSize = [self showSize:finallySizeArray[i]];
        if (i == 0) {
            
            rect = CGRectMake(0, 0, labelSize.width +15, labelHight);
            
        }else{
            
            rect = CGRectMake(CGRectGetMaxX(sizeRect) + 10, sizeRect.origin.y, labelSize.width + 15, labelHight);
            
        }
        
        //!重启一行
        if (CGRectGetMaxX(rect) > sizeWidth) {
            
            rect = CGRectMake(0, CGRectGetMaxY(sizeRect) + 5, labelSize.width + 15, labelHight);
        }
                
        sizeRect = rect;
        
    }

    return CGRectGetMaxY(sizeRect);
    
    
}
-(CGSize )showSize:(NSString *)price{
    
    float sizeWidth = SCREEN_WIDTH - 15 - 60 - 15 - 45 - 50;

    CGSize showSize = [price boundingRectWithSize:CGSizeMake(sizeWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return showSize;
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (section == 1) {//!发货信息段
        
        return [self alertRowNum];
        
    }else{
        
        
        return detailDTO.goodsList.count;
        
    }
    
}
//!发货信息段的行数
-(NSInteger)alertRowNum{

    //!交易完成、交易取消 发货数据的上下都有 提示显示 +2行
    
    //!其他情况 只有 上面有提示显示 +1行
    
    //采购单状态（类型:int)(0-采购单取消;1-待付款;2-未发货;3-待收货; 4-交易取消; 5-已签收)
    returnRow = 0;
    
    if ([orderStatus intValue] == 5 || [orderStatus intValue] == 4 ) {
        
        returnRow =  detailDTO.orderDeliveryDTOList.count +2;
        
    }else{
        
        returnRow =  detailDTO.orderDeliveryDTOList.count +1;
        
    }
    
    //!判断，如果 提交退换货申请，没有取消申请，并且有商品信息行要显示 就+1行
    if ([self isApplyRefundWitTakeInfo]) {
        
        returnRow = returnRow +1;
    }
    
    return returnRow;

    

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    //!去除选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell * selectCell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //!是点击物流查询才进行跳转
    if ([selectCell isKindOfClass:[ExpressDeliverViewCell class]]) {
        
        OrderDeliveryDTO * deliverDTO =  detailDTO.orderDeliveryDTOList[indexPath.row - 1];
        //1拍照发货，2快递单号发货
        if ([deliverDTO.type intValue] == 2) {
            
            CourierViewController * courierVC = [[CourierViewController alloc]init];
            courierVC.expressCompanyCode = deliverDTO.logisticCode;//!快递公司代码
            courierVC.expressNO = deliverDTO.logisticTrackNo;//!快递单号
            courierVC.CourierName = deliverDTO.logisticName;//快递公司的名字
            [self.navigationController pushViewController:courierVC animated:YES];
            
        }
    
        
    }else if ([selectCell isKindOfClass:[OrderDeatiGoodsViewCell class]]){//!商品详情进行的跳转
    
    
        orderGoodsItemDTO * goodsDTO = detailDTO.goodsList[indexPath.row];
       
        //!0普通商品 , 1样板商品 2邮费专拍
        if ([goodsDTO.cartType isEqualToString:@"0"] || [goodsDTO.cartType isEqualToString:@"1"]) {
            
            //商品详情
            CPSGoodsDetailsPreviewViewController *goodsDetailsPreviewViewController = [[CPSGoodsDetailsPreviewViewController alloc]init];
            
            goodsDetailsPreviewViewController.isPreview = NO;
            goodsDetailsPreviewViewController.noGoodsListView = YES;
            goodsDetailsPreviewViewController.goodsNo = goodsDTO.goodsNo;
            
            [self.navigationController pushViewController:goodsDetailsPreviewViewController animated:YES];
            
        
        }else{
        
            
            CPSPostageViewController *postageInfo = [[CPSPostageViewController alloc]init];
            
            [self.navigationController pushViewController:postageInfo animated:YES];
            
        
        }
       
    
    
    }
    
  

}

#pragma mark 请求采购单详情的数据
-(void)requeOrderDeatil{


    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForGetOrderDetail:self.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];

        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            detailDTO = [[GetOrderDetailDTO alloc]initWithDictionary:dic[@"data"]];
            orderStatus = detailDTO.status;
            
            [_tableView reloadData];
            
            //!创建底部的view
            [self makeBottom];
        
            
        }else{
        
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        [MBProgressHUD hideHUDForView:self.view  animated:YES];

        [self.view makeMessage:webErrorAlert duration:2.0 position:@"center"];

        
    }];



}

#pragma mark 待付款 --修改采购单价格
-(void)changePrice{

    __weak CSPModifyPriceView *modifyPriceView = [[[NSBundle mainBundle]loadNibNamed:@"CSPModifyPriceView" owner:self options:nil]lastObject];
    modifyPriceView.requestType = @"block";
    
    //!(0-期货 ;1-现货)
    NSString * orderType;
    if ([detailDTO.type intValue] == 0) {
        
        orderType = @"【现货单】";
    }else{
        
        orderType = @"【现货单】";
    }
    modifyPriceView.titleLabel.text = [NSString stringWithFormat:@"%@    %@    %@",orderType,detailDTO.consigneeName,detailDTO.consigneePhone];
    
    modifyPriceView.originalTotalAmountLabel.text = [NSString stringWithFormat:@"采购单总价：￥%.2f",[detailDTO.originalTotalAmount doubleValue] ];
    
    modifyPriceView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    modifyPriceView.requestType = @"block";
    
    
    
    modifyPriceView.confirmBlock = ^(){
        
        
        //!记录下修改后的价格
        self.changePriceStr = modifyPriceView.amoutTextField.text;

        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForGetModifyOrderAmount:detailDTO.orderCode newAmount:modifyPriceView.amoutTextField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];

            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                //!重新请求采购单
                [self requeOrderDeatil];
                
                //!修改成功，调用block，让列表改变
                if (self.changeTotalCountBlock) {
                    
                    //采购单状态（类型:int)(0-采购单取消; 1-待付款;2-未发货; 3-待收货;4-交易取消;5-已签收)
                    NSString * orderStaturStr = [NSString stringWithFormat:@"%@",orderStatus];
                    
                    
                    self.changeTotalCountBlock(detailDTO.orderCode ,orderStaturStr,self.changePriceStr);
                    
                }
                

                
            }else{
                
                [self.view makeMessage:@"修改价钱失败" duration:2.0 position:@"center"];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
            
            
        }];
        
        
    };
    
    [self.view addSubview:modifyPriceView];



}
#pragma mark  待发货 时 发货成功，调用block刷新采购单列表
-(void)toRefreshOrderList{

    //采购单状态（类型:int)(0-采购单取消; 1-待付款;2-未发货; 3-待收货;4-交易取消;5-已签收)
    NSString * orderStaturStr = [NSString stringWithFormat:@"%@",orderStatus];

    
    if (self.deliverGoodsInWaitStatusBlock && [orderStaturStr isEqualToString:@"2"]) {
        
        self.deliverGoodsInWaitStatusBlock(detailDTO.orderCode,orderStaturStr);
        
    }
    

}
#pragma mark 拍照发货
-(void)takePhotoSendGoods{
    
    
    //!显示选择的view
    self.blackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    
    [self.view bringSubviewToFront:self.blackAlphaView];
    [self.view bringSubviewToFront:self.photoAndCamerSelectView];
    
}
//!创建拍照发货 选择相册 相机的view
-(void)initPhotoView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 ;//!50是底部的高度
    float selectHight = 106;
    
    //!透明的view
    self.blackAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight - selectHight)];
    
    [self.blackAlphaView setBackgroundColor:[UIColor colorWithHexValue:0x000000 alpha:0.25]];
    [self.view addSubview:self.blackAlphaView];
    
    
    UITapGestureRecognizer * selectHideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePhotoSelectView)];
    [self.blackAlphaView addGestureRecognizer:selectHideTap];
    
    
    //!相册选择的view
    self.photoAndCamerSelectView= [[[NSBundle mainBundle]loadNibNamed:@"PhotoAndCamerSelectView" owner:self options:nil]lastObject];
    [self.photoAndCamerSelectView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.photoAndCamerSelectView];
    
    [self.photoAndCamerSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.blackAlphaView.mas_bottom);
//        make.bottom.equalTo(@50);//!50是底部的高度
        make.height.equalTo(@106);
        
    }];
    
    __weak OrderDetaillViewController * orderVC = self;
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
    
    //!标志进入相册了
    self.backFromPhoto = YES;
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
    
}
#pragma mark-UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //隐藏拍照发货选中的View
        [self hidePhotoSelectView];
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0000001f);
        
        //上传图片,修改
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"5" orderCode:_orderCode goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {//!拍照发货成功
                
                //!修改成功，调用block，让列表改变
                [self toRefreshOrderList];
                
                //!重新请求数据
                [self requeOrderDeatil];
                
            }else{
                
                [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];

            
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


#pragma mark 录入快递单发货
-(void)takeExpressSendGoods{

    __weak OrderDetaillViewController * vc = self;
    ExpressDeliverViewController * expressVC = [[ExpressDeliverViewController alloc]init];
    expressVC.orderCode = detailDTO.orderCode;
    expressVC.takeExpressSuccessBlock = ^(){//!发货成功
    
        //!修改成功，调用block，让列表改变
        [self toRefreshOrderList];
        
        //!请求并刷新数据
        [vc requeOrderDeatil];
    
    };
    [self.navigationController pushViewController:expressVC animated:YES];

}
#pragma mark 进入客服
-(void)customService{
    

    self.orderMerchantDic =detailDTO.mj_keyValues;
    
//    ConversationWindowViewController
    
    [[ChatManager shareInstance] getServerAcountWithName:detailDTO.nickName withMerchanNo:detailDTO.merchantNo withOrderDic:self.orderMerchantDic withController:self];

//    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:detailDTO.nickName jid:detailDTO.chatAccount withMerchanNo:detailDTO.merchantNo withDic:self.orderMerchantDic];
//    [self.navigationController pushViewController:conversationVC animated:YES];

}

#pragma mark 退换货申请的判断
//!判断是否提交退换货申请，没有取消申请，并且有发货信息行要显示（则tableView行数+1）
-(BOOL)isApplyRefundWitTakeInfo{
    
    if ([self isApplyRefund] && detailDTO.orderDeliveryDTOList.count) {
        
        return YES;
        
    }
    
    return NO;
    
}

//!判断是否提交退换货申请，没有取消申请，并且没有发货信息行要显示（则tableView行数不变，在第0行添加上申请退货的信息）
-(BOOL)isApplyRefundNoTakeInfo{

    if ([self isApplyRefund] && !detailDTO.orderDeliveryDTOList.count) {
        
        return YES;
        
    }
    
    return NO;

}


//!判断是否提交退换货申请，并且没有取消申请
-(BOOL)isApplyRefund{

    if (![detailDTO.refundStatus isEqual:@""] && ![detailDTO.refundStatus isEqual:[NSNumber numberWithInt:6]]) {
        
        return YES;
        
    }
    
    return NO;


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
