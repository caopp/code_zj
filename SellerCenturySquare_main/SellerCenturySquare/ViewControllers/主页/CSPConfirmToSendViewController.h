//
//  CSPConfirmToSendViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "SaveGoodsRecommendModel.h"

@interface CSPConfirmToSendViewController : BaseViewController
@property (nonatomic,strong) NSMutableDictionary *goodsInfoDic;
@property (nonatomic,strong) NSMutableDictionary *memberInfoDic;
@property (nonatomic,strong) SaveGoodsRecommendModel *saveGoodsRecommendModel;

@end
