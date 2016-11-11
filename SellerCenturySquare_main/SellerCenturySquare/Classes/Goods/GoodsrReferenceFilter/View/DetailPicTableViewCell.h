//
//  DetailPicTableViewCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/7/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodImageDTO.h"

@protocol DetailPicTableViewCellDelagate <NSObject>
-(void)setDetailButton:(UIButton *)detailButton image:(UIImageView *)image;

//放大图片
-(void)amplificationImage:(UIImageView *)imageView;
@end

@interface DetailPicTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstrain;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

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

//代理
@property (weak,nonatomic)id<DetailPicTableViewCellDelagate>delegate;


//接受数据赋值给cell
-(void)acceptGoodImageDTO:(GoodImageDTO *)goodImageDTO;


@end
