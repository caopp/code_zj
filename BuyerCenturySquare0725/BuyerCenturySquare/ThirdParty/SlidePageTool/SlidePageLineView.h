//
//  SlidePageLineView.h
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import <UIKit/UIKit.h>
#

@class SlidePageLineView;
@protocol SlidePageLineViewDelegate<NSObject>

/**
 *  按钮点击回调
 *  @param view  滑块视图
 *  @param index 点击按钮 Index
 */
- (void)SlidePageLine:(SlidePageLineView*)view andBtnClickIndex:(NSInteger)index;

@end


@interface SlidePageLineView : UIScrollView

/**
 *  实例化方法
 *
 *  @param dataArr 数据源
 *
 *  @return 返回实例化对象
 */
- (instancetype)initWithDataArr:(NSArray<NSString *> *)dataArr bgColor:(UIColor *)bgColor squareViewColor:(UIColor *)squareViewColor unSelectTitleColor:(UIColor*)unSelectTitleColor selectTitleColor:(UIColor *)selectTitleColor withTitleFont:(UIFont *)titleFont;

/**
 *  滑动过程中，滑块的偏移量
 */
@property (nonatomic,assign) CGFloat  squareViewOriginX;

/**
 *  停止滑动时，滑块的偏移量
 */
@property (nonatomic,assign) CGFloat  endcontentOffsetX;

@property (nonatomic,weak)   id <SlidePageLineViewDelegate> delegateForSlidePage;


@end
