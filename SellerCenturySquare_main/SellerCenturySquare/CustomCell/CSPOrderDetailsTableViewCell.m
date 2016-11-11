//
//  CSPOrderDetailsTableViewCell.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/19.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPOrderDetailsTableViewCell.h"
#import "UUImageAvatarBrowser.h"

@implementation CSPOrderDetailsTableViewCell

- (void)awakeFromNib{
    self.circularView.layer.cornerRadius = self.circularView.frame.size.width / 2;
    self.circularView.clipsToBounds = YES;
    
    self.orderTypeBackgroundView.layer.cornerRadius = 2;
}

@end
