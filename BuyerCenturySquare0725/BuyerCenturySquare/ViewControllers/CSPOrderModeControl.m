
//
//  CSPOrderModeControl.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderModeControl.h"
#import "CSPBaseOrderTableViewCell.h"
#import "CSPNormalOrderTableViewCell.h"
#import "CSPSampleOrderTableViewCell.h"
#import "CSPMailCartTableViewCell.h"
#import "CSPOrderSectionHeaderView.h"
#import "CSPOrderSectionFooterView.h"
#import "OrderGroupListDTO.h"
#import "OrderAddDTO.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "GUAAlertView.h"


@interface CSPOrderModeControl () <CSPOrderSectionFooterViewActionDelegate,UIActionSheetDelegate, CSPOrderSectionHeaderViewDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) OrderGroupListDTO* orderListOfAll;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfToPay;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfToDispatch;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfToTakeDelivery;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfDealComplete;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfDealCancel;
@property (nonatomic, strong) OrderGroupListDTO* orderListOfOrderCancel;

@property (nonatomic, strong) OrderGroup* groupOfPrepareToCancel;
@property (nonatomic, assign) BOOL shouldUpdateToDispatchGroup;
@property (nonatomic, strong) OrderGroup* groupOfPrepareToConfirmTakeDelivery;
@property (nonatomic, assign) BOOL shouldUpdateCompleteGroup;
@property (nonatomic, assign) BOOL shouldUpdateAllGroup;

@property (nonatomic, weak)  SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak)  SDRefreshFooterView *refreshFooter;

@end

@implementation CSPOrderModeControl

static NSString* reuseOrderInfoIdentifier = @"orderInfoCell";
static NSString* reuseOrderActionFooterIdentifier = @"orderActionFooterView";
static NSString* reuseOrderActionHeaderIdentifier = @"orderActionHeaderView";

- (id)initWithTableView:(UITableView*)tableView {
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    
    return self;
}


- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPOrderModeControl * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadNewOrderList];
    };
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
            
        [weakSelf loadMoreOrderList];
    };

    UINib *sectionHeaderNib = [UINib nibWithNibName:@"OrderSectionHeaderView" bundle:nil];
    [_tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:reuseOrderActionHeaderIdentifier];

    UINib *sectionFooterNib = [UINib nibWithNibName:@"OrderSectionFooterView" bundle:nil];
    [_tableView registerNib:sectionFooterNib forHeaderFooterViewReuseIdentifier:reuseOrderActionFooterIdentifier];

}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self orderGroupForSection:section].goodsList.count == 0) {
        return 1;
        
    }
    else{
        return [self orderGroupForSection:section].goodsList.count;;
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self orderListForCurrentSegment].groupList.count) {
        return [self orderListForCurrentSegment].groupList.count;

    }else{
        return 1;
        
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPBaseOrderTableViewCell *cell = nil;
    OrderGoods* orderGoods = [self orderGoodsForRowAtIndexPath:indexPath];
    tableView.showsVerticalScrollIndicator = YES;

    cell.textLabel.text = nil;
    if ([self orderGroupForSection:indexPath.section].goodsList.count == 0) {
        TitleZoneGoodsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        

        cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];

        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        
        
        return cell;
        
        
    }else{
    
    switch (orderGoods.cartGoodsType) {
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
}
    // Configure the cell...
    cell.orderGoodsInfo = orderGoods;

    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    
    OrderGroup* orderGroupInfo = [self orderGroupForSection:indexPath.section];
    
    
    if ([self orderGroupForSection:indexPath.section].goodsList.count == 0) {
    }
    else{
     
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedOrderGroup:)]) {
            
            [self.delegate selectedOrderGroup:orderGroupInfo];
        }
    }

    
    
   }

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if ([self orderGroupForSection:section].goodsList.count == 0) {
        return nil;
    }
    else{
        CSPOrderSectionHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseOrderActionHeaderIdentifier];
        
        headerView.delegate = self;
//        headerView.contentView.backgroundColor = [UIColor whiteColor];
        headerView.orderGroupInfo = [self orderGroupForSection:section];
        
        return headerView;
        
    }

    
 }

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    if ([self orderGroupForSection:section].goodsList.count == 0) {
        return nil;
    }
    else{
        CSPOrderSectionFooterView* footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseOrderActionFooterIdentifier];
        
//        footerView.contentView.backgroundColor = [UIColor whiteColor];
        footerView.orderGroupInfo = [self orderGroupForSection:section];
        footerView.delegate = self;
        
        return footerView;
        
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if ([self orderGroupForSection:section].goodsList.count == 0) {
        return 0;
    }
    else{
        return [CSPOrderSectionFooterView sectionFooterHeightWithOrderMode:[self orderGroupForSection:section].orderMode];

        
    }

   }

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self orderGroupForSection:section].goodsList.count == 0) {
        return 0.01;
    }
    else{
        return [CSPOrderSectionHeaderView sectionHeaderHeight];
        
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderGoods* orderGoodsInfo = [self orderGoodsForRowAtIndexPath:indexPath];
    
    if ([self orderGroupForSection:indexPath.section].goodsList.count == 0) {
        return self.view.frame.size.height;
        
    }else
    {
        if (orderGoodsInfo) {
            return [CSPBaseOrderTableViewCell cellHeightWithSizesCount:orderGoodsInfo.sizes.count];

            
        }
    }
    
  
    return 119.0f;
}

#pragma mark -
#pragma mark SMSegmentViewDelegate

- (void)segmentView:(SMSegmentView *)segmentView didSelectSegmentAtIndex:(NSInteger)index {
    switch (index) {
        case 0:
            self.orderMode = CSPOrderModeAll;
            break;
        case 1:
            self.orderMode = CSPOrderModeToPay;
            break;
        case 2:
            self.orderMode = CSPOrderModeToDispatch;
            break;
        case 3:
            self.orderMode = CSPOrderModeToTakeDelivery;
            break;
        case 4:
            self.orderMode = CSPOrderModeDealCompleted;
            break;
        case 5:
            self.orderMode = CSPOrderModeOrderCanceled;
            break;
        case 6:
            self.orderMode = CSPOrderModeDealCanceled;
            break;
        default:
            break;
    }
    [self reloadCurrentSegmentOrderList];
}
/**
 *  CSPOrderSegmentView 标题按钮视图的delegate
 *
 *  @param index 按钮的标志
 */
- (void)OrderSegmentViewClick:(NSInteger)index {
    
    switch (index) {
        case 0:
            self.orderMode = CSPOrderModeAll;//全部
            break;
        case 1:
            self.orderMode = CSPOrderModeToPay;//待付款
            break;
        case 2:
            self.orderMode = CSPOrderModeToDispatch;//待发货
            break;
        case 3:
            self.orderMode = CSPOrderModeToTakeDelivery;//待收货
            break;
        case 4:
            self.orderMode = CSPOrderModeDealCompleted;//交易完成
            break;
        case 5:
            self.orderMode = CSPOrderModeOrderCanceled;//采购单取消
            break;
        case 6:
            self.orderMode = CSPOrderModeDealCanceled;//交易完成
            break;
        default:
            break;
    }

    [self reloadCurrentSegmentOrderList];
}

/**
 *  每种状态所执行的操作
 */
- (void)reloadCurrentSegmentOrderList {
    
    //数据模型，用于填充数据。
    OrderGroupListDTO* selectedOrderGroupList = [self orderListForCurrentSegment];
    
    
    if (!selectedOrderGroupList || selectedOrderGroupList.groupList.count == 0) {
        //下拉刷新 请求数据
        [self.refreshHeader beginRefreshing];
        
    } else if (self.orderMode == CSPOrderModeToDispatch && self.shouldUpdateToDispatchGroup) {//待发货
        
        [self.refreshHeader beginRefreshing];
        self.shouldUpdateToDispatchGroup = NO;
    } else if (self.orderMode == CSPOrderModeDealCompleted && self.shouldUpdateCompleteGroup) {//交易完成
        [self.refreshHeader beginRefreshing];
        self.shouldUpdateCompleteGroup = NO;
    } else if (self.orderMode == CSPOrderModeAll && self.shouldUpdateAllGroup) {//全部
        [self.refreshHeader beginRefreshing];
        self.shouldUpdateAllGroup = NO;
    }
    else {

        [self.tableView reloadData];
    }
}


/**
 *  选择数据那种数据
 *
 *  @return 数据模型
 */
- (OrderGroupListDTO*)orderListForCurrentSegment {
    
    OrderGroupListDTO* selectedOrderGroupList = nil;
    switch (self.orderMode) {
        case CSPOrderModeAll:
            
            selectedOrderGroupList = self.orderListOfAll;
            break;
        case CSPOrderModeToPay:
            selectedOrderGroupList = self.orderListOfToPay;
            break;
        case CSPOrderModeToDispatch:
            selectedOrderGroupList = self.orderListOfToDispatch;
            break;
        case CSPOrderModeToTakeDelivery:
            selectedOrderGroupList = self.orderListOfToTakeDelivery;
            NSLog(@"orderListOfToTakeDelivery = %@",self.orderListOfToTakeDelivery);
            
            break;
        case CSPOrderModeDealCanceled:
            selectedOrderGroupList = self.orderListOfDealCancel;
            break;
        case CSPOrderModeOrderCanceled:
            selectedOrderGroupList = self.orderListOfOrderCancel;
            break;
        case CSPOrderModeDealCompleted:
            selectedOrderGroupList = self.orderListOfDealComplete;
            break;
        default:
            break;
    }

    return selectedOrderGroupList;
}


//返回section个数
- (OrderGroup*)orderGroupForSection:(NSInteger)section {

    OrderGroup* orderGroup = nil;
    OrderGroupListDTO* selectedOrderGroupList = [self orderListForCurrentSegment];
    if (selectedOrderGroupList && section < selectedOrderGroupList.groupList.count) {
        orderGroup = selectedOrderGroupList.groupList[section];
    }

    return orderGroup;
}

- (OrderGoods*)orderGoodsForRowAtIndexPath:(NSIndexPath*)indexPath {

    OrderGoods* orderGoods = nil;

    OrderGroup* orderGroup = [self orderGroupForSection:indexPath.section];
    
    if (orderGroup && indexPath.row < orderGroup.goodsList.count) {
        orderGoods = orderGroup.goodsList[indexPath.row];
    } else {
        NSLog(@"错误: 采购单列表中的商品数量错误");
    }

    return orderGoods;
}
#pragma mark 请求单个或者全部采购单
//请求数据 代理返回值
- (void)getOrderListWithOrderStatus:(NSString*)orderStatus pageNo:(NSInteger)pageNo complete:(void (^)(OrderGroupListDTO* orderGroupList))complete {
    [HttpManager sendHttpRequestForOrderListWithOrderStatus:orderStatus pageNo:[NSNumber numberWithInteger:pageNo] pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        OrderGroupListDTO* orderGroupList;
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            DebugLog(@"%@", dic);
            

           orderGroupList  = [[OrderGroupListDTO alloc]initWithDictionary:dic[@"data"]];
            complete(orderGroupList);
            
            [self.tableView reloadData];
            
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询采购单失败,%@",[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            return ;
            
        }

        [self.refreshHeader endRefreshing];
        NSNumber * totalCount =dic[@"data"][@"totalCount"];
           NSInteger count =  [self orderListForCurrentSegment].groupList.count;
        
    if (totalCount.integerValue== count) {
            
            [self.refreshFooter   noDataRefresh];
            
            
        }else
        {
            [self.refreshFooter endRefreshing];

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];

        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];

}
/**
 *  下拉时 请求数据
 */
- (void)loadNewOrderList {
    
    
    //所有
    if (self.orderMode == CSPOrderModeAll) {//全部
        [self getOrderListWithOrderStatus:nil pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfAll = orderGroupList;
            
            if (self.orderListOfAll.totalCount == 0) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(withoutAnyOrder)]) {
                    [self.delegate withoutAnyOrder];
                }
            }

        }];
        //
    } else if (self.orderMode == CSPOrderModeToPay) {//待付款
        [self getOrderListWithOrderStatus:@"1" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfToPay = orderGroupList;
        }];
    } else if (self.orderMode == CSPOrderModeToDispatch) {//待发货
        [self getOrderListWithOrderStatus:@"2" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfToDispatch = orderGroupList;
        }];
    } else if (self.orderMode == CSPOrderModeToTakeDelivery) {//待收货
        [self getOrderListWithOrderStatus:@"3" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfToTakeDelivery = orderGroupList;
        }];
        
    } else if (self.orderMode == CSPOrderModeOrderCanceled) {//采购单取消
        [self getOrderListWithOrderStatus:@"0" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfOrderCancel = orderGroupList;
        }];
    } else if (self.orderMode == CSPOrderModeDealCanceled) {//交易取消
        [self getOrderListWithOrderStatus:@"4" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfDealCancel = orderGroupList;
        }];
    } else if (self.orderMode == CSPOrderModeDealCompleted) {//交易完成
        [self getOrderListWithOrderStatus:@"5" pageNo:1 complete:^(OrderGroupListDTO *orderGroupList) {
            self.orderListOfDealComplete = orderGroupList;
        }];
    }
}

//上拉时 请求数据 并给你每一个参数传值
- (void)loadMoreOrderList {
    if (self.orderMode == CSPOrderModeAll) {
        if ([self.orderListOfAll isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:nil pageNo:[self.orderListOfAll nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfAll.totalCount = orderGroupList.totalCount;
                
                [self.orderListOfAll.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeToPay) {

        if ([self.orderListOfToPay isLoadedAll]) {
//            [self.tableView.footer noticeNoMoreData];
            [self.refreshFooter endRefreshing];
            
            
        
        } else {
            [self getOrderListWithOrderStatus:@"1" pageNo:[self.orderListOfToPay nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfToPay.totalCount = orderGroupList.totalCount;
                [self.orderListOfToPay.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeToDispatch) {

        if ([self.orderListOfToDispatch isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:@"2" pageNo:[self.orderListOfToDispatch nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfToDispatch.totalCount = orderGroupList.totalCount;
                [self.orderListOfToDispatch.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeToTakeDelivery) {

        if ([self.orderListOfToTakeDelivery isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:@"3" pageNo:[self.orderListOfToTakeDelivery nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfToTakeDelivery.totalCount = orderGroupList.totalCount;
                [self.orderListOfToTakeDelivery.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeOrderCanceled) {

        if ([self.orderListOfOrderCancel isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:@"0" pageNo:[self.orderListOfOrderCancel nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfOrderCancel.totalCount = orderGroupList.totalCount;
                [self.orderListOfOrderCancel.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeDealCanceled) {
        if ([self.orderListOfDealCancel isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:@"4" pageNo:[self.orderListOfDealCancel nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfDealCancel.totalCount = orderGroupList.totalCount;
                [self.orderListOfDealCancel.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    } else if (self.orderMode == CSPOrderModeDealCompleted) {
        if ([self.orderListOfDealComplete isLoadedAll]) {
            [self.refreshFooter endRefreshing];

//            [self.tableView.footer noticeNoMoreData];
        } else {
            [self getOrderListWithOrderStatus:@"5" pageNo:[self.orderListOfDealComplete nextPage] complete:^(OrderGroupListDTO *orderGroupList) {

                self.orderListOfDealComplete.totalCount = orderGroupList.totalCount;
                [self.orderListOfDealComplete.groupList addObjectsFromArray:orderGroupList.groupList];
            }];
        }
    }

}

- (void)removeCanceledUnpaidOrder:(OrderGroup *)orderGroupInfo {
    [self.orderListOfToPay removeOrderGroup:orderGroupInfo];
}

- (void)removeTakenDeliveryOrder:(OrderGroup*)orderGroupInfo {
    [self.orderListOfToTakeDelivery removeOrderGroup:orderGroupInfo];
}



//取消采购单
- (void)doCancelActionWithUnpaidOrder:(OrderGroup*)orderGroupInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    

    
    [HttpManager sendHttpRequestForOrderCancelUnpaid:orderGroupInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        

        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self removeCanceledUnpaidOrder:orderGroupInfo];

            self.shouldUpdateAllGroup = YES;
            self.shouldUpdateToDispatchGroup = YES;

            [self reloadCurrentSegmentOrderList];

            [self.view makeMessage:@"取消采购单成功" duration:2.0f position:@"center"];

        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"取消采购单失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

            
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
    }];
}

//确认收货
- (void)doConfirmTakeDeliveryActionWithOrder:(OrderGroup*)orderGroupInfo {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [HttpManager sendHttpRequestForOrderReceived:orderGroupInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            [self removeTakenDeliveryOrder:orderGroupInfo];

            self.shouldUpdateAllGroup = YES;
            self.shouldUpdateCompleteGroup = YES;

            [self reloadCurrentSegmentOrderList];

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

#pragma mark -
#pragma mark UIAlertViewDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"是"]) {
        if (self.groupOfPrepareToCancel) {
            [self doCancelActionWithUnpaidOrder:self.groupOfPrepareToCancel];
            self.groupOfPrepareToCancel = nil;
        } else if (self.groupOfPrepareToConfirmTakeDelivery) {
            [self doConfirmTakeDeliveryActionWithOrder:self.groupOfPrepareToConfirmTakeDelivery];
            self.groupOfPrepareToConfirmTakeDelivery = nil;
        }
    }
}

/**
 *  alertView的delegate方法
 *
 *  @param alertView
 *  @param buttonIndex  
 */
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.groupOfPrepareToCancel = nil;
    self.groupOfPrepareToConfirmTakeDelivery = nil;
}

#pragma mark CSPOrderSectionFooterViewActionDelegate

- (void)payButtonClickedForOrderGroup:(OrderGroup *)orderGroupInfo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(prepareToPayForOrder:)]) {

        [self.delegate prepareToPayForOrder:orderGroupInfo.orderCode];
    }
}

//取消采购单
- (void)cancelUnpaidOrder:(OrderGroup *)orderGroupInfo {

    self.groupOfPrepareToCancel = orderGroupInfo;

    
    GUAAlertView *cancelOrderAl = [GUAAlertView alertViewWithTitle:@"是否取消采购单？" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"确认" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        if (self.groupOfPrepareToCancel) {
            [self doCancelActionWithUnpaidOrder:self.groupOfPrepareToCancel];
            self.groupOfPrepareToCancel = nil;
        }
        
        
    } dismissAction:^{
        
    }];
    
    [cancelOrderAl show];
    
    
    
    
}


//延期收货
- (void)postponeGoods:(OrderGroup *)orderGroupInfo
{
    NSString *messageStr = [NSString stringWithFormat:@"剩余延期次数: %lu",orderGroupInfo.balanceQuantity];
    GUAAlertView *al = [GUAAlertView alertViewWithTitle:@"确定延长时间收货？" withTitleClor:nil message:messageStr withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [HttpManager sendHttpRequestForSetOrderAutoConfirm:orderGroupInfo.orderCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSLog(@"%@",dic);
            if ([dic[@"code"] isEqualToString:@"000"]) {
                [self.view makeMessage:@"操作成功" duration:2.0f position:@"center"];

                [self.refreshHeader beginRefreshing];

            }else
            {
                [self.view makeMessage:dic[@"errorMessage"] duration:2.0f position:@"center"];

               

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

//确认收货
- (void)confirmTakeDeliveryForOrder:(OrderGroup *)orderGroupInfo {

    self.groupOfPrepareToConfirmTakeDelivery = orderGroupInfo;

//    UIActionSheet* actionSheet = [[UIActionSheet alloc]initWithTitle:@"是否确认收货?" delegate:self cancelButtonTitle:@"否" destructiveButtonTitle:nil otherButtonTitles:@"是", nil];
//    [actionSheet showInView:self.view];
    
    GUAAlertView *sureGoods = [GUAAlertView alertViewWithTitle:@"是否确认收货?" withTitleClor:nil message:nil withMessageColor:nil oKButtonTitle:@"是" withOkButtonColor:nil cancelButtonTitle:@"否" withOkCancelColor:nil withView:self.view buttonTouchedAction:^{
        
        if (self.groupOfPrepareToConfirmTakeDelivery) {
            [self doConfirmTakeDeliveryActionWithOrder:self.groupOfPrepareToConfirmTakeDelivery];
            self.groupOfPrepareToConfirmTakeDelivery = nil;
        }

    } dismissAction:^{
        
    }];
    [sureGoods show];
    
}

#pragma mark - CSPOrderSectionHeaderViewDelegate
#pragma mark 

-(void)refreshOrder
{
    [self.refreshHeader beginRefreshing];
}

//点击客服
- (void)sectionHeaderView:(CSPOrderSectionHeaderView*)sectionHeaderView enquiryWithMerchantName:(NSString*)merchantName andMerchantNo:(NSString *)merchantNo {
    if (self.delegate && [self.delegate respondsToSelector:@selector(enquiryWithMerchantName:andMerchantNo:)]) {
        [self.delegate enquiryWithMerchantName:merchantName andMerchantNo:merchantNo];
    }
}

//点击商品名称

- (void)CSPOrderSectionHeaderView:(CSPOrderSectionHeaderView *)sectionHeaderView merchanName:(NSString *)merchant merchantNo:(NSString *)merchantNo
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(CSPOrderModeJumpNextMerchanName:merchanNo:)]) {
        [self.delegate CSPOrderModeJumpNextMerchanName:merchant merchanNo:merchantNo];
        
        
    }
}

@end
