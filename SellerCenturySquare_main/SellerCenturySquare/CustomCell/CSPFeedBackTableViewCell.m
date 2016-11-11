//
//  CSPFeedBackTableViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/25.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPFeedBackTableViewCell.h"

static NSString *const tipString = @"您遇到什么问题，或者哪些功能建议，欢迎在此提出！我们将持续跟进优化。";

@implementation CSPFeedBackTableViewCell

- (void)awakeFromNib{
    
    self.feedBackTextView.delegate = self;
    
    self.wordLimitLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)tipString.length];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(id)sender{
    
    if (self.feedBackTextView.text.length>200) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不可以超过200字" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        
        [alert show];
        
        self.feedBackTextView.text = [self.feedBackTextView.text substringToIndex:200];
    }
    
    self.wordLimitLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)self.feedBackTextView.text.length];
}

#pragma mark-
#pragma mark-UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:tipString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        self.wordLimitLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)self.feedBackTextView.text.length];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    //将textView.text去除空格和换行
    NSString *contentTextStr = textView.text;
    
   // contentTextStr = [contentTextStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    contentTextStr = [contentTextStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    if (contentTextStr.length<1) {
        textView.text = tipString;
        textView.textColor = HEX_COLOR(0x999999FF);
        self.wordLimitLabel.text = [NSString stringWithFormat:@"%lu/200",(unsigned long)self.feedBackTextView.text.length];
    }
}

@end
