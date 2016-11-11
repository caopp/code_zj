//
//  PersonIofoTextField.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/8/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "PersonIofoTextField.h"
#define colorValue 1

#define colorTypeface 0.3
#define PlaceholderColor [UIColor colorWithHexValue:0x999999 alpha:1]
@interface PersonIofoTextField()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;
@property (nonatomic, strong) UIView *view;

@end

@implementation PersonIofoTextField

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
    return CGRectInset( bounds, 10 , 0);
}


-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 10 , 0 );
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+0, bounds.origin.y + 5, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
    
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:PlaceholderColor}];
    }else
    {
        [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName:PlaceholderColor}];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self setValue:PlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    [self setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    self.deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"01_登录_删除"] forState:UIControlStateNormal];
    
    
//    //设置按钮颜色
//    self.deleteButton.backgroundColor = [UIColor redColor];
//    //设置text背景颜色
//    self.backgroundColor= [UIColor yellowColor];
    
    
    [self.deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    
    self.deleteButton.adjustsImageWhenHighlighted = NO;
    self.rightView = self.deleteButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-1, self.bounds.size.width, 1)];
    
    self.view.alpha = colorTypeface;
    self.view.backgroundColor = LGClickColor;
    [self addSubview:self.view];
    
    self.alpha = colorValue;
    
        self.password = @"";
    
    __weak PersonIofoTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
                                 {
                                     if (weakSelf == note.object ) {
                                         [self changeTextViewAlpha:1];
                                         [self changeTextLineAlpha:1];
                                     }
                                     if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
                                         weakSelf.text = @"";
                                                     [weakSelf insertText:weakSelf.password];
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
                                           if (weakSelf == note.object) {
                                               weakSelf.password = weakSelf.text;
                                           }
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
    
    self.text = @"";
    NSDictionary *dic = @{@"text_row":self.text_row};
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"PersonIofoTextFieldName" object:self userInfo:dic];
    
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
}


@end
