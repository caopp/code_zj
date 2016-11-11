//
//  BadgeImageView.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/22/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"

@interface BadgeImageView : UIImageView

{
    NSString *badgeNumber_;
}
@property (nonatomic,strong)CustomBadge *badge;
@property (nonatomic, strong) NSString *badgeNumber;

@end
