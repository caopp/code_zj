//
//  DownloadTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/3.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "DownloadTableViewCell.h"

@implementation DownloadTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self updateNum:@"0" WithTitle:@" "];

}

//更新数量
- (void)updateNum:(NSString*)num WithTitle:(NSString *)title{
    
    if ([num integerValue]==0) {
        _titleL.text = title;
    
    }else{
        _titleL.text = [NSString stringWithFormat:@"%@(%@)",title,num];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
