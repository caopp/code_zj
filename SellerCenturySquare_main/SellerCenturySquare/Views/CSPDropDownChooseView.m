//
//  CSPDropDownChooseView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDropDownChooseView.h"

@implementation CSPDropDownChooseView{
        
    UIButton *_chooseButton;
    
    BOOL _isDropDown;
}

- (void)awakeFromNib{
    
    self.titleArray = [[NSMutableArray alloc]initWithObjects:@"货号",@"名称", nil];
    
    self.defaultTitle = @"货号";
    
    _mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_mainButton  addTarget:self action:@selector(mainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainButton.frame = CGRectMake(0, 0, 47, 30);
    
    [_mainButton setTitle:self.defaultTitle forState:UIControlStateNormal];
    
    _mainButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [_mainButton setTitleColor:HEX_COLOR(0x000000FF) forState:UIControlStateNormal];
    
    _mainButton.backgroundColor = HEX_COLOR(0xf0f0f0FF);
    
    _mainButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _mainButton.layer.borderWidth = 0.5;
    
    [self addSubview:_mainButton];
    
    _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    [_chooseButton setImage:[UIImage imageNamed:@"04_商家中心_商品_货号选择下拉选项.png"] forState:UIControlStateNormal];
    
    _chooseButton.frame = CGRectMake(46, 0, 30, 30);
    
    _chooseButton.backgroundColor = HEX_COLOR(0xf0f0f0FF);
    
    _chooseButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _chooseButton.layer.borderWidth = 0.5;
    
    [self addSubview:_chooseButton];
    
    [self bringSubviewToFront:_mainButton];
}

- (void)mainButtonClick:(UIButton*)sender{
    DebugLog(@"调用");
    
    _isDropDown = !_isDropDown;

    [self removeExcessView];

}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self awakeFromNib];
        
        return self;
    }else{
        return nil;
    }
}

- (void)chooseButtonClick:(UIButton *)sender{
    
    DebugLog(@"test");
    
    _isDropDown = !_isDropDown;
    
    if (!self.titleArray.count) {
        return;
    }
    
    //先remove
    [self removeExcessView];
    
    if (!_isDropDown) {
        
        return;
    }

    NSMutableArray *array = [[NSMutableArray alloc]init];
    
    [array addObjectsFromArray:self.titleArray];
    
    [self.titleArray removeObject:_mainButton.titleLabel.text];
    
    for (int i = 0; i<self.titleArray.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button addTarget:self action:@selector(selectedTitleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.frame = CGRectMake(0, _mainButton.frame.size.height*i+_mainButton.frame.size.height, _mainButton.frame.size.width, _mainButton.frame.size.height);
        
        [button setTitle:[self.titleArray objectAtIndex:i] forState:UIControlStateNormal];
        
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:13];

        button.backgroundColor = HEX_COLOR(0xf0f0f0FF);
        
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        button.layer.borderWidth = 0.5;
        
        [self addSubview:button];
    }
    
    [self.titleArray removeAllObjects];
    
    [self.titleArray addObjectsFromArray:array];
    
    //
    self.setFrameBlock(_isDropDown);
}

- (void)selectedTitleClick:(UIButton *)sender{
    
    _isDropDown = !_isDropDown;
    
    [_mainButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    
    [self removeExcessView];
}

- (void)removeExcessView{
    
    NSArray *subViews = self.subviews;
    
    for (UIButton *button in subViews) {
        if (button != _mainButton && button!= _chooseButton) {
            [button removeFromSuperview];
        }
    }
}



@end
