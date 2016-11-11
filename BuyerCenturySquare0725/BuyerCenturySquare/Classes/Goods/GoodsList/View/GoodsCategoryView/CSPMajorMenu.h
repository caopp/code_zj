//
//  CSPSecondLevelCategoryView.h
//  CategoryViewDemo
//
//  Created by skyxfire on 8/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSPCategorySegment.h"

@class CSPMajorMenu;

@protocol CSPMajorMenuDelegate <NSObject>

- (void)segmentView:(CSPMajorMenu*)segmentView didSelectSegmentAtIndex:(NSInteger)index;

@end

typedef NS_ENUM(NSInteger, CSPSegmentOrganiseMode) {
    CSPSegmentOrganiseHorizontal,
    CSPSegmentOrganiseVertical
};


@interface CSPMajorMenu : UIView

@property(nonatomic, assign)id<CSPMajorMenuDelegate> delegate;
@property(nonatomic, assign)NSInteger indexOfSelectedSegment;
@property(nonatomic, assign)NSInteger numberOfSegments;
@property(nonatomic, assign)CGFloat segmentVertivalMargin;
@property(nonatomic, strong)UIColor* separatorColor;
@property(nonatomic, assign)CGFloat separatorWidth;
@property(nonatomic, strong)UIColor* segmentOnSelectionColor;
@property(nonatomic, strong)UIColor* segmentOffSelectionColor;
@property(nonatomic, strong)UIColor* segmentOnSelectionTextColor;
@property(nonatomic, strong)UIColor* segmentOffSelectionTextColor;
@property(nonatomic, strong)UIFont* segmentTitleFont;
@property(nonatomic, assign)CSPSegmentOrganiseMode organiseMode;

- (void)addSegmentWithTitle:(NSString*)title isLastOne:(BOOL)isLastOne;
- (void)addsegmentTitles:(NSArray*)titles;

@end
