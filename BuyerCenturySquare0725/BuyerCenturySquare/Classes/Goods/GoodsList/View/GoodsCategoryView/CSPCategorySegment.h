//
//  CSPCategorySegment.h
//  CategoryViewDemo
//
//  Created by skyxfire on 8/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CSPCategorySegment;

@protocol CSPCategorySegmentDelegate <NSObject>

- (void)selectSegment:(CSPCategorySegment*)segment;

@end

@interface CSPCategorySegment : UIView

@property (nonatomic, assign) id<CSPCategorySegmentDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property(nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat separatorWidth;
// Segment Colour
@property (nonatomic, strong) UIColor* onSelectionColor;
@property (nonatomic, strong) UIColor* offSelectionColor;
// Segment Title Text & Colour & Font
@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) UIColor* onSelectionTextColor;
@property (nonatomic, strong) UIColor* offSelectionTextColor;
@property (nonatomic, strong) UIFont* titleFont;
@property (nonatomic, assign) BOOL isdrawLine;


- (id)initWithSeparatorWidth:(CGFloat)separatorWidth verticalMargin:(CGFloat)verticalMargin onSelectionColor:(UIColor*)onSelectionColor offSelectionColor:(UIColor*)offSelectionColor onSelectionTextColor:(UIColor*)onSelectionTextColor offSelectionTextColor:(UIColor*)offSelectionTextColor titleFont:(UIFont*)titleFont isDrawLine:(BOOL)isDrawLine;

@end
