//
//  CCWebViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/4/28.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@protocol CCWebViewControllerDelegate <NSObject>

-(void)backEliminateOrderingMerchantsVC;

-(void)enterTheDetailsPageDic:(NSDictionary *)dic;

-(void)enterTheChatPageOfTheServiceDic:(NSDictionary *)dic;

-(void)removeScoreRecordCache;

-(void)removeTradingWaterCache;

-(void)jumpToPayInterfaceDic:(NSDictionary *)dic;



@end

@interface CCWebViewController : BaseViewController
@property (nonatomic,strong)NSString *file;
@property (nonatomic,strong)NSString *titleVC;
@property (strong, nonatomic) UIWebView *webView;
@property (nonatomic,assign)BOOL isOK;

@property (nonatomic,assign)BOOL isPay;

@property (nonatomic,assign)BOOL isRecond;

@property (nonatomic,assign)BOOL isTitle;


@property (nonatomic,assign)BOOL isRule;

@property (nonatomic,assign)BOOL isProtocal;



@property (nonatomic,assign)BOOL isPrepay;

@property (weak,nonatomic)id<CCWebViewControllerDelegate>delegate;




@property (nonatomic,strong)NSString *show;
@end
