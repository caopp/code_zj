//
//  CustomTextField.m
//  CPTextViewPlaceholderDemo
//
//  Created by qingsong on 13-9-27.
//  Copyright (c) 2013年 Cassius Pacheco. All rights reserved.
//

#import "CustomTextField.h"
#import "ChooseView.h"
//#define time 0.5
#import "UIColor+UIColor.h"
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条
#define PlaceholderColor [UIColor colorWithHexValue:0xffffff alpha:0.5]
#define colorValue 0.7

@interface CustomTextField()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;
@property (nonatomic, strong) UIView *view;

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
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x, bounds.origin.y+7, bounds.size.width, bounds.size.height);//更好理解些
    return inset;
}


- (void)drawPlaceholderInRect:(CGRect)rect
{
       [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:PlaceholderColor}];
    
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.textColor = [UIColor whiteColor];
    
    [self setValue:PlaceholderColor forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"02_商户登录_删除"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.adjustsImageWhenHighlighted = NO;
    
    self.rightView = deleteButton;
    
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    //下划线
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, 30-1, 500, 1)];
    
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
            [self changeTextLineAlpha:1];}

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
        if (weakSelf == note.object) {
//            weakSelf.password = weakSelf.text;
        }

    }];
}

//删除按钮进行的操作
- (void)isPull{
    UIButton *pullButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    [pullButton setBackgroundImage:[UIImage imageNamed:@"03_商家商品列表_分类选中"] forState:UIControlStateNormal];
    [pullButton addTarget:self action:@selector(pullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    pullButton.adjustsImageWhenHighlighted = NO;
    self.rightView = pullButton;
    self.rightViewMode = UITextFieldViewModeAlways;
}




#pragma mark-弹出列表
- (void)pullButtonClick:(UIButton*)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"CHOOSEACCOUT" object:nil];
}


- (void)isPullAndDel{
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"02_商户登录_删除"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.adjustsImageWhenHighlighted = NO;
    
    
    UIButton *pullButton = [[UIButton alloc]initWithFrame:CGRectMake(28, 0, 13, 13)];
    
    [pullButton setBackgroundImage:[UIImage imageNamed:@"03_商家商品列表_分类选中"] forState:UIControlStateNormal];
    
    [pullButton addTarget:self action:@selector(pullButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    pullButton.adjustsImageWhenHighlighted = NO;
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 41, 13)];
    
    rightView.backgroundColor = [UIColor clearColor];
    
    [rightView addSubview:deleteButton];
    
    [rightView addSubview:pullButton];
    
    self.rightView = rightView;
    
    self.rightViewMode = UITextFieldViewModeWhileEditing;
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
}




@end
