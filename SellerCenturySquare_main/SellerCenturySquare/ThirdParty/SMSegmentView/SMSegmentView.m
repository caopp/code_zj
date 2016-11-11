//
//  SMSegmentView.m
//  BuyerCenturySquare
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma. All rights reserved.
//

#import "SMSegmentView.h"

/*
 Keys for segment properties
 */

// This is mainly for the top/bottom margin of the imageView
const NSString* keyContentVerticalMargin = @"VerticalMargin";

// The colour when the segment is under selected/unselected
const NSString* keySegmentOnSelectionColour = @"OnSelectionBackgroundColour";
const NSString* keySegmentOffSelectionColour = @"OffSelectionBackgroundColour";

// The colour of the text in the segment for the segment is under selected/unselected
const NSString* keySegmentOnSelectionTextColour = @"OnSelectionTextColour";
const NSString* keySegmentOffSelectionTextColour = @"OffSelectionTextColour";

// The font of the text in the segment
const NSString* keySegmentTitleFont = @"TitleFont";

@interface SMSegmentView ()

@property(nonatomic, strong)NSMutableArray* segments;

@end

@implementation SMSegmentView

- (void)awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;

        [self setup];
    }

    return self;
}

- (id)initWithFrame:(CGRect)frame separatorColor:(UIColor*)separatorColor separatorWidth:(CGFloat)separatorWidth segmentProperties:(NSDictionary*)segmentProperties {
    self = [super initWithFrame:frame];
    if (self) {

        [self setup];

        _separatorColor = separatorColor;
        _separatorWidth = separatorWidth;

        id margin = [segmentProperties objectForKey:keyContentVerticalMargin];
        if ([margin isKindOfClass:[NSNumber class]]) {
            NSNumber* value = margin;
            _segmentVertivalMargin = value.doubleValue;
        }

        id onSelectionColor = [segmentProperties objectForKey:keySegmentOnSelectionColour];
        if ([onSelectionColor isKindOfClass:[UIColor class]]) {
            _segmentOnSelectionColor = onSelectionColor;
        }else {
            _segmentOnSelectionColor = [UIColor whiteColor];
        }

        id offSelectionColor = [segmentProperties objectForKey:keySegmentOffSelectionColour];
        if ([offSelectionColor isKindOfClass:[UIColor class]]) {
            _segmentOffSelectionColor = offSelectionColor;
        } else {
            _segmentOffSelectionColor = [UIColor darkGrayColor];
        }

        id onSelectionTextColor = [segmentProperties objectForKey:keySegmentOnSelectionTextColour] ;
        if ([onSelectionTextColor isKindOfClass:[UIColor class]]) {

            _segmentOnSelectionTextColor = onSelectionTextColor;
        } else {
            _segmentOnSelectionTextColor = [UIColor darkGrayColor];
        }

        id offSelectionTextColor = [segmentProperties objectForKey:keySegmentOffSelectionTextColour];
        if ([offSelectionTextColor isKindOfClass:[NSNumber class]]) {

            _segmentOffSelectionTextColor = offSelectionTextColor;
        } else {
            _segmentOffSelectionTextColor = HEX_COLOR(0xF0F0F0FF);
        }

        id titleFont = [segmentProperties objectForKey:keySegmentTitleFont];
        if ([titleFont isKindOfClass:[UIFont class]]) {
            _segmentTitleFont = titleFont;
        } else {
            _segmentTitleFont = [UIFont systemFontOfSize:13];
        }

        self.backgroundColor = [UIColor clearColor];
        self.layer.masksToBounds = YES;
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateFrameForSegments];
}

- (void)setup {
    _indexOfSelectedSegment = NSNotFound;
    _numberOfSegments = 0;
    _organiseMode = SegmentOrganiseHorizontal;
    _segmentVertivalMargin = 0.0f;
    _separatorColor = [UIColor blackColor];
    _separatorWidth = 0.0f;
    _segmentOnSelectionColor = [UIColor whiteColor];
    _segmentOffSelectionColor = [UIColor darkGrayColor];
    _segmentOnSelectionTextColor = [UIColor darkGrayColor];
    _segmentOffSelectionTextColor = HEX_COLOR(0xF0F0F0FF);
    _segmentTitleFont = [UIFont systemFontOfSize:13];
    _segments = [NSMutableArray array];
}

#pragma mark -
#pragma mark Setter

- (void)setOrganiseMode:(SegmentOrganiseMode)organiseMode {
    _organiseMode = organiseMode;

    [self setNeedsDisplay];
}

- (void)setSegmentVertivalMargin:(CGFloat)segmentVertivalMargin {
    _segmentVertivalMargin = segmentVertivalMargin;

    for (SMSegment* segment in self.segments) {
        segment.verticalMargin = self.segmentVertivalMargin;
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor {
    _separatorColor = separatorColor;

    [self setNeedsDisplay];
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    _separatorWidth = separatorWidth;

    for (SMSegment* segment in self.segments) {
        segment.separatorWidth = self.separatorWidth;
    }

    [self updateFrameForSegments];
}

- (void)setSegmentOnSelectionColor:(UIColor *)segmentOnSelectionColor {
    _segmentOnSelectionColor = segmentOnSelectionColor;

    for (SMSegment* segment in self.segments) {
        segment.onSelectionColor = self.segmentOnSelectionColor;
    }
}

- (void)setSegmentOffSelectionColor:(UIColor *)segmentOffSelectionColor {
    _segmentOffSelectionColor = segmentOffSelectionColor;

    for (SMSegment* segment in self.segments) {
        segment.offSelectionColor = self.segmentOffSelectionColor;
    }
}

- (void)setSegmentOnSelectionTextColor:(UIColor *)segmentOnSelectionTextColor {
    _segmentOnSelectionTextColor = segmentOnSelectionTextColor;

    for (SMSegment* segment in self.segments) {
        segment.onSelectionTextColor = self.segmentOnSelectionTextColor;
    }
}

- (void)setSegmentOffSelectionTextColor:(UIColor *)segmentOffSelectionTextColor {
    _segmentOffSelectionTextColor = segmentOffSelectionTextColor;

    for (SMSegment* segment in self.segments) {
        segment.offSelectionTextColor = self.segmentOffSelectionTextColor;
    }
}

- (void)setSegmentTitleFont:(UIFont *)segmentTitleFont {
    _segmentTitleFont = segmentTitleFont;

    for (SMSegment* segment in self.segments) {
        segment.titleFont = self.segmentTitleFont;
    }
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;

    [self updateFrameForSegments];
}


#pragma mark -
#pragma mark Private Methods

- (void)updateFrameForSegments {
    if (self.segments.count == 0) {
        return;
    }

    NSInteger count = self.segments.count;
    if (count > 1) {
        if (self.organiseMode == SegmentOrganiseHorizontal) {
            CGFloat segmentWidth = (CGRectGetWidth(self.frame) - self.separatorWidth * (count - 1)) / count;
            CGFloat originX = 0.0f;
            for (SMSegment* segment in self.segments) {
                segment.frame = CGRectMake(originX, 0.0, segmentWidth, CGRectGetHeight(self.frame));
                originX += segmentWidth + self.separatorWidth;
            }
        } else {
            CGFloat segmentHeight = (CGRectGetHeight(self.frame) - self.separatorWidth * (count - 1)) / count;
            CGFloat originY = 0.0f;
            for (SMSegment* segment in self.segments) {
                segment.frame = CGRectMake(0.0, originY, CGRectGetWidth(self.frame), segmentHeight);
                originY += segmentHeight + self.separatorWidth;
            }
        }
    } else {
        SMSegment* segment = [self.segments firstObject];
        segment.frame = self.frame;
    }

    [self setNeedsDisplay];
}

- (void)drawSeparatorWithContext:(CGContextRef)context {
    CGContextSaveGState(context);

    if (self.segments.count > 1) {
        CGMutablePathRef path = CGPathCreateMutable();

        SMSegment* firstSegment = [self.segments firstObject];

        if (self.organiseMode == SegmentOrganiseHorizontal) {

            CGFloat originX = CGRectGetWidth(firstSegment.frame) + self.separatorWidth / 2.0f;
            for (int index = 1; index < self.segments.count; index++) {
                CGPathMoveToPoint(path, nil, originX, 0.0);
                CGPathAddLineToPoint(path, nil, originX, CGRectGetHeight(self.frame));

                SMSegment* nextSegment = self.segments[index];
                originX += CGRectGetWidth(nextSegment.frame) + self.separatorWidth;
            }
        } else {
            CGFloat originY = CGRectGetHeight(firstSegment.frame) + self.separatorWidth / 2.0f;
            for (int index = 1; index < self.segments.count; index++) {
                CGPathMoveToPoint(path, nil, 0.0, originY);
                CGPathAddLineToPoint(path, nil, CGRectGetWidth(self.frame), originY);

                SMSegment* nextSegment = self.segments[index];
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

- (void)addSegmentWithTitle:(NSString*)title {
    [self addSegmentWithTitle:title onSelectionImage:nil offSelectionImage:nil];
}

- (void)addSegmentWithTitle:(NSString *)title onSelectionImage:(UIImage *)onSelectionImage offSelectionImage:(UIImage *)offSelectionImage {
    SMSegment* segment = [[SMSegment alloc]initWithSeparatorWidth:self.separatorWidth verticalMargin:self.segmentVertivalMargin onSelectionColor:self.segmentOnSelectionColor offSelectionColor:self.segmentOffSelectionColor onSelectionTextColor:self.segmentOnSelectionTextColor offSelectionTextColor:self.segmentOffSelectionTextColor titleFont:self.segmentTitleFont];
    
    segment.index = self.segments.count;
    [self.segments addObject:segment];
    [self updateFrameForSegments];

    segment.delegate = self;
    segment.title = title;
    segment.onSelectionImage = onSelectionImage;
    segment.offSelectionImage = offSelectionImage;

    [self addSubview:segment];
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
        SMSegment* segment = self.segments[self.indexOfSelectedSegment];
        [segment setSelected:NO];

        self.indexOfSelectedSegment = NSNotFound;
    }
}

#pragma mark -
#pragma mark SegmentDelegate

- (void)selectSegment:(SMSegment *)segment {
    if (self.indexOfSelectedSegment != NSNotFound) {
        SMSegment* previousSelectedSegment = self.segments[self.indexOfSelectedSegment];
        [previousSelectedSegment setSelected:NO];
    }
    self.indexOfSelectedSegment = segment.index;
    [segment setSelected:YES];

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
