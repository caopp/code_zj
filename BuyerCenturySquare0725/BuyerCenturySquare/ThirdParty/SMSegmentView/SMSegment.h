//
//  SMSegment.h
//  BuyerCenturySquare
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMSegment;

@protocol SMSegmentDelegate <NSObject>

- (void)selectSegment:(SMSegment*)segment;

@end

@interface SMSegment : UIView

@property (nonatomic, assign) id<SMSegmentDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property(nonatomic, assign, getter=isSelected) BOOL selected;

@property (nonatomic, assign) CGFloat verticalMargin;
@property (nonatomic, assign) CGFloat separatorWidth;
// Segment Colour
@property (nonatomic, strong) UIColor* onSelectionColor;
@property (nonatomic, strong) UIColor* offSelectionColor;
// Segment Title Text & Colour & Font
@property (nonatomic, strong) NSString* title;

@property (nonatomic, strong) UIColor* onSelectionTextColor;
@property (nonatomic, strong) UIColor* offSelectionTextColor;
@property (nonatomic, strong) UIFont* titleFont;
//Segment Image
@property (nonatomic, strong) UIImage* onSelectionImage;
@property (nonatomic, strong) UIImage* offSelectionImage;

- (id)initWithSeparatorWidth:(CGFloat)separatorWidth verticalMargin:(CGFloat)verticalMargin onSelectionColor:(UIColor*)onSelectionColor offSelectionColor:(UIColor*)offSelectionColor onSelectionTextColor:(UIColor*)onSelectionTextColor offSelectionTextColor:(UIColor*)offSelectionTextColor titleFont:(UIFont*)titleFont;

@end
