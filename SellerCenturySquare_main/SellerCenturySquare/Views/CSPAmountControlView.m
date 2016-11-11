//
//  CSPAmountControlView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPAmountControlView.h"
#import "CSPCounterView.h"
#import "SingleSku.h"
#import "DoubleSku.h"

@interface CSPSkuControlView () <CSPCounterViewDelegate>

@property (nonatomic, strong)UILabel* titleLabel;
@property (nonatomic, strong)CSPCounterView* stockCounterView;
@property (nonatomic, strong)CSPCounterView* futureCounterView;


@end

@implementation CSPSkuControlView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:self.titleLabel];
        
        self.stockCounterView = [[CSPCounterView alloc]init];
        self.stockCounterView.delegate = self;
        [self addSubview:self.stockCounterView];
        
        self.futureCounterView = [[CSPCounterView alloc]init];
        self.stockCounterView.delegate = self;
        [self addSubview:self.futureCounterView];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.titleLabel sizeToFit];
        
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;
        
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.titleLabel = [[UILabel alloc]init];
        [self addSubview:self.titleLabel];

        self.stockCounterView = [[CSPCounterView alloc]init];
        self.stockCounterView.delegate = self;
        [self addSubview:self.stockCounterView];

        self.futureCounterView = [[CSPCounterView alloc]init];
        self.futureCounterView.delegate = self;
        [self addSubview:self.futureCounterView];

        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.backgroundColor = [UIColor blackColor];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.titleLabel sizeToFit];

        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 2.0;
        self.layer.masksToBounds = YES;

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame {
    if (self.style == CSPSkuControlViewStyleNoneTitle) {
        self.stockCounterView.frame = self.bounds;
        [self.stockCounterView setNeedsLayout];
    } else if (self.style == CSPSkuControlViewStyleSingleCounter) {
        CGRect viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 3, CGRectGetHeight(self.bounds));
        self.titleLabel.frame = viewFrame;

        viewFrame = CGRectMake(CGRectGetWidth(self.bounds) / 3, 0, CGRectGetWidth(self.bounds) * 2 / 3, CGRectGetHeight(self.bounds));
        self.stockCounterView.frame = viewFrame;
        [self.stockCounterView setNeedsLayout];

    } else {
        CGRect viewFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) / 5, CGRectGetHeight(self.bounds));
        self.titleLabel.frame = viewFrame;

        viewFrame = CGRectMake(CGRectGetWidth(self.bounds) / 5, 0, CGRectGetWidth(self.bounds) * 2 / 5, CGRectGetHeight(self.bounds));
        self.stockCounterView.frame = viewFrame;
        [self.stockCounterView setNeedsLayout];

        viewFrame = CGRectMake(CGRectGetWidth(self.bounds) * 3 / 5, 0, CGRectGetWidth(self.bounds) * 2 / 5, CGRectGetHeight(self.bounds));
        self.futureCounterView.frame = viewFrame;
        [self.futureCounterView setNeedsLayout];
    }
}


- (void)setTitle:(NSString *)title {
    _title = title;
    NSAttributedString* contentString = [[NSAttributedString alloc]initWithString:_title attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.titleLabel.attributedText = contentString;
}

- (void)setSkuValue:(BasicSkuDTO *)skuValue {
    _skuValue = skuValue;
    self.title = _skuValue.skuName;

    if ([skuValue isKindOfClass:[SingleSku class]]) {
        SingleSku* sku = (SingleSku*)skuValue;
        self.stockCounterView.count = sku.value;
        
    } else if ([skuValue isKindOfClass:[DoubleSku class]]) {
        DoubleSku* sku = (DoubleSku*)skuValue;

        if (self.style == CSPSkuControlViewStyleDoubleCounter) {
            self.stockCounterView.count = sku.spotValue;
            self.futureCounterView.count = sku.futureValue;
        } else {
            self.stockCounterView.count = sku.spotValue;
        }

    }
}

#pragma mark -
#pragma mark CSPCounterViewDelegate

- (BOOL)counterView:(CSPCounterView*)counterView couldValueChange:(NSInteger)targetValue; {
    NSInteger totalQuantity = targetValue;

    if (counterView == self.stockCounterView) {
        if ([self.skuValue isKindOfClass:[SingleSku class]]) {
            // do nothing
        } else {
            DoubleSku* sku = (DoubleSku*)self.skuValue;
            totalQuantity += sku.futureValue;
        }
    } else if (counterView == self.futureCounterView) {
        if ([self.skuValue isKindOfClass:[SingleSku class]]) {
            // do nothing
        } else {
            DoubleSku* sku = (DoubleSku*)self.skuValue;
            totalQuantity += sku.spotValue;
        }
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(skuControlView:couldSkuValueChanged:)]) {
        return [self.delegate skuControlView:self couldSkuValueChanged:totalQuantity];
    } else {
        return YES;
    }
}

- (void)counterView:(CSPCounterView*)counterView countChanged:(NSInteger)count {
    NSString* valueType = nil;

    if (counterView == self.stockCounterView) {
        self.stockCounter = count;

        if ([self.skuValue isKindOfClass:[SingleSku class]]) {
            SingleSku* sku = (SingleSku*)self.skuValue;
            sku.value = count;
        } else {
            DoubleSku* sku = (DoubleSku*)self.skuValue;
            sku.spotValue = count;
        }

        valueType = @"spot";
    } else if (counterView == self.futureCounterView) {
        self.futureCounter = count;

        if ([self.skuValue isKindOfClass:[SingleSku class]]) {
//            SingleSku* sku = (SingleSku*)self.skuValue;
//            sku.value = count;
        } else {
            DoubleSku* sku = (DoubleSku*)self.skuValue;
            sku.futureValue = count;
        }

        valueType = @"future";
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(skuControlView:skuValueChanged:)]) {
        [self.delegate skuControlView:self skuValueChanged:self.skuValue];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(skuControlView:skuValueChanged:valueType:)]) {
        [self.delegate skuControlView:self skuValueChanged:self.skuValue valueType:valueType];
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
