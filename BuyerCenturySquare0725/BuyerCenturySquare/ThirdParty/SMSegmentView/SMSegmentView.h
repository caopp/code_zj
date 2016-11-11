//
//  SMSegmentView.h
//  BuyerCenturySquare
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSegment.h"

@class SMSegmentView;

@protocol SMSegmentViewDelegate <NSObject>

- (void)segmentView:(SMSegmentView*)segmentView didSelectSegmentAtIndex:(NSInteger)index;

@end


typedef NS_ENUM(NSInteger, SegmentOrganiseMode) {
    SegmentOrganiseHorizontal,
    SegmentOrganiseVertical
};

/*
 Keys for segment properties
 */

// This is mainly for the top/bottom margin of the imageView
extern const NSString* keyContentVerticalMargin;

// The colour when the segment is under selected/unselected
extern const NSString* keySegmentOnSelectionColour;
extern const NSString* keySegmentOffSelectionColour;

// The colour of the text in the segment for the segment is under selected/unselected
extern const NSString* keySegmentOnSelectionTextColour;
extern const NSString* keySegmentOffSelectionTextColour;

// The font of the text in the segment
extern const NSString* keySegmentTitleFont;

@interface SMSegmentView : UIView <SMSegmentDelegate>

@property(nonatomic, assign)id<SMSegmentViewDelegate> delegate;
@property(nonatomic, assign)NSInteger indexOfSelectedSegment;
@property(nonatomic, assign)NSInteger numberOfSegments;
@property(nonatomic, assign)SegmentOrganiseMode organiseMode;
@property(nonatomic, assign)CGFloat segmentVertivalMargin;
@property(nonatomic, strong)UIColor* separatorColor;
@property(nonatomic, assign)CGFloat separatorWidth;
@property(nonatomic, strong)UIColor* segmentOnSelectionColor;
@property(nonatomic, strong)UIColor* segmentOffSelectionColor;
@property(nonatomic, strong)UIColor* segmentOnSelectionTextColor;
@property(nonatomic, strong)UIColor* segmentOffSelectionTextColor;
@property(nonatomic, strong)UIFont* segmentTitleFont;


- (id)initWithFrame:(CGRect)frame separatorColor:(UIColor*)separatorColor separatorWidth:(CGFloat)separatorWidth segmentProperties:(NSDictionary*)segmentProperties;

- (void)addSegmentWithTitle:(NSString*)title;
- (void)addSegmentWithTitle:(NSString*)title onSelectionImage:(UIImage*)onSelectionImage offSelectionImage:(UIImage*)offSelectionImage;

- (void)selectSegmentAtIndex:(NSInteger)index;
- (void)deselectSegment;


@end
