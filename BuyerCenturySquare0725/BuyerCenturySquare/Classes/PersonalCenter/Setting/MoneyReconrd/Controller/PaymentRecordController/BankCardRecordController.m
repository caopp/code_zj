//
//  BankCardRecordController.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BankCardRecordController.h"
#import "BankRecordCell.h"
#import "PaymentDetailController.h"//!详情
#import "LoginDTO.h"
#import "CreditTransferDTO.h"

@interface BankCardRecordController ()<UITableViewDataSource,UITableViewDelegate>
{

    UITableView *_tableView;
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView *refreshFooter;
    
    NSInteger pagrNo;
    NSInteger pageSize;
    
    NSMutableArray *dataArray;//!数据源
}
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation BankCardRecordController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    //!导航
    [self createNav];

    //!创建tableView
    [self createTableView];
    
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];


    // !创建刷新
    [self createRefresh];
    
    
}
#pragma mark 导航
-(void)createNav{


    //!左导航
    [self addCustombackButtonItem];

    self.title = @"银行卡转账充值记录";
    
    [self.view setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    
    
}
#pragma mark 创建tableView
-(void)createTableView{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - 20) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setBackgroundColor:[UIColor colorWithHexValue:0xf0f0f0 alpha:1]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return dataArray.count;

}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 52;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    BankRecordCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!cell) {
        
        cell =[[[NSBundle mainBundle]loadNibNamed:@"BankRecordCell" owner:self options:nil]lastObject];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (dataArray.count) {
        
        [cell configInfo:dataArray[indexPath.row]];
        
        
    }
    
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    CreditTransferDTO *dto = dataArray[indexPath.row];

    PaymentDetailController *detailVC = [[PaymentDetailController alloc]init];

    detailVC.auditNo = dto.auditNo;//!审核编号
    detailVC.isFromList = YES;//从列表进入的
    
    [self.navigationController pushViewController:detailVC animated:YES];

    
}

#pragma mark 请求数据
- (void)createRefresh{
    
    //!header
    refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:_tableView];
    
    __weak BankCardRecordController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadData:refreshHeader];
        
    };
    
    
    //!footer
    refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:_tableView];
    
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf loadData:refreshFooter];

    };
    
    
}

-(void)loadData:(SDRefreshView *)refresh{

    
    if (refresh == refreshHeader) {
        
        pagrNo = 1;
        
    }else{
    
        pagrNo ++;
    }
    pageSize = 20;
    
    NSDictionary *upDic = @{@"tokenId":[LoginDTO sharedInstance].tokenId,
                            @"pageNo":[NSNumber numberWithInteger:pagrNo],
                            @"pageSize":[NSNumber numberWithInteger:pageSize]};
    
    [HttpManager sendHttpRequestForCreditTransfer:upDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            if (dic[@"data"][@"list"]) {
                
                //!下拉刷新
                if (refresh == refreshHeader) {
                    
                    dataArray = [NSMutableArray arrayWithCapacity:0];
                }
                
                for (NSDictionary * infoDic in dic[@"data"][@"list"]) {
                    
                    CreditTransferDTO * dto = [[CreditTransferDTO alloc]initWithDictionary:infoDic];
                    [dataArray addObject:dto];
                    
                }
                
                [_tableView reloadData];
            }
        
        }
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];

        //!请求完数据 修改底部刷新提示
        if ([dic[@"data"][@"totalCount"] intValue] == dataArray.count) {
            
            [refreshFooter noDataRefresh];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        [refreshHeader endRefreshing];
        [refreshFooter endRefreshing];
        
        
    }];
    

}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self loadData:refreshHeader];


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
