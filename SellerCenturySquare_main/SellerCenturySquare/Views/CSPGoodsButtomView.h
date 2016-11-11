//
//  CSPGoodsButtomView.h
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPBaseCustomView.h"

//!销售渠道
typedef NS_ENUM(NSInteger,ChannelType){

    ChannelType_All = 0,//!全部
    ChannelType_Wholse = 1,//!批发
    ChannelType_Retail = 2,//!零售
    ChannelType_WholseAndRetail = 3 //!批发/零售

};

@protocol CSPGoodsButtomViewDelegete <NSObject>
//全选
- (void)selectedAll;
//全部上架、全部下架
- (void)goodsStateOperation;

@end


@interface CSPGoodsButtomView : CSPBaseCustomView


@property(assign,nonatomic)id<CSPGoodsButtomViewDelegete>delegete;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;


@property (weak, nonatomic) IBOutlet UIButton *operationBtn;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;


//!底部左按钮
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

//!底部右按钮
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

//!记录当前的销售渠道
@property(nonatomic,assign)ChannelType channelType;


//!全选
@property (copy,nonatomic)void(^selectedAllGoods)();

//!上下架操作
@property (copy,nonatomic)void(^goodsOperation)();


//!左边按钮的操作
@property(nonatomic,copy) void(^leftBtnClickBlock)();

//!右边按钮的操作
@property(nonatomic,copy) void(^rightBtnClickBlock)();



-(void)configBottom:(ChannelType)channelType;


@end
