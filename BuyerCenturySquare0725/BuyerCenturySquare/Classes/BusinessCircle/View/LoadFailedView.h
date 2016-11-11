//
//  LoadFailedView.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/4/29.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LoadFailedDelegate <NSObject>

- (void)loadFailedAgainRequest;

@end

@interface LoadFailedView : UIView

@property (nonatomic ,assign)id<LoadFailedDelegate>delegate;

@end

