//
//  ReturnApplyViewController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/5/23.
//  Copyright © 2016年 pactera. All rights reserved.
//  !退换货申请

#import "ReturnApplyViewController.h"
#import "SelectApplyTypeCell.h"//!选择申请类型的cell
#import "ReturnReasonViewCell.h"//!选择原因的cell
#import "ReturnPriceTableViewCell.h"//!退款金额的cell
#import "AddViewCell.h"//!补充说明的cell
#import "UpImageTableViewCell.h"//!上传照片的cell
#import "PhotoAndCamerSelectView.h"//!拍照发货的view
#import "PickSelectView.h"//!选择框
#import "Masonry.h"
#import "LoginDTO.h"
#import "GUAAlertView.h"
#import "MyOrderDetailViewController.h"
#import "ExitChangeGoodsViewController.h"//!退换货申请详情

static float normalHight = 50;//!普通cell高度
static float addInstrumentHight = 90;//!补充说明cell高度
static float upImageHight = 200;//!上传照片的cell高度
static float bottomViewHight = 49;//!提交申请 按钮的高度


@interface ReturnApplyViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,ELCImagePickerControllerDelegate>
{

    UIView * firstSectionFooterView;//!第一段的footerView
   
    //!“最多可退”
    NSString * mostReturnMoney;
    //!最多200字
    NSString * mostWriteNum;
    
    //!退货金额的行
    NSIndexPath * moneyIndexPath;
    //!补充说明的行
    NSIndexPath * addRemarkIndexPath;
    
    //!凭证列表
    NSMutableArray * imageArray;
    
    //!上传的数据
    NSMutableDictionary * upDic;
    
    GUAAlertView * alertView;
    
    
}
@property(nonatomic,strong)UITableView * applyTableView;//!申请的tabelView

//!原因选择框
@property(nonatomic,strong)PickSelectView * pickSelectView;

//!原因 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * pickerBlackAlphaView;

//!在选择货物状态 还是 退货原因
@property(nonatomic,assign)BOOL isShwoSelectReturnReason;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * photoBlackAlphaView;

//!退换货编号（用于修改的时候）
@property(nonatomic,copy)NSString * refundNo;

@end


@implementation ReturnApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //!导航
    [self createNav];
    
    
    mostReturnMoney = [NSString stringWithFormat:@"最多可退￥%.2f",self.orderDetailInfo.paidTotalAmount];
    mostWriteNum = @"最多200字";
    
    //!创建界面
    [self makeUI];
    
    //!隐藏tabbar
    [[self rdv_tabBarController] setTabBarHidden:YES];

    //!点击空白收起键盘
    UITapGestureRecognizer * hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddeKeyBoard)];
    hideTap.cancelsTouchesInView = NO;
    [_applyTableView addGestureRecognizer:hideTap];
    
    if (!self.applyDTO) {
        
        self.applyDTO = [[RefundApplyDTO alloc]init];
        
        if (self.orderDetailInfo.status == 2) {//!订单状态为“待发货” 则 1、只可以选择“仅退款” (如果订单状态为“待发货”,点击其他服务类型，给提示)  2、货物状态只能是“未收到货”
            
            self.applyDTO.refundType = [NSNumber numberWithInt:1];
            self.applyDTO.goodsStatus = [NSNumber numberWithInt:0];
            
            
        }
        
        //!上传图片的数组
        imageArray = [NSMutableArray arrayWithCapacity:0];
        
        DebugLog(@"goodsStatus:%d", [self.applyDTO.goodsStatus intValue]);
        
        [self.applyTableView reloadData];

        
    }else{//!有申请dto传过来，就是要修改的情况
    
        self.refundType = [NSString stringWithFormat:@"%@",self.applyDTO.refundType];
        
        if (![self.applyDTO.pics isEqualToString:@""]) {
            
            imageArray = [NSMutableArray arrayWithArray:[self.applyDTO.pics componentsSeparatedByString:@","]];
            
        }else{
        
            imageArray = [NSMutableArray arrayWithCapacity:0];

        }

        //!记录要修改的refundNo
        self.refundNo = self.applyDTO.refundNo;
       
        [self.applyTableView reloadData];
    
        
    }
    
    
    //!把选择界面移除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dissMissPhoto) name:@"cacelPhotoPage" object:nil];
    
    
    
}

-(void)hiddeKeyBoard{

    [self.view endEditing:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


}
#pragma mark 导航
-(void)createNav{
    
    self.title = @"退/换货";
    
    //!返回键
    [self addCustombackButtonItem];
    
}


#pragma mark 创建界面
-(void)makeUI{
    
    
    _applyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 - bottomViewHight) style:UITableViewStylePlain];
    _applyTableView.delegate = self;
    _applyTableView.dataSource = self;
    
    _applyTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_applyTableView];
    
   
    //!退换货原因选择框
    [self makeSelectView];
    
    //!创建拍照发货 选择相册 相机的view
    [self initPhotoView];

    
    //!提交申请按钮
    UIButton * applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    applyBtn.frame = CGRectMake(0, CGRectGetMaxY(_applyTableView.frame), SCREEN_WIDTH, bottomViewHight);
    [applyBtn setBackgroundColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
    [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyBtn];
    
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xefeff4 alpha:1]];
    
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0) {//!第0段，显示的是选择退换货类型的cell
        
        return 1;
        
    }
    
    //!0-退货退款 1-仅退款 2-换货
    if ([self.refundType isEqualToString:@"0"] ) {
        
        return 4;
        
    }else if ([self.refundType isEqualToString:@"1"]){
    
        return 5;
    
    }
    
    return 3;
    
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (!section) {//!选择类型段
        
        return 10;
        
    }
    
    return 0.00001;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (!section) {//!选择类型段
        
        if (!firstSectionFooterView) {//!灰色分割线
            
            firstSectionFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
            
            [firstSectionFooterView setBackgroundColor:[UIColor colorWithHexValue:0xefeff4 alpha:1]];
            
        }
        
        return firstSectionFooterView;
        
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {//!第0段，显示的是选择退换货类型的cell
        
        return 130;
        
    }else{
    
        
        if ([self.refundType isEqualToString:@"0"]) {//!退货退款
            
           return [self sureReturnRefundHight:indexPath];
            
            
        }else if ([self.refundType isEqualToString:@"1"]){//!仅退款
        
            return [self sureOnlyRefundHight:indexPath];
            
        }else{//!换货
        
            return [self sureChangeHight:indexPath];
            
        }
    

    }
    
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //!第0段：申请类型的选择
    if (!indexPath.section) {
        
        SelectApplyTypeCell * selectTypeCell = [[[NSBundle mainBundle]loadNibNamed:@"SelectApplyTypeCell" owner:nil options:nil]lastObject];
        
        //!设置选择类型的颜色  0-退货退款 1-仅退款 2-换货
        [selectTypeCell setLeftTextColor:self.refundType];
        
        //!记录订单dto
        selectTypeCell.orderDetailInfo = self.orderDetailInfo;
        
        __weak ReturnApplyViewController * applyVC = self;
        
        
        selectTypeCell.changeSelectType = ^(NSString * changeType){
        
            if (self.orderDetailInfo.status == 2 && ![changeType isEqualToString:@"1"]) {//!订单状态为“待发货” 则 只可以选择“仅退款” (如果订单状态为“待发货”,点击其他服务类型，给提示)
                
                //!订单状态(0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成)
                [applyVC.view makeMessage:@"待发货订单仅可申请退款服务" duration:2.0 position:@"center"];
                
                return ;
            
            }
            
            if (self.orderDetailInfo.status == 2){//!订单状态为待发货，点击切换的时候不做任何操作
            
                return ;
            
            }
            
            //!改变类型，刷新
            applyVC.refundType = changeType;
            
            
            //!每次切换，保存数据的dto都更换
            applyVC.applyDTO = [[RefundApplyDTO alloc]init];
            
            //!上传图片的数组也更换
            imageArray = [NSMutableArray arrayWithCapacity:0];
            
            NSIndexSet * sectionSet = [[NSIndexSet alloc]initWithIndex:1];
            
            [applyVC.applyTableView reloadSections:sectionSet withRowAnimation:UITableViewRowAnimationNone];

               
        };
        selectTypeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return selectTypeCell;
        
    }
    
    
    if ([self.refundType isEqualToString:@"0"]) {//!退货退款
        
        return [self sureReturnRefundCell:indexPath];
        
    }else if ([self.refundType isEqualToString:@"1"]){//!仅退款
    
        return [self sureOnlyRefundCell:indexPath];
    
    }else{//!换货
    
        return [self sureExchangeCell:indexPath];
        
    }
    
    
}

#pragma mark 退货退款
-(CGFloat)sureReturnRefundHight:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {//!补充说明
        
        return [self addConentCellHight];
        
    }else if (indexPath.row == 3){//!上传照片
    
        return [self imageCellHight];
        
    }
    
    return normalHight;//!普通cell的高度
    


}
-(UITableViewCell *)sureReturnRefundCell:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0://!选择原因
        {
            ReturnReasonViewCell * returnReasonCell = [self reasonAndStatusCell:YES];
            
            returnReasonCell.inIndexPath = indexPath;
            
            return returnReasonCell;
        
        }
            break;
        case 1:{//!退货金额
        
            //!记录退货金额的行
            moneyIndexPath = indexPath;
            
            return  [self returnPriceTableViewCell];
        
        }
            break;
          
        case 2:{//!补充说明
            
            //!记录补充说明的行
            addRemarkIndexPath = indexPath;
            
            return  [self addViewCell];
        
        }
            break;
            
        default:{//!上传照片
        
            return [self upImageTableViewCell];

        
        }
            break;
    }
    

}
#pragma mark 仅退款
-(CGFloat)sureOnlyRefundHight:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 3) {//!补充说明
        
        return [self addConentCellHight];
        
    }else if (indexPath.row == 4){//!上传照片
        
        return [self imageCellHight];
        
    }
    
    return normalHight;//!普通cell的高度
    
    
    
}

-(UITableViewCell *)sureOnlyRefundCell:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:{//!货物状态
        
            ReturnReasonViewCell * returnReasonCell = [self reasonAndStatusCell:NO];
            
            returnReasonCell.inIndexPath = indexPath;
            
//            if (self.orderDetailInfo.status == 2) {//!订单状态为“待发货” 则 1、只可以选择“仅退款” (如果订单状态为“待发货”,点击其他服务类型，给提示)  2、货物状态只能是“未收到货”
//            
//                [returnReasonCell.selectBtn setTitle:@" 未收到货" forState:
//UIControlStateNormal];
//            
//            }
            
            return returnReasonCell;
            
        }
            break;
            
        case 1://!选择原因
        {
            
            ReturnReasonViewCell * returnReasonCell = [self reasonAndStatusCell:YES];
            
            returnReasonCell.inIndexPath = indexPath;
            
            return returnReasonCell;
            
            
        }
            break;
        case 2:{//!退货金额
            
            //!记录退货金额的行
            moneyIndexPath = indexPath;
            
            return  [self returnPriceTableViewCell];
            
        }
            break;
            
        case 3:{//!补充说明
            
            //!记录补充说明的行
            addRemarkIndexPath = indexPath;
            
            return  [self addViewCell];
            
        }
            break;
            
        default:{//!上传照片
            
            return [self upImageTableViewCell];
            
            
        }
            break;
    }
    
    
}
#pragma mark 换货
-(CGFloat)sureChangeHight:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 1) {//!补充说明
        
        return [self addConentCellHight];
        
    }else if (indexPath.row == 2){//!上传照片
        
        return [self imageCellHight];
        
    }
    
    return normalHight;//!普通cell的高度
    
}


-(UITableViewCell *)sureExchangeCell:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0://!选择原因
        {
            
            ReturnReasonViewCell * returnReasonCell = [self reasonAndStatusCell:YES];
            
            returnReasonCell.inIndexPath = indexPath;
            
            return returnReasonCell;
            
        }
            break;
       
        case 1:{//!补充说明
            
            //!记录补充说明的行
            addRemarkIndexPath = indexPath;
            
            
            return  [self addViewCell];
            
        }
            break;
            
        default:{//!上传照片
            
            return [self upImageTableViewCell];
            
            
        }
            break;
    }
    
    
}


#pragma mark cell的创建
//!退货原因、货物状态的cell 是退货原因：yes

-(ReturnReasonViewCell *)reasonAndStatusCell:(BOOL)isReturnReason{


    ReturnReasonViewCell * returnReasonCell = [_applyTableView dequeueReusableCellWithIdentifier:@"ReturnReasonViewCellID"];
    
    if (!returnReasonCell) {
        
        returnReasonCell =  [[[NSBundle mainBundle]loadNibNamed:@"ReturnReasonViewCell" owner:self options:nil]lastObject];
        
    }
    
    //!确定是"货物状态"还是"退货原因"
    [returnReasonCell isReturnReasonSelect:isReturnReason withApplyDTO:self.applyDTO];
    
    
    
    __weak ReturnApplyViewController * vc = self;
    returnReasonCell.reasonSelectBlock = ^(BOOL isSelectReturnReason ,NSIndexPath * inIndexPath){//!这个cell给的状态:退货原因选择、货物状态
    
        BOOL noGetGoods = NO;
        
        //!退货原因
        if (isSelectReturnReason) {
        
            //!仅退款的时候，要根据货物状态显示 退款原因，所以要先选择货物状态
            //!如果是仅退款，在没有 选择货物状态的时候选择 退货原因
            if ([self.refundType isEqualToString:@"1"] && vc.applyDTO.goodsStatus == nil) {
                
                [self.view makeMessage:@"请先选择“货物状态”" duration:2.0 position:@"center"];
                
                return ;
                
            }
            
            //!仅退款：（1）待发货； （2）待收货,货物状态状态为 “未收到” 这两种情况的退货原因 noGodds=yes
            if (([self.refundType isEqualToString:@"1"] && self.orderDetailInfo.status == 2 )
                ||
                ([self.refundType isEqualToString:@"1"] && [self.applyDTO.goodsStatus intValue] == 0)) {
                
                //!订单状态(0-订单取消;1-待付款;2-待发货;3-待收货;4-交易取消;5-交易完成)
                
                noGetGoods = YES;
                
            }
            
            
            
        }else{//!货物状态
        
            if (self.orderDetailInfo.status == 2) {//!订单状态为“待发货” 则 1、只可以选择“仅退款” (如果订单状态为“待发货”,点击其他服务类型，给提示)  2、货物状态只能是“未收到货”
                
                [self.view makeMessage:@"待发货订单不可选择已收货" duration:2.0 position:@"center"];
                
                return;

            }
            
        }
        
        //!显示
        [vc hideOrShowSelectView];
        
        //!刷新显示的数据
        [vc.pickSelectView reloadDataIsShowReason:isSelectReturnReason withNoGetGoods:noGetGoods];
        
        //!点击吊起原因选择界面的时候，记录一下是选择 退货原因还是货物状态
        self.isShwoSelectReturnReason = isSelectReturnReason;
        
        //!把这一行顶到顶部
        [self changeEditCellToTop:inIndexPath];
        
    };
    
    returnReasonCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return returnReasonCell;
    
    
}
//!退货金额的cell
-(UITableViewCell *)returnPriceTableViewCell{

    ReturnPriceTableViewCell * priceCell = [_applyTableView dequeueReusableCellWithIdentifier:@"ReturnPriceTableViewCellID"];
    
    
    if (!priceCell) {
        
        priceCell = [[[NSBundle mainBundle]loadNibNamed:@"ReturnPriceTableViewCell" owner:self options:nil]lastObject];

    }
    
    [priceCell setPriceTextViewContent:self.applyDTO withMostAlert:mostReturnMoney];
    
    
    priceCell.priceTextView.delegate = self;

    priceCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return priceCell;

    
}
//!补充说明的cell
-(UITableViewCell *)addViewCell{

    AddViewCell * addCell = [_applyTableView dequeueReusableCellWithIdentifier:@"AddViewCellID"];
    
    if (!addCell) {
        
        addCell =  [[[NSBundle mainBundle]loadNibNamed:@"AddViewCell" owner:nil options:nil]lastObject];

    }
    [addCell setAddTextViewContent:self.applyDTO withMostAlert:mostWriteNum];
    
    addCell.addTextView.delegate = self;

    addCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return addCell;

}
//!上传照片的cell
-(UITableViewCell *)upImageTableViewCell{

    UpImageTableViewCell * upImageCell = [_applyTableView dequeueReusableCellWithIdentifier:@"UpImageTableViewCellID"];
    if (!upImageCell) {
        
        upImageCell = [[[NSBundle mainBundle]loadNibNamed:@"UpImageTableViewCell" owner:nil options:nil]lastObject];
        
    }

    //!根据图片的张数显示显示按钮的个数
    [upImageCell setImageBtnNumWithArray:imageArray];

    
    __weak ReturnApplyViewController * vc = self;
    
    
    //!上传图片
    upImageCell.selectImageBlock = ^(NSInteger selectBtnTag){//!传过来的是选择的第几个图片
    
        [vc takePhoto];

        
    };
    //!删除图片
    upImageCell.deleteImageBlock = ^(NSInteger deleteBtnTag){//!传过来的是选择的第几个按钮
    
        [imageArray removeObjectAtIndex:deleteBtnTag];
        
        [vc reloadImageRow];
        
    };
    
    upImageCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return upImageCell;
    
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
}
#pragma mark 退换货原因选择框
-(void)makeSelectView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 ;//!50是底部的高度
    float selectHight = 304;
    
    //!透明的view
    self.pickerBlackAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight - selectHight)];
    
    [self.pickerBlackAlphaView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.pickerBlackAlphaView];
    
    //!透明view上面的点击事件
    UITapGestureRecognizer * hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideOrShowSelectView)];
    [self.pickerBlackAlphaView addGestureRecognizer:hideTap];
    
    
    //!选择框
    self.pickSelectView = [[PickSelectView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.pickerBlackAlphaView.frame), SCREEN_WIDTH, selectHight)];
    
    
    [self.view addSubview:self.pickSelectView];
    
    //!隐藏
    [self hideOrShowSelectView];
    
    
    //!选中的时候返回  选中要显示的内容，选中要传给服务器的对应值
    __weak ReturnApplyViewController * applyVC = self;
    self.pickSelectView.selectBlock = ^(NSString * selectTitle,NSNumber * selectNum){
        
        //!退货退款、换货
        if ([applyVC.refundType isEqualToString:@"0"] || [applyVC.refundType isEqualToString:@"2"]) {
            
            ReturnReasonViewCell * cell = [applyVC.applyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
            
            [cell.selectBtn setTitle:selectTitle forState:UIControlStateNormal];
            
            //!记录退货原因
            applyVC.applyDTO.refundReason = selectNum;
                
            
        }else if ([applyVC.refundType isEqualToString:@"1"]){//!仅退款
        
            if (applyVC.isShwoSelectReturnReason) {//!是选择退货原因
                
                ReturnReasonViewCell * cell = [applyVC.applyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                
                [cell.selectBtn setTitle:selectTitle forState:UIControlStateNormal];
                
                //!记录退货原因
                applyVC.applyDTO.refundReason = selectNum;
                
                
            }else{//!是选择货物状态
            
                
                //!如果货物状态改变，退换原因需要更改
                if ([applyVC.applyDTO.goodsStatus intValue] != [selectNum intValue]) {
                    
                    applyVC.applyDTO.refundReason = nil;
                    
                    ReturnReasonViewCell * cell = [applyVC.applyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
                    
                    [cell.selectBtn setTitle:@" 请选择退货原因" forState:UIControlStateNormal];
                    
                    
                }
                
                ReturnReasonViewCell * cell = [applyVC.applyTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
                
                [cell.selectBtn setTitle:selectTitle forState:UIControlStateNormal];
                
                //!记录退货原因
                applyVC.applyDTO.goodsStatus = selectNum;
                
            
            }
            
            
        }
        
    };
    
    //!点击“取消”/"确定"按钮 收起弹出框
    self.pickSelectView.sureAndCancelBlock = ^(){
    
        [applyVC hideOrShowSelectView];
    };

    
}
-(void)hideOrShowSelectView{

    self.pickerBlackAlphaView.hidden = !self.pickerBlackAlphaView.hidden;

    self.pickSelectView.hidden = !self.pickSelectView.hidden;
    
    if (!self.pickerBlackAlphaView.hidden) {
        
        [self.view bringSubviewToFront:self.pickSelectView];
        
    }
    
}
#pragma mark textViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{


    if (textView.tag == 300) {//!退货金额
        
        if ([textView.text isEqualToString:mostReturnMoney]) {
            
            textView.text = @"";
        }
        
    
    }else{//!补充说明
    
        if ([textView.text isEqualToString:mostWriteNum]) {
            
            textView.text = @"";
        }
    
        //!把这一行顶到顶部
        [self changeEditCellToTop:addRemarkIndexPath];
    
    }
    
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{

    if (textView.tag == 300) {//!退货金额
        
        if ([textView.text isEqualToString:@""]) {
            
            textView.text = mostReturnMoney;
            
            _applyDTO.refundFee = nil;

        
        }else{
        
           
//            NSString * refundStr = textView.text;
//            
//            double refundDouble = [refundStr doubleValue];
//            
//            _applyDTO.refundFee = [NSNumber numberWithDouble:refundDouble];
            
            _applyDTO.refundFee = textView.text;
            
            
            
            
        }
        
        
    }else{//!补充说明
        
        if ([textView.text isEqualToString:@""]) {
            
            textView.text = mostWriteNum;
            _applyDTO.remark = @"";

            
        }else{
        
            _applyDTO.remark = textView.text;

        }
        
        //!刷新补充说明行:0-退货退款 1-仅退款 2-换货
        NSIndexPath * addIndex;
        if ([self.refundType isEqualToString:@"0"]) {
            
           addIndex = [NSIndexPath indexPathForRow:2 inSection:1];
        
        }else if ([self.refundType isEqualToString:@"1"]){
        
            addIndex = [NSIndexPath indexPathForRow:3 inSection:1];

        
        }else{
        
            addIndex = [NSIndexPath indexPathForRow:1 inSection:1];
        
        }
        
        [self.applyTableView reloadRowsAtIndexPaths:@[addIndex] withRowAnimation:UITableViewRowAnimationNone];
        
        
    }


}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{

    if (textView.tag == 300) {//!退货金额 限制只能输入到小数点后两位
        
//        NSArray * textArray = [textView.text componentsSeparatedByString:@"."];
//
//        if (textArray.count == 2) {//!如果数组中有两个值，则说明输入了小数点
//            
//            NSRange ran=[textView.text rangeOfString:@"."];
//            
//            int tt=range.location-ran.location;//!将要修改的位置-小数点在的位置
//            
//            if (tt <= 2 ){
//                
//                return YES;
//                
//            }
//            
//            return NO;
//        }
        
        return YES;
        
        
    }
    
    return YES;
    
}
#pragma mark 选择照片的view
-(void)takePhoto{
    
    //!显示选择的view
    self.photoBlackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    
    [self.view bringSubviewToFront:self.photoBlackAlphaView];
    [self.view bringSubviewToFront:self.photoAndCamerSelectView];
    
}

//!创建拍照发货 选择相册 相机的view
-(void)initPhotoView{
    
    float showHight = self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20 ;//!50是底部的高度
    float selectHight = 106;
    
    //!透明的view
    self.photoBlackAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, showHight - selectHight)];
    
    [self.photoBlackAlphaView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.photoBlackAlphaView];
    
    
    UITapGestureRecognizer * selectHideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hidePhotoSelectView)];
    [self.photoBlackAlphaView addGestureRecognizer:selectHideTap];
    
    
    //!相册选择的view
    self.photoAndCamerSelectView= [[[NSBundle mainBundle]loadNibNamed:@"PhotoAndCamerSelectView" owner:self options:nil]lastObject];
    [self.photoAndCamerSelectView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    [self.view addSubview:self.photoAndCamerSelectView];
    
    [self.photoAndCamerSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.photoBlackAlphaView.mas_bottom);
        //        make.bottom.equalTo(@50);//!50是底部的高度
        make.height.equalTo(@106);
        
    }];
    
    __weak ReturnApplyViewController * orderVC = self;
    //!拍照发货的事件
    self.photoAndCamerSelectView.photoBlock = ^(){
        
        //!相机的时候
        [orderVC showPhoto];
        
    };
    
    self.photoAndCamerSelectView.camerBlock = ^(){
        
        
        [orderVC showCamer];
        
    };
    
    //!先隐藏，点击拍照发货的时候显示
    self.photoBlackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
    
}

//!隐藏相册选择的view 以及上半部分的灰色半透明部分
-(void)hidePhotoSelectView{
    
    self.photoBlackAlphaView.hidden = YES;
    self.photoAndCamerSelectView.hidden = YES;
    
    
}
//!吊起相册
-(void)showPhoto{

    ELCImagePickerController * elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 5 - imageArray.count;
    elcPicker.returnsOriginalImage = YES;
    elcPicker.returnsImage = YES;
    elcPicker.onOrder = YES;
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage];
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];


}
//!点击具体相册里面的取消，会发出通知调用这个方法
-(void)dissMissPhoto{

    [self dismissViewControllerAnimated:YES completion:nil];



}
//!掉起相机:isCamer=yes
-(void)showCamer{
    
    //拍照发货
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;  //是否可编辑
    picker.navigationBar.tintColor = [UIColor blackColor];
    picker.navigationBar.translucent = NO;
    //如果选择的是相机，则判断是否可以吊起相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    
    
    //!吊起相机、相册的时候 修改状态栏的颜色，在这个界面将要出现的时候改回白色
    [self presentViewController:picker animated:YES completion:^{
        
        
    }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    //!隐藏拍照发货选择的view
    [self hidePhotoSelectView];

    
}
#pragma mark ELCImagePickerControllerDelegate
-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [self dismissViewControllerAnimated:YES completion:nil];

    NSMutableArray * getImageArray = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary * imageDic in info) {
        
        [getImageArray addObject:imageDic[@"UIImagePickerControllerOriginalImage"]];
        
        
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self upImageArray:[NSMutableArray arrayWithArray:getImageArray]];
    
}


#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    

    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self progressHUDShowWithString:@"上传中"];
        
        
        //隐藏拍照发货选中的View
        [self hidePhotoSelectView];
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        [self upImageArray:[NSMutableArray arrayWithArray:@[image]]];
        

    }];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    
    
}
-(void)upImageArray:(NSMutableArray *)getImageArray{

    
    if (getImageArray.count) {
        
        //!每次取出第0个图片
        
        //得到图片
        UIImage *image = getImageArray[0];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0001f);
        
        //上传图片,修改
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"2" type:@"9" orderCode:@"" goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {//!上传成功
                
                //!把图片添加到数组
                [imageArray addObject:responseDic[@"data"]];
                
                //!刷新图片行
                [self reloadImageRow];
                
                //!移除已经上传了的图片
                [getImageArray removeObjectAtIndex:0];
                
                if (getImageArray.count) {
                    
                    [self upImageArray:getImageArray];
                    
                }else{
                
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                }
                
                
            }else{
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self.view makeMessage:responseDic[ERRORMESSAGE] duration:2.0 position:@"center"];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0 position:@"center"];
            
            
        }];

        
        
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


//!刷新图片行
-(void)reloadImageRow{
    
    NSInteger imageRowInteger = 0;
    
    if ([self.refundType isEqualToString:@"0"]) {
        
        imageRowInteger = 3;
        
    }else if ([self.refundType isEqualToString:@"1"]){
        
        imageRowInteger = 4;
    }else{
        
        imageRowInteger = 2;
        
    }
    
    NSIndexPath * imageIndextPath = [NSIndexPath indexPathForRow:imageRowInteger inSection:1];
    
    
    [self.applyTableView reloadRowsAtIndexPaths:@[imageIndextPath] withRowAnimation:UITableViewRowAnimationNone];
    
    
}

#pragma mark 编辑的时候改变tableview的contentoffest
-(void)changeEditCellToTop:(NSIndexPath *)editIndexPath{


    UITableViewCell * cell = [self.applyTableView cellForRowAtIndexPath:editIndexPath];
    
    [self.applyTableView setContentOffset:CGPointMake(0, cell.frame.origin.y) animated:YES];

}


#pragma mark 提交申请
-(void)applyBtnClick{

    [self.view endEditing:YES];
    
    //!校验通过
    if ([self isCanSubmit]) {
    
        
        if (alertView) {
            
            [alertView removeFromSuperview];
            
        }
        alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定提交？" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
            [self upApplyInfo];
            
        } dismissAction:nil];
        
        [alertView show];
        
    
    }
    
}

-(void)upApplyInfo{

    //!补充说明、上传凭证 非必填
    upDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if ([self.refundType isEqualToString:@"0"]) {//!退货退款
        
        //!金额
        
        
        [upDic setObject:self.applyDTO.refundFee forKey:@"refundFee"];
        
        
        
        
    }else if ([self.refundType isEqualToString:@"1"]){//!仅退款
        
        //!货物状态
        [upDic setObject:self.applyDTO.goodsStatus forKey:@"goodsStatus"];
        
        
        //!金额
        [upDic setObject:self.applyDTO.refundFee forKey:@"refundFee"];
        
    }else{//!换货
        
        
    }

    
    
    
    //!订单编号
    [upDic setObject:self.orderDetailInfo.orderCode forKey:@"orderCode"];
    
    //!退换货类型
    [upDic setObject:[NSNumber numberWithInt:[self.refundType intValue]] forKey:@"refundType"];
    
    //!退换货原因
    [upDic setObject:self.applyDTO.refundReason forKey:@"refundReason"];
    
    //!补充说明
    if (self.applyDTO.remark) {
        
        [upDic setObject:self.applyDTO.remark forKey:@"remark"];
    }
    
    //!上传凭证
    if (imageArray.count) {
        
        NSMutableString * imageStr = [NSMutableString stringWithString:@""];
        for (int i = 0; i < imageArray.count ; i++) {
            
           
            [imageStr appendString:imageArray[i]];
            
            if (i != imageArray.count - 1) {//!如果不是最后一个，就在前面添加逗号进行分割
                
                [imageStr appendString:@","];
            }
            
        }
        
        [upDic setObject:imageStr forKey:@"pics"];
        
        
    }
    
    //!tokenID
    if ([LoginDTO sharedInstance].tokenId != nil) {
        
        [upDic setObject:[LoginDTO sharedInstance].tokenId forKey:@"tokenId"];
        
    }
    
    
    
    //!从申请详情过来的，则进入修改接口
    if (self.isFromApplyDetail) {
        
        [upDic setObject:self.refundNo forKey:@"refundNo"];
        [self changeApplyRequest];

    }else{
    
        [self submitApplyRequest];
    
    }
    
    
   
}
//!提交申请
-(void)submitApplyRequest{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestFororderRefundApply:upDic Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!申请成功
            
            //!进入退换货申请详情页面
            ExitChangeGoodsViewController * exitChangeVC = [[ExitChangeGoodsViewController alloc]init];
            exitChangeVC.orderCode = self.orderDetailInfo.orderCode;
            exitChangeVC.detailDto = self.orderDetailInfo;
            [self.navigationController pushViewController:exitChangeVC animated:YES];
            
            //!发送通知给订单列表，刷新订单列表
            [[NSNotificationCenter defaultCenter]postNotificationName:@"RefreshOrderList" object:nil];
            
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        
    }];
    
    


}
-(void)changeApplyRequest{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [HttpManager sendHttpRequestForOrderRefundApplyUpdate:upDic Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {//!申请成功
            
            //!进入退换货申请详情页面
            ExitChangeGoodsViewController * exitChangeVC = [[ExitChangeGoodsViewController alloc]init];
            exitChangeVC.orderCode = self.orderDetailInfo.orderCode;
            exitChangeVC.detailDto = self.orderDetailInfo;
            [self.navigationController pushViewController:exitChangeVC animated:YES];
            
            
        }else{
            
            [self.view makeMessage:dic[@"errorMessage"] duration:2.0 position:@"center"];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view  animated:YES];
        [self.view makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。" duration:2.0f position:@"center"];
        

        
    }];



}


-(BOOL)isCanSubmit{

    
    //!退货退款  原因、金额、(补充说明、上传凭证)
    if ([self.refundType isEqualToString:@"0"]) {
        
        //!退货原因
        if (self.applyDTO.refundReason == nil) {
            
            [self.view makeMessage:@"请选择退货原因" duration:2.0 position:@"center"];
            
            return NO;
            
        }
        
        if (self.applyDTO.refundFee == nil || ![self.applyDTO.refundFee doubleValue]) {
            
            [self.view makeMessage:@"请输入退款金额" duration:2.0f position:@"center"];
            
            return NO;
            
        }
        
        if ([self refundFeeIsCanCommit] == NO) {
            
            [self.view makeMessage:@"请输入合法的退款金额" duration:2.0f position:@"center"];
            
            return NO;
            
        }
        double reset = [self.applyDTO.refundFee doubleValue] - self.orderDetailInfo.paidTotalAmount;
        
        DebugLog(@"reset:%f", reset);

        
        if (reset  > 0) {
            
            [self.view makeMessage:mostReturnMoney duration:2.0 position:@"center"];
            
            return NO;

        }
        
        
    }
    
    //!仅退款   货物状态、原因、金额、（补充说明、上传凭证）
    if ([self.refundType isEqualToString:@"1"]) {
        
        //!货物状态
        if (self.applyDTO.goodsStatus == nil) {
            
            [self.view makeMessage:@"请选择货物状态" duration:2.0 position:@"center"];
            
            return NO;

            
        }
        
        //!退货原因
        if (self.applyDTO.refundReason == nil) {
            
            [self.view makeMessage:@"请选择退货原因" duration:2.0 position:@"center"];
            
            return NO;
            
        }
        
        if (self.applyDTO.refundFee == nil || ![self.applyDTO.refundFee doubleValue]) {
            
            [self.view makeMessage:@"请输入退款金额" duration:2.0f position:@"center"];
            
            return NO;
            
        }
        
        if ([self refundFeeIsCanCommit] == NO) {
            
            [self.view makeMessage:@"请输入合法的退款金额" duration:2.0f position:@"center"];
            
            return NO;
            
        }
        
        
        double reset = [self.applyDTO.refundFee doubleValue] - self.orderDetailInfo.paidTotalAmount;
        
        
        DebugLog(@"reset:%f", reset);
        
        
        if (reset  > 0) {
            
            [self.view makeMessage:mostReturnMoney duration:2.0 position:@"center"];
            
            return NO;
            
        }
        
        
    }
    
    //!换货     原因、（补充说明、上传凭证）
    if ([self.refundType isEqualToString:@"2"]) {
        
        //!退货原因
        if (self.applyDTO.refundReason == nil) {
            
            [self.view makeMessage:@"请选择退货原因" duration:2.0 position:@"center"];
            
            return NO;
            
        }

        
    }

    //!补充说明
    if (_applyDTO.remark != nil) {
        
        if (_applyDTO.remark.length > 200) {
            
            [self.view makeMessage:mostWriteNum duration:2.0 position:@"center"];
            
            return NO;
        }
        
    }
    
    

    return YES;

}
//!判断金额输入的是否合法：是否有多个小数点，小数点后面是否是两位数以内
-(BOOL)refundFeeIsCanCommit{
    
    NSString * refundStr = [NSString stringWithFormat:@"%@",self.applyDTO.refundFee];//!后台传过来的是nsnumber就好崩溃

    NSArray * textArray = [refundStr componentsSeparatedByString:@"."];
    
    if (textArray.count > 2) {//!有多个小数点
        
        
        return NO;
    }
    
    if (textArray.count == 2) {//!有1个小数点
        
        NSString * desStr = textArray[1];//!小数点后面的数字
        
        if (desStr.length <= 0 ) {
            
            return NO;
        }
        
        if (desStr.length>2) {
            
            return NO;
        }
        
        
    }
    
    
    
    return YES;
}



#pragma mark 计算cell的高度
//!计算补充说明内容的高度
-(float )addConentCellHight{
    
    
    CGFloat addContentWidth = self.applyTableView.frame.size.width - 15 -61 -15 -15;//!补充说明在界面上的宽度
    
    CGSize addContentSize = [self.applyDTO.remark boundingRectWithSize:CGSizeMake(addContentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    CGFloat cellHight = addContentSize.height + 15;//!15是补充说明textview距离cell顶部的距离
    
    if (cellHight < addInstrumentHight) {
        
        return addInstrumentHight;
        
    }else{
        
        return cellHight + 15;//!15是让文字距离上下有点距离，cellHight < addInstrumentHight 的情况，本来就是够的，就不需要加15
        
    }
    
    
}
//!根据图片张数给出图片cell的高度
-(float)imageCellHight{

    //!每3张一行
    
    if (imageArray.count >= 3) {//!有两行的情况
        
        return upImageHight;
    
    }else{
    
        return upImageHight - 80;//!80是一行图片的高度
    
    }

}
-(void)dealloc{


    //!把选择界面移除
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cacelPhotoPage" object:nil];
    


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
