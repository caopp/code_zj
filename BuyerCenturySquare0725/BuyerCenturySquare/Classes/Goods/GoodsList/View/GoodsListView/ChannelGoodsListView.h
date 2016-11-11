 //
//  ChannelGoodsListView.h
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//  !频道的商品列表

#import <UIKit/UIKit.h>
#import "CommodityGroupListDTO.h"

@interface ChannelGoodsListView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    
    
    //!item的宽度（图片的宽度）、item高度
    float itemWidth;
    float itemHight;
    
    //!需要传入的参数
    //!频道id
    int channelId;
    //!查看范围
    NSString * rangeFlag;
    //!查看的页码
    int pageNo;
    //!每页搜索出来的个数
    int pageSize;
    
    int totoalCount;
    NSMutableArray * dataArray;
    
}
@property(nonatomic,strong)UICollectionView *goodsCollectionView;
@property (nonatomic, weak) SDRefreshHeaderView *refreshHeader;
@property (nonatomic, weak) SDRefreshFooterView *refreshFooter;

//!点击事件的处理
@property(nonatomic,copy) void(^selectBlock)(Commodity *);

//!无商品的block
@property(nonatomic,copy) void(^noGoodsBlock)();

//!请求完毕
@property(nonatomic,copy) void(^finishRequest)();


-(id)initWithFrame:(CGRect)frame withChannelId:(int)channelIds rangFlag:(NSString *)rangeFlags;

-(void)requestData:(SDRefreshView *)refresh;



@end
