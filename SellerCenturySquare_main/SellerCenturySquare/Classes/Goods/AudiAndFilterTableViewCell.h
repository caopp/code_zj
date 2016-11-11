//
//  AudiAndFilterTableViewCell.h
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/6/17.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudiAndFilterTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *operationTitleLabel;

//!详细解释的内容
@property (weak, nonatomic) IBOutlet UILabel *detailAlertLabel;

//!分割线
@property (weak, nonatomic) IBOutlet UILabel *filterLabel;

//!"待审核的商品分享："
@property (weak, nonatomic) IBOutlet UILabel *numLeftLabel;

//!数量显示
@property (weak, nonatomic) IBOutlet UILabel *numLabel;


//!如果是参考图筛选，传入 yes
-(void)configWithFilter:(BOOL)isFilter withNum:(NSInteger)num;



@end
