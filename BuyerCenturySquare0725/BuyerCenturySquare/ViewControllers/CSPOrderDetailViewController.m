//
//  CSPOrderDetailViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/15/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderDetailViewController.h"
#import "OrderDetailDTO.h"
#import "CSPOrderIntroSectionHeaderView.h"
#import "CSPConsigneeSectionHeaderView.h"
#import "CSPNormalSectionHeaderView.h"
#import "CSPNormalOrderTableViewCell.h"
#import "CSPSampleOrderTableViewCell.h"
#import "CSPMailOrderTableViewCell.h"
#import "CSPOrderDetailSectionFooterView.h"
#import "ConversationWindowViewController.h"
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"
#import "GoodsInfoDTO.h"
#import "MerchantDeatilViewController.h"//!商家商品列表
#import "CSPPostageViewController.h"

#import "OrderAddDTO.h"
#import "CSPPayAvailabelViewController.h"
#import "GUAAlertView.h"
#import "CSPGoodsInfoTableViewController.h"
#import "GoodDetailViewController.h"
#import "Masonry.h"
typedef NS_ENUM(NSInteger, OrderDetailBottomType) {
    OrderDetailBottomTypeNone,
    OrderDetailBottomTypeToConfirmReceive,
    OrderDetailBottomTypeToPay,
};

@interface CSPOrderDetailViewController () <UITableViewDataSource, UITableViewDelegate, CSPNormalSectionHeaderViewDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *confirmReceiveButton;//确认收货
@property (weak, nonatomic) IBOutlet UIButton *postponeGoodsBtn;//延期收货

@property (nonatomic ,strong) OrderAddDTO *orderAddDTO;





@property (nonatomic, assign) OrderDetailBottomType bottomType;

@property (nonatomic, strong) OrderDetailDTO* orderDetailInfo;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation CSPOrderDetailViewController

static NSString* reuseOrderInfoIdentifier = @"orderInfoCell";
static NSString* sectionOrderFooterIdentifier = @"sectionFooterView";
static NSString* sectionOrderHeaderIdentifier = @"sectionHeaderView";
static NSString* introSectionHeaderIdentifier = @"introSectionFooterView";
static NSString* consigneeSectionHeaderIdentifier = @"consigneeSectionHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"采购单详情";

    

    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    
    __weak CSPOrderDetailViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadOrderDetailInfo];
    };
    

    UINib *introSectionHeaderNib = [UINib nibWithNibName:@"OrderIntroSectionHeaderView" bundle:nil];
    [_tableView registerNib:introSectionHeaderNib forHeaderFooterViewReuseIdentifier:introSectionHeaderIdentifier];

    UINib *consigneeSectionHeaderNib = [UINib nibWithNibName:@"ConsigneeSectionHeaderView" bundle:nil];
    [_tableView registerNib:consigneeSectionHeaderNib forHeaderFooterViewReuseIdentifier:consigneeSectionHeaderIdentifier];

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"NormalSectionHeaderView" bundle:nil];
    [_tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:sectionOrderHeaderIdentifier];

    UINib *sectionFooterNib = [UINib nibWithNibName:@"OrderDetailSectionFooterView" bundle:nil];
    [_tableView registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:sectionOrderFooterIdentifier];

    [refreshHeader beginRefreshing];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(-1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view);

        
    }];


    [self addCustombackButtonItem];
    [self updateBottomView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 2 ? self.orderDetailInfo.goodsList.count: 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderDetailInfo) {
        return 3;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPBaseOrderTableViewCell *cell = nil;
    OrderGoodsItem* orderGoodsInfo = self.orderDetailInfo.goodsList[indexPath.row];
    switch (orderGoodsInfo.cartGoodsType) {
        case CartGoodsTypeOfNormal:
            cell = [tableView dequeueReusableCellWithIdentifier:@"NormalOrderTableViewCell" forIndexPath:indexPath];
            break;
        case CartGoodsTypeOfSample:
            cell = [tableView dequeueReusableCellWithIdentifier:@"SampleOrderTableViewCell" forIndexPath:indexPath];
            break;
        case CartGoodsTypeOfMail:
            cell = [tableView dequeueReusableCellWithIdentifier:@"MailOrderTableViewCell" forIndexPath:indexPath];
            break;
        default:
            break;
    }
    // Configure the cell...
    cell.orderGoodsItemInfo = orderGoodsInfo;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderGoodsItem* orderGoodsInfo = self.orderDetailInfo.goodsList[indexPath.row];
    
    
    GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
    
    goodsInfoDTO.goodsNo = orderGoodsInfo.goodsNo;
    if ([orderGoodsInfo.cartType isEqualToString:@"2"]) {
        CSPPostageViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPostageViewController"];
        destViewController.merchantNo = self.orderDetailInfo.merchantNo;
        
        [self.navigationController pushViewController:destViewController animated:YES];
        
        
    }else{
        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
        //
        //            goodsInfo.goodsNo = commodityInfo.goodsNo;
        
        GoodDetailViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        
        [self.navigationController pushViewController:goodsInfo animated:YES];
        
        
        
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        CSPOrderDetailSectionFooterView* footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionOrderFooterIdentifier];
        footerView.orderDetailInfo = self.orderDetailInfo;

        return footerView;
    }
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = nil;
    if (section == 0) {
        CSPOrderIntroSectionHeaderView* introView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:introSectionHeaderIdentifier];
        
        [introView setOrderDetailInfo:self.orderDetailInfo];
        headerView = introView;
    } else if (section == 1) {
        CSPConsigneeSectionHeaderView* consigneeView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:consigneeSectionHeaderIdentifier];
        [consigneeView setOrderDetailInfo:self.orderDetailInfo];
        consigneeView.addShippingAddressView.hidden = YES;
        
        headerView = consigneeView;
    } else {
        CSPNormalSectionHeaderView* normalView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:sectionOrderHeaderIdentifier];
        [normalView setOrderDetailInfo:self.orderDetailInfo];
        normalView.delegate = self;
        headerView = normalView;
    }

    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return [CSPOrderDetailSectionFooterView sectionHeightWithOrderDetail:self.orderDetailInfo];
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 143.0f;
    } else if (section == 1) {
        
        return [CSPConsigneeSectionHeaderView sectionHeaderHeightWithContent:self.orderDetailInfo.addressDescription];
    } else {
        return 30.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 0.0f;
    } else if (indexPath.section == 1) {
        return 0.0f;
    } else {
        OrderGoodsItem* orderGoodsInfo = self.orderDetailInfo.goodsList[indexPath.row];
        return [CSPBaseOrderTableViewCell cellHeightWithSizesCount:orderGoodsInfo.sizes.count];
    }
}

- (void)updateBottomView {
    UIEdgeInsets originalContentInsets = self.tableView.contentInset;
    if ([self.orderDetailInfo convertOrderStatusToValue] == CSPOrderModeToPay) {
        [self.bottomView setHidden:NO];
         
        [self.confirmReceiveButton setHidden:YES];
        [self.postponeGoodsBtn setHidden:YES];

        originalContentInsets.bottom = 64;
    } else if ([self.orderDetailInfo convertOrderStatusToValue] == CSPOrderModeToTakeDelivery) {
        [self.bottomView setHidden:NO];
        [self.confirmReceiveButton setHidden:NO];
        [self.postponeGoodsBtn setHidden:NO];
        originalContentInsets.bottom = 64;
    } else {
        [self.bottomView setHidden:YES];
        originalContentInsets.bottom = 30;
    }

    self.tableView.contentInset = originalContentInsets;
}

//确定收货
- (IBAction)confirmReceiveButtonClicked:(id)sender {

    
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定已收货?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [self doConfirmTakeDeliveryAction];

    } dismissAction:^{
    }];
    [alertView show];

    
}


//取消采购单
- (IBAction)cancelOrderButtonClicked:(id)sender {

    
    GUAAlertView *alertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"确定取消采购单?" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [self doCancelAction];

    } dismissAction:^{
        
    }];
    [alertView show];
}

//
- (IBAction)payButtonClicked:(id)sender {

    
    [HttpManager sendHttpRequestForConfirmPay:self.orderCode  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            self.orderAddDTO = [[OrderAddDTO alloc] init];
            [self.orderAddDTO setDictFrom:[dic objectForKey:@"data"]];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            CSPPayAvailabelViewController* destViewController = [storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
            destViewController.orderAddDTO = self.orderAddDTO;
            destViewController.isAvailable = YES;
            [self.navigationController pushViewController:destViewController animated:YES];
            
        }else{
            //            if (alertView) {
            //                [alertView removeFromSuperview];
            //
            //            }
            //            alertView = [GUAAlertView alertViewWithTitle:@"请求失败" withTitleClor:nil message:[dic objectForKey:@"errorMessage"]  withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:nil withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
            //
            //            } dismissAction:^{
            //
            //            }];
            //            [alertView show];
            
            
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        
    }];

//    CSPPayAvailabelViewController* destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPPayAvailabelViewController"];
//    destViewController.orderCode = self.orderCode;
//        destViewController.isAvailable = YES;
//    [self.navigationController pushViewController:destViewController animated:YES];

}

- (IBAction)postponeGoodsBtn:(id)sender {
    
    
 
    [self PostponeGoods];
    

    
}


/**
 *  请求采购单详情的所有数据
 */

- (void)loadOrderDetailInfo {
    [HttpManager sendHttpRequestForOrderDetailWithOrderCode:self.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        DebugLog(@"%@", dic);
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.orderDetailInfo = [[OrderDetailDTO alloc]initWithDictionary:dic[@"data"]];
            [self.tableView reloadData];

            [self updateBottomView];
            
        } else {
            [self.view makeMessage:[NSString stringWithFormat:@"查询采购单详情失败, %@", [dic objectForKey:@"errorMessage"]]   duration:2.0f position:@"center"];
            

            
           
        }

        [self.refreshHeader endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"网络连接异常"   duration:2.0f position:@"center"];
        

        

        [self.refreshHeader endRefreshing];
    }];
}


/**
 *  取消采购单
 */
- (void)doCancelAction {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForOrderCancelUnpaid:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {

            [self.refreshHeader beginRefreshing];

            [self.view makeMessage:@"取消采购单成功"   duration:2.0f position:@"center"];

        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"取消采购单失败, %@", [dic objectForKey:@"errorMessage"]]   duration:2.0f position:@"center"];

          
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

         [self.view makeMessage:@"网络连接异常"   duration:2.0f position:@"center"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}


/**
 *  确认收货
 */
- (void)doConfirmTakeDeliveryAction {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForOrderReceived:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {

            [self.refreshHeader beginRefreshing];


             [self.view makeMessage:@"确认收货成功" duration:2.0f position:@"center"];
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"确认收货失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

           
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}


/**
 *  延期收货
 */
- (void)PostponeGoods
{
    NSString *messageStr = [NSString stringWithFormat:@"剩余延期次数: %lu",self.orderDetailInfo.balanceQuantity];
    GUAAlertView *al = [GUAAlertView alertViewWithTitle:@"确定延长时间收货？" withTitleClor:nil message:messageStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForSetOrderAutoConfirm:self.orderDetailInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",dic);
            if ([dic[@"code"] isEqualToString:@"000"]) {
                [self.refreshHeader beginRefreshing];

                [self.view makeMessage:@"操作成功" duration:2.0f position:@"center"];

                
            }else
            {
                [self.view makeMessage:dic[@"errorMessage"] duration:2.0f position:@"center"];

                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
             [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
            
            
            
        }];
        
        
    } dismissAction:^{
        
        
    }];
    al.lastTextColor = [UIColor redColor];
    
    [al show];

}

#pragma mark CSPNormalSectionHeaderViewDelegate

- (void)sectionHeaderView:(CSPNormalSectionHeaderView *)sectionHeaderView reviewMerchantGoodsWithMerchantNo:(NSString *)merchantNo {
    
    
    
    MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
    detailVC.merchantNo =merchantNo;
    [self.navigationController pushViewController:detailVC animated:YES];
    

    
//    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:merchantNo pageNo:@1 pageSize:@20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSDictionary* dataDict = [dic objectForKey:@"data"];
//
//            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
//            MerchantListDetailsDTO* merchantDetails = [merchantListDTO.merchantList firstObject];
//            
//            MerchantDeatilViewController *detailVC = [[MerchantDeatilViewController alloc]init];
//            detailVC.merchantNo = merchantDetails.merchantNo;
//            [self.navigationController pushViewController:detailVC animated:YES];
//            
//            
//        } else {
//            
//            [self.view makeMessage:[NSString stringWithFormat:@"查询商家信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
//
//           
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
//    }];

}

- (void)sectionHeaderView:(CSPNormalSectionHeaderView *)sectionHeaderView enquiryWithMerchantName:(NSString *)merchantName andMerchantNo:(NSString *)merchantNo {
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString* jid = [dic objectForKey:@"data"];
            NSNumber *isExit = dic[@"data"][@"isExit"];
            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantName jid:jid withMerchantNo:merchantNo];
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


@end
