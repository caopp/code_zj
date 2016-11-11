//
//  KeyboardBar.m
//  KeyboardInputView
//
//  Created by Brian Mancini on 10/4/14.
//  Copyright (c) 2014 iOSExamples. All rights reserved.
//

#import "KeyboardBar.h"

@implementation KeyboardBar

+ (KeyboardBar *)sharedInstance {
    
    static KeyboardBar *instance_;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance_ = [[KeyboardBar alloc] init];
    });
    return instance_;
}

- (id)init {
    CGRect screen = [[UIScreen mainScreen] bounds];
    CGRect frame = CGRectMake(0,0, CGRectGetWidth(screen), 45);
    self = [self initWithFrame:frame];
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if(self) {
        // 设置style
        [self setBarStyle:UIBarStyleDefault];
//        self.backgroundColor = [UIColor colorWithWhite:0.75f alpha:1.0f];
        
        // 定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
        UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                    target:self
                                    action:nil];
        
        UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                     target:self
                                     action:nil];
        
        // 定义完成按钮
        UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone
                                                                      target:self action:@selector(resignKeyboard)];
        
        // 在toolBar上加上这些按钮
        NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
        
        [self setItems:buttonsArray];
    }
    return self;
}

- (void) resignKeyboard
{
    [self.textField endEditing:YES];
}

@end
