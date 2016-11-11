//
//  CollectionGoodsViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/3.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MerchantListDetailsDTO;
@protocol CollectionGoodsViewControllerDelegate <NSObject>

-(void)backEliminateCollectionGoodsWebView;
-(void)enterTheDetailsPageDic:(NSDictionary *)dic;

-(void)enterTheChatPageOfTheServiceDic:(NSDictionary *)dic;

-(void)collectionGoodsListDetailPageDic:(MerchantListDetailsDTO *)dic merchantNo:(NSString *)merchantNo;



@end

@interface CollectionGoodsViewController : UIViewController

@property (nonatomic,strong)UIWebView *webView;

@property (weak,nonatomic)id<CollectionGoodsViewControllerDelegate>delegate;

@end
