//
//  OrderingMerchantsViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/3.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderingMerchantsViewControllerDelegate <NSObject>

-(void)backEliminateOrderingMerchantsVC;

-(void)enterTheDetailsPageDic:(NSDictionary *)dic;

-(void)enterTheChatPageOfTheServiceDic:(NSDictionary *)dic;



@end

@interface OrderingMerchantsViewController : UIViewController

@property (nonatomic,strong)UIWebView *webView;

@property (weak,nonatomic)id<OrderingMerchantsViewControllerDelegate>delegate;


@end
