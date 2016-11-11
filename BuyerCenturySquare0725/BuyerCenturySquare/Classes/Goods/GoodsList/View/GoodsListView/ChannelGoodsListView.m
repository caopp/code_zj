//
//  ChannelGoodsListView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ChannelGoodsListView.h"
#import "GoodsCollectionViewCell.h"
#import "SDRefresh.h"

static const int  itemSpace = 5;//!item的间距
static const int sectionInsetValue = 7;//!collectionview离两边的距离

@implementation ChannelGoodsListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(id)initWithFrame:(CGRect)frame withChannelId:(int)channelIds rangFlag:(NSString *)rangeFlags{

    self = [super initWithFrame:frame];

    if (self) {
        
        //!item的宽度（图片的宽度）
        itemWidth = (self.frame.size.width - sectionInsetValue*2 - itemSpace)/2;
        itemHight = itemWidth + 75;
        
        channelId = channelIds;
        rangeFlag = rangeFlags;
        
        
        //!创建collectionview
        [self createCollectionView];
        
        //!创建刷新
        [self createRefresh];
        
        [self requestData:self.refreshHeader];

        
    }


    return self;
}


#pragma mark 创建collectionview
-(void)createCollectionView{

    //!创建collectionview
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = itemSpace;//item间距(最小值)
    flowLayout.sectionInset = UIEdgeInsetsMake(0, sectionInsetValue , 0, sectionInsetValue);//!设置collectionview离两边的距离
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHight);//item的大小
    
    
    self.goodsCollectionView= [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:flowLayout];
    
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.delegate = self;
    
    [self.goodsCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.goodsCollectionView.alwaysBounceVertical = YES;//!如果不加这句话，数据没有或者数据少的时候没法滑动
    
    [self addSubview:self.goodsCollectionView];



}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    return dataArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"goodsCell"];
    
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
   
    if (dataArray.count) {
        
        Commodity * goodsInfo = dataArray[indexPath.row];
        [cell configData:goodsInfo];
        
        [cell.cornerView setHidden:YES];

    }


    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(itemWidth, itemHight);
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    Commodity * commodity = (Commodity *)dataArray[indexPath.row];

    if (self.selectBlock) {
        
        self.selectBlock(commodity);
    }

}
#pragma mark 创建刷新
-(void)createRefresh{

    __weak ChannelGoodsListView * view = self;

    //!头部
//    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
//
//    [refreshHeader addToScrollView:self.goodsCollectionView];
//    self.refreshHeader = refreshHeader;
//    
//    
//    self.refreshHeader.beginRefreshingOperation = ^{
//        
//        [view requestData:self.refreshHeader];
//        
//    };
    
    //!底部
    self.refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [self.refreshFooter addToScrollView:self.goodsCollectionView];
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [view requestData:self.refreshFooter];
        
    };


}
#pragma mark 请求
-(void)requestData:(SDRefreshView *)refresh{

    if (refresh == self.refreshFooter) {
        
        pageNo ++;

    }else{
    
        pageNo = 1;

    }
   
    pageSize = 20;
    
    
    [HttpManager sendHttpRequestFoChannelGoodsListWithChannelId:[NSNumber numberWithInt:channelId] withRangeFlag:rangeFlag withPageNo:[NSNumber numberWithInt:pageNo] withPageSize:[NSNumber numberWithInt:pageSize] Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            if (refresh == nil) {
                
                dataArray = [NSMutableArray arrayWithCapacity:0];

            }
            
            for (NSDictionary * goodsDic  in dic[@"data"][@"list"]) {
                
                Commodity * commodity = [[Commodity alloc]initWithDictionary:goodsDic];
                
                [dataArray addObject:commodity];
                
            }
            
            [CATransaction begin];
            
            [self.goodsCollectionView reloadData];
            
            [CATransaction commit];
            
            
            [self.refreshHeader endRefreshing];
            [self.refreshFooter endRefreshing];
            
            if (self.finishRequest) {//!告诉调用请求的地方，请求完成了
                
                self.finishRequest();
                
            }
            
            totoalCount = [dic[@"data"][@"totalCount"] intValue];
            
            if (dataArray.count == totoalCount) {
                
                [self.refreshFooter noDataRefresh];
            }
            
            //!如果没有商品，返回无商品的标志
            if (totoalCount == 0) {
                
                if (self.noGoodsBlock) {
                    
                    self.noGoodsBlock();
                }
                
            }
            
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        
        
    }];


}


@end
