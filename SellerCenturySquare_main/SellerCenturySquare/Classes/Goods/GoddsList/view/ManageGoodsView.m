//
//  ManageGoodsView.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ManageGoodsView.h"
#import "CSPGoodsButtomView.h"
#import "CSPGoodsTableViewCell.h"//!cell
#import "CSPGoodsTopView.h"//!header

//!底部操作栏的高度
static float bottomNormalHight = 44;
static float bottomHight = 94;//!底部 渠道修改的高度

@interface ManageGoodsView()<UITableViewDelegate,UITableViewDataSource>
{
    
    //!商品数量
    UILabel * _numLabel;
    
    UITableView * _tableView;
    
    CSPGoodsButtomView * _goodsButtomView;
    
    //!商品数据
    NSMutableArray * _goodsDataArray;
    
    //!当前view要显示的商品状态
    NSInteger _goodsStatus;
    
    //!当前状态的所有商品数量
    NSInteger _totalCount;
    
    //!无数据的提示
    UILabel * noDataLabel;
    
    
}
 
@property(nonatomic,strong)SDRefreshHeaderView* refreshHeader;

@property(nonatomic,strong)SDRefreshFooterView * refreshFooter;

@end


@implementation ManageGoodsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame withGoodsStatus:(NSInteger)goodsStatus{

    self = [super initWithFrame:frame];
    
    if (self) {
    
        _goodsStatus = goodsStatus;

        //!创建界面
        [self createUI];
        
        //!创建刷新
        [self createRefresh];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        //!让cell自适应高度
        _tableView.estimatedRowHeight = 44.0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        //!初始化选中数据的数组
        _selectArray = [NSMutableArray arrayWithCapacity:0];
        
        
    }
    
    return self;
    
}
#pragma mark 创建界面
-(void)createUI{

    float numLabelY = 0;
    //!在售的情况下，需要添加筛选分类功能
    if (_goodsStatus == GoodStatusOnSales) {
        
        self.segmentView = [[[NSBundle mainBundle]loadNibNamed:@"WholeAndRetailSegmentView" owner:self options:nil]lastObject];
        self.segmentView.frame = CGRectMake(15, 17, SCREEN_WIDTH - 30, self.segmentView.frame.size.height);
        //!削圆
        self.segmentView.layer.masksToBounds = YES;
        self.segmentView.layer.cornerRadius = 2;
        
        //!边框
        self.segmentView.layer.borderWidth = 0.5;
        self.segmentView.layer.borderColor = [UIColor colorWithHex:0xd9d9d9].CGColor;
        
        [self addSubview:self.segmentView];
        
        __unsafe_unretained __typeof(self) weakSelf = self;
        
        //!点击了销售渠道按钮
        self.segmentView.changetypeBlock = ^(NSString * selChannelType){
        
            weakSelf.channelType = selChannelType;
            [weakSelf heaerRefresh];
            
        
        };
        
        
        numLabelY = CGRectGetMaxY(self.segmentView.frame) + 15;
        
    }
    
    
    //!商品数量
    _numLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, numLabelY, self.frame.size.width - 15, 30)];
    [_numLabel setText:@""];
    [_numLabel setTextColor:[UIColor colorWithHex:0x999999]];
    [_numLabel setFont:[UIFont systemFontOfSize:13]];
    [self addSubview:_numLabel];

    //!tableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_numLabel.frame), self.frame.size.width, self.frame.size.height - bottomNormalHight - CGRectGetMaxY(_numLabel.frame)) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    //!底部操作栏
    _goodsButtomView = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsButtomView" owner:self options:nil]firstObject];
    
    _goodsButtomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.frame.size.width, bottomNormalHight);
    
    [self addSubview:_goodsButtomView];
    
    
    
    //!实现底部操作栏的block
    [self realizeGoodsBottomBlock];
    

    //!无数据的提示栏
    noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    noDataLabel.center = self.center;
    [noDataLabel setTextAlignment:NSTextAlignmentCenter];
    [noDataLabel setTextColor:[UIColor grayColor]];
    [noDataLabel setText:[self alertNoGoodText]];
    noDataLabel.center = _tableView.center;
    noDataLabel.font = [UIFont systemFontOfSize:13];

    [self addSubview:noDataLabel];
    
    
}


#pragma mark tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return _goodsDataArray.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *cellID = @"CSPGoodsTableViewCellID";
    
    CSPGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsTableViewCell" owner:self options:nil]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    if (_goodsDataArray.count) {
        
        EditGoodsDTO *editGoods = [_goodsDataArray objectAtIndex:indexPath.section];
        
        [cell configData:editGoods];

        cell.goodsNo = editGoods.goodsNo;

        //!在售
        if (_goodsStatus == GoodStatusOnSales) {
            
            [cell.groundingButton setTitle:@"下架" forState:UIControlStateNormal];
            
            cell.goodsStatus = @"3";
            
        }else{//!新发布  已下架
        
            [cell.groundingButton setTitle:@"上架" forState:UIControlStateNormal];
            
            cell.goodsStatus = @"2";
            
        }
        
        //!如果是发布未上架的 歇业中及关闭的商家不能发布 这里需要记录
        if (_goodsStatus == GoodStatusNewRelease) {
            
            cell.isNotPublish = YES;

        }
        
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30.0f;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    static NSString *headViewID = @"headViewID";
    
    EditGoodsDTO *editGoods = [_goodsDataArray objectAtIndex:section];
    
    CSPGoodsTopView *view = (CSPGoodsTopView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:headViewID];
    
    
    if (!view) {
        
        view = [[[NSBundle mainBundle]loadNibNamed:@"CSPGoodsTopView" owner:self options:nil]firstObject];
    }
    
    
    view.articleNumberLabel.text = [NSString stringWithFormat:@"货号：%@", editGoods.goodsWillNo];
    
    [view.typeLabel setText:[self getGoodsStatus]];
    
    
    if (section == 0) {
        
        view.filterLabelOne.hidden = NO;
    
    }else{//!如果不是第一行，不需要顶部的分割线
    
        view.filterLabelOne.hidden = YES;

    }
    
    if ([_selectArray containsObject:editGoods]) {
        
        view.selectedButton.selected = YES;
    
    }else{
    
        view.selectedButton.selected = NO;
    
    }
    
    
    
    
    //选择/取消选择 商品
    view.selectedGoods = ^(){
        
        if ([_selectArray containsObject:editGoods]) {
            [_selectArray removeObject:editGoods];
        }else{
            [_selectArray addObject:editGoods];
        }
        
        //!设置底部
        [self setBottom];
        
    };
    
    
    return view;


}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 0.000001;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EditGoodsDTO *editGoods = [_goodsDataArray objectAtIndex:indexPath.section];
    
    if (self.intoDetailBlock) {
        
        self.intoDetailBlock(editGoods.goodsNo);
    }
    
    
    
}
#pragma mark 商品状态的文字
-(NSString *)getGoodsStatus{

    if (_goodsStatus == GoodStatusOnSales) {
        
        return @"在售";
        
    }else if (_goodsStatus == GoodStatusNewRelease){
        
        return @"新发布";
        
    }else{
        
        return @"已下架";
        
    }


}

#pragma mark 返回无数据时候的提示文字
//!根据枚举判断当前view 显示的是什么状态
-(NSString *)alertNoGoodText{

    if (_goodsStatus == GoodStatusOnSales) {
        
        //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
        if ([self.channelType isEqualToString:@"-1"]) {//!全部
            
            return @"暂无在售商品";
            
        }else if ([self.channelType isEqualToString:@"0"]){//!批发
            
            return @"暂无在售的批发商品";
            
        }else if ([self.channelType isEqualToString:@"1"]){//!零售
            
            return @"暂无在售的零售商品";
            
        }else{//!批发和零售
            
            return @"暂无在售的，同时在批发和零售渠道销售的商品";
            
        }
        
        return @"在售";
        
    }else if (_goodsStatus == GoodStatusNewRelease){
        
        return @"暂无新发布的商品";
        
    }else{
        
        return @"暂无下架的商品";
        
    }

}
#pragma mark 返回 顶部商品数量的提示文字
-(NSString *)setNumLabelText:(NSInteger)totalCount{
    
    
    //!顶部 商品数量的显示
    if (_goodsStatus == GoodStatusOnSales) {
        
        
        //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
        if ([self.channelType isEqualToString:@"-1"]) {//!全部
            
            return [NSString stringWithFormat:@"全部在售商品：%ld",totalCount];
            
        }else if ([self.channelType isEqualToString:@"0"]){//!批发
            
            return [NSString stringWithFormat:@"批发的商品：%ld",totalCount];
            
        }else if ([self.channelType isEqualToString:@"1"]){//!零售
            
            return [NSString stringWithFormat:@"零售的商品：%ld",totalCount];
            
        }else{//!批发和零售
            
            return [NSString stringWithFormat:@"同时[批发]和[零售]的商品：%ld",totalCount];
            
        }
        
        
        
    }else if (_goodsStatus == GoodStatusNewRelease){//!新发布
        
        return [NSString stringWithFormat:@"新发布商品：%ld",totalCount];
        
    }else{//!已下架
        
        return [NSString stringWithFormat:@"已下架商品：%ld",totalCount];
        
    }
    
    
    
}

#pragma mark 创建刷新 
-(void)createRefresh{

    // !请求
    SDRefreshHeaderView* refreshHeader = [SDRefreshHeaderView refreshViewWithStyle:SDRefreshViewStyleCustom];
    
    [refreshHeader addToScrollView:_tableView];
    
    self.refreshHeader = refreshHeader;
    
    __weak ManageGoodsView * goodsView = self;
    self.refreshHeader.beginRefreshingOperation = ^{
        
        [goodsView heaerRefresh];
    };
    
    SDRefreshFooterView * refreshFooter = [SDRefreshFooterView refreshViewWithStyle:SDRefreshViewStyleClassical];
    [refreshFooter addToScrollView:_tableView];
    
    self.refreshFooter = refreshFooter;
    
    refreshFooter.beginRefreshingOperation = ^{
        
        [goodsView goToRequest:NO];

        
    };


}
-(void)heaerRefresh{

    //!下拉刷新把选中的数据去除
    _selectArray = [NSMutableArray arrayWithCapacity:0];
    //!改变底部按钮状态
    [self setBottom];
    
    [self goToRequest:YES];

    
}

//!返回到vc 去请求数据，isHeader：是否是下拉刷新
-(void)goToRequest:(BOOL )isHeader{

    if (self.refreshBlock) {
        
        self.refreshBlock(isHeader,_goodsStatus,self.channelType);
    
    }

}


#pragma mark 刷新数据
-(void)reloadData:(NSMutableArray *)dataArray withTotalCount:(NSInteger)totalCount{


    _goodsDataArray = dataArray;
    
    _totalCount = totalCount;
    
    [_tableView reloadData];
    
    //!顶部 商品数量的显示
    [_numLabel setText:[self setNumLabelText:totalCount]];
    
    //!无数据的提示
    [noDataLabel setText:[self alertNoGoodText]];
    
    
    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];

    if (dataArray.count == totalCount) {
        
        [self.refreshFooter noDataRefresh];
    }
    
    //!如果总数量为0，显示无商品提示
    if (!totalCount) {
        
        _tableView.hidden = YES;
        
    }else{
        
        _tableView.hidden = NO;
    }
    
    noDataLabel.hidden = !_tableView.hidden;
    
    //!设置底部
    [self setBottom];
    
    


}
#pragma mark 设置底部
-(void)setBottom{

    //!全选按钮的状态
    if (_selectArray.count != 0 && _selectArray.count == _goodsDataArray.count) {
        
        _goodsButtomView.selectedButton.selected = YES;

    }else{
    
        _goodsButtomView.selectedButton.selected = NO;

    }
    

    
    //!设置底部按钮的文字
    if (_goodsStatus == GoodStatusOnSales) {
        
        
        [_goodsButtomView.operationBtn setTitle:@"下架" forState:UIControlStateNormal];
        
    }else if (_goodsStatus == GoodStatusNewRelease){//!新发布
        
        [_goodsButtomView.operationBtn setTitle:@"上架" forState:UIControlStateNormal];
        
        
    }else{//!已下架
        
        [_goodsButtomView.operationBtn setTitle:@"上架" forState:UIControlStateNormal];
        
    }
    
    //!设置底部按钮的颜色以及可用性
    if (_selectArray.count) {
        
        _goodsButtomView.operationBtn.enabled = YES;
        
        _goodsButtomView.operationBtn.backgroundColor = [UIColor colorWithHex:0xfd4f57];
        
    }else{
        
        _goodsButtomView.operationBtn.enabled = NO;
        
        _goodsButtomView.operationBtn.backgroundColor = [UIColor lightGrayColor];
        
    }
    
    //!改变底部的高度及内容
    if (_goodsStatus == GoodStatusOnSales) {//!在售
        
        [self changeBottomHight];

    }
    


}
//!改变底部的高度及内容（是否显示改变销售渠道）
-(void)changeBottomHight{

    
    //!“在售”的各个状态：销售渠道 -1 全部 0 批发 1 零售 2批发和零售
    if ([self.channelType isEqualToString:@"-1"]) {
        
        [_goodsButtomView configBottom:ChannelType_All];
        
        [UIView animateWithDuration:0.5 animations:^{
           
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(_numLabel.frame), self.frame.size.width, self.frame.size.height - bottomNormalHight - CGRectGetMaxY(_numLabel.frame));
            
            _goodsButtomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.frame.size.width, bottomNormalHight);
            
            
        }];
        
        return;
        
        
    }else if ([self.channelType isEqualToString:@"0"]){//!批发
    
        [_goodsButtomView configBottom:ChannelType_Wholse];

    
    }else if ([self.channelType isEqualToString:@"1"]){//!零售
    
        [_goodsButtomView configBottom:ChannelType_Retail];
        
    }else{
        
        [_goodsButtomView configBottom:ChannelType_WholseAndRetail];

    }
    
    //!显示出底部修改销售渠道的按钮 的位置
    [UIView animateWithDuration:0.5 animations:^{
        
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_numLabel.frame), self.frame.size.width, self.frame.size.height - bottomHight - CGRectGetMaxY(_numLabel.frame));
        
        _goodsButtomView.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame), self.frame.size.width, bottomHight);
        
        
    }];
    

}

#pragma mark 底部的block
-(void)realizeGoodsBottomBlock{
    
    __weak ManageGoodsView * goodsView = self;

    //!选中全部
    _goodsButtomView.selectedAllGoods = ^(){
    
        //!先移除所有
        [goodsView.selectArray removeAllObjects];
    
        //!如果是以前不是全选，现在要全选，就加入商品
        if (!_goodsButtomView.selectedButton.selected) {
            
            //!再把所有数据加入
            [_selectArray addObjectsFromArray:_goodsDataArray];

        }
        
        //!刷新
        [_tableView reloadData];
        
        //!改变底部按钮的状态
        [self setBottom];
        
        
    };
    
    //!多个上架/下架按钮
    _goodsButtomView.goodsOperation = ^(){
    
        
        //!要让商品成为的状态
        NSString * goodsStatus = @"";
        
        //!在售
        if (_goodsStatus == GoodStatusOnSales) {
            
            goodsStatus = @"3";
            
        }else{//!新发布  已下架
            
             goodsStatus = @"2";
            
        }

        if (goodsView.multiGoodsOperationBlock) {
            
            
            goodsView.multiGoodsOperationBlock(goodsView.selectArray,goodsStatus);
            
            
        }
        
        
        
    };
    
    //!左边按钮的block
    _goodsButtomView.leftBtnClickBlock = ^(){
        
        if (goodsView.leftChangeChannelBlock) {
            
            goodsView.leftChangeChannelBlock(goodsView.selectArray);
            
        }
        
    };
    
    //!右边按钮的block
    _goodsButtomView.rightBtnClickBlock = ^(){
    
    
        if (goodsView.rightChangeChannelBlock) {
            
            goodsView.rightChangeChannelBlock(goodsView.selectArray);
            
        }
    
    };
    
}
-(void)endRefresh{

    [self.refreshHeader endRefreshing];
    [self.refreshFooter endRefreshing];
    

}

#pragma mark 设置列表是否可以置顶
-(void)setTableViewScrollToTop:(BOOL)canToTop{

    _tableView.scrollsToTop = canToTop;

}


@end
