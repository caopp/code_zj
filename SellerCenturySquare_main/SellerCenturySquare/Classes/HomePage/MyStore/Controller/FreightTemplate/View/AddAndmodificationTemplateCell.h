//
//  AddAndmodificationTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectedAreaModel;


@protocol AddAndmodificationTemplateCellDelegate <NSObject>

-(void)joinAreaDetailPageIndexPath:(NSIndexPath *)indexPath;
@end


@interface AddAndmodificationTemplateCell : UITableViewCell


@property (weak,nonatomic)id<AddAndmodificationTemplateCellDelegate>delegate;


@property(weak,nonatomic)NSIndexPath *index_row;

//添加背景视图

@property (nonatomic,assign)float floatHeight;

//运送到
@property (nonatomic,strong)UILabel *shippedLabel;

//选择城市
@property (nonatomic,strong)UILabel *cityLabel;

//分割线
@property (nonatomic,strong)UILabel *dividerLabel;

//首
@property (nonatomic,strong)UILabel *firstThingLabel;
//首数量
@property (nonatomic,strong)UITextField *firstThingCountField;

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


@property (nonatomic,strong)UIButton *getAeaButton;


-(void)getNewFreightTemplateCellData:(SelectedAreaModel *)data;



@end
