//
//  ChildAccountZoneView.h
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChildAccountZoneViewDelegate <NSObject>
- (void)childAccountZoneAddChildAccount;
@end
@interface ChildAccountZoneView : UIView
@property (nonatomic ,assign) id<ChildAccountZoneViewDelegate>delegate;

@end
