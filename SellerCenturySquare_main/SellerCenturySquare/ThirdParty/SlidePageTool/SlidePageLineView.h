//
//  SlidePageLineView.h
//  SlidePageTool
//
//  Created by 小胖的Mac on 16/6/16.
//  Copyright © 2016年 江文俊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlidePageLineView : UIScrollView

/**
 *  实例化方法
 *
 *  @param dataArr 数据源
 *
 *  @return 返回实例化对象
 */
- (instancetype)initWithDataArr:(NSArray<NSString*>*)dataArr;

/**
 *  滑动过程中，滑块的偏移量
 */
@property (nonatomic,assign) CGFloat  squareViewOriginX;

/**
 *  停止滑动时，滑块的偏移量
 */
@property (nonatomic,assign) CGFloat  endcontentOffsetX;

@end
