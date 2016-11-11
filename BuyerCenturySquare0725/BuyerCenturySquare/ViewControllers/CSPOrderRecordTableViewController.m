//
//  CSPOrderRecordTableViewController.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/16/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPOrderRecordTableViewController.h"
#import "CSPOrderRecordTableViewCell.h"
#import "GetOrderListDTO.h"
#import "OrderGoodsItemDTO.h"
#import "CSPOrderDetailView.h"
#import "UIImageView+WebCache.h"
#import "TitleZoneGoodsTableViewCell.h"
#import "DeviceDBHelper.h"
@interface CSPOrderRecordTableViewController ()
{
    NSMutableArray *listArray_;
    NSInteger pageNo;
}
@property (nonatomic,strong) NSMutableArray *listArray;
@property (nonatomic, weak)  SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak)  SDRefreshFooterView *refreshFooter;
@end

@implementation CSPOrderRecordTableViewController
@synthesize listArray = listArray_;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"采购单记录";
    [self addCustombackButtonItem];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CSPOrderRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPOrderRecordTableViewCell"];
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPOrderRecordTableViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf refreshTableView:refreshHeader];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    
    self.refreshFooter = refreshFooter;
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf refreshTableView:refreshFooter];
        
    };
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    if (self.listArray.count) {
           return self.listArray.count;
    }else{
   
        return 1;
    }
 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.listArray.count) {
        CSPOrderRecordTableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOrderRecordTableViewCell" forIndexPath:indexPath];
        
        
        GetOrderDTO *getOrderDTO = [[GetOrderDTO alloc] init];
        OrderGoodsItemDTO *orderItemDTO = [[OrderGoodsItemDTO alloc] init];
        
        
        NSDictionary *Dictionary = [self.listArray objectAtIndex:indexPath.section];
        [getOrderDTO setDictFrom:Dictionary];
        
        if (getOrderDTO.type.intValue == 0) {
            orderCell.titleLabel.text = @"【期货单】";
            orderCell.titleLabel.textColor = HEX_COLOR(0x4B3185FF);
        }else{
            orderCell.titleLabel.text = @"【现货单】";
            orderCell.titleLabel.textColor = HEX_COLOR(0x5677FCFF);
        }
        
        orderCell.orderNumber.text = getOrderDTO.orderCode;
        NSNumber * refundStatus = [Dictionary objectForKey:@"refundStatus"];
        NSNumber *status = [Dictionary objectForKey:@"status"];
        NSString *statusstr = [refundStatus isKindOfClass:[NSNumber class]]?[[DeviceDBHelper sharedInstance] refundStatusWith:[refundStatus intValue]]:[[DeviceDBHelper sharedInstance] statusWith:[status intValue] ];
        orderCell.accountLabel.text = [NSString stringWithFormat:@"%@ ￥%@",statusstr,[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
        [orderCell.accountLabel sizeToFit];
        for (UIView *view in orderCell.scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        long count = [getOrderDTO.orderGoodsItemsList count];
        NSLog(@"The orderGoodsItemsList count is %ld\n",count);
        
        orderCell.scrollView.contentSize = CGSizeMake(70*count-10, 100);
        for( int index =0; index <count; index ++){
            NSDictionary *Dictionary = [getOrderDTO.orderGoodsItemsList objectAtIndex:index];
            [orderItemDTO setDictFrom:Dictionary];
            
            
            CSPOrderDetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"CSPOrderDetailView" owner:self options:nil] objectAtIndex:0];
            
            [view.titleImageView sd_setImageWithURL:[NSURL URLWithString:orderItemDTO.picUrl] ];
            view.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[CSPUtils stringFromNumber:orderItemDTO.price]];
            view.countLabel.text = [NSString stringWithFormat:@"x%@",orderItemDTO.quantity.stringValue];
            //            NSLog(@"The goodsNo is %@\n",orderItemDTO.goodsNo);
            view.frame =  CGRectMake(index*70, 0, 60, 60);
            [orderCell.scrollView addSubview:view];
           
        }
         orderCell.scrollView.userInteractionEnabled = NO;
        
        return orderCell;
    }else{
        TitleZoneGoodsTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        
        
        cell = [[TitleZoneGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
        cell.titleLabel.text = @"暂无相关采购单";
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor clearColor]];
        
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.showsHorizontalScrollIndicator = NO;
        return cell;
    }
  
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.listArray.count) {
        return 148;
    }else{
        return self.view.frame.size.height;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 9;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = [self.listArray objectAtIndex:indexPath.section];
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dictionary setObject:[dic objectForKey:@"orderGoodsItems"] forKey:@"goodsList"];
     [dictionary setObject:[dic objectForKey:@"totalAmount"] forKey:@"originalTotalAmount"];
    self.reOrderSendBlock(dictionary)
    ;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)refreshTableView:(SDRefreshView *)refresh
{
    NSNumber *pageSize = [[NSNumber alloc] initWithInt:15];
    if (refresh == self.refreshHeader) {
        
        pageNo = 1;
        
    }else{
        
        pageNo ++;
    }
    if (self.merchantNo == nil) {
        [self.refreshHeader endRefreshing];
        return;
    }
    NSNumber *numberNo = [[NSNumber alloc] initWithInteger:pageNo];
    [HttpManager sendHttpRequestForGetOrderByMerchant:self.merchantNo pageNo:numberNo pageSize:pageSize  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
      
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            //参数需要保存
            GetOrderListDTO *getOrderListDTO = [[GetOrderListDTO alloc] init];
            getOrderListDTO.getOrderDTOList = [[dic objectForKey:@"data"] objectForKey:@"orderList"];
             if (refresh == self.refreshHeader) {
                 self.listArray = [[NSMutableArray alloc] initWithArray:getOrderListDTO.getOrderDTOList];
             }else{
               [self.listArray addObjectsFromArray:getOrderListDTO.getOrderDTOList];
             }
         
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            NSLog(@"totalCount==%@===%ld",dic[@"data"][@"totalCount"],self.listArray.count);
            //!请求完数据 修改底部刷新提示
            if ([dic[@"data"][@"totalCount"] intValue] == self.listArray.count) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            [self.tableView reloadData];
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请求失败" message:[dic objectForKey:@"errorMessage"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [self.refreshHeader endRefreshing];
            [alert show];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"error = %@",[NSString stringWithFormat:@"%@",error]);
        NSLog(@"The error description is %@\n",[error localizedDescription]);
        [self.refreshHeader endRefreshing];
    }];

}


@end
