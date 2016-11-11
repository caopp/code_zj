//
//  ScoreRecordViewController.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/12.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  ScoreRecordViewControllerDelagate<NSObject>

-(void)removeScoreRecordCache;

@end

@interface ScoreRecordViewController : UIViewController

@property(nonatomic,weak)id<ScoreRecordViewControllerDelagate>delegate;

@property(nonatomic,strong)UIWebView *webView;

@end
