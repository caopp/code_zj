//
//  CSPOrderSegmentView.h
//  BuyerCenturySquare
//
//  Created by 王剑粟 on 15/10/8.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderSegmentViewDelegate <NSObject>

- (void)OrderSegmentViewClick:(NSInteger)index;

@end

@interface CSPOrderSegmentView : UIView {
    
    UIScrollView * scrollView;
    NSArray * titleArray;
    NSInteger currentIndex;
}

@property (nonatomic, assign) id<OrderSegmentViewDelegate>delegate;

- (void)selectSegmentAtIndex:(NSInteger)index;

@end
