//
//  CSPMerchantTableViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantTableViewController.h"

#import "CSPGoodsViewController.h"// !商家详情
#import "CSPMerchantTableViewCell.h"// !商家列表的cell

#import "LoginDTO.h"// !登录的dto
#import "MerchantListDTO.h"
#import "SDRefresh.h"
#import "DeviceDBHelper.h"//!获取未读消息

@interface CSPMerchantTableViewController ()
{
    NSNumber * lastPageNo;//上一次请求的页码

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) MerchantListDTO* merchantListDTO;
@property (weak, nonatomic) IBOutlet UIButton *backTopButton;// !返回顶部

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation CSPMerchantTableViewController

const NSInteger pageSize = 20;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"shop", @"商家");

    // !创建刷新
    [self createRefresh];
    
    
    
}
// !创建刷新
- (void)createRefresh{

    //!header
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPMerchantTableViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
        
        // !同一个用户，在一个IP下登录 切换了IP，则商家列表只会出现动画，不会进入这一步； 用户使用不会切换ip，所以这里并未i
        [weakSelf loadNewMerchantList];
        
        
    };

    // !进入页面自动加载一次数据
//    if ([LoginDTO sharedInstance].tokenId.length > 0) {
//        
//        [refreshHeader beginRefreshing];
//    }
    
    //!footer
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [weakSelf loadMoreMerchantList];
    };


}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    // !如果没有商家数据，则请求商家数据
    if (self.merchantListDTO.merchantList.count == 0) {
        if ([LoginDTO sharedInstance].tokenId.length > 0) {
            
//            [self.refreshHeader beginRefreshing];
            [self loadNewMerchantList];
            
            return;
        }
    }
    
    // !如果是从登录界面过来的，则刷新界面
    if ([MyUserDefault defaultLoadLogined]) {
        
//        [self.refreshHeader beginRefreshing];
        [self loadNewMerchantList];

        
        [MyUserDefault removeLogined];// !删除本地记录
        
    }
    
    
}
// !同一个用户，在一个IP下登录 切换了IP，则商家列表只会出现动画，不会进入这一步；所以把动效和加载分开
-(void)refresh{

    [self.refreshHeader beginRefreshing];
    [self loadNewMerchantList];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.merchantListDTO) {
        return self.merchantListDTO.merchantList.count;
    }

    return 0;
}

- (CSPMerchantTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"merchantCell" forIndexPath:indexPath];
    // Configure the cell...
    if (indexPath.row < self.merchantListDTO.merchantList.count) {

        [cell setupWithMerchantDetailsDTO:self.merchantListDTO.merchantList[indexPath.row]];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
//    CGFloat height = SCREEN_WIDTH / (375.0/210.0);
//
//    return height + 50;
    
    return SCREEN_WIDTH;
    
}


// !cell上面的点击事件
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toGoodsList"]) {
        
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
        MerchantListDetailsDTO* merchantDetailsDTO = self.merchantListDTO.merchantList[indexPath.row];
        
        CSPGoodsViewController* destViewController = segue.destinationViewController;
        
        destViewController.merchantDetail = merchantDetailsDTO;
        
        destViewController.style = CSPGoodsViewStyleSingleMerchant;
        
    }
}


#pragma mark -
#pragma mark Getter and Setter

- (MerchantListDTO*)merchantListDTO {
    
    if (!_merchantListDTO) {
        _merchantListDTO = [[MerchantListDTO alloc]init];
    }
    return _merchantListDTO;
    
}


#pragma mark Private Methods

// !返回顶部按钮的事件
- (IBAction)backTopButtonClicked:(id)sender {
    [self.tableView setContentOffset:CGPointZero animated:YES];
}
// !下拉刷新
- (void)loadNewMerchantList {
    
    //!记录这次请求的页码
    lastPageNo = @1;
    
    
    [self getMerchantListWithPageNo:@1];
   
    
    
}
// !上拉加载
- (void)loadMoreMerchantList {
    
    NSNumber * pageNo = [NSNumber numberWithInteger:(self.merchantListDTO.merchantList.count /pageSize) + 1];

    //!没有数据的时候
//    if ([pageNo intValue] == [lastPageNo intValue]) {
//        
////        [self.refreshFooter endRefreshing];
//        
//        return ;
//        
//    }else{
    
        lastPageNo = pageNo;
//    }

    
    [self getMerchantListWithPageNo:pageNo];
    
    
}

// !请求数据
- (void)getMerchantListWithPageNo:(NSNumber*)pageNo{
    
    // merchantNo：商家编号，有的时候是查询单个商家；无的时候是查询整个列表
    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:nil pageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            NSDictionary* dataDict = [dic objectForKey:@"data"];
            // !初始化所有的商家信息 dto  并且把每个商家的信息转换成dto放到 MerchantListDTO中
            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
            
            self.merchantListDTO.totalCount = merchantListDTO.totalCount;
            
             //!下拉刷新需要
            if ([lastPageNo  isEqual: @1]) {
                
                [self.merchantListDTO.merchantList removeAllObjects];

            }
            
            [self.merchantListDTO.merchantList addObjectsFromArray:merchantListDTO.merchantList];
            
            [self.tableView reloadData];
            
                        
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"%@, %@", NSLocalizedString(@"shopListFail", @"查询商家列表失败"),[dic objectForKey:@"errorMessage"]]  duration:2.0f position:@"center"];
            
        }
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        //!没有数据的时候
        NSNumber * pageNo = [NSNumber numberWithInteger:(self.merchantListDTO.merchantList.count /pageSize) + 1];
        
        if ([pageNo intValue] == [lastPageNo intValue]) {
            
            [self.refreshFooter noDataRefresh];
        
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        [self.view makeMessage:NSLocalizedString(@"connectError", @"网络连接异常")   duration:2.0f position:@"center"];
        
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        
    }];
    
}





#pragma mark -
#pragma mark ScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.y > 50) {
        [self.backTopButton setHidden:NO];
    } else {
        [self.backTopButton setHidden:YES];
    }
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [self.backTopButton setHidden:YES];

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
