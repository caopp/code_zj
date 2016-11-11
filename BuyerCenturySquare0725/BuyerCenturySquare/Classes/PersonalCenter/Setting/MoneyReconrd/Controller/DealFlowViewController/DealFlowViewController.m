//
//  DealFlowViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "DealFlowViewController.h"
#import "CustomBarButtonItem.h"
#import "DealFlowModel.h"

#import "RecordTableViewCell.h"

@interface DealFlowViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,strong)DealFlowModel *dealFlowModel;


@end

@implementation DealFlowViewController

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
    self.title =  @"预付货款充值记录";
    [self addCustombackButtonItem];
 
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

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
            self.dealFlowModel.totalCount = 1;
            [self buyRecordPageNo:self.dealFlowModel.totalCount];
            
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
        self.dealFlowModel.totalCount += 1;
        
        if (self.arr.count/pageSize >= self.dealFlowModel.totalCount) {
            [self buyRecordPageNo:self.dealFlowModel.totalCount];
        }else
        {
            [self buyRecordPageNo:self.dealFlowModel.totalCount];
        }
        
        [self.tableView reloadData];
        [self.refreshFooter endRefreshing];
    });
}

#pragma mark -----进行数据请求----
-(void)buyRecordPageNo:(NSInteger)pageNo
{
    
    [HttpManager sendHttpRequestForPaymentRecordPageNo:[NSNumber numberWithInteger:pageNo] pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        self.arr = [NSMutableArray arrayWithCapacity:0];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            
            //items个数
            for (NSDictionary *dicItems in dic[@"data"][@"items"]) {
                //每个items中字典个数
                DealFlowModel *downLoadRecordModel = [[DealFlowModel alloc]init];
                [downLoadRecordModel setValuesForKeysWithDictionary:dicItems];
                [self.arr addObject:downLoadRecordModel];
            }
            [self.tableView reloadData];
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
//        [self.view makeToast:NSLocalizedString(@"connectError", @"网络连接异常") duration:2.0f position:@"center"];
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];

    }];
    
}

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
        
    static NSString *cellIdentifier=@"RecordTableViewCell";
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RecordTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    RecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 1)];
    
    [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
    [cell.contentView addSubview:filterLabel];
    
    [cell setModelParameters:self.arr[indexPath.row]];


       return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}


@end
