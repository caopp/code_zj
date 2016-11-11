//
//  RefreshTableView.m
//  SellerCenturySquare
//
//  Created by caopenpen on 16/7/20.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "RefreshTableView.h"

@implementation RefreshTableView
static int pageSize = 20;

-(void)awakeFromNib{
    [self createRefresh];
    _arrShareGoods = [[NSMutableArray alloc] initWithCapacity:0];
    _pageNo = 1;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//!创建刷新
-(void)createRefresh{
    
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self];
    
    self.refreshHeader = refreshHeader;
    
    __weak RefreshTableView * refreshTable = self;
    
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [refreshTable requestData:self.refreshHeader];
    };

    //!底部
    SDRefreshFooterView *refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    
    [refreshFooter addToScrollView:self];
    
    self.refreshFooter = refreshFooter;
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [refreshTable requestData:self.refreshFooter];
    };
}

#pragma mark 请求数据
-(void)requestData:(SDRefreshView *)refresh{
    
    if (refresh == self.refreshHeader) {
        
        _pageNo = 1;
        
        [_arrShareGoods removeAllObjects];
        
    }else{
        
        _pageNo = _pageNo +1;
        
    }
    
    //查询类型(1:未审核,2:通过,3:不通过,不填为查全部)
    NSNumber *queryType = [NSNumber numberWithInt:_shareStatus];
    if (_shareStatus == AllShareStatus) {
        queryType = nil;
    }
    
    [HttpManager sendHttpRequestForAuditListWtihtGoodNo:_goodsNo withUserId:_userId withQueryType:queryType pageNo:[NSNumber numberWithInt:_pageNo] pageSize:[NSNumber numberWithInt:pageSize] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *responseDic =  [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([responseDic[@"code"] isEqualToString:@"000"]) {
            if (refresh == self.refreshHeader) {
                [_arrShareGoods removeAllObjects];
            }
            
            NSDictionary *dic = responseDic[@"data"];
            _totalCount = [dic[@"totalCount"] intValue];
            
            NSArray *arr = dic[@"list"];
            for (NSDictionary *dic in arr) {
                GoodsShareDTO *goodsShareDTO = [[GoodsShareDTO alloc] init];
                [goodsShareDTO setDictFrom:dic];
                [_arrShareGoods addObject:goodsShareDTO];
            }
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            
            if (arr.count < pageSize) {
                
                [self.refreshFooter noDataRefresh];
                
            }
            
            [self reloadData];
            
        }else{
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
    }];
    
    
}



@end
