//
//  BadgeImageView.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BadgeImageView.h"


@interface BadgeImageView ()
{
    CustomBadge *badge_;
}



@end
@implementation BadgeImageView

@synthesize badgeNumber = badgeNumber_;
@synthesize badge = badge_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self awakeFromNib];
    }
    return self;
}


- (void)awakeFromNib
{
    self.clipsToBounds = NO;
}


- (void)setBadgeNumber:(NSString *)badgeNumber{
    
    if (self.badge == nil) {
        self.badge = [[CustomBadge alloc]init];
    }
     [self.badge  changeViewToBadgeWithString:badgeNumber withScale:0.7];
    //self.badge = [CustomBadge customBadgeWithString:badgeNumber];
    self.badge.frame = CGRectMake(22, -3, 15, 15);
    self.badge.badgeStyle.badgeFrameColor = HEX_COLOR(0x673ab7FF);
    if ([badgeNumber isEqualToString:@"0"]|| badgeNumber ==nil) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }else{
        [self addSubview:self.badge];
    }
}

@end
