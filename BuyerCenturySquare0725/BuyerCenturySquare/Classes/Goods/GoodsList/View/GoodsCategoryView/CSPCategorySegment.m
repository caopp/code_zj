//
//  CSPCategorySegment.m
//  CategoryViewDemo
//
//  Created by skyxfire on 8/3/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCategorySegment.h"

@interface CSPCategorySegment ()

//UI Elements
@property (nonatomic, strong)UILabel* label;
@property (nonatomic, strong)UILabel* lineLabel;
@property (nonatomic, assign)CGFloat labelWidth;

@end

@implementation CSPCategorySegment

- (id)initWithSeparatorWidth:(CGFloat)separatorWidth verticalMargin:(CGFloat)verticalMargin onSelectionColor:(UIColor*)onSelectionColor offSelectionColor:(UIColor*)offSelectionColor onSelectionTextColor:(UIColor*)onSelectionTextColor offSelectionTextColor:(UIColor*)offSelectionTextColor titleFont:(UIFont*)titleFont isDrawLine:(BOOL)isDrawLine{
    self = [super initWithFrame:CGRectZero];
    if (self) {

        [self setup];

        _separatorWidth = separatorWidth;
        _onSelectionColor = onSelectionColor;
        _offSelectionColor = offSelectionColor;
        _onSelectionTextColor = onSelectionTextColor;
        _offSelectionTextColor = offSelectionTextColor;
        _titleFont = titleFont;
        _isdrawLine = isDrawLine;
        
        [self setupUIElements];
    }
    return self;
}

- (void)setup {
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
    
    _selected = NO;
    _index = 0;
    _onSelectionColor = [UIColor darkGrayColor];
    _offSelectionColor = [UIColor whiteColor];
    _onSelectionTextColor = [UIColor whiteColor];
    _offSelectionTextColor = [UIColor darkGrayColor];
    _titleFont = [UIFont systemFontOfSize:17.0f];

    _label = [[UILabel alloc]init];
    _lineLabel = [[UILabel alloc] init];
}

- (void)setupUIElements {
    self.backgroundColor = self.offSelectionColor;

    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = self.titleFont;
    self.label.textColor = self.offSelectionTextColor;
    [self addSubview:self.label];
    
    if (_isdrawLine) {
        [self.lineLabel setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.lineLabel];
    }
}

#pragma mark -
#pragma mark Setter and Getter

- (void)setOnSelectionColor:(UIColor *)onSelectionColor {
    _onSelectionColor = onSelectionColor;

    if (self.isSelected) {
        self.backgroundColor = self.onSelectionColor;
    }
}

- (void)setOffSelectionColor:(UIColor *)offSelectionColor {
    _offSelectionColor = offSelectionColor;

    if (!self.isSelected) {
        self.backgroundColor = self.offSelectionColor;
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;

    self.label.text = _title;
}

- (void)setOnSelectionTextColor:(UIColor *)onSelectionTextColor {
    _onSelectionTextColor = onSelectionTextColor;

    if (self.isSelected) {
        self.label.textColor = self.onSelectionTextColor;
    }
}

- (void)setOffSelectionTextColor:(UIColor *)offSelectionTextColor {
    _offSelectionTextColor = offSelectionTextColor;

    if (!self.isSelected) {
        self.label.textColor = self.offSelectionTextColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;

    self.label.font = _titleFont;
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;

    self.label.frame = self.bounds;
    self.lineLabel.frame = CGRectMake(self.bounds.size.width - 1, (self.bounds.size.height - 15.0f) / 2, 1.0f, 15.0f);
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    if (self.isSelected) {
        self.backgroundColor = self.onSelectionColor;
        self.label.textColor = self.onSelectionTextColor;
    } else {
        self.backgroundColor = self.offSelectionColor;
        self.label.textColor = self.offSelectionTextColor;
    }
}


#pragma mark -
#pragma mark Private Methods

- (UIColor*)willOnSelectionColor {
    CGFloat hue = 0.0f;
    CGFloat saturation = 0.0f;
    CGFloat brightness = 0.0f;
    CGFloat alpha = 0.0f;

    [self.onSelectionColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    return [UIColor colorWithHue:hue saturation:saturation * 0.5 brightness:MIN(brightness * 1.5, 1.0) alpha:alpha];
}

// Update Frame
- (void)resetContentFrame {

    // If there's no text, align imageView centred
    // Else align text centred
    self.label.frame = self.bounds;
    
    self.lineLabel.frame = CGRectMake(self.bounds.size.width - 1, (self.bounds.size.height - 15.0f) / 2, 1.0f, 15.0f);
}

#pragma mark -
#pragma mark touch
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//
//    //    if (!self.isSelected) {
//    self.backgroundColor = [self willOnSelectionColor];
//    //    }
//}

- (void)tapGesture:(UITapGestureRecognizer *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSegment:)]) {
        [self.delegate selectSegment:self];
    }

}

@end
