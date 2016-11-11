//
//  GoodsListView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/2.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsListView.h"
#import "GoodsCollectionViewCell.h"

@implementation GoodsListView

-(instancetype)initWithFrame:(CGRect)frame withMerchantNo:(NSString *)merchantNos withStructNo:(NSString *)structNos withRangFlag:(NSString *)rangFlags{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        merchantNo = merchantNos;
        structNo = structNos;
        rangFlag = rangFlags;
        
        //!初始化排序的DTO，默认显示推荐的
        self.sortDTO = [[GoodsSortDTO alloc]init];
        self.sortDTO.orderByField = @"4";
        self.sortDTO.orderBy = orderBydesc;
        
        
        //!item的宽度（图片的宽度）
        itemWidth = (self.frame.size.width - sectionInsetValue*2 - itemSpace)/2;
        itemHight = itemWidth + 75;
        
        //!创建排序
        [self createSortView];
        
        //!创建collectionview
        [self createCollectionView];
        
        //!创建刷新
        [self createRefresh];
        
        
        [self requestData:self.refreshHeader];

        
        //!返回顶部按钮
        backUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backUpBtn setImage:[UIImage imageNamed:@"back_top"] forState:UIControlStateNormal];
        backUpBtn.frame = CGRectMake(self.frame.size.width - 55, self.frame.size.height - 55, 35, 35);
        [backUpBtn addTarget:self action:@selector(backUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
        backUpBtn.hidden = YES;
        [self addSubview:backUpBtn];
        
    }

    return self;
}
#pragma mark 创建排序的createSortView
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

#pragma mark 创建collectionview
-(void)createCollectionView{

    //!创建collectionview
    UICollectionViewFlowLayout *flowLayout= [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;//滚动方向
    flowLayout.minimumLineSpacing = 0;//行间距(最小值)
    flowLayout.minimumInteritemSpacing = itemSpace;//item间距(最小值)
    flowLayout.sectionInset = UIEdgeInsetsMake(0, sectionInsetValue , 0, sectionInsetValue);//!设置collectionview离两边的距离
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHight );//item的大小
    
    
    self.goodsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.goodsSortView.frame) + 14, self.frame.size.width, self.frame.size.height - (CGRectGetMaxY(self.goodsSortView.frame) + 14)) collectionViewLayout:flowLayout];
    
    self.goodsCollectionView.dataSource = self;
    self.goodsCollectionView.delegate = self;
    
    [self.goodsCollectionView setBackgroundColor:[UIColor whiteColor]];
    self.goodsCollectionView.alwaysBounceVertical = YES;//!如果不加这句话，数据没有或者数据少的时候没法滑动

    [self addSubview:self.goodsCollectionView];
    



}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //!获取每段的信息
    CommodityGroup* goodsSectionInfo = self.goodsListDTO.groupList[section];
    //!返回每段的个数
    return goodsSectionInfo.commodityList.count;

}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    //!返回段数
    return self.goodsListDTO.groupList.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *nib = [UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:[NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"goodsCell"];
    
    GoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"goodsCell" forIndexPath:indexPath];
    
    //!得到对应段
    CommodityGroup* goodsSectionInfo = self.goodsListDTO.groupList[indexPath.section];
  
    if (goodsSectionInfo && goodsSectionInfo.commodityList.count > indexPath.row) {
        
        Commodity * goodsInfo = goodsSectionInfo.commodityList[indexPath.row];
        [cell configData:goodsInfo];
        
        //!按时间排序、并且是第一行才显示更新时间段
        BOOL isSortByDay = [self.sortDTO.orderByField isEqualToString:@"1"];

        if (indexPath.row == 0 && isSortByDay) {
            
            if ([goodsInfo.goodsType isEqualToString:@"1"]) {//!邮费专拍
                
                [cell.cornerView setHidden:YES];
                
            }else{// !普通商品
                
                [cell.cornerView setHidden:NO];
                
            }
            
        } else {//!不是第一行，去除右边提示
            
            [cell.cornerView  setHidden:YES];
            
        }

        
    }
    
    
    
    
    
    return cell;
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(itemWidth, itemHight);
    
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CommodityGroup* goodsSectionInfo = self.goodsListDTO.groupList[indexPath.section];

    Commodity *goodsCommodity = goodsSectionInfo.commodityList[indexPath.row];
    
    
    if (self.selectBlock) {
        
        self.selectBlock(goodsCommodity);
        
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(GoodsCollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell startAnimation];
    
    
}
#pragma mark 创建刷新
-(void)createRefresh{

    //!头部
    SDRefreshHeaderView *refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:self.goodsCollectionView];
    self.refreshHeader = refreshHeader;
    
    
    __weak GoodsListView * view = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [view requestData:self.refreshHeader];
        
    };
    
    //!底部
    self.refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [self.refreshFooter addToScrollView:self.goodsCollectionView];
    
    self.refreshFooter.beginRefreshingOperation = ^{
        
        [view requestData:self.refreshFooter];
        
    };
    


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
            
            BOOL isSortByDay = [self.sortDTO.orderByField isEqualToString:@"1"];
            
            //!1、数据加入数组
            if (refresh == self.refreshFooter) {//!上拉就把数据加入数组
                
                [self.goodsListDTO addCommoditiesFromDictionary:dataDic withByDaySave:isSortByDay];

            }else{//!下拉则重新分配空间
                
                self.goodsListDTO = [[CommodityGroupListDTO alloc]initWithDictionary:dataDic withByDaySave:isSortByDay];


            }
            
            //2、!如果是从商家列表进入 判断商家状态是否要显示和刷新商品列表
            if (merchantNo && ![merchantNo isEqualToString:@""]) {
                
                if ([self isReloadData:dataDic]) {//!显示并刷新商品列表
                    
                    self.goodsCollectionView.hidden = NO;
                    
                    [self reloadData];
                    
                }else{
                
                    self.goodsCollectionView.hidden = YES;
                
                }
                
                
            }else{//!全部商品
            
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

//!根据商家状态，判断是否显示 和刷新colectionView

-(BOOL)isReloadData:(NSDictionary *)dataDic{

    merchantDetail = [[MerchantListDetailsDTO alloc]initWithDictionary:nil];
    
    merchantDetail.blacklistFlag = dataDic[@"blacklistFlag"];
    merchantDetail.closeStartTime = dataDic[@"closeStartTime"];
    merchantDetail.closeEndTime = dataDic[@"closeEndTime"];
    merchantDetail.operateStatus = dataDic[@"operateStatus"];
    merchantDetail.merchantStatus = dataDic[@"merchantStatus"];
    
    
    if (self.merchantShowViewBlock) {
        
        self.merchantShowViewBlock(merchantDetail,self.goodsListDTO.totalCount);
        
    }
    //!商家状态：正常、无上架商品、歇业、黑名单无权限查看、关闭
    if ([merchantDetail.merchantStatus isEqualToString:@"1"]){//!关闭
        
        return NO;
        
    }else if ([merchantDetail.blacklistFlag isEqualToString:@"1"]) {//!黑名单
            
        return NO;
        
    }else if([merchantDetail.operateStatus isEqualToString:@"1"]){//!歇业
    
        return NO;
        
    
    }else if (!self.goodsListDTO.totalCount){//!无上架商品
    
        return NO;
    
    
    }
    
    return YES;
    
    
}
#pragma mark 返回顶部按钮的事件

//!返回顶部按钮的事件
-(void)backUpBtnClick{
     
    [self.goodsCollectionView setContentOffset:CGPointZero animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView.contentOffset.y > 50) {
        
        [backUpBtn setHidden:NO];
        
    } else {
        
        [backUpBtn setHidden:YES];
        
    }
    
    
    
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    
    [backUpBtn setHidden:YES];
    
}
#pragma mark !筛选的时候调用的方法
-(void)filterWithStructNo:(NSString *)filterStructNo{

    structNo = filterStructNo;
    
    [self requestData:self.refreshHeader];
    
}
#pragma mark !重置sortDTO
-(void)resetSortDTO{
    
    self.sortDTO.orderByField = @"4";
    self.sortDTO.orderBy = orderBydesc;
    
    self.sortDTO.upDayNum = @"";
    self.sortDTO.minPrice = @"";
    self.sortDTO.maxPrice = @"";
    
    [self.goodsSortView setGoodsSortDTO:self.sortDTO];//!初始化数据
    
    [self requestData:nil];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
