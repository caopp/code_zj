//
//  CPSGoodsDetailsPreviewViewController.h
//  SellerCenturySquare
//
//  Created by clz on 15/9/1.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "CPSGoodsDeatilsCell.h"// !商品详情--》商品描述

@interface CPSGoodsDetailsPreviewViewController : BaseViewController

@property(nonatomic, strong) NSMutableArray *arrColorItems;
@property(nonatomic,strong)GetGoodsInfoListDTO *getGoodsInfoList;

@property(nonatomic,assign)BOOL isPreview;
@property(nonatomic,assign)BOOL  noGoodsListView; //非 商品 预览
@property (nonatomic,assign)BOOL isNotes;//手记详情进入
@property (nonatomic, assign) BOOL isFromConversation;

/**
 *  商品编号，用商品编号来请求商品详情数据
 */
@property(nonatomic,copy)NSString *goodsNo;

@property(nonatomic,copy)NSString *defaultPicUrl;



@end
