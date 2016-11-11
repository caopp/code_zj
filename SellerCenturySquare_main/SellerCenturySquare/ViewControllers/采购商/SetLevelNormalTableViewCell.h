//
//  SetLevelNormalTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kSetLevelSelectedLevelStateNotification @"SetLevelSelectedLevelStateNotification"
@interface SetLevelNormalTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *levelL;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (nonatomic,assign) NSInteger index;


- (void)setSelectState:(BOOL)selected;
- (void)setDisplayLevel:(NSInteger)level;
@end
