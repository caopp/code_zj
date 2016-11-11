//
//  YcSegmentView.h
//  YCSegmentDemo
//
//  Created by hz_jiajia on 16/3/22.
//  Copyright © 2016年 hz_jiajia. All rights reserved.
//

#define SCREENW  [UIScreen mainScreen].bounds.size.width
#define SCREENH  [UIScreen mainScreen].bounds.size.height

#import <UIKit/UIKit.h>

@protocol YcSegmentViewDelegate <NSObject>

- (void)didSelectIndex:(NSInteger)index;


@end

@interface YcSegmentView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) BOOL animation;

@property (nonatomic, strong) NSArray *titleArray;//标题title
@property (nonatomic, strong) NSArray *showControllerArray;//每项对应的UIViewController
@property (nonatomic, weak) id <YcSegmentViewDelegate> delegate;


-(instancetype)initWithFrame:(CGRect)frame andHeaderHeight:(CGFloat )headerHeight andTitleArray:(NSArray *)titleArray andShowControllerNameArray:(NSArray *)showControllerArray nav:(UINavigationController *)nav;


-(instancetype)initWithFrame:(CGRect)frame andHeaderHeight:(CGFloat )headerHeight andTitleArray:(NSArray *)titleArray andShowControllerNameArray:(NSArray *)showControllerArray;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com