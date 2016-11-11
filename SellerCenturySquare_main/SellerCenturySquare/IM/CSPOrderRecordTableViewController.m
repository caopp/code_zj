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
#import "SDRefresh.h"
#import "GetOrderDTO.h"
#import "CSPUtils.h"
#import "CustomBarButtonItem.h"
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
        
        switch (getOrderDTO.status.intValue) {//0-采购单取消;1-未付款;2-未发货;3-已发货;4-交易取消;5-已签收
            case 0:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"采购单取消￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
            case 1:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"待付款￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
            case 2:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"待发货￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
            case 3:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"待收货￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
            case 4:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"交易取消￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
            case 5:
                orderCell.accountLabel.text = [NSString stringWithFormat:@"交易完成￥%@",[CSPUtils stringFromNumber:getOrderDTO.totalAmount]];
                break;
                
            default:
                break;
        }
        
        for (UIView *view in orderCell.scrollView.subviews) {
            [view removeFromSuperview];
        }
        
        long count = [getOrderDTO.goodsList count];
        NSLog(@"The orderGoodsItemsList count is %ld\n",count);
        
        orderCell.scrollView.contentSize = CGSizeMake(70*count-10, 100);
        for( int index =0; index <count; index ++){
            //orderGoodsItemDTO *orderItem = [[orderGoodsItemDTO alloc] init];
            orderGoodsItemDTO *orderItem = [getOrderDTO.goodsList objectAtIndex:index];
            //[orderItem setDictFrom:Dictionary];
            
            
            CSPOrderDetailView *view = [[[NSBundle mainBundle] loadNibNamed:@"CSPOrderDetailView" owner:self options:nil] objectAtIndex:0];
            
            [view.titleImageView sd_setImageWithURL:[NSURL URLWithString:orderItem.picUrl] ];
            view.moneyLabel.text = [NSString stringWithFormat:@"￥%@",[CSPUtils stringFromNumber:orderItem.price]];
            view.countLabel.text = [NSString stringWithFormat:@"x%@",orderItem.quantity.stringValue];
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
    NSNumber *pageNumberNo = [[NSNumber alloc] initWithInteger:pageNo];
    if (self.memberNo == nil) {
        [self.refreshHeader endRefreshing];
        return;
    }
    
    [HttpManager sendHttpRequestForGetOrderByMemberNo:self.memberNo pageNo:pageNumberNo pageSize:pageSize  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"dic = %@",dic);
        
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


/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    CustomBarButtonItem *backBarButton = [[CustomBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"04_商家中心_设置_后退"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick:)];
    self.navigationItem.leftBarButtonItem = backBarButton;
    
    
}

@end
