//
//  BadgeButton.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BadgeButton.h"
#import "CustomBadge.h"

@interface BadgeButton ()
{
    CustomBadge *badge_;
}

@property (nonatomic,strong)CustomBadge *badge;


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
   
    
}


- (void)setBadgeNumber:(NSString *)badgeNumber{
    
    if (self.badge == nil) {
        self.badge = [[CustomBadge alloc]init];
    }
    self.badge = [CustomBadge customBadgeWithString:badgeNumber];
    self.badge.frame = CGRectMake(17, -3, 15, 15);
    self.badge.badgeStyle.badgeFrameColor = HEX_COLOR(0x673ab7FF);
    if ([badgeNumber isEqualToString:@"0"]|| badgeNumber ==nil) {
        [self.badge removeFromSuperview];
        self.badge = nil;
    }else{
        [self addSubview:self.badge];
    }
}




@end
