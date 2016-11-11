//
//  BadgeButton.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BadgeButton.h"


@interface BadgeButton ()



@end

@implementation BadgeButton
@synthesize badgeNumber = badgeNumber_;
@synthesize badge = badge_;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self awakeFromNib];
        
    }
    return self;
}


- (void)awakeFromNib
{
//    if (self.badge == nil) {
//        self.badge = [CustomBadge customBadgeWithString:self.badgeNumber];
//    }

}


- (void)setBadgeNumber:(NSString *)badgeNumber{
    
    [self.badge removeFromSuperview];
    self.badge = nil;
    self.badge = [CustomBadge customBadgeWithString:badgeNumber];

    self.badge.frame = CGRectMake(14, -12, 24, 24);

    
    if ([badgeNumber isEqualToString:@"0"]|| badgeNumber ==nil) {
//        [self.badge removeFromSuperview];
//        self.badge = nil;

    }else{
        
        [self addSubview:self.badge];

    }
}




@end
