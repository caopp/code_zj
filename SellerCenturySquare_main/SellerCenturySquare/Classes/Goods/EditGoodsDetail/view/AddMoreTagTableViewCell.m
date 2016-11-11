//
//  AddMoreTagTableViewCell.m
//  SellerCenturySquare
//
//  Created by 陈光 on 16/3/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddMoreTagTableViewCell.h"
#import "CSPUtils.h"
#import "UIColor+HexColor.h"
#import "KeyboardToolBarTextField.h"
@interface AddMoreTagTableViewCell ()<UITextFieldDelegate>
@property (nonatomic ,strong) UITextField *recordField;

@property (weak, nonatomic) IBOutlet UIButton *deleteCurrentCell;
- (IBAction)deleteCurrentClickBtn:(id)sender;

@end

@implementation AddMoreTagTableViewCell


- (void)awakeFromNib {
    self.tagNameTF.delegate = self;
    
//    self.tagNameTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.tagNameTF.font = [UIFont systemFontOfSize:13];

    
    self.tagNameTF.layer.cornerRadius = 2;
    self.tagNameTF.layer.masksToBounds = YES;
    self.tagNameTF.layer.borderWidth = 0.5;
    self.tagNameTF.layer.borderColor = [UIColor colorWithHex:0x999999 alpha:1].CGColor;
    [KeyboardToolBarTextField registerKeyboardToolBar:self.tagNameTF];

    self.deletedButton.font = [UIFont systemFontOfSize:13];
    [self.deletedButton setTitleColor:[UIColor colorWithHex:0x000000 alpha:1 ] forState:(UIControlStateNormal)];
    [self.deletedButton setBackgroundColor:[UIColor colorWithHex:0xe2e2e2 alpha:1]];
    self.deletedButton.layer.cornerRadius = 2;
    self.deletedButton.layer.masksToBounds = YES;
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"%@",textField.text);
        [self.delegate  AddMoreTagSendDataStr:textField.text andCurrentCell:self];


    
}

//- textFieldShouldBeginEditing
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    [self.delegate keyboardJumpCell:self];
    
    
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)deleteCurrentClickBtn:(id)sender {

    [self.tagNameTF endEditing:YES];
    
    [self.delegate deleteTheCurrentCell:self];
    
}


@end