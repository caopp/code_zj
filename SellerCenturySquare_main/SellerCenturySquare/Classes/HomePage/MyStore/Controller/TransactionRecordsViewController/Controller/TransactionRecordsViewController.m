//
//  TransactionRecordsViewController.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "TransactionRecordsViewController.h"
#import "RecordsTableViewCell.h"
#import "TransactionRecordsModel.h"
#import "CustomBarButtonItem.h"
//进行刷新
#import "RefreshControl.h"
#import "SDRefresh.h"

@interface TransactionRecordsViewController ()<UITableViewDelegate,UITableViewDataSource,RefreshControlDelegate>
{
    //设置页面个数
//    NSInteger _pageNo;
    NSNumber * lastPageNo;//上一次请求的页码

}
//储存数据数组
@property (nonatomic,strong)NSMutableArray *arr;
//tableView
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//刷新属性
@property(nonatomic,strong)RefreshControl *refreshControl;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;
@property(nonatomic,strong)TransactionRecordsModel *downLoadRecordModel;


@property (nonatomic,strong)UILabel *recordLabel;


@end

@implementation TransactionRecordsViewController
const NSInteger pageSize = 20;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =  @"下载次数购买记录";
    //tableView的代理
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    
    
    

    //添加返回按钮
    [self addCustombackButtonItem];
    //初始化刷新代理方法
    self.refreshControl = [[RefreshControl alloc]initWithScrollView:self.tableView delegate:self];
    self.refreshControl.topEnabled = YES;
    
    // !创建刷新
    [self createRefresh];
    
    //暂无相关记录
    self.recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.recordLabel.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
    self.recordLabel.text = @"暂无相关记录";
    self.recordLabel.hidden = YES;
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
    self.recordLabel.textColor = [UIColor colorWithHexValue:0xbbbbbb alpha:1];
    self.recordLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.recordLabel];
    
    
    
    
    
}
// !创建刷新
- (void)createRefresh{
    
    //!header
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak TransactionRecordsViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        [weakSelf loadNewMerchantList];
        
    };
    
    //!footer
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    refreshFooter.beginRefreshingOperation = ^{
        [weakSelf loadMoreMerchantList];
    };
}
// !上拉加载
- (void)loadMoreMerchantList {
    
    NSNumber * pageNo = [NSNumber numberWithInteger:(_downLoadRecordModel.totalCount /pageSize) + 1];
    
    if ([pageNo intValue] == [lastPageNo intValue]) {
        
        [self.refreshFooter endRefreshing];
        return ;
        
    }else{
        
        lastPageNo = pageNo;
    }
       [self requestDataPageNo:pageNo];
    
}

- (void)loadNewMerchantList {
    
     lastPageNo = @1;
     [self requestDataPageNo:@1];
}


#pragma mark -----数据进行请求----
-(void)requestDataPageNo:(NSNumber*)pageNo
{
    @try {
        
        [HttpManager sendHttpRequestForBuyRecordPageNo:pageNo pageSize:[NSNumber numberWithInteger:20] success:^(AFHTTPRequestOperation *operation, id requestObject) {
            
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:requestObject options:NSJSONReadingAllowFragments error:nil];
            
            self.arr = [NSMutableArray arrayWithCapacity:0];
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                NSDictionary *dict =  dic[@"data"][@"items"];
                if( dict.count == 0)
                {
                    self.recordLabel.hidden = NO;
                    
                }
                
                
                //items个数
                for (NSDictionary *dicItems in dic[@"data"][@"items"]) {
                    //每个items中字典个数
                    _downLoadRecordModel = [[TransactionRecordsModel alloc]init];
                    
                    [_downLoadRecordModel setValuesForKeysWithDictionary:dicItems];
                    [self.arr addObject:_downLoadRecordModel];
                     self.recordLabel.hidden = YES;
                }
                //结束刷新
                [self.refreshControl finishRefreshingDirection:RefreshDirectionTop];
                //根据返回来个数对上拉加载模式的开启或关闭进行判断。
                if (self.arr.count >= 20) {
                    self.refreshControl.bottomEnabled = YES;
                }else
                {
                    self.refreshControl.bottomEnabled = NO;
                }
                [self.tableView reloadData];
            }
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            //!没有数据的时候
            NSNumber * pageNo = [NSNumber numberWithInteger:(_downLoadRecordModel.totalCount /pageSize) + 1];
            
            if ([pageNo intValue] == [lastPageNo intValue]) {
                
                [self.refreshFooter noDataRefresh];
                
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            //如果请求失败，侧结束加载模式
            [self.refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        }];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}





#pragma mark ----返回按钮的设置----
/**
 *  设置后退按钮
 */
-(void)addCustombackButtonItem{
    
    CustomBarButtonItem *backBarButton = [[CustomBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"public_nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonClick)];
    
    self.navigationItem.leftBarButtonItem = backBarButton;
    
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
    
    static NSString *cellIdentifier=@"RecordsTableViewCell";
    BOOL nibsRegistered=NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"RecordsTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
        nibsRegistered = YES;
    }
    
    RecordsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel *filterLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, 1)];
    
    [filterLabel setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
    [cell.contentView addSubview:filterLabel];
    //传值
    [cell settingModelParameters:self.arr[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}



#pragma mark ----页面刚出现，导航栏的透明度进行设置----
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [self.refreshHeader beginRefreshing];

//    self.navigationController.navigationBar.translucent = NO;
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = NO;
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];

}

@end


