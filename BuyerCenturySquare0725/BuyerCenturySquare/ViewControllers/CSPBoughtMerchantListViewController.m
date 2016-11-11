//
//  CSPBoughtMerchantListViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 8/24/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPBoughtMerchantListViewController.h"
#import "MerchantGetBoughtListDTO.h"
#import "CSPBoughtMerchantTableViewCell.h"
#import "BoughtDTO.h"
#import "MerchantListDetailsDTO.h"
#import "CSPGoodsViewController.h"
#import "ConversationWindowViewController.h"

@interface CSPBoughtMerchantListViewController () <CSPBoughtMerchantTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)MerchantGetBoughtListDTO* boughtList;
@property (weak, nonatomic) IBOutlet UIView *invalidView;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

@end

@implementation CSPBoughtMerchantListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订购过的商家列表";
    
    [self.view bringSubviewToFront:self.invalidView];
    [self.invalidView setHidden:YES];
    
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPBoughtMerchantListViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadNewMerchantList];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];
    
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:self.tableView];
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
            
        [weakSelf loadMoreMerchantList];
    };

    [self addCustombackButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (MerchantGetBoughtListDTO*)boughtList {
    if (!_boughtList) {
        _boughtList = [[MerchantGetBoughtListDTO alloc]init];
    }

    return _boughtList;
}

#pragma mark -
#pragma mark Private Methods
- (void)getMerchantListWithPageNo:(NSNumber*)pageNo  complete:(void (^)(NSNumber* totalCount, NSArray* merchantList))complete {
    [HttpManager sendHttpRequestForGetBoughtListWithPageNo:pageNo pageSize:[NSNumber numberWithInteger:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSDictionary* dataDict = [dic objectForKey:@"data"];

            MerchantGetBoughtListDTO* boughtList = [[MerchantGetBoughtListDTO alloc]initWithDictionary:dataDict];

            complete(boughtList.totalCount, boughtList.merchantList);

        } else {
            
             [self.view makeMessage:[NSString stringWithFormat:@"获取订购过商家列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
                  }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        

        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

- (void)loadNewMerchantList {
    [self getMerchantListWithPageNo:@1 complete:^(NSNumber *totalCount, NSArray *merchantList) {
        self.boughtList.totalCount = totalCount;
        [self.boughtList.merchantList removeAllObjects];
        [self.boughtList.merchantList addObjectsFromArray:merchantList];
        
        if (totalCount.integerValue == 0) {
            [self.invalidView setHidden:NO];
        } else {
            [self.invalidView setHidden:YES];
        }

        [self.tableView reloadData];

        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
    }];
}

- (void)loadMoreMerchantList {
    if (self.boughtList.totalCount.integerValue <= self.boughtList.merchantList.count) {
        [self.refreshFooter endRefreshing];
        return;

    }

    NSNumber * pageNo = [NSNumber numberWithInteger:(self.boughtList.merchantList.count /pageSize) + 1];
    [self getMerchantListWithPageNo:pageNo complete:^(NSNumber *totalCount, NSArray *merchantList) {
        self.boughtList.totalCount = totalCount;
        [self.boughtList.merchantList addObjectsFromArray:merchantList];

        [self.tableView reloadData];
        
        [self.refreshFooter endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.boughtList) {
        return self.boughtList.merchantList.count;
    }

    return 0;
}

- (CSPBoughtMerchantTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPBoughtMerchantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"boughtMerchantCell" forIndexPath:indexPath];

    // Configure the cell...
    if (indexPath.row < self.boughtList.merchantList.count) {
        [cell setMerchantInfo:self.boughtList.merchantList[indexPath.row]];
        cell.delegate = self;
    }

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toGoodsList"]) {
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];

        CSPGoodsViewController* destViewController = segue.destinationViewController;
        destViewController.merchantDetail = self.boughtList.merchantList[indexPath.row];
        destViewController.style = CSPGoodsViewStyleSingleMerchant;
    }
    
}

#pragma mark -
#pragma mark CSPBoughtMerchantTableViewCellDelegate

- (void)tableViewCell:(UITableViewCell *)tableViewCell startEnquiryWithMerchant:(MerchantListDetailsDTO *)merchantInfo {
    [HttpManager sendHttpRequestForGetMerchantRelAccount:merchantInfo.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString * jid = [NSString stringWithFormat:@"%@",dic[@"data"]];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:merchantInfo.merchantName jid:jid withMerchantNo:merchantInfo.merchantNo];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
