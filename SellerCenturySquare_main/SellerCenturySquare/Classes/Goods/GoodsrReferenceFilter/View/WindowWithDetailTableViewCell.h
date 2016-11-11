//
//  WindowWithDetailTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/11.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodImageDTO.h"


@protocol WindowWithDetailTableViewCellDelegate <NSObject>

-(void)setButton:(UIButton *)button image:(UIImageView *)image;


-(void)amplificationImage:(UIImageView *)imageView;

@end

@interface WindowWithDetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weightConstraint;

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

//展示名字
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//展示时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//按钮点击事件
- (IBAction)didClickSelectButtonAction:(UIButton *)sender;
//设置窗口图的名字
@property (weak, nonatomic) IBOutlet UILabel *setLabel;
//窗口图和详情图
@property (weak, nonatomic) IBOutlet UIImageView *WindowWithDetail;
//分割线
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak,nonatomic)id<WindowWithDetailTableViewCellDelegate>delegate;


@property (nonatomic,assign)float heightCell;
//设置个方法接受数据

-(void)acceptImageDTO:(GoodImageDTO *)goodImageDTO;



@end
