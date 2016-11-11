//
//  RecommendPostScriptTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendPostScriptTableViewCell.h"

@implementation RecommendPostScriptTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [_textView.layer setMasksToBounds:YES];
    [_textView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [_textView.layer setBorderWidth:1];
    _textView.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
   // xxxx
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditeRecommend" object:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    _saveGoodsRecommendModel.content = _textView.text;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EditeRecommend" object:nil];

}

- (IBAction)endEdit:(id)sender {
    
    [self endEditing:YES];
}

@end
