//
//  DealFlowRecordViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DealFlowRecordViewControllerDelegate <NSObject>

-(void)removeDepositPrepaidPhoneRecordsCache;

@end

@interface DealFlowRecordViewController : UIViewController

@property(nonatomic,weak)id<DealFlowRecordViewControllerDelegate>delegate;



@property(nonatomic,strong)UIWebView *webView;
@end
