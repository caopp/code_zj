//
//  CSPDownloadImageView.m
//  SellerCenturySquare
//
//  Created by clz on 15/9/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPDownloadImageView.h"

@implementation CSPDownloadImageView

- (void)awakeFromNib{
    
//    view.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95];
    
    [self viewWithTag:101].backgroundColor = HEX_COLOR(0x666666F2);
    
    [self viewWithTag:102].backgroundColor = HEX_COLOR(0x999999FF);
    
    [self viewWithTag:103].backgroundColor = HEX_COLOR(0x666666F2);
    
}


- (IBAction)downLoadReferImageButtonClick:(id)sender {
    
    self.downLoadReferImageBlock();
}

- (IBAction)downLoadButtonClick:(id)sender {
    
    self.downLoadBlock();
}

- (IBAction)downLoadObjectiveImageButtonClick:(id)sender {
    
    self.downloadObjectiveImageBlock();
}
@end
