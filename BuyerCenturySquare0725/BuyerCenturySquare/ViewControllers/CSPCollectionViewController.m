//
//  CSPCollectionViewController.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCollectionViewController.h"
#import "SMSegmentView.h"
#import "CSPCollectionGoodsHeaderTableViewCell.h"
#import "CSPCollectionGoodsTableViewCell.h"
#import "GetFavoriteListDTO.h"
#import "FavoriteDTO.h"
#import "GoodsCollectionByTimeDTO.h"
#import "GoodsCollectionByMerchantDTO.h"
#import "CSPGoodsViewController.h"
#import "CartAddDTO.h"
#import "ConversationWindowViewController.h"
#import "MerchantListDTO.h"
#import "MerchantListDetailsDTO.h"
#import "CSPGoodsInfoTableViewController.h"
#import "GoodsInfoDTO.h"
#import "SDRefresh.h"
#import "GoodDetailViewController.h"
typedef NS_ENUM(NSUInteger, CollectionGoodsListStyle) {
    CollectionGoodsListStyleOrderByTime,
    CollectionGoodsListStyleOrderByMerchant,
};

@interface CSPCollectionViewController () <SMSegmentViewDelegate, CSPCollectionGoodsTableViewCellDelegate, CSPCollectionGoodsHeaderTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet SMSegmentView *segmentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GoodsCollectionByTimeDTO* collectionGoodsList;
@property (nonatomic, strong) GoodsCollectionByMerchantDTO* collectionMerchantList;

@property (nonatomic, assign)CollectionGoodsListStyle style;

@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;

@end

@implementation CSPCollectionViewController


static NSString* reuseCellIdentifier = @"collectionGoodsInfoCell";
static NSString* sectionHeaderIdentifier = @"sectionHeaderView";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"商品收藏";

    self.segmentView.delegate = self;

    [self.segmentView addSegmentWithTitle:@"按时间"];
    [self.segmentView addSegmentWithTitle:@"按商家"];

    [self.segmentView selectSegmentAtIndex:0];

    
    SDRefreshHeaderView * refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.tableView];
    self.refreshHeader = refreshHeader;
    
    __weak CSPCollectionViewController * weakSelf = self;
    refreshHeader.beginRefreshingOperation = ^{
            
        [weakSelf loadNewGoodsList];
    };
    
    // 进入页面自动加载一次数据
    [refreshHeader beginRefreshing];

    [self addCustombackButtonItem];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[self rdv_tabBarController] setTabBarHidden:NO animated:YES];
    
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.style == CollectionGoodsListStyleOrderByTime) {
        return self.collectionGoodsList.goodsList.count;
    } else {
        CollectionMerchant* merchant = self.collectionMerchantList.merchantList[section];
        return merchant.goodsList.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.style == CollectionGoodsListStyleOrderByTime ? 1 : self.collectionMerchantList.merchantList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CSPCollectionGoodsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseCellIdentifier];

    if (self.style == CollectionGoodsListStyleOrderByTime) {
        [cell setupWithTimeOrderForCollectionInfo:self.collectionGoodsList.goodsList[indexPath.row]];
    } else {
        CollectionMerchant* merchant = self.collectionMerchantList.merchantList[indexPath.section];
        [cell setupWithMerchantOrderForCollectionInfo:merchant.goodsList[indexPath.row]];
    }
    cell.delegate = self;

    return cell;
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CSPCollectionGoodsHeaderTableViewCell* headerView = [tableView dequeueReusableCellWithIdentifier:sectionHeaderIdentifier];
    if (self.style == CollectionGoodsListStyleOrderByMerchant) {
        CollectionMerchant* merchant = self.collectionMerchantList.merchantList[section];
        [headerView.merchantNameButton setTitle:merchant.merchantName forState:UIControlStateNormal];
        headerView.section = section;
    }
    return headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 122;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.style == CollectionGoodsListStyleOrderByTime) {
        return 0.0f;
    }
    return 30.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.style == CollectionGoodsListStyleOrderByTime) {
        
        CollectionGoods* goodsInfo = [self.collectionGoodsList.goodsList objectAtIndex:indexPath.row];
        
        GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
        
        goodsInfoDTO.goodsNo = goodsInfo.goodsNo;

        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
        //
        //            goodsInfo.goodsNo = commodityInfo.goodsNo;
        
        GoodDetailViewController *goodsInfoVC = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    } else {
        CollectionMerchant* merchantInfo = [self.collectionMerchantList.merchantList objectAtIndex:indexPath.section];
        
        CollectionGoods* goodsInfo = [merchantInfo.goodsList objectAtIndex:indexPath.row];
        
        GoodsInfoDTO *goodsInfoDTO = [GoodsInfoDTO sharedInstance];
        
        goodsInfoDTO.goodsNo = goodsInfo.goodsNo;

        
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //            CSPGoodsInfoTableViewController *goodsInfo = [main instantiateViewControllerWithIdentifier:@"CSPGoodsInfoTableViewController"];
        //
        //            goodsInfo.goodsNo = commodityInfo.goodsNo;
        
        GoodDetailViewController *goodsInfoVC = [main instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        
        [self.navigationController pushViewController:goodsInfoVC animated:YES];
    }

}

#pragma mark -
#pragma mark SMSegmentViewDelegate

- (void)segmentView:(SMSegmentView *)segmentView didSelectSegmentAtIndex:(NSInteger)index {
    self.style = index == 0 ? CollectionGoodsListStyleOrderByTime : CollectionGoodsListStyleOrderByMerchant;

    if (index == 0) {
        self.style = CollectionGoodsListStyleOrderByTime;
        if (self.collectionGoodsList.goodsList.count == 0) {
            [self.refreshHeader beginRefreshing];
        }
    } else {
        self.style = CollectionGoodsListStyleOrderByMerchant;
        if (self.collectionMerchantList.merchantList.count == 0) {
            [self.refreshHeader beginRefreshing];
        }
    }

    [self.tableView reloadData];
}

#pragma mark -
#pragma mark PrivateMethods


#pragma mark -
#pragma mark CSPCollectionGoodsTableViewCellDelegate

- (void)tableViewCell:(CSPCollectionGoodsTableViewCell *)tableViewCell deleteFavourSuccess:(BOOL)isSucceed {
    if (!isSucceed) {
        
        [self.view makeMessage:@"取消收藏失败" duration:2.0f position:@"center"];
        
        return;
    }
    
    NSIndexPath* indexPath = [self.tableView indexPathForCell:tableViewCell];
    
    if (self.style == CollectionGoodsListStyleOrderByTime) {
        
        [self.collectionGoodsList.goodsList removeObjectAtIndex:indexPath.row];
        [self getGoodsCollectionByMerchant];
        
    } else {
        CollectionMerchant* merchantInfo = [self.collectionMerchantList.merchantList objectAtIndex:indexPath.section];
        [merchantInfo.goodsList removeObjectAtIndex:indexPath.row];
        if (merchantInfo.goodsList.count == 0) {
            [self.collectionMerchantList.merchantList removeObject:merchantInfo];
        }
        
        [self getGoodsCollectionByTime];
    }
    
    
    [self.tableView reloadData];
}

- (void)tableViewCell:(CSPCollectionGoodsTableViewCell *)tableViewCell startEnquiryWithGoodsInfo:(CollectionGoods *)goodsInfo {

    [HttpManager sendHttpRequestForGetMerchantRelAccount:goodsInfo.merchantNo success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
//            NSString * jid = [NSString stringWithFormat:@"%@",dic[@"data"]];

            NSString* jid = [[dic objectForKey:@"data"] objectForKey:@"account"];
            NSNumber *time = [[dic objectForKey:@"data"] objectForKey:@"time"];
            NSNumber *isExit = dic[@"data"][@"isExit"];

            ConversationWindowViewController * conversationVC = [[ConversationWindowViewController alloc] initServiceWithName:goodsInfo.merchantName jid:jid withMerchantNo:goodsInfo.merchantNo];
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

- (void)merchantButtonClickedForCell:(CSPCollectionGoodsTableViewCell*)cell collectionInfo:(CollectionGoods *)collectionInfo {
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    if (self.style == CollectionGoodsListStyleOrderByTime) {
        CollectionGoods* goodsInfo = self.collectionGoodsList.goodsList[indexPath.row];
        [self prepareLinkToGoodsViewByMerchantNo:goodsInfo.merchantNo];
    } else {
        CollectionMerchant* merchant = self.collectionMerchantList.merchantList[indexPath.section];
        [self prepareLinkToGoodsViewByMerchantNo:merchant.merchantNo];

    }
}

#pragma mark -
#pragma mark CSPCollectionGoodsHeaderTableViewCellDelegate

- (void)merchantNamePressedForSection:(NSInteger)section {
    if (section < self.collectionMerchantList.merchantList.count) {
        CollectionMerchant* merchantInfo = self.collectionMerchantList.merchantList[section];
        [self prepareLinkToGoodsViewByMerchantNo:merchantInfo.merchantNo];
    }
}


#pragma mark -
#pragma mark Private Methods

- (void)getGoodsCollectionByTime {
    [HttpManager sendHttpRequestForGetFavoriteListByTime:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.collectionGoodsList = [[GoodsCollectionByTimeDTO alloc]initWithDictionary:dic[@"data"]];
            if (self.collectionGoodsList.goodsList.count > 0) {
                [self.tableView reloadData];
            }
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询收藏列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

           
        }
        [self.refreshHeader endRefreshing];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        
        [self.refreshHeader endRefreshing];
    }];
}

- (void)getGoodsCollectionByMerchant {
    [HttpManager sendHttpRequestForGetFavoriteListByMerchant:@"0" success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            self.collectionMerchantList = [[GoodsCollectionByMerchantDTO alloc]initWithDictionary:dic[@"data"]];
            if (self.collectionMerchantList.merchantList.count > 0) {
                [self.tableView reloadData];
            }
        } else {
            
            [self.view makeMessage:[NSString stringWithFormat:@"查询收藏列表失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

            
        }

        [self.refreshHeader endRefreshing];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.view makeMessage:@"网络连接异常" duration:2.0f position:@"center"];
        

        
        [self.refreshHeader endRefreshing];
    }];
}



- (void)loadNewGoodsList {
    if (self.style == CollectionGoodsListStyleOrderByTime) {
        [self getGoodsCollectionByTime];
    } else {
        [self getGoodsCollectionByMerchant];
    }
}

- (void)prepareLinkToGoodsViewByMerchantNo:(NSString*)merchantNo {
    [HttpManager sendHttpRequestForGetMerchantListWithMerchantNo:merchantNo pageNo:@1 pageSize:@20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            NSDictionary* dataDict = [dic objectForKey:@"data"];

            MerchantListDTO* merchantListDTO = [[MerchantListDTO alloc]initWithDictionary:dataDict];
            
            if (merchantListDTO.merchantList.count > 0) {
                MerchantListDetailsDTO* merchantDetails = [merchantListDTO.merchantList firstObject];
                CSPGoodsViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CSPGoodsViewController"];
                destViewController.merchantDetail = merchantDetails;
                destViewController.style = CSPGoodsViewStyleSingleMerchant;
                
                [self.navigationController pushViewController:destViewController animated:YES];
            } else {
                
                [self.view makeMessage:[NSString stringWithFormat:@"查询商家信息失败, %@", [dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];

               
            }
            
        } else {
            
             [self.view makeMessage:@"查询信息失败,查看服务器" duration:2.0f position:@"center"];
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
