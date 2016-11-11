//
//  CollectionHeaderView.m
//  CollectionViewSubscriptionLabel
//
//  Created by chenyk on 15/4/24.
//  Copyright (c) 2015年 chenyk. All rights reserved.
//

#import "CollectionHeaderView.h"
#import "UIColor+UIColor.h"

#define kTitleButtonWidth 250.f
#define kMoreButtonWidth  36*2
#define kCureOfLineHight  0.5
#define kCureOfLineOffX   16

float CYLFilterHeaderViewHeigt = 38;

@implementation CollectionHeaderView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}
- (id)initWithCoder: (NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        self = [self sharedInit];
    }
    return self;
}

- (id)sharedInit {
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 30)];

    [self addSubview:self.titleLabel];
    
    //线体
    self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 7 , self.frame.size.width, 1)];
    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    
    [self addSubview:self.lineLabel];
    
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [self.titleLabel setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    
    return self;
    
}

@end
