//
//  CSPCounterView.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPCounterView.h"
#import "KeyboardBar.h"

@interface CSPCounterView ()<UITextFieldDelegate> {
    
    UIView * bgClickView;
}


@property (nonatomic, assign)NSInteger privateCounter;
@property (nonatomic, strong)UIButton* plusButton;
@property (nonatomic, strong)UIButton* subtractButton;
//@property (nonatomic, strong)UITextField* textField;

@end




@implementation CSPCounterView

- (id)init {
    self =  [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.plusButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.plusButton addTarget:self action:@selector(plusButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.plusButton setImage:[UIImage imageNamed:@"增加"] forState:UIControlStateNormal];
        [self.plusButton setImage:[UIImage imageNamed:@"增加"] forState:UIControlStateHighlighted];
        [self addSubview:self.plusButton];
        
        self.subtractButton = [[UIButton alloc]initWithFrame:CGRectZero];
        [self.subtractButton addTarget:self action:@selector(subtractButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.subtractButton setImage:[UIImage imageNamed:@"减少"] forState:UIControlStateNormal];
        [self.subtractButton setImage:[UIImage imageNamed:@"减少"] forState:UIControlStateHighlighted];
        [self addSubview:self.subtractButton];
        
        self.textField = [[UITextField alloc]initWithFrame:CGRectZero];
        self.textField.textAlignment = NSTextAlignmentCenter;
        self.textField.delegate = self;
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.keyboardType = UIKeyboardTypeNumberPad;
        self.textField.inputAccessoryView = [KeyboardBar sharedInstance];
        //        [self.textField addTarget:self action:@selector(textFieldDidEndOnExit:) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self addSubview:self.textField];
        
        [self sendSubviewToBack:self.textField];
        
//        self.layer.borderColor = [UIColor blackColor].CGColor;
//        self.layer.borderWidth = 0.5;
        
        self.count = 0;
        

        
    }

    return self;
}

- (void)layoutSubviews {
    self.textField.frame = self.bounds;
    self.textField.tag = self.tag;
    CGRect buttonFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) * 0.4, CGRectGetHeight(self.bounds));
    self.subtractButton.frame = buttonFrame;

    buttonFrame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.bounds) * 0.4, 0, CGRectGetWidth(self.bounds) *0.4, CGRectGetHeight(self.bounds));
    self.plusButton.frame = buttonFrame;
}


- (void)plusButtonClicked {
    
    
    if (_batchNumLimit!=0) {
        _privateCounter += self.batchNumLimit;
        _count = _privateCounter;
        _batchNumLimit = 0;
        

    }else {
    _privateCounter += 1;
    _count = _privateCounter;
    
    }
    self.textField.text = [NSNumber numberWithInteger:self.count].stringValue;

    if (self.delegate && [self.delegate respondsToSelector:@selector(counterView:countChanged:)]) {
        [self.delegate counterView:self countChanged:_privateCounter];
    }

}
- (void)setBatchNumLimit:(NSInteger)batchNumLimit
{
    _batchNumLimit = batchNumLimit;
    
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

//- (void)textFieldDidEndOnExit:(UITextField*)textField {
//    NSInteger value = textField.text.integerValue;
//    if (value < 0) {
//        value = 0;
//    }
//
//    self.privateCounter = value;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
