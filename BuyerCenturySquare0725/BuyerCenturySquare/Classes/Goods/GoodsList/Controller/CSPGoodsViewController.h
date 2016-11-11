//
//  CSPGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"


// !====商品
// !一级分类
#import "REMenu.h"
#import "REMenuItem.h"
#import "CSPCategoryMenu.h"
#import "CommodityClassification.h"// !商品--商家分类总集



#import "CommodityClassificationDTO.h"// !商品--商家分类dto



// !====商家
#import "CSPMerchantInfoPopView.h"// !商家--商家信息view

#import "CSPMerchantClosedView.h"// !商家关闭的view
#import "CSPMerchantBlackListView.h"// !商家黑名单view
#import "CSPMerchantOutOfBusinessView.h"// !歇业状态的view
#import "CSPMerchantNoGoodsView.h"//!没有商品的view
#import "GoodsCategoryMenuView.h"// !商家商品分类

#import "MerchantListDetailsDTO.h" // !商家详情 dto
#import "GetCategoryListDTO.h"// !商家详情 --商品分类总
#import "GetCategoryDTO.h"// !商家详情--商品分类

#import "ConversationWindowViewController.h"// !客服聊天
#import "CSPMerchantTableViewController.h"// !商家列表



// !===公共
#import "SMSegmentView.h"//!第三方分段选择
#import "CSPGoodsCollectionViewCell.h"// !collectionCell
#import "CSPAuthorityPopView.h"// !点击cell，权限不够时候的提醒view
#import "CSPGoodsSectionHeaderView.h"

#import "CSPGoodsInfoTableViewController.h"// !商品详情
#import "CSPPostageViewController.h"// !邮费专拍


#import "GoodsNotLevelTipDTO.h" // !查看商品详情需要的等级 的dto
#import "CommodityGroupListDTO.h" // !商品总列表
#import "GoodsInfoDTO.h" // !商品详情

#import "UIImageView+WebCache.h"
#import "UIImage+ImageEffects.h"

#import "SWRevealViewController.h"


typedef NS_ENUM(NSInteger, CSPGoodsViewStyle) {
    
    CSPGoodsViewStyleAll,
    CSPGoodsViewStyleSingleMerchant,
    
};

typedef NS_ENUM(NSInteger, CSPMerchantStyle) {
    CSPMerchantStyleNormal,
    CSPMerchantStyleClosed,         //关闭
    CSPMerchantStyleBlackList,      //黑名单
    CSPMerchantStyleOutOfBusiness,  //歇业
};

@interface CSPGoodsViewController :BaseViewController


@property(nonatomic, assign)CSPGoodsViewStyle style;
@property(nonatomic, strong)MerchantListDetailsDTO* merchantDetail;
@property (strong, nonatomic) NSMutableArray * menuArray;
@property (assign, nonatomic) BOOL isFromLetter;



@end
