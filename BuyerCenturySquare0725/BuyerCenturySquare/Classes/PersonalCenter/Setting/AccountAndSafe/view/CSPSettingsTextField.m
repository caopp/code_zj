//
//  CSPSettingsTextField.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 8/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPSettingsTextField.h"

@interface CSPSettingsTextField()
@property (nonatomic, copy) NSString *password;
@property (nonatomic, weak) id beginEditingObserver;
@property (nonatomic, weak) id endEditingObserver;


@end

@implementation CSPSettingsTextField



-(void)awakeFromNib{
    
    [self setValue:HEX_COLOR(0x999999FF) forKeyPath:@"_placeholderLabel.textColor"];
    [self setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = HEX_COLOR(0xE2E2E2FF).CGColor;
    self.layer.cornerRadius = 3.0f;
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"10_设置_修改登录密码_清除"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAll) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.adjustsImageWhenHighlighted = NO;
    self.rightView = deleteButton;
    self.rightViewMode = UITextFieldViewModeWhileEditing;
    
    self.password = @"";
    
    __weak CSPSettingsTextField *weakSelf = self;
    
    self.beginEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidBeginEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
                                 {
                                     
                                     if (weakSelf == note.object && weakSelf.isSecureTextEntry) {
                                         weakSelf.text = @"";
                                         [weakSelf insertText:weakSelf.password];
                                     }
                                     
                                     
                                 }];
    self.endEditingObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidEndEditingNotification object:nil queue:nil usingBlock:^(NSNotification *note)
                               {
                                   
                                   if (weakSelf == note.object) {
                                       weakSelf.password = weakSelf.text;
                                   }
                                   
                               }];

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

- (CGRect)rightViewRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.size.width -15-15, bounds.origin.y+15, 15, 15);
    return inset;
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds, 15 , 0 );
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    return CGRectInset(bounds, 15, 0);
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds, 15, 0);
}

//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    //CGContextRef context = UIGraphicsGetCurrentContext();
//    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
//    
//    
//    [[self placeholder] drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//}


@end
