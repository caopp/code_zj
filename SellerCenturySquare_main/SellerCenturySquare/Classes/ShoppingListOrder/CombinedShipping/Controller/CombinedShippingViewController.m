//
//  CombinedShippingViewController.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CombinedShippingViewController.h"
#import "MyOrderParentTableViewCell.h"
#import "MergeSendGoodsDTO.h"
#import "ExpressDeliverViewController.h"//录入快递单发货
#import "RefreshControl.h"
#import "PhotoAndCamerSelectView.h"
#import "Masonry.h"
#import "CominedShippingBottomView.h"
#import "GUAAlertView.h"
#import "ConversationWindowViewController.h"
#import "OrderDetaillViewController.h"//!采购单详情
#import "ChatManager.h"

@interface CombinedShippingViewController ()<MyOrderParentDelegate,MyOrderParentDelegate,RefreshControlDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CominedShippingDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) MergeSendGoodsDTO *merSendDto;

//所有数据
@property (nonatomic ,strong) NSMutableArray *memberListArr;

@property (nonatomic ,assign) int pageNo;

//更改位置
@property (nonatomic ,assign) BOOL changeTablePoint;


/**
 * 选中的采购单
 */
@property (nonatomic ,strong) NSMutableArray *selectArr;
@property (nonatomic ,assign) CGFloat normalHeight;
@property (nonatomic, strong) RefreshControl *freshController;

@property (nonatomic ,strong) CominedShippingBottomView *bottomView;

@property (nonatomic ,strong) NSString *recordMerchanNo;

//!相机相册选择view
@property(nonatomic,strong)PhotoAndCamerSelectView * photoAndCamerSelectView;

//!相机相册 选择view弹出时上半透明部分
@property(nonatomic,strong)UIView * blackAlphaView;

@property (nonatomic ,strong) NSDictionary *orderMechantDic;


//点击拍照发货的时候记录类型。取出采购单号
@property (nonatomic ,strong) OrderListDTO *recordOrderList;





@end

@implementation CombinedShippingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customBackBarButton];
    self.title = @"合并采购商发货";
    self.pageNo = 1;
    
    self.selectArr = [NSMutableArray array];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) style:UITableViewStyleGrouped];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.memberListArr = [NSMutableArray array];
    self.progressHUD.hidden = NO;
    
    

    RefreshControl *freshController =[[RefreshControl alloc] initWithScrollView:self.tableView delegate:self];
    freshController.bottomEnabled = YES;
//    freshController.topEnabled = YES;
    self.freshController = freshController;
    
    CominedShippingBottomView *bottomView = (CominedShippingBottomView*)[[[NSBundle mainBundle] loadNibNamed:@"CominedShippingBottomView" owner:nil options:nil]lastObject];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    bottomView.hidden = NO;
    bottomView.delegat = self;
    
    
    

    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@49);
        
        
    }];
    
    [self initPhotoView];

    
    [self requestInitData];
    
    
  }
- (void)viewWillAppear:(BOOL)animated
{
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //!因为在 吊起相机、相册的时候会把状态栏颜色改成黑色，在这里改回白色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.memberListArr.count>0) {
        MemberListDTO *memberdDto = self.memberListArr[section];
    return memberdDto.orderList.count;
        }
    return 0;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.memberListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1> 普通商品
    static NSString *centerNormalShopMessageCellId= @"CenterNormalShopMessageCombinedTableViewCellId";
    //2> 邮费专拍
    static NSString *centerPostageShopMessageCellId = @"CenterPostageShopMessageCombinedTableViewCellId";
    //3> 样板
    static NSString *centerSampleShopMessageCellId = @"CenterSampleShopMessageCombinedTableViewCellId";
    //底部
    static NSString *cellId = @"cellId";
    
    
    MyOrderParentTableViewCell *cell;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[MyOrderParentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
    }
    
    if (self.memberListArr.count>0) {
        
    MemberListDTO *memberList = self.memberListArr[indexPath.section];
        
        if (memberList.orderList.count>0) {
            
        
        OrderListDTO *orderList = memberList.orderList[indexPath.row];
            
            if ([orderList.cartType isEqualToString:@"0"]) {
                //普通商品
                cell =  [tableView dequeueReusableCellWithIdentifier:centerNormalShopMessageCellId];
                //    中间pt视图
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterNormalShopMessageCombinedTableViewCell" owner:nil options:nil]lastObject];
                }

            }else if ([orderList.cartType isEqualToString:@"1"])
            {
                //样板商品
                cell =  [tableView dequeueReusableCellWithIdentifier:centerSampleShopMessageCellId];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterSampleShopMessageCombinedTableViewCell" owner:nil options:nil]lastObject];
                }
            }else if ([orderList.cartType isEqualToString:@"2"])
                {
                    //包邮商品
                    cell =  [tableView dequeueReusableCellWithIdentifier:centerPostageShopMessageCellId];
                    if (!cell) {
                        cell = [[[NSBundle mainBundle] loadNibNamed:@"CenterPostageShopMessageCombinedTableViewCell" owner:nil options:nil]lastObject];
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            
            
            if ([orderList.numb isEqualToString:@"first"] )
            {
                cell.hideView = @"bottom";
            }else if ([orderList.numb isEqualToString:@"last"])
            {
                cell.hideView = @"top";
                
            }else if([orderList.numb isEqualToString:@"own"])
            {
                cell.hideView = @"show";

            }else
            {
                cell.hideView = @"all";

            }
            cell.orderLsitDto = orderList;
            cell.memberListDto =memberList;
            cell.delegate = self;
            
            return cell;
    }
    
  }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.memberListArr.count>0) {
        
        MemberListDTO *memberList = self.memberListArr[section];
        
        if (memberList.orderList.count>0) {
            
            MyOrderParentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TopCombinedShippingHeadView" owner:nil options:nil]lastObject];
            cell.memberListDto = memberList;
            cell.delegate = self;
            return cell;
            
        }
    }
    
    UIView *view = [[UIView alloc] init];
    return view;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.memberListArr.count>0) {
        
        MemberListDTO *memberList = self.memberListArr[indexPath.section];
        if (memberList.orderList.count>0) {
            
        
        OrderListDTO *orderList = memberList.orderList[indexPath.row];
            
            CGFloat cellHeight= 0.0;
            
            NSArray *sizesArr = [orderList.sizes componentsSeparatedByString:@","];
            if (sizesArr.count>0) {
                
                CGFloat recordShowTag = 1.0;
                CGFloat labY = 0.0;
                CGRect recordLab;

                
                CGFloat widthView = self.view.frame.size.width - 15-60-50-15;
                
                for (int i = 0; i<sizesArr.count; i++) {
                    
                    NSString *sizeStrs = sizesArr[i];
                    NSArray *arrSize = [sizeStrs componentsSeparatedByString:@":"];
                    
                    
                    NSString*sizeStr =      [NSString stringWithFormat:@"%@ x %@",[arrSize firstObject],[arrSize lastObject]];
                    CGSize strSize = [self accordingContentFont:sizeStr];
                    CGRect label;
                    if (i != 0) {
                        if (CGRectGetMaxX(recordLab)+(strSize.width+10)>widthView) {
                            labY = labY + 23;
                            recordShowTag = 0;
                        }
                        label = CGRectMake(CGRectGetMaxX(recordLab)*recordShowTag+10, labY, strSize.width+10, strSize.height+4);
                        recordShowTag = 1;
                    }else
                    {
                        label = CGRectMake(10, 0, strSize.width+10, strSize.height+4);
                        
                    }
                    recordLab = label;
                    
                    if (sizesArr.count== (i+1)) {
                        cellHeight = recordLab.size.height+recordLab.origin.y;
                    }
                }
            }

        
        if (memberList.orderList.count>1) {
            
//
            
            if ([orderList.numb isEqualToString:@"first"] )
            {
                if ([orderList.cartType isEqualToString:@"0"]) {

                    //隐藏底部
                    return cellHeight+50+55;
                    
                }
                return 112;
                
                
            }else if ([orderList.numb isEqualToString:@"last"])
            {
                //隐藏顶部
                if ([orderList.cartType isEqualToString:@"0"]) {
                    return  cellHeight+110+61;
//                    return self.normalHeight;
                    
                }

                return 180;
                
            }else if([orderList.numb isEqualToString:@"own"])
            {
                if ([orderList.cartType isEqualToString:@"0"]) {
                    
                    //都不隐藏
                    return cellHeight+108+30+61;
//                    return self.normalHeight+88;
                    
                }

                return 210;
                
            }else
            {

                if ([orderList.cartType isEqualToString:@"0"]) {
//                    return self.normalHeight;‘
                    NSLog(@"出来一下啊%.2f",cellHeight);
                    //中间
                    return cellHeight+72;
                    
                    
                }

                return 82;
                
            }
            
            }
            
            if ([orderList.cartType isEqualToString:@"0"]) {

                return cellHeight+70+85+30;
                
                
            }

        }
    }
    
    return 200+self.normalHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MemberListDTO *memberList = self.memberListArr[indexPath.section];
    
    OrderListDTO *orderList = memberList.orderList[indexPath.row];
    
    OrderDetaillViewController * orderVC = [[OrderDetaillViewController alloc]init];
    orderVC.deliverGoodsInWaitStatusBlock = ^(NSString * orederCode,NSString * orderOldStatus)
    {
        self.pageNo = 1;
        self.changeTablePoint = YES;
        
        [self.selectArr removeAllObjects];
        [self.memberListArr removeAllObjects];
        
        [self requestInitData];
        self.requestBlock();
        
        
    };
    
    orderVC.orderCode = orderList.orderCode;
    [self.navigationController pushViewController:orderVC animated:YES];
    


}
#pragma mark - MyOrderParentDelegate

/**
 *  全选
 *
 *  @param memberDto
 */
- (void)myOrderParentSelectMerchantOrder:(MemberListDTO *)memberDto
{
    [self.tableView reloadData];
    for (OrderListDTO *order in memberDto.orderList) {
    
        if ([order.numb isEqualToString:@"first"]||[order.numb isEqualToString:@"own"]) {
            
            if ([order.checkBtn isEqualToString:@"YES"]) {
              [self.selectArr addObject:order];
                self.recordMerchanNo = order.memberNo;

            }else{
                [self.selectArr removeObject:order];
                
            }
        }
    }
    
    if (self.selectArr.count>0) {
//        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
        self.bottomView.hidden = NO;
    }else
    {
//        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        self.bottomView.hidden = YES;

    }
    
    NSLog(@"%@",self.selectArr);

}

/**
 *  单选
 *
 *  @param orderList
 *  @param memberList
 */

- (void)myOrderParentSelectOrderList:(OrderListDTO *)orderList memberListDto:(MemberListDTO *)memberList
{
    
    
    [self.tableView reloadData];
    
    if ([orderList.checkBtn isEqualToString:@"YES"]) {
        [self.selectArr  addObject:orderList];
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
        self.recordMerchanNo = orderList.memberNo;
        
        
        
    }else if ([orderList.checkBtn isEqualToString:@"NO"])
    {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        if (self.selectArr.count>0) {
            
            [self.selectArr  removeObject:orderList];
        }
    }
    
    if (self.selectArr.count>0) {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49);
        self.bottomView.hidden = NO;
    }else
    {
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//        self.bottomView.hidden = YES;
        
    }
    NSLog(@"%@",self.selectArr);
}

/**
 *  录入快递单
 *
 *  @param cell
 *  @param orderList
 */

- (void)myOrderParentSelectEntryExpressSingle:(MyOrderParentTableViewCell *)cell orderListDto:(OrderListDTO *)orderList
{
    ExpressDeliverViewController *expressVC = [[ExpressDeliverViewController alloc] init];
    expressVC.takeExpressSuccessBlock = ^()
    {
        [self.selectArr removeAllObjects];
        [self.memberListArr removeAllObjects];
        self.pageNo = 1;
        self.changeTablePoint = YES;
        [self requestInitData];
        //刷新订单数据
        self.requestBlock();
        

    };
    
    expressVC.orderCode= orderList.orderCode;
    [self.navigationController pushViewController:expressVC animated:YES];
    
}

/**
 *  拍摄快递单发货
 *
 *  @param cell
 *  @param orderList
 */

- (void)myOrderParentSelectShootExpressSingle:(MyOrderParentTableViewCell *)cell orderListDto:(OrderListDTO *)orderList
{
    self.recordOrderList = orderList;
    
    self.blackAlphaView.hidden = NO;
    self.photoAndCamerSelectView.hidden = NO;
    
    
}

- (CGSize)accordingContentFont:(NSString *)str
{
    CGSize size;
    size=[str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:13]} context:nil].size;
    
    return size;
    
}

/**
 *  客服
 *
 *  @param memberDto
 */
-(void)myOrderParentSelectSerVice:(MemberListDTO *)memberDto
{
    self.orderMechantDic = memberDto.mj_keyValues;
    
    [[ChatManager shareInstance] getServerAcount:memberDto.memberNo withName:memberDto.nickName withController:self];
//    ConversationWindowViewController *conversationVC = [[ConversationWindowViewController alloc] initWithName:memberDto.nickName withJID:memberDto.chatAccount];

//    ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initOrderWithName:memberDto.nickName jid:getOrderDTO.chatAccount withMerchanNo:memberDto.merchantNo withDic:self.orderMerchantDic];
    
    
    
    
  // [self.navigationController pushViewController:conversationVC animated:YES];
    

}

- (void)myOrderParentSelectMerchantName:(MemberListDTO *)memberDto
{
    
}

#pragma mark - RefreshDirectionDelegate

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction
{
    
    
    if (direction == RefreshDirectionBottom) {
        
        [self  requestInitData];
        

    }
}


#pragma mark - CominedShippingDelegate
/**
 *  合并拍照发货
 */
- (void)cominedShippingMergePictures
{
    NSString *orders ;
    if (self.selectArr.count>0) {
        
    
        
        NSArray *arrFirst = self.selectArr;
        NSArray *arrThird = self.selectArr;
        BOOL isSame = NO;
        
        for (OrderListDTO *orderFirst in arrFirst) {
            
            for (OrderListDTO *orderThird in arrThird) {
                if (![orderFirst.memberNo isEqualToString:orderThird.memberNo]) {
                    isSame = YES;
                    
                }
            }
        }
        
        if (isSame) {
            
        
        GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"请勾选同一采购商的采购单！" withTitleClor:nil message:@"您勾选的为不同采购商的采购单，\n 无法合并发货。" withMessageColor:[UIColor colorWithHex:0xeb301f] oKButtonTitle:@"重新勾选" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            
        } dismissAction:^{
            
        }];
        [alert show];
        return;
        }
    }else
    {
        [self.view makeMessage:@"请先选择需要合并发货的订单" duration:2 position:@"center"];
        
        return;
        
    }
    
    OrderListDTO *orderList = [self.selectArr lastObject];
    
    GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"确定合并拍照发货?" withTitleClor:[UIColor colorWithHexValue:0x676767 alpha:1] message:[NSString stringWithFormat:@"您已选择的采购商:%@的%lu张订单。",orderList.nickName,(unsigned long)self.selectArr.count] withMessageColor:[UIColor colorWithHexValue:0xeb301f alpha:1] oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        self.blackAlphaView.hidden = NO;
        self.photoAndCamerSelectView.hidden = NO;
        
        
    } dismissAction:^{
        
    }];
    [alert show];
}

/**
 *  录入快递单发货
 */
- (void)cominedShippingEntryExpress
{
    NSString *orders ;
    
    if (self.selectArr.count>0 ) {
        
        NSArray *arrFirst = self.selectArr;
        NSArray *arrThird = self.selectArr;
        BOOL isSame = NO;
        
        for (OrderListDTO *orderFirst in arrFirst) {
            
            for (OrderListDTO *orderThird in arrThird) {
                if (![orderFirst.memberNo isEqualToString:orderThird.memberNo]) {
                    isSame = YES;
                    
                }
            }
        }
        if (isSame) {
            
            
            GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"请勾选同一采购商的采购单！" withTitleClor:nil message:@"您勾选的为不同采购商的采购单，\n 无法合并发货。" withMessageColor:[UIColor colorWithHex:0xeb301f] oKButtonTitle:@"重新勾选" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
                
            } dismissAction:^{
                
            }];
            [alert show];
            return;
        }
    }else
    {
        [self.view makeMessage:@"请先选择需要合并发货的订单" duration:2 position:@"center"];
        return;
        

    }
    
    if (self.selectArr.count>0 ) {
        for (int i = 0; i<self.selectArr.count; i++) {
            
            OrderListDTO *orderDto = self.selectArr[i];

            if (i == 0) {
                orders = orderDto.orderCode;
            }else
            {
                orders = [NSString stringWithFormat:@"%@,%@",orders,orderDto.orderCode];
            }
        }
    }
    
    
    ExpressDeliverViewController *expressVC = [[ExpressDeliverViewController alloc] init];
    expressVC.takeExpressSuccessBlock = ^()
    {

        [self.selectArr removeAllObjects];
        [self.memberListArr removeAllObjects];
        self.pageNo = 1;
        self.changeTablePoint = YES;

        [self requestInitData];
        
        //刷新订单数据
        self.requestBlock();
        
        
    };
    expressVC.orderCode= orders;
    [self.navigationController pushViewController:expressVC animated:YES];


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
    
    __weak CombinedShippingViewController * orderVC = self;
    //!拍照发货的事件
    self.photoAndCamerSelectView.photoBlock = ^(){
        
//

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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    
}

#pragma mark-UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
//        [self progressHUDShowWithString:@"上传中"];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        //隐藏拍照发货选中的View
        [self hidePhotoSelectView];
        
        //得到图片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //压缩照片
        NSData *imageData = UIImageJPEGRepresentation([self fixOrientation:image], 0.0000001f);
        
        //上传图片,修改
        [HttpManager sendHttpRequestForImgaeUploadWithAppType:@"1" type:@"5" orderCode:@"" goodsNo:@"" file:imageData success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
           
            NSDictionary *responseDic = [self conversionWithData:responseObject];
            
            DebugLog(@"dic = %@", responseDic);
            
            if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                
                
                [self progressHUDHiddenTipSuccessWithString:@"上传成功"];
                
                NSString *orders ;
                if (self.selectArr.count>0) {
                    for (int i = 0; i<self.selectArr.count; i++) {
                        
                        OrderListDTO *orderDto = self.selectArr[i];
//                        
//                        if (![orderDto.memberNo isEqualToString:self.recordMerchanNo]) {
//                            //                请勾选同一采购商的采购单！
//                            
//                            GUAAlertView *alert = [GUAAlertView alertViewWithTitle:@"请勾选同一采购商的采购单！" withTitleClor:nil message:@"您勾选的为不同采购商的采购单，\n 无法合并发货。" withMessageColor:[UIColor colorWithHex:0xeb301f] oKButtonTitle:@"重新勾选" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
//                                
//                            } dismissAction:^{
//                                
//                            }];
//                            [alert show];
//                            return;
//                            
//                        }
                        if (i == 0) {
                            orders = orderDto.orderCode;
                        }else
                        {
                            orders = [NSString stringWithFormat:@"%@,%@",orders,orderDto.orderCode];
                        }
                    }
                }else
                {
                    if (self.recordOrderList.orderCode) {
                        orders = self.recordOrderList.orderCode;
                        
                    }
                }

                
                

                [HttpManager sendHttpRequestForOrderDeliverOrderCodes:orders type:@"1" picUrl:responseDic[@"data"] logisticTrackNo:@"" logisticCode:@"" logisticName:@"" success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    
                    NSDictionary *responseDic = [self conversionWithData:responseObject];
//                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    
                    
                    DebugLog(@"dic = %@", responseDic);
                    if ([self isRequestSuccessWithCode:[responseDic objectForKey:CODE]]) {
                        [self progressHUDHiddenTipSuccessWithString:@"发货成功"];
                        
                        [self.view makeMessage:@"发货成功" duration:2 position:@"center"];
                        
                        [self.selectArr removeAllObjects];
                        [self.memberListArr removeAllObjects];
                        
                        self.pageNo = 1;
                        self.changeTablePoint = YES;
                        
                        [self requestInitData];
                        self.requestBlock();
                        
                        
                    }else{
//                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self alertViewWithTitle:@"发货失败" message:responseDic[@"errorMessage"]];
                        
                        [self.view makeMessage:@"发货失败" duration:2 position:@"center"];

                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];


                    }

                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];

                }];
                
                
            }else{
                
                [self.progressHUD hide:YES];
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self alertViewWithTitle:@"上传失败" message:[responseDic objectForKey:ERRORMESSAGE]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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

#pragma mark -  request
 - (void)requestInitData
{
    
    [HttpManager sendHttpRequestForOrderDeliverListMerchantNo:self.merchantNo pageNo:[NSNumber numberWithInt:self.pageNo] pageSize:[NSNumber numberWithInteger:5] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dict);
        
        self.freshController.bottomEnabled = YES;
        self.freshController.dataEnable = YES;

        NSLog(@"%@",operation.responseString);
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([dict[@"code"]isEqualToString:@"000"]) {
            MergeSendGoodsDTO *merSendDto = [[MergeSendGoodsDTO alloc] init];
            [merSendDto setDictFrom:dict[@"data"]];
            [self.memberListArr addObjectsFromArray:merSendDto.memberListArr];
            
            self.merSendDto = merSendDto;
            self.pageNo++;
            [NSThread sleepForTimeInterval:1];
            
            
            [self.tableView reloadData];
            if (self.changeTablePoint) {
                self.tableView.contentOffset = CGPointMake( 0, 0);
                
            }
            
            [self.freshController finishRefreshingDirection:RefreshDirectionBottom];
            if (self.memberListArr.count>=PAGESIZE) {
                
                self.freshController.bottomEnabled = YES;
                
            }else{
                
                self.freshController.bottomEnabled = NO;
            }

            if (self.memberListArr.count >= merSendDto.totalCount.integerValue) {
                
                if (merSendDto.totalCount == 0) {
                self.freshController.dataEnable = NO;

                }
                self.freshController.bottomEnabled = NO;

                self.freshController.dataEnable = NO;
                
            }
            
            DebugLog(@"请求成功");
        }else
        {
            [self alertViewWithTitle:@"请求失败" message:dict[@"errorMessage"]];

        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"请求失败");
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];

}


@end
