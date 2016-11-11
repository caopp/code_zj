//
//  GuideViewController.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideViewController : UIViewController<UIScrollViewDelegate>
{
    
    UIScrollView * guideScrollView;
    NSArray *imagesArray;
    UIPageControl *pageControl;
    
}
//!点击确定后调用的block

@property(nonatomic,copy)void (^changeVCBlcok)();

// !从关于 进入
@property(nonatomic,assign)BOOL isFromAbout;

@end
