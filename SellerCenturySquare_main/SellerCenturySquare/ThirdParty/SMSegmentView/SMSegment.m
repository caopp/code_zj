//
//  SMSegment.m
//  BuyerCenturySquare
//
//  Created by Si MA on 03/01/2015.
//  Copyright (c) 2015 Si Ma. All rights reserved.
//

#import "SMSegment.h"

@interface SMSegment ()

//UI Elements
@property (nonatomic, strong)UILabel* label;
@property (nonatomic, assign)CGFloat labelWidth;
@property (nonatomic, strong)UIImageView* imageView;



@end

@implementation SMSegment

- (id)initWithSeparatorWidth:(CGFloat)separatorWidth verticalMargin:(CGFloat)verticalMargin onSelectionColor:(UIColor*)onSelectionColor offSelectionColor:(UIColor*)offSelectionColor onSelectionTextColor:(UIColor*)onSelectionTextColor offSelectionTextColor:(UIColor*)offSelectionTextColor titleFont:(UIFont*)titleFont {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self setup];

        _separatorWidth = separatorWidth;
        _verticalMargin = verticalMargin;
        _onSelectionColor = onSelectionColor;
        _offSelectionColor = offSelectionColor;
        _onSelectionTextColor = onSelectionTextColor;
        _offSelectionTextColor = offSelectionTextColor;
        _titleFont = titleFont;

        [self setupUIElements];
    }
    return self;
}

- (void)setup {
    _selected = NO;
    _index = 0;
    _verticalMargin = 5.0f;
    _onSelectionColor = [UIColor darkGrayColor];
    _offSelectionColor = [UIColor whiteColor];
    _onSelectionTextColor = [UIColor whiteColor];
    _offSelectionTextColor = [UIColor darkGrayColor];
    _titleFont = [UIFont systemFontOfSize:17.0f];

    _imageView = [[UIImageView alloc]init];
    _label = [[UILabel alloc]init];
}

- (void)setupUIElements {
    self.backgroundColor = self.offSelectionColor;

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];

    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = self.titleFont;
    self.label.textColor = self.offSelectionTextColor;
    [self addSubview:self.label];

}

#pragma mark -
#pragma mark Setter and Getter

- (void)setVerticalMargin:(CGFloat)verticalMargin {
    _verticalMargin = verticalMargin;
    [self resetContentFrame];
}

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
    if (_title.length > 0) {
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName, nil];

        self.labelWidth = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    } else {
        self.labelWidth = 0.0f;
    }

    [self resetContentFrame];
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
    if (self.label.text.length > 0) {
        CGSize size = CGSizeMake(CGRectGetWidth(self.frame) + 1.0, CGRectGetHeight(self.frame));
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.label.font, NSFontAttributeName, nil];

        self.labelWidth = [self.label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    } else {
        self.labelWidth = 0.0f;
    }

    [self resetContentFrame];
}

- (void)setOnSelectionImage:(UIImage *)onSelectionImage {
    _onSelectionImage = onSelectionImage;
    if (self.onSelectionImage) {
        [self resetContentFrame];
    }

    if (self.isSelected) {
        self.imageView.image = self.onSelectionImage;
    }
    
}

- (void)setOffSelectionImage:(UIImage *)offSelectionImage {
    _offSelectionImage = offSelectionImage;
    if (self.offSelectionImage) {
        [self resetContentFrame];
    }

    if (!self.isSelected) {
        self.imageView.image = self.offSelectionImage;
    }
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    [self resetContentFrame];
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;

    if (self.isSelected) {
        self.backgroundColor = self.onSelectionColor;
        self.label.textColor = self.onSelectionTextColor;
        self.imageView.image = self.onSelectionImage;
    } else {
        self.backgroundColor = self.offSelectionColor;
        self.label.textColor = self.offSelectionTextColor;
        self.imageView.image = self.offSelectionImage;
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
    CGFloat distanceBetween = 0.0f;
    
    CGRect imageViewFrame = CGRectMake(0.0, self.verticalMargin, 0.0, CGRectGetHeight(self.frame) - self.verticalMargin * 2);
    


    if (self.onSelectionImage || self.offSelectionImage) {
        // Set ImageView as a square
        imageViewFrame.size.width = CGRectGetHeight(self.frame) - self.verticalMargin * 2;
        distanceBetween = 5.0f;
    }

    // If there's no text, align imageView centred
    // Else align text centred
    if (self.labelWidth == 0.0) {
        imageViewFrame.origin.x = MAX((CGRectGetWidth(self.frame) - CGRectGetWidth(imageViewFrame)) * 0.5, 0.0);
    } else {
        imageViewFrame.origin.x = MAX((CGRectGetWidth(self.frame) - CGRectGetWidth(imageViewFrame) - self.labelWidth) * 0.5 - distanceBetween, 0.0);
    }

//    self.imageView.frame = imageViewFrame;
//    self.label.frame = CGRectMake(imageViewFrame.origin.x + imageViewFrame.size.width + distanceBetween, self.verticalMargin, self.labelWidth, self.frame.size.height - self.verticalMargin * 2);

    self.imageView.frame = CGRectMake(imageViewFrame.origin.x , (CGRectGetHeight(self.frame) - 13)/2.0, 20.0 , 13);//!图片的位置

    self.label.frame = CGRectMake(self.imageView.frame.origin.x + self.imageView.frame.size.width, self.verticalMargin, self.labelWidth, self.frame.size.height - self.verticalMargin * 2);

}

#pragma mark -
#pragma mark touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];

//    if (!self.isSelected) {
        self.backgroundColor = [self willOnSelectionColor];
//    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if (self.delegate && [self.delegate respondsToSelector:@selector(selectSegment:)]) {
        [self.delegate selectSegment:self];
    }
}

@end
