//
//  CSPSecondLevelCategoryView.m
//  CategoryViewDemo
//
//  Created by skyxfire on 8/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMajorMenu.h"
#import "CSPCategorySegment.h"




@interface CSPMajorMenu () <CSPCategorySegmentDelegate>

@property(nonatomic, strong)NSMutableArray* segments;

@property(nonatomic, strong)UIScrollView* scrollView;

@end


@implementation CSPMajorMenu

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }

    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateFrameForSegments];
}

- (void)setup {

    self.backgroundColor = [UIColor clearColor];
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:0.98];
    [self addSubview:_scrollView];

    _indexOfSelectedSegment = NSNotFound;
    _numberOfSegments = 0;
    _organiseMode = CSPSegmentOrganiseHorizontal;
    _separatorColor = [UIColor whiteColor];
    _separatorWidth = 0.0f;
//    _segmentOnSelectionColor = HEX_COLOR(0x999999F2);
//    _segmentOffSelectionColor = HEX_COLOR(0x999999F2);
    _segmentOnSelectionTextColor = [UIColor whiteColor];
    _segmentOffSelectionTextColor = [UIColor whiteColor];
    _segmentTitleFont = [UIFont systemFontOfSize:15.0];
    _segments = [NSMutableArray array];
}

#pragma mark -
#pragma mark Setter

- (void)setOrganiseMode:(CSPSegmentOrganiseMode)organiseMode {
    _organiseMode = organiseMode;

    [self setNeedsDisplay];
}

- (void)setSegmentVertivalMargin:(CGFloat)segmentVertivalMargin {
    _segmentVertivalMargin = segmentVertivalMargin;
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;

    [self setNeedsDisplay];
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;

    for (CSPCategorySegment* segment in self.segments) {
        segment.separatorWidth = self.separatorWidth;
    }

    [self updateFrameForSegments];
}

- (void)setSegmentOnSelectionColor:(UIColor *)segmentOnSelectionColor {
    _segmentOnSelectionColor = segmentOnSelectionColor;

    for (CSPCategorySegment* segment in self.segments) {
        segment.onSelectionColor = self.segmentOnSelectionColor;
    }
}

- (void)setSegmentOffSelectionColor:(UIColor *)segmentOffSelectionColor {
    _segmentOffSelectionColor = segmentOffSelectionColor;

    for (CSPCategorySegment* segment in self.segments) {
        segment.offSelectionColor = self.segmentOffSelectionColor;
    }
}

- (void)setSegmentOnSelectionTextColor:(UIColor *)segmentOnSelectionTextColor {
    _segmentOnSelectionTextColor = segmentOnSelectionTextColor;

    for (CSPCategorySegment* segment in self.segments) {
        segment.onSelectionTextColor = self.segmentOnSelectionTextColor;
    }
}

- (void)setSegmentOffSelectionTextColor:(UIColor *)segmentOffSelectionTextColor {
    _segmentOffSelectionTextColor = segmentOffSelectionTextColor;

    for (CSPCategorySegment* segment in self.segments) {
        segment.offSelectionTextColor = self.segmentOffSelectionTextColor;
    }
}

- (void)setSegmentTitleFont:(UIFont *)segmentTitleFont {
    _segmentTitleFont = segmentTitleFont;

    for (CSPCategorySegment* segment in self.segments) {
        segment.titleFont = self.segmentTitleFont;
    }
}


#pragma mark -
#pragma mark Private Methods

- (void)updateFrameForSegments {
    if (self.segments.count == 0) {
        return;
    }

    NSInteger count = self.segments.count;
    if (count > 0) {
        if (self.organiseMode == CSPSegmentOrganiseHorizontal) {
            CGFloat segmentWidth = 100.0f;

            if (count * segmentWidth < SCREEN_WIDTH) {
                segmentWidth = SCREEN_WIDTH / count;
            }
            CGFloat segmentHeight = 50.0f;
            CGFloat originX = 0.0f;
            for (CSPCategorySegment* segment in self.segments) {
                segment.frame = CGRectMake(originX, 0.0, segmentWidth, segmentHeight);
                originX += segmentWidth + self.separatorWidth;
            }

            self.frame = CGRectMake(0, 64.0, SCREEN_WIDTH, segmentHeight);
            self.scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, segmentHeight);
            self.scrollView.contentSize = CGSizeMake(originX, segmentHeight);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.scrollView.contentInset = UIEdgeInsetsZero;

        } else {
            CGFloat segmentWidth = SCREEN_WIDTH;
            CGFloat segmentHeight = 40.0f;
            CGFloat originY = 0.0f;

            for (CSPCategorySegment* segment in self.segments) {
                segment.frame = CGRectMake(0.0, originY, segmentWidth, segmentHeight);
                originY += segmentHeight + self.separatorWidth;
            }

            self.frame = CGRectMake(0, 64.0, segmentWidth, originY);
            self.scrollView.frame = self.bounds;
            self.scrollView.contentInset = UIEdgeInsetsZero;
        }
    }

    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self setNeedsDisplay];
}

- (void)drawSeparatorWithContext:(CGContextRef)context {
    CGContextSaveGState(context);

    if (self.segments.count > 1) {
        CGMutablePathRef path = CGPathCreateMutable();

        CSPCategorySegment* firstSegment = [self.segments firstObject];

        if (self.organiseMode == CSPSegmentOrganiseHorizontal) {

            CGFloat seperatorLineHeight = 15.0f;

            CGFloat originX = CGRectGetWidth(firstSegment.frame) + self.separatorWidth / 2.0f;
            for (int index = 1; index < self.segments.count; index++) {
                CGPathMoveToPoint(path, nil, originX, (CGRectGetHeight(self.frame) - seperatorLineHeight) / 2);
                CGPathAddLineToPoint(path, nil, originX, (CGRectGetHeight(self.frame) + seperatorLineHeight) / 2);

                CSPCategorySegment* nextSegment = self.segments[index];
                originX += CGRectGetWidth(nextSegment.frame) + self.separatorWidth;
            }
        } else {
            CGFloat originY = CGRectGetHeight(firstSegment.frame) + self.separatorWidth / 2.0f;
            for (int index = 1; index < self.segments.count; index++) {
                CGPathMoveToPoint(path, nil, 0.0, originY);
                CGPathAddLineToPoint(path, nil, CGRectGetWidth(self.frame), originY);

                CSPCategorySegment* nextSegment = self.segments[index];
                originY += CGRectGetHeight(nextSegment.frame) + self.separatorWidth;
            }
        }

        CGContextAddPath(context, path);
        CGContextSetStrokeColorWithColor(context, self.separatorColor.CGColor);
        CGContextSetLineWidth(context, self.separatorWidth);
        CGContextDrawPath(context, kCGPathStroke);
    }

    CGContextRestoreGState(context);
}

#pragma mark -
#pragma mark Public Methods

- (void)addsegmentTitles:(NSArray*)titles {
    for (int i = 0; i < titles.count; i++) {
        NSString* title = [titles objectAtIndex:i];
        if (i == titles.count - 1) {
            [self addSegmentWithTitle:title isLastOne:YES];
        }else {
            [self addSegmentWithTitle:title isLastOne:NO];
        }
    }
}

- (void)addSegmentWithTitle:(NSString*)title isLastOne:(BOOL)isLastOne{
    BOOL isDrawLine = YES;
    if (isLastOne) {
        isDrawLine = NO;
    }
    
    CSPCategorySegment* segment = [[CSPCategorySegment alloc]initWithSeparatorWidth:self.separatorWidth verticalMargin:self.segmentVertivalMargin onSelectionColor:self.segmentOnSelectionColor offSelectionColor:self.segmentOffSelectionColor onSelectionTextColor:self.segmentOnSelectionTextColor offSelectionTextColor:self.segmentOffSelectionTextColor titleFont:self.segmentTitleFont isDrawLine:isDrawLine];
    segment.index = self.segments.count;
    [self.segments addObject:segment];
    [self updateFrameForSegments];

    segment.delegate = self;
    segment.title = title;

    [self.scrollView addSubview:segment];
    self.numberOfSegments = self.segments.count;
}

- (void)selectSegmentAtIndex:(NSInteger)index {
    if (index >= 0 && index < self.segments.count) {
        [self selectSegment:self.segments[index]];
    } else {
        NSLog(@"Index at %ld is out of bounds", index);
    }
}

- (void)deselectSegment {
    if (self.indexOfSelectedSegment != NSNotFound) {
        CSPCategorySegment* segment = self.segments[self.indexOfSelectedSegment];
        [segment setSelected:NO];

        self.indexOfSelectedSegment = NSNotFound;
    }
}

#pragma mark -
#pragma mark SegmentDelegate

- (void)selectSegment:(CSPCategorySegment *)segment {
    if (self.indexOfSelectedSegment != NSNotFound) {
        CSPCategorySegment* previousSelectedSegment = self.segments[self.indexOfSelectedSegment];
        [previousSelectedSegment setSelected:NO];
    }
    self.indexOfSelectedSegment = segment.index;
    [segment setSelected:YES];

    if (self.organiseMode == CSPSegmentOrganiseHorizontal) {
        if (segment.frame.origin.x < self.scrollView.contentOffset.x) {
            [UIView animateWithDuration:0.5f animations:^{
                self.scrollView.contentOffset = segment.frame.origin;
            }];
        } else if (segment.frame.origin.x + segment.frame.size.width > (self.scrollView.contentOffset.x + SCREEN_WIDTH)){
            [UIView animateWithDuration:0.5f animations:^{
                self.scrollView.contentOffset = CGPointMake(segment.frame.origin.x + segment.frame.size.width - SCREEN_WIDTH, 0.0);
            }];
        }
    }


    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentView:didSelectSegmentAtIndex:)]) {
        [self.delegate segmentView:self didSelectSegmentAtIndex:segment.index];
    }
}

#pragma mark -
#pragma mark Override
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawSeparatorWithContext:context];
}


@end
