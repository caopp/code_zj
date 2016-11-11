//
//  CustomTextField.m
//  CPTextViewPlaceholderDemo
//
//  Created by qingsong on 13-9-27.
//  Copyright (c) 2013年 Cassius Pacheco. All rights reserved.
//

#import "CustomTextField.h"
#import "ChooseView.h"

#import "UIColor+UIColor.h"

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
       [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

-(void)awakeFromNib{
    
    [super awakeFromNib];
    
    self.textColor = [UIColor whiteColor];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setValue:[UIFont fontWithName:@"SourceHanSansCN-Normal" size:13] forKeyPath:@"_placeholderLabel.font"];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 13, 13)];
    
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"02_商户登录_删除"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.adjustsImageWhenHighlighted = NO;
    
    self.rightView = deleteButton;
    
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    //下划线
    self.view = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-1, 500, 1)];
    
    self.view.alpha = 0.3;
    
    self.view.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
    
    [self addSubview:self.view];
    
    self.alpha = 0.3f;
    
    self.password = @"";
    
    __weak CustomTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        if (weakSelf == note.object ) {
            [self changeTextViewAlpha:1];
            [self changeTextLineAlpha:1];}

        if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
            weakSelf.text = @"";
            [weakSelf insertText:weakSelf.password];
        }
    }];
    
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
    {
        
        if (weakSelf == note.object && [weakSelf.text isEqualToString:@""]) {
            [self changeTextViewAlpha:0.3];
            [self changeTextLineAlpha:0.3];
        }else{
            [self changeTextViewAlpha:0.3];
            [self changeTextLineAlpha:0.7];
        }
        if (weakSelf == note.object) {
            weakSelf.password = weakSelf.text;
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
