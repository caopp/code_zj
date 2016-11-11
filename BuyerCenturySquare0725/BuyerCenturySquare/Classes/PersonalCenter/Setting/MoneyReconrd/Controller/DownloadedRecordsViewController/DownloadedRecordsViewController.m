//
//  DownloadedRecordsViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "DownloadedRecordsViewController.h"
#import "DealViewCell.h"
#import "CustomBarButtonItem.h"
#import "DownLoadRecordModel.h"



@interface DownloadedRecordsViewController ()<UITableViewDelegate,UITableViewDataSource>

{
    NSNumber *lastPageNo;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,strong)NSMutableDictionary *dicArr;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic,strong)DownLoadRecordModel *downLoadRecordModel;

@property (nonatomic,strong)UILabel *recordLabel;



@end

@implementation DownloadedRecordsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"下载次数购买记录";
    //添加按钮
    [self addCustombackButtonItem];
    //!table
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    //暂无相关记录
    self.recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.recordLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.recordLabel.text = @"暂无相关记录";
    self.recordLabel.hidden = YES;
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
    self.recordLabel.textColor = [UIColor colorWithHexValue:0xbbbbbb alpha:1];
    self.recordLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.recordLabel];
    
    
    
    
    
    
    //刷新数据
    [self createHeaderRefresh];
    //加载数据
    [self loadDownDataRefresh];
}


#pragma mark !创建刷新
-(void)createHeaderRefresh{
     SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    [refreshHeader addToScrollView:self.tableView];
    
    _refreshHeader = refreshHeader;
    
    __weak SDRefreshHeaderView *weakRefreshHeader = refreshHeader;
    refreshHeader.beginRefreshingOperation = ^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.downLoadRecordModel.totalCount = 1;
            [self getPaymentRecordsPageNo:[NSNumber numberWithInteger:self.downLoadRecordModel.totalCount]];

            [self.tableView reloadData];
            [weakRefreshHeader endRefreshing];
        });
    };
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
}

#pragma mark !加载数据
-(void)loadDownDataRefresh
{
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    [refreshFooter addTarget:self refreshAction:@selector(footerRefresh)];
    _refreshFooter = refreshFooter;
}
- (void)footerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.downLoadRecordModel.totalCount += 1;
        lastPageNo = [NSNumber numberWithInteger:self.downLoadRecordModel.totalCount];
        
        
        if (self.arr.count/pageSize >= self.downLoadRecordModel.totalCount) {
              [self getPaymentRecordsPageNo:[NSNumber numberWithInteger:self.downLoadRecordModel.totalCount]];
        }else
        {
          [self getPaymentRecordsPageNo:[NSNumber numberWithInteger:self.downLoadRecordModel.totalCount]];
        }
    
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}


#pragma mark -----进行数据请求----
- (void)getPaymentRecordsPageNo:(NSNumber*)pageNo  {
    [HttpManager sendHttpRequestForBuyRecordPageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize]  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.arr = [NSMutableArray arrayWithCapacity:0];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            
            NSDictionary *dict =  dic[@"data"][@"items"];
            if( dict.count == 0)
            {
//                [self.view makeMessage:@"暂无相关记录" duration:2.0f position:@"center"];
                
                self.recordLabel.hidden = NO;

            }
        
            //items个数
            for (NSDictionary *dicItems in dic[@"data"][@"items"]) {
                //每个items中字典个数
                self.downLoadRecordModel = [[DownLoadRecordModel alloc]init];
                [self.downLoadRecordModel setValuesForKeysWithDictionary:dicItems];
                
                [self.arr addObject:self.downLoadRecordModel];
                self.recordLabel.hidden = YES;

            }

            
            [self.tableView reloadData];
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            //!没有数据的时候
            NSNumber * pageNo = [NSNumber numberWithInteger:(self.arr.count/pageSize) + 1];
            
            if ([pageNo intValue] == [lastPageNo intValue]) {
                
                [self.refreshFooter noDataRefresh];
                
            }

           
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.view makeMessage:NSLocalizedString(@"connectError", @"网络连接异常") duration:2.0f position:@"center"];
             [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];

};

    




/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    self.navigationItem.leftBarButtonItem = [[CustomBarButtonItem alloc]initWithCustomView:[CustomViews leftBackBtnMethod:@selector(backBarButtonClick) target:self]];

}


-(void)backBarButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier=@"DealViewCell";
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"DealViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    DealViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 1)];
    
    [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
    [cell.contentView addSubview:filterLabel];
    
    NSDictionary *dict = self.arr[indexPath.row];
    
     [cell settingModelParameters:self.arr[indexPath.row]];
   
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}
@end
