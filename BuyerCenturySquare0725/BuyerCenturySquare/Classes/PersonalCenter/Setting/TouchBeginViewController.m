//
//  TouchBeginViewController.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/9/1.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TouchBeginViewController.h"

@interface TouchBeginViewController ()
{
    UIScrollView *_scrollView;
    UITextField *_textField1;
    NSInteger _indextext;
}
@end

@implementation TouchBeginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(70,CGRectGetHeight(self.view.bounds)/3,CGRectGetWidth(self.view.bounds) - 100, 30)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.bounces = NO;
    _scrollView.layer.borderWidth = 1;
    [self.view addSubview:_scrollView];
    
    //    NSMutableAttributedString * attributedStr4 = [[NSMutableAttributedString alloc]initWithString:@"请输入约会内容"];
    //    [attributedStr4 addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, attributedStr4.length)];
    _textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0,7,CGRectGetWidth(self.view.bounds) - 100, 15)];
    _textField1.textAlignment = NSTextAlignmentRight;
    _textField1.text = @"";
    _textField1.textColor = [UIColor grayColor];
    _textField1.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
    //    _textField1.attributedPlaceholder = attributedStr4;
    [_textField1 addTarget:self action:@selector(textFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    [_scrollView addSubview:_textField1];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_textField1.bounds),30);
    
    
}

- (void)textFieldEditChanged:(UITextField *)textField
{
    if (CGRectGetWidth(_textField1.bounds)  >=CGRectGetWidth(self.view.bounds) - 100) {
        _scrollView.contentSize =CGSizeMake(CGRectGetWidth(_textField1.bounds),30);
        NSLog(@"%.2f",_scrollView.contentSize.width);
        if (_indextext != _textField1.text.length) {
            [_textField1 sizeToFit];
            [_scrollView setContentOffset:CGPointMake(CGRectGetWidth(_textField1.bounds) -CGRectGetWidth(_scrollView.bounds), 0) animated:NO];
            _indextext = _textField1.text.length;
        }
    }
    else {
        _textField1.frame = CGRectMake(0, 7,CGRectGetWidth(self.view.bounds) - 100, 15);
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        _scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) - 100,30);
        _indextext = _textField1.text.length;
        
    }
    
}

@end
