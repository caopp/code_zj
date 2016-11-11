//
//  CSPCollectionGoodsHeaderTableViewCell.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/17/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CSPBaseTableViewCell.h"

@protocol CSPCollectionGoodsHeaderTableViewCellDelegate <NSObject>

- (void)merchantNamePressedForSection:(NSInteger)section;

@end

@interface CSPCollectionGoodsHeaderTableViewCell : CSPBaseTableViewCell

@property (nonatomic, assign)id<CSPCollectionGoodsHeaderTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *merchantNameButton;
@property (nonatomic, assign)NSInteger section;

@end
