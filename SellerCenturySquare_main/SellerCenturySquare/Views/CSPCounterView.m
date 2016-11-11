//
//  CSPCounterView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCounterView.h"
#import "KeyboardBar.h"

@interface CSPCounterView ()<UITextFieldDelegate>

@property (nonatomic, assign)NSInteger privateCounter;
@property (nonatomic, strong)UIButton* plusButton;
@property (nonatomic, strong)UIButton* subtractButton;

@end

@implementation CSPCounterView
{
    UIView *bgClickView;
    
}
- (id)init {
    self =  [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.plusButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.plusButton addTarget:self action:@selector(plusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString* contentString = [[NSAttributedString alloc]initWithString:@"＋" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor blackColor]}];
        [self.plusButton setAttributedTitle:contentString forState:UIControlStateNormal];
        [self.plusButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.plusButton];

        self.subtractButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.subtractButton addTarget:self action:@selector(subtractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        contentString = [[NSAttributedString alloc]initWithString:@"－" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20], NSForegroundColorAttributeName: [UIColor blackColor]}];
        [self.subtractButton setAttributedTitle:contentString forState:UIControlStateNormal];
        [self.subtractButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self addSubview:self.subtractButton];

        self.textField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.delegate = self;
        self.textField.inputAccessoryView = [KeyboardBar sharedInstance];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        
        self.textField.font = [UIFont fontWithName:@"Tw Cen MT" size:16];
        [self.textField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self addSubview:self.textField];

        [self sendSubviewToBack:self.textField];

        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.5;

        self.count = 0;
    }

    return self;
}

- (void)layoutSubviews {
    self.textField.frame = self.bounds;
    CGRect buttonFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds));
    self.subtractButton.frame = buttonFrame;

    buttonFrame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bounds) * 0.4, 0, CGRectGetWidth(self.bounds) *0.4, CGRectGetHeight(self.bounds));
    self.plusButton.frame = buttonFrame;
}

- (void)plusButtonClicked {
    _privateCounter += 1;
    _count = _privateCounter;

    self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;

    if (self.delegate && [self.delegate respondsToSelector:@selector(counterView:countChanged:)]) {
        [self.delegate counterView:self countChanged:_privateCounter];
    }
}

- (void)subtractButtonClicked {
    if (self.privateCounter > 0) {
        self.privateCounter -= 1;
    }
}

- (void)setCount:(NSInteger)count {

    _count = count;
    _privateCounter = count;

    self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;
}



- (void)setPrivateCounter:(NSInteger)privateCounter {
    if (self.delegate && [self.delegate respondsToSelector:@selector(counterView:couldValueChange:)]) {
        if ([self.delegate counterView:self couldValueChange:privateCounter]) {
            _count = privateCounter;
            _privateCounter = privateCounter;

            self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;

            if (self.delegate && [self.delegate respondsToSelector:@selector(counterView:countChanged:)]) {
                [self.delegate counterView:self countChanged:privateCounter];
            }
        } else {
            self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;
        }
    } else {
        _count = privateCounter;
        _privateCounter = privateCounter;

        self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;

        if (self.delegate && [self.delegate respondsToSelector:@selector(counterView:countChanged:)]) {
            [self.delegate counterView:self countChanged:privateCounter];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [KeyboardBar sharedInstance].textField = textField;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    bgClickView.hidden = NO;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger value = textField.text.integerValue;
    if (value < 0) {
        value = 0;
    }
    
    self.privateCounter = value;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
