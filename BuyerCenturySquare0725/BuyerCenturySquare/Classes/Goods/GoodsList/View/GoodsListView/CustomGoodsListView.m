//
//  CustomGoodsListView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/8/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CustomGoodsListView.h"

@implementation CustomGoodsListView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


#pragma mark 重写父类的方法
//!创建排序
-(void)createSortView{

    self.goodsSortView = [[[NSBundle mainBundle]loadNibNamed:@"CustomGoodsSortView" owner:self options:nil]lastObject];
    
    self.goodsSortView.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, self.goodsSortView.frame.size.height);
    
    self.goodsSortView.layer.masksToBounds = YES;
    self.goodsSortView.layer.cornerRadius = 2;
    self.goodsSortView.layer.borderColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1].CGColor;
    self.goodsSortView.layer.borderWidth = 1;
    
    [self.goodsSortView setGoodsSortDTO:self.sortDTO];//!初始化数据

    [self addSubview:self.goodsSortView];
    
    __weak GoodsListView * goodsListView = self;
    
    self.goodsSortView.sortClickBlock = ^(){
        
        [goodsListView requestData:nil];
        
        
    };


}


//!创建刷新
-(void)createRefresh{
    
    //!底部
    __weak GoodsListView * view = self;
    
    self.refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [self.refreshFooter addToScrollView:self.goodsCollectionView];
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [view requestData:self.refreshFooter];
        
    };


}

//!添加下拉刷新
-(void)addHeaderRefresh{
    
    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.goodsCollectionView];
    self.refreshHeader = refreshHeader;
    
    
    __weak GoodsListView * view = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [view requestData:self.refreshHeader];
        
    };
    
    
}

//!移除下拉刷新
-(void)removeHeaderRefresh{
    
    [self.refreshHeader removeFromSuperview];
    self.refreshHeader = nil;
    
}

#pragma mark 请求数据
-(void)requestData:(SDRefreshView *)refresh{
    
    
    if (refresh == self.refreshFooter) {
        
        page ++;
        
    }else{
        
        page = 1;
        num = 20;
        [self.goodsCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];

    }
    
    
    [HttpManager sendHttpRequestForGetGoodsListWithPageNo:[NSNumber numberWithInt:page] pageSize:[NSNumber numberWithInt:num] merchantNo:merchantNo structureNo:structNo rangeFlag:rangFlag withGoodsSortDTO:self.sortDTO success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
//        DebugLog(@"%@", dic);
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSDictionary *dataDic = dic[@"data"];
            
            //!按时间排序、并且是第一行才显示更新时间段
            BOOL isSortByDay = [self.sortDTO.orderByField isEqualToString:@"1"];

            //!1、数据加入数组
            if (refresh == self.refreshFooter) {//!上拉就把数据加入数组
                
                [self.goodsListDTO addCommoditiesFromDictionary:dataDic withByDaySave:isSortByDay];
                
            }else{//!下拉则重新分配空间
                
                self.goodsListDTO = [[CommodityGroupListDTO alloc]initWithDictionary:dataDic withByDaySave:isSortByDay];
                
                
            }
            
            if (noGoodsView) {
                
                [noGoodsView removeFromSuperview];
                noGoodsView = nil;
            }
            
            if (!self.goodsListDTO.totalCount) {//!筛选没有上架商品
                
                self.goodsCollectionView.hidden = YES;
                
                noGoodsView = [self instanceAllNoGoodsView];
                noGoodsView.frame = self.goodsCollectionView.frame;
                [self addSubview:noGoodsView];
                
            }else{
                
                self.goodsCollectionView.hidden = NO;
                
                [self reloadData];
                
            }
            
            
        }else{
            
            [self makeMessage:[NSString stringWithFormat:@"%@, %@",NSLocalizedString(@"goodListError", @"查询商品列表失败") ,[dic objectForKey:@"errorMessage"]] duration:2.0f position:@"center"];
            
        }
        
        //!3、结束刷新
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        if ([self.goodsListDTO isLoadedAll]) {
            
            
            [self.refreshFooter noDataRefresh];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self makeMessage:@"加载失败，目前的网络不顺畅!请检查手机是否联网。"  duration:2.0f position:@"center"];
        
        [self.refreshHeader endRefreshing];
        [self.refreshFooter endRefreshing];
        
        
        
    }];
    
    
    
    
}

-(AllListNoGoodsView *)instanceAllNoGoodsView{
    
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"AllListNoGoodsView" owner:nil options:nil];
    
    AllListNoGoodsView * noGoodsView = [nibView objectAtIndex:0];
    
    return noGoodsView;
    
}

@end
