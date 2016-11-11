//
//  GoodsTemplateViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/23.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsTemplateViewCellDelegate <NSObject>

-(void)selectedBtn:(UIButton *)btn;

@end

@interface GoodsTemplateViewCell : UITableViewCell

@property (weak,nonatomic)id<GoodsTemplateViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

@property (weak, nonatomic) IBOutlet UILabel *templateNameLabel;

@end
