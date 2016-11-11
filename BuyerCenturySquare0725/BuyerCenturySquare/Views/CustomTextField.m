//
//  CustomTextField.m
//  CPTextViewPlaceholderDemo
//
//  Created by qingsong on 13-9-27.
//  Copyright (c) 2013年 Cassius Pacheco. All rights reserved.
//

#import "CustomTextField.h"

#define colorValue 0.7

#define colorTypeface 0.3

@interface CustomTextField()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;

@end

@implementation CustomTextField


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)changeTextViewAlpha:(CGFloat)alpha
{
    self.alpha = alpha;
}
- (void)changeTextLineAlpha:(CGFloat)alpha
{
    self.view.alpha = alpha;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 0 , 0 );
}


-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+0, bounds.origin.y+8.5, bounds.size.width, bounds.size.height);//更好理解些
    
    return inset;
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
       [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:PlaceholderColor}];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setValue:PlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"01_登录_删除"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.adjustsImageWhenHighlighted = NO;
    self.rightView = deleteButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-1, self.bounds.size.width, 1)];
    
    self.view.alpha = colorValue;
    self.view.backgroundColor = LGClickColor;
    [self addSubview:self.view];
    
    self.alpha = colorValue;
    
//    self.password = @"";
    
    __weak CustomTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        if (weakSelf == note.object ) {
            [self changeTextViewAlpha:1];
            [self changeTextLineAlpha:1];
        }
        if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
            weakSelf.text = @"";
//            [weakSelf insertText:weakSelf.password];
        }
    }];
    
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        if (weakSelf == note.object && [weakSelf.text isEqualToString:@""]) {
            [self changeTextViewAlpha:colorValue];
            [self changeTextLineAlpha:colorValue];
        }else{
            [self changeTextViewAlpha:colorValue];
            [self changeTextLineAlpha:colorValue];
        }
//        if (weakSelf == note.object) {
//            weakSelf.password = weakSelf.text;
//        }
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.view.frame = CGRectMake(self.bounds.origin.x, self.bounds.size.height-1, self.bounds.size.width, 1);
}

- (void)setSecureTextEntry:(BOOL)secureTextEntry {
    BOOL isFirstResponder = self.isFirstResponder;
    [self resignFirstResponder];
    [super setSecureTextEntry:secureTextEntry];
    if (isFirstResponder) {
        [self becomeFirstResponder];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];
}

- (void)deleteAll
{
    self.text = nil;
}




@end
