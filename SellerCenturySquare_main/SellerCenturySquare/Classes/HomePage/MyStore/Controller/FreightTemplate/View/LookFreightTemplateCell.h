//
//  LookFreightTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LookFerightTempListModel,LookFerightTempModel;
@interface LookFreightTemplateCell : UITableViewCell


@property (nonatomic,strong)UIView *groundView;
//背景颜色
@property (nonatomic,strong)UIView *view;

//运送到
@property (nonatomic,strong)UILabel *shippedLabel;

//选择城市
@property (nonatomic,strong)UILabel *cityLabel;

//分割线
@property (nonatomic,strong)UILabel *dividerLabel;

//首
@property (nonatomic,strong)UILabel *firstThingLabel;
//首数量
@property (nonatomic,strong)UILabel *firstThingCountLabel;

//续
@property (nonatomic,strong)UILabel *goOnThingLabel;
//续数量
@property (nonatomic,strong)UILabel *goOnThingCountLabel;

//首运费
@property (nonatomic,strong)UILabel *firstThingFreightLabel;
//首运费money
@property (nonatomic,strong)UILabel *firstThingFreightMoneyLabel;

//续运费
@property (nonatomic,strong)UILabel *goOnThingFreightLabel;
//续运费money
@property (nonatomic,strong)UILabel *goOnThingFreightMoneyLabel;



@property (nonatomic,assign)float numFloat;



-(void)getLookFreightTemplateCellData:(LookFerightTempModel *)data  type:(NSString *)type  selectedDefault:(NSString *)selectedDefault;


@end
