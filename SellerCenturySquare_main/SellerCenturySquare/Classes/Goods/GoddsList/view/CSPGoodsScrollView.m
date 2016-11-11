//
//  CSPGoodsScrollView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPGoodsScrollView.h"
#import "CSPGoodsTopView.h"
#import "CSPGoodsTableViewCell.h"
#import "GetEditGoodsListDTO.h"
#import "EditGoodsDTO.h"
#import "UIImageView+WebCache.h"

static NSInteger const tableViewTagOfGoosScrollView = 101;

static NSInteger const tipNoDataLabelTag = 201;

//!商品数量的tag
static NSInteger const numTag = 301;


//!商品数量的view 高度
static CGFloat const numTopViewHeight = 30.0f;


@implementation CSPGoodsScrollView{
    
    NSMutableArray *_selectedsArray;
    
    RefreshControl *_groundingRefreshControl;
    
    RefreshControl *_newRefreshControl;
    
    RefreshControl *_ungroundingRefreshControl;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _selectedsArray = [[NSMutableArray alloc]init];
        
        
        return self;
    }else{
        return nil;
    }
    
}

- (void)addViewOnScrollViewWithNumber:(NSInteger)number{

    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:self.subviews];
    
    for (UIView *view in array) {
        
        
        [view removeFromSuperview];
        
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width*number, self.frame.size.height);
    
    for (int i = 0; i<number; i++) {
        
        NSMutableArray *array = [[NSMutableArray alloc]init];
        
        [_selectedsArray addObject:array];
        
        //!tableView
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, numTopViewHeight, self.frame.size.width, self.frame.size.height-numTopViewHeight)style:UITableViewStyleGrouped];
        
        [tableView setBackgroundColor:[UIColor whiteColor]];
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        tableView.tag = tableViewTagOfGoosScrollView+i;// 101 102 103
        
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [tableView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];
        
        [self addSubview:tableView];
        
    
        //!没有数据的提示label
        UILabel *label = [[UILabel alloc]init];
        
        label.bounds = CGRectMake(0, 0, tableView.frame.size.width, 20);
        
        label.center = tableView.center;
        
        label.text = [self.tipNoDataArray objectAtIndex:i];
        
        label.tag = tipNoDataLabelTag+i;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.backgroundColor = [UIColor clearColor];
        
        label.font = [UIFont systemFontOfSize:13];
        
        [self addSubview:label];
        
        //!数量提示
        UILabel * numLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.origin.x+15, (numTopViewHeight - 15 )/2.0, 150, 15)];
        
        [numLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
        [numLabel setFont:[UIFont systemFontOfSize:13]];
        numLabel.tag = numTag+i;
        [self addSubview:numLabel];
        
        
    }
    
    UITableView *tableView = (UITableView *)[self viewWithTag:101];
    
    UITableView *tableView1 = (UITableView *)[self viewWithTag:102];
    
    UITableView *tableView2 = (UITableView *)[self viewWithTag:103];

    
    _groundingRefreshControl  = [[RefreshControl alloc] initWithScrollView:tableView delegate:self];
    
    _groundingRefreshControl.bottomEnabled = YES;

    
    _newRefreshControl  = [[RefreshControl alloc] initWithScrollView:tableView1 delegate:self];
    
    _newRefreshControl.bottomEnabled = YES;

    
    _ungroundingRefreshControl  = [[RefreshControl alloc] initWithScrollView:tableView2 delegate:self];
    
    _ungroundingRefreshControl.bottomEnabled = YES;

}

//!每次请求回来，都需要先把状态改成yes
-(void)changeBottomStatus:(NSInteger)index{

    
    if (index == 0) {//!在售
        
        [self changeRefresh:_groundingRefreshControl];
        
        
    }else if (index == 1){//!新发布
        
        [self changeRefresh:_newRefreshControl];

        
    }else if (index == 2){//!已下架
        
        [self changeRefresh:_ungroundingRefreshControl];

        
    }
    
    
}
-(void)changeRefresh:(RefreshControl *)refresh{

   
    refresh.dataEnable = YES;
    refresh.bottomEnabled = YES;
    


}


//!没有数据的时候停止给footer的下拉；有数据，但是已经全部请求了，就改底部提示语
-(void)stopFooterRefreshAlert:(NSInteger)index withNumDic:(NSDictionary *)dic{

    //!判断总数据是否为0
    NSMutableArray *array = [self.resourceData objectAtIndex:index];

    if (index == 0) {//!在售
       
        [self stopWithRefresh:_groundingRefreshControl WithDataArrayCount:array.count withTotalCount:[dic[@"0"] integerValue]];
        
        
    }else if (index == 1){//!新发布
    
        [self stopWithRefresh:_newRefreshControl WithDataArrayCount:array.count withTotalCount:[dic[@"1"] integerValue]];

        
    }else if (index == 2){//!已下架
    
        [self stopWithRefresh:_ungroundingRefreshControl WithDataArrayCount:array.count withTotalCount:[dic[@"2"] integerValue]];

    
    }
    

    
    
}
-(void)stopWithRefresh:(RefreshControl*)refresh WithDataArrayCount:(NSInteger )count withTotalCount:(NSInteger)totalCount{

    
//    !总数据为0的时候，去掉提示语
    if (!count) {
        
        refresh.dataEnable = NO;
    }
    
//    !已经没有更多数据的时候，修改提示语(总书记为0的时候也需要这个)
    if (totalCount == count) {
        
        refresh.bottomEnabled = NO;
    
    }
  


}

- (void)reloadData{
    

    
    for (int i = 0; i<self.resourceData.count; i++) {
        
        
        //!刷新tableView
        UITableView *tableView = (UITableView *)[self viewWithTag:tableViewTagOfGoosScrollView+i];
        
        [tableView reloadData];
        
        //!刷新顶部数量的数据
        [self changeTopNum:i];
        
        
    }
    
    
}
//!刷新顶部数量的数据
-(void)changeTopNum:(NSInteger)i{
    
    UILabel * numLabel = (UILabel *)[self viewWithTag:numTag+i];
    
    NSNumber *num = @0;
    NSString *showStr = @"";
    
    if (i == 0) {//!在售
        
        if (self.numDic[@"0"]) {
            
            num = self.numDic[@"0"];
        }
        
        showStr = @"在售商品";
        
    }else if (i == 1){//!新发布
        
        if (self.numDic[@"1"]) {
            
            num = self.numDic[@"1"];
        }
        showStr = @"新发布商品";

        
    }else if (i == 2){//!已下架
    
        if (self.numDic[@"2"]) {
            
            num = self.numDic[@"2"];
        }
        showStr = @"已下架商品";

    }
    
    [numLabel setText:[NSString stringWithFormat:@"%@：%@",showStr,num]];
    

}

- (void)hiddenTipNoDataLabel{
    
    for (int i = 0; i<self.resourceData.count; i++) {
        
        UILabel *label = (UILabel *)[self viewWithTag:tipNoDataLabelTag+i];
        
        NSMutableArray *array = [self.resourceData objectAtIndex:i];
        
        //!找到当前的tableView
        UITableView * nowTableView= (UITableView *)[self viewWithTag:tableViewTagOfGoosScrollView+i];

        if (!array.count) {
        
            label.hidden = NO;
        
            //!没有数据的时候 背景为白色
            [nowTableView setBackgroundColor:[UIColor whiteColor]];

            
        }else{
            
            label.hidden = YES;
            //!有数据的时候背景 和cell底部的分割线是一个颜色
            [nowTableView setBackgroundColor:[UIColor colorWithHex:0xefeff4 alpha:1]];

        
        }
    }
    
}

#pragma mark-UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSMutableArray *array = [self.resourceData objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
        
    return array.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellID = @"CSPGoodsTableViewCellID";
    
    CSPGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsTableViewCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    if (self.resourceData.count) {
        
        NSMutableArray *array = [self.resourceData objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
        
        EditGoodsDTO *editGoods = [array objectAtIndex:indexPath.section];
        
        [cell configData:editGoods];
        
        if (tableView.tag == tableViewTagOfGoosScrollView) {// !101：是已经上架的
            
            [cell.groundingButton setTitle:@"下架" forState:UIControlStateNormal];
            
            cell.goodsStatus = @"3";
            
        }else{// !未发布的 已下架的
            
            [cell.groundingButton setTitle:@"上架" forState:UIControlStateNormal];
            
            cell.goodsStatus = @"2";
            
        }
        
        if (tableView.tag == 102) {// !未发布 因为歇业中及关闭的商家不能发布 这里需要记录
            
            cell.isNotPublish = YES;
            
        }
        
        
        cell.goodsNo = editGoods.goodsNo;
        // !上架/下架
        cell.goodsStatusOperation = ^(NSString *goodsNo,NSString *goodsStatus){
            
            self.goodsOperationBlock(goodsNo,goodsStatus);
        };
        
        //!不能上架
        cell.cannotChangeStatus = ^(NSString *resason){
            
            if (self.cannotChangeStatus) {
                
                self.cannotChangeStatus(resason);
            }
            
        };

        
    }
    
    
    return cell;
    
    
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *headViewID = @"headViewID";
    
    NSMutableArray *array = [self.resourceData objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
    
    EditGoodsDTO *editGoods = [array objectAtIndex:section];
    
    CSPGoodsTopView *view = (CSPGoodsTopView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewID];
    
    
    if (!view) {
        
        view = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsTopView" owner:self options:nil]firstObject];
    }
    
    
    view.articleNumberLabel.text = [NSString stringWithFormat:@"货号：%@", editGoods.goodsWillNo];
    
    view.typeLabel.text = [self.titleArray objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
    
    NSMutableArray *selectedArray = [_selectedsArray objectAtIndex:tableView.tag - tableViewTagOfGoosScrollView];
    
    if ([selectedArray containsObject:editGoods]) {
        
        view.selectedButton.selected = YES;
    }else{
        view.selectedButton.selected = NO;
    }

    //选择商品
    view.selectedGoods = ^(){
        
        if ([selectedArray containsObject:editGoods]) {
            [selectedArray removeObject:editGoods];
        }else{
            [selectedArray addObject:editGoods];
        }
        
        self.selectedGoodsBlock(_selectedsArray);
    };
    
    
    return view;
    
    
}
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//
//    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [footerView setBackgroundColor:[UIColor yellowColor]];
//    
//    return nil;
//}

//全选
- (void)selectAllWithGoodsSalesStatus:(GoodsSalesStatus)goodsSalesStatus{
    
    NSMutableArray *array = [_selectedsArray objectAtIndex:goodsSalesStatus];
    
    //全选
    [array addObjectsFromArray:[self.resourceData objectAtIndex:goodsSalesStatus]];
        
    //刷新tableview
    UITableView *tableView = (UITableView *)[self viewWithTag:tableViewTagOfGoosScrollView+goodsSalesStatus];
    
    [tableView reloadData];
    
    self.undercarriageBlock(_selectedsArray);
}

//全不选
- (void)selectNothingWithGoodsSalesStatus:(GoodsSalesStatus)goodsSalesStatus{
    
    NSMutableArray *array = [_selectedsArray objectAtIndex:goodsSalesStatus];
    
    //全不选
    [array removeAllObjects];
    
    //刷新tableview
    UITableView *tableView = (UITableView *)[self viewWithTag:tableViewTagOfGoosScrollView+goodsSalesStatus];
    
    [tableView reloadData];
    
    self.undercarriageBlock(_selectedsArray);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.resourceData.count) {
        
        NSMutableArray *array = [self.resourceData objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
        
        EditGoodsDTO *editGoodsDTO = [array objectAtIndex:indexPath.section];
    
        
        NSMutableArray * vipPriceArray = [NSMutableArray arrayWithCapacity:0];
        
      
        NSDictionary * price6Dic = @{@"level":@"6",
                                     @"price":editGoodsDTO.price6};
        [vipPriceArray addObject:price6Dic];
        
        NSDictionary * price5Dic = @{@"level":@"5",
                                     @"price":editGoodsDTO.price5};
        [vipPriceArray addObject:price5Dic];
        
        NSDictionary * price4Dic = @{@"level":@"4",
                                     @"price":editGoodsDTO.price4};
        [vipPriceArray addObject:price4Dic];
        
        NSDictionary * price3Dic = @{@"level":@"3",
                                     @"price":editGoodsDTO.price3};
        
        [vipPriceArray addObject:price3Dic];
        
        NSDictionary * price2Dic = @{@"level":@"2",
                                     @"price":editGoodsDTO.price2};
        
        [vipPriceArray addObject:price2Dic];
        
        NSDictionary * price1Dic = @{@"level":@"1",
                                     @"price":editGoodsDTO.price1};
        
        [vipPriceArray addObject:price1Dic];
        
        
        CGFloat priceViewWidth = self.frame.size.width - (15 +60) - 15 - 30;//!减去 图片距离前面的距离 、图片宽高、价格view距离前面的距离、价格view距离后面的距离 = 价格view的宽度
        
        CGRect priceRect;
        for (int i = 0 ; i < vipPriceArray.count ; i ++ ) {
            
            
            NSDictionary * priceDic = vipPriceArray[i];
            
            NSString * levelStr = [NSString stringWithFormat:@"V%@: ",priceDic[@"level"]];
            
            NSMutableAttributedString * levelString = [[NSMutableAttributedString alloc]initWithString:levelStr attributes:
                                                       @{NSForegroundColorAttributeName: [UIColor colorWithHex:0x666666 alpha:1],
                                                         NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            NSMutableAttributedString * priceSting = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"￥%@",priceDic[@"price"]] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
            
            [levelString appendAttributedString:priceSting];
            
            CGSize vipLabelSize = [self showVIPPriceSize:[NSString stringWithFormat:@"V%@: ￥%@",priceDic[@"level"],priceDic[@"price"]]];
            
            
            CGRect vipRect ;
            
            if (i == 0) {//!还没有记录下label来，就是第一个
                
                vipRect = CGRectMake(0, 0, vipLabelSize.width, vipLabelSize.height);
                
            }else{
                
                vipRect = CGRectMake(CGRectGetMaxX(priceRect)+13, priceRect.origin.y, vipLabelSize.width, vipLabelSize.height);
                
                float vipWidth = CGRectGetMaxX(vipRect);
                
                
                if (vipWidth >= priceViewWidth) {//!重新起一行
                    //!cell.vipPriceView.frame.size.width =200
                    
                    vipRect = CGRectMake(0, CGRectGetMaxY(priceRect)+10, vipLabelSize.width, vipLabelSize.height);
                    
                    
                }
                
                
            }
            
            priceRect = vipRect;//!记录下来
            
        }
        
        float  cellHight = 175;
        cellHight = cellHight - 35;//!先用当前cell的高度 - xib里面价格view的高度（35）
        
        cellHight = cellHight + CGRectGetMaxY(priceRect);//!其他部分的高度 + 价格view的高度
    
        priceRect = CGRectMake(0, 0, 0, 0);
        
        return cellHight;
        
    }
    
    
    
    return 175.0f;

    
}
-(CGSize )showVIPPriceSize:(NSString *)price{
    
    //!cell.vipPriceView.frame.size.width =200
    CGSize showSize = [price boundingRectWithSize:CGSizeMake(200, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size;
    
    return showSize;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30.0f;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.00001;//!去除底部的footer
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *array = [self.resourceData objectAtIndex:tableView.tag-tableViewTagOfGoosScrollView];
    
    EditGoodsDTO *editGoods = [array objectAtIndex:indexPath.section];

    self.goodsDetailsEditBlock(editGoods.goodsNo);
    
    
}

- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    
    if (direction==RefreshDirectionTop)
        
    {
        
    }else if (direction == RefreshDirectionBottom){
        
        //上拉的时候需要知道上拉的是新发布、在售、已下架
        
        if (refreshControl == _groundingRefreshControl) {
            //在售
            self.refreshBlock(@"2",SalesStatusOnSales);
        }
        
        if (refreshControl == _ungroundingRefreshControl) {
            //已下架
            self.refreshBlock(@"3",SalesStatusUndercarriage);

        }
        
        if (refreshControl == _newRefreshControl) {
            //新发布
            self.refreshBlock(@"1",SalesStatusNewRelease);

        }
        
    }
    
}

- (void)completeRefresh{

    [_groundingRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
    [_newRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
    [_ungroundingRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
    
    
}
- (void)completeRefresh:(NSInteger)index{

    if (index == 0) {//!在售
        
        [_groundingRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        
    }else if (index == 1){//!新发布
        
        [_newRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        
    }else if (index == 2){//!已下架
        
        [_ungroundingRefreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
        
    }
    
    
    

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    
    UITableView *tableView = (UITableView *)[self viewWithTag:101];
    
    UITableView *tableView1 = (UITableView *)[self viewWithTag:102];
    
    UITableView *tableView2 = (UITableView *)[self viewWithTag:103];
    
    
    //!当显示不满一屏幕，则隐藏底部的刷新提示
    if (scrollView == tableView) {//!在售
        
        if (tableView.contentSize.height < tableView.frame.size.height) {
            
            _groundingRefreshControl.dataEnable = NO;
            _groundingRefreshControl.bottomEnabled = NO;

        }
        
        [self setScToTopWithGrounding:YES withNew:NO withUnGrounding:NO];
        
    }else if (scrollView == tableView1){//!新发布
        
        
        if (tableView1.contentSize.height < tableView1.frame.size.height) {
            
            _newRefreshControl.dataEnable = NO;
            _newRefreshControl.bottomEnabled = NO;
        }
       
        [self setScToTopWithGrounding:NO withNew:YES withUnGrounding:NO];

        
    }else if (scrollView == tableView2){//!已下架
        
        if (tableView2.contentSize.height < tableView2.frame.size.height) {
            
            _ungroundingRefreshControl.dataEnable = NO;
            _ungroundingRefreshControl.bottomEnabled = NO;
        
        }
        
        [self setScToTopWithGrounding:NO withNew:NO withUnGrounding:YES];

        
    }

    
}
//!设置 点击状态栏 tableView是否可以滑动到顶部
-(void)setScToTopWithGrounding:(BOOL)isGrounding withNew:(BOOL)isNew withUnGrounding:(BOOL)isUnGrounding{

    self.scrollsToTop = NO;
    
    UITableView *tableView = (UITableView *)[self viewWithTag:101];
    
    UITableView *tableView1 = (UITableView *)[self viewWithTag:102];
    
    UITableView *tableView2 = (UITableView *)[self viewWithTag:103];

    //!在售
    tableView.scrollsToTop = isGrounding;
    
    //!新发布
    tableView1.scrollsToTop = isNew;
    
    //!已下架
    tableView2.scrollsToTop = isUnGrounding;

    
}


@end
