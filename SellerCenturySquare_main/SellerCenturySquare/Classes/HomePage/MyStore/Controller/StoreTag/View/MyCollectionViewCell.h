//
//  MyCollectionViewCell.h
//  collection
//
//  Created by 徐茂怀 on 16/2/23.
//  Copyright © 2016年 徐茂怀. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell


@property(nonatomic, strong)UILabel *label;


@property (nonatomic,assign)BOOL isOk;

-(void)layoutSubviews;
@end
