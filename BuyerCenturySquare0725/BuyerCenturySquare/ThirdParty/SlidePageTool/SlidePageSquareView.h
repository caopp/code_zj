//
//  SlidePageSquareView.h
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SlidePageSquareView;
@protocol SlidePageSquareViewDelegate<NSObject>

/**
 *  按钮点击回调
 *  @param view  滑块视图
 *  @param index 点击按钮 Index
 */
- (void)slidePageSquareView:(SlidePageSquareView*)view andBtnClickIndex:(NSInteger)index;

@end

@interface SlidePageSquareView : UIScrollView

/**
 *  init 方法
 *  @param dataArr 数据源 <NSString*>
 *  @param bgColor 背景颜色 <UIColor*>
 *  @param squareViewColor 滑块的颜色 <UIColor*>
 *  @param unSelectTitleColor 未选中文字的颜色 <UIColor*>
 *  @param selectTitleColor 选中文字的颜色 <UIColor*>
 *  @param titleFont 文字的字体 <UIFont*>
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

/**
 *  滑块视图的delegate 方法 —— 点击时会回调delegate
 */
@property (nonatomic,weak)   id <SlidePageSquareViewDelegate> delegateForSlidePage;

@end
