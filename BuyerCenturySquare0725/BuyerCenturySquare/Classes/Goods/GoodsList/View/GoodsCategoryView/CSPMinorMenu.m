//
//  CSPMinorMenu.m
//  DOPNavbarMenuDemo
//
//  Created by skyxfire on 8/5/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "CSPMinorMenu.h"
#import "CommodityClassificationDTO.h"

@interface CSPMinorMenu ()

@property (nonatomic, strong) NSArray* minorItems;
@property (assign, nonatomic) NSInteger numberOfRow;
@property (assign, nonatomic) NSInteger maximumNumberInRow;
@property (assign, nonatomic) CGFloat sideMargin;
@property (assign, nonatomic) CGFloat separatorWidth;

@end

@implementation CSPMinorMenu

static const NSInteger rowHeight = 65.0;

- (id)initWithMinorItems:(NSArray*)minorItems {
    self = [super init];
    if (self) {
        self.maximumNumberInRow = 5;
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
        self.minorItems = minorItems;
        self.separatorWidth = 1;
        self.sideMargin = 7.5;

        self.numberOfRow = (int)ceil(((float)self.minorItems.count + 1) / (float)self.maximumNumberInRow);

        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.numberOfRow * rowHeight);
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UIView* subview in self.subviews) {
        [subview removeFromSuperview];
    }

    CGFloat buttonWidth = (SCREEN_WIDTH - self.sideMargin * 2 - (self.separatorWidth * (self.maximumNumberInRow + 1)))/self.maximumNumberInRow;
    CGFloat buttonHeight = rowHeight;
    
    //添加全部按钮
    CGFloat buttonX = (0 % self.maximumNumberInRow) * (buttonWidth + self.separatorWidth) + self.sideMargin;
    CGFloat buttonY = (0 / self.maximumNumberInRow) * (buttonHeight + self.separatorWidth);
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
    button.tag = 1000;
    [self addSubview:button];
    [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    NSDictionary* attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEX_COLOR(0x999999FF)};
    NSAttributedString* content = [[NSAttributedString alloc]initWithString:@"全部" attributes:attribute];
    [button setAttributedTitle:content forState:UIControlStateNormal];
    
    if ([self.selectStructureNo isEqualToString:self.parentStructureNo]) {
        self.selectBtn = button;
        [button.layer setBackgroundColor:[UIColor blackColor].CGColor];
    }

    [self.minorItems enumerateObjectsUsingBlock:^(CommodityClassificationDTO *obj, NSUInteger idx, BOOL *stop) {
        
        idx ++;
        CGFloat buttonX = (idx % self.maximumNumberInRow) * (buttonWidth + self.separatorWidth) + self.sideMargin;
        CGFloat buttonY = (idx / self.maximumNumberInRow) * (buttonHeight + self.separatorWidth);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        button.tag = idx;
        [self addSubview:button];
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

        NSDictionary* attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:12], NSForegroundColorAttributeName: HEX_COLOR(0x999999FF)};
        NSAttributedString* content = [[NSAttributedString alloc]initWithString:obj.categoryName attributes:attribute];
        [button setAttributedTitle:content forState:UIControlStateNormal];
        if ([self.selectStructureNo isEqualToString:obj.structureNo]) {
            self.selectBtn = button;
            [button.layer setBackgroundColor:[UIColor blackColor].CGColor];
        }
    }];

    for (int i = 0; i <= self.maximumNumberInRow; i++) {
        CGFloat separatorX = i * (buttonWidth + self.separatorWidth) + self.sideMargin;
        CGFloat separatorY = 0;

        UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(separatorX, separatorY, self.separatorWidth, CGRectGetHeight(self.frame))];
        separatar.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [self addSubview:separatar];
    }

    int rows = (int)ceil(((float)self.minorItems.count + 1) / (float)self.maximumNumberInRow);
    for (int i = 0; i <= rows; i++) {
        CGFloat separatorX = self.sideMargin;
        CGFloat separatorY = i * rowHeight;

        UIView *separatar = [[UIView alloc] initWithFrame:CGRectMake(separatorX, separatorY, CGRectGetWidth(self.frame) - self.sideMargin * 2, self.separatorWidth)];
        separatar.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [self addSubview:separatar];
    }
}

- (void)setMinorItems:(NSArray *)minorItems {
    
    _minorItems = minorItems;
    self.numberOfRow = (int)ceil(((float)self.minorItems.count + 1) / (float)self.maximumNumberInRow);
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.numberOfRow * rowHeight);
    
}

- (void)buttonTapped:(id)sender {

    UIButton * btn = (UIButton *)sender;
    
    [self.selectBtn.layer setBackgroundColor:[UIColor clearColor].CGColor];
    [btn.layer setBackgroundColor:[UIColor blackColor].CGColor];
    self.selectBtn = btn;
    
    if(self.delegate) {
        
        [self.delegate MinorMenuClick:btn.tag withCSPMinorMenu:self];
    }
}

- (void)showInView:(UIView *)view belowSubview:(UIView*)subview {

}


- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        [self removeFromSuperview];
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect viewFrame = self.frame;
            viewFrame.origin.y += 20;
            self.frame = viewFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect viewFrame = self.frame;
                viewFrame.origin.y = -320;
                self.frame = viewFrame;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = -320;
        self.frame = viewFrame;
        completion();
    }

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
