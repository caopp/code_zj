//
//  ZJ_FreightTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/4/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LookFerightTempListModel,LookFerightTempModel,ZJ_FreightTemplateCell;


@protocol ZJ_FreightTemplateCellDelegate <NSObject>

-(void)joinAreaDetailPageIndexPath:(NSIndexPath *)indexPath;
//键盘弹出的时候触发的方法
- (void)keyboardJumpCell:(NSIndexPath *)indexPath;

 //删除对应的数据
-(void)deletedFreightTemplateCell:(ZJ_FreightTemplateCell *)freightTemplateCell  indexPath:(NSIndexPath *)indexPath ;

@end

@interface ZJ_FreightTemplateCell : UITableViewCell

//代理方法
@property (weak,nonatomic)id<ZJ_FreightTemplateCellDelegate>delegate;

@property (nonatomic,strong)UIImageView *icon;

@property(weak,nonatomic)NSIndexPath *index_cellRow;

@property(weak,nonatomic)NSIndexPath *index_row;

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
@property (nonatomic,strong)UITextField *firstThingCountField;
//续
@property (nonatomic,strong)UILabel *goOnThingLabel;
//续数量
@property (nonatomic,strong)UITextField *goOnThingCountField;
//首运费
@property (nonatomic,strong)UILabel *firtThingFreightLabel;
//首运费money
@property (nonatomic,strong)UITextField *firstThingFreightMoneyField;
//续运费
@property (nonatomic,strong)UILabel *goOnThingFreightLabel;
//续运费money
@property (nonatomic,strong)UITextField *goOnThingFreightMoneyField;



@property (nonatomic,strong)UILabel *firstUnitLabel;

@property (nonatomic,strong)UILabel *secondUnitLabel;

@property (nonatomic,strong)UILabel *thrstUnitLabel;

@property (nonatomic,strong)UILabel *fourUnitLabel;



//运送至
@property (nonatomic,strong)UILabel *transportedLabel;
//删除按钮
@property (nonatomic,strong)UIButton *deletedButton;
//分割线
@property (nonatomic,strong)UILabel * firstLineLabel;

@property (nonatomic,assign)float numFloat;
-(void)getLookFreightTemplateCellType:(NSString *)type  cityStr:(NSString *)cityStr indexRow:(NSInteger )indexRow;
@end
