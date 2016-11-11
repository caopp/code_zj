//
//  MerchantsInTextField.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/12/29.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "MerchantsInTextField.h"
#import "UIColor+UIColor.h"


@implementation MerchantsInTextField
{
    //!下划线
    UIView *lineView;
    
    //!设置删除按钮
    UIButton *deleteButton;
    
}

- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self create];
        
        
    }
    
    return self;
    
}

-(void)create{

    
    //!设置文字
    self.textColor = [UIColor whiteColor];
    [self setFont:[UIFont systemFontOfSize:15]];
    
    //!设置输提醒字颜色 大小
//    [self setValue:[UIColor colorWithHexValue:0xffffff alpha:0.7] forKeyPath:@"_placeholderLabel.textColor"];

//    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
//    [self setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    
    //!设置删除按钮
    deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    [deleteButton setImage:[UIImage imageNamed:@"02_商户登录_删除"] forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    
    deleteButton.adjustsImageWhenHighlighted = NO;
    
    self.rightView = deleteButton;
    
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    //下划线
    lineView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.size.height-1, 500, 1)];
    
    lineView.alpha = 0.7;
    self.alpha = 0.3;
    
    lineView.backgroundColor = [UIColor colorWithHexValue:0xffffff alpha:1];
    
    [self addSubview:lineView];
    

    
    __weak MerchantsInTextField *weakSelf = self;

    //!开始编辑
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note){
        
        if (weakSelf == note.object ) {
            
            [self changeTextViewAlpha:1];
            
            [self changeTextLineAlpha:1];
            
            [self setValue:[UIColor colorWithHexValue:0xffffff alpha:1] forKeyPath:@"_placeholderLabel.textColor"];

        }
        
        
        
    }];
    //!结束编辑
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note){
        
        if (weakSelf == note.object ) {

            [self changeTextViewAlpha:0.3];
            
            [self changeTextLineAlpha:0.7];
            
            [self setValue:[UIColor colorWithHexValue:0xffffff alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            
        }


        
    }];


}

//!删除按钮事件  删除所有内容
- (void)deleteAll
{
    self.text = @"";
}
//!设置透明度
- (void)changeTextViewAlpha:(CGFloat)alpha
{
    self.alpha = alpha;
}
- (void)changeTextLineAlpha:(CGFloat)alpha
{
    lineView.alpha = alpha;
    
    
}
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self.beginEditingObserver];
    [[NSNotificationCenter defaultCenter] removeObserver:self.endEditingObserver];

}
//重写改变绘制占位符属性.重写时调用super可以按默认图形属性绘制,若自己完全重写绘制函数，就不用调用super了.
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    
}


@end
