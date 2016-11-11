//
//  SearchGoodsListView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SearchGoodsListView.h"

@implementation SearchGoodsListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame withQueryParam:(NSString *)queryParams withRangeFlag:(NSString *)rangeFlags{


    self = [super initWithFrame:frame];
    if (self) {
        
        //!记录查询的内容、搜索的范围
        queryParam = queryParams;
        rangeFlag = rangeFlags;
        
        //!初始化排序的DTO，默认显示推荐的
        self.sortDTO = [[GoodsSortDTO alloc]init];
        self.sortDTO.orderByField = @"4";
        self.sortDTO.orderBy = orderBydesc;
        
        //!item的宽度（图片的宽度）
        itemWidth = (self.frame.size.width - sectionInsetValue*2 - itemSpace)/2;
        itemHight = itemWidth + 75;

        //!调用父类的方法
        //!创建排序
        [self createSortView];
        
        //!创建collectionview
        [self createCollectionView];
        
        //!创建刷新
        [self createRefresh];
        
        
        [self requestData:self.refreshHeader];
        

        
    }

    return self;

}
#pragma mark 重写父类的方法

-(void)requestData:(SDRefreshView *)refresh{
    
    
    if (refresh == self.refreshFooter) {
        
        page ++;
        
    }else{
        
        page = 1;
        num = 20;
        [self.goodsCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];

    }

    [HttpManager sendHttpRequestFoSeachGoodsList:[NSNumber numberWithInt:page] withPageSize:[NSNumber numberWithInt:num] withQueryParam:queryParam withRangeFlag:rangeFlag withGoodsSortDTO:self.sortDTO Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            NSDictionary *dataDic = dic[@"data"];
            
            //!按时间排序、并且是第一行才显示更新时间段
            BOOL isSortByDay = [self.sortDTO.orderByField isEqualToString:@"1"];

            //!1、数据加入数组
            if (refresh == self.refreshFooter) { //!上拉就把数据加入数组
                
                [self.goodsListDTO addCommoditiesFromDictionary:dataDic withByDaySave:isSortByDay];

            }else{//!下拉则重新分配空间
                
                self.goodsListDTO = [[CommodityGroupListDTO alloc]initWithDictionary:dataDic withByDaySave:isSortByDay];

            }
            
            if (!self.goodsListDTO.totalCount) {//!筛选没有上架商品
                
                self.goodsCollectionView.hidden = YES;
                
            }else{
                
                self.goodsCollectionView.hidden = NO;
                
                [self reloadData];
                
            }
            
            //!判断没有商品，则显示无商品的界面
            if (self.showNoGoodsTips) {
                
                self.showNoGoodsTips(self.goodsListDTO.totalCount);
                
                
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
//!去除动画，刷新数据
-(void)reloadData{
    
    //!添加事物，用于去除动画
    [CATransaction begin];
    
    [self.goodsCollectionView reloadData];
    

    [CATransaction commit];
    
}

@end
