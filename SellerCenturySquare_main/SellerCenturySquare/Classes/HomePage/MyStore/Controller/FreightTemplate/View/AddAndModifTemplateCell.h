//
//  AddAndModifTemplateCell.h
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LabelPadding.h"
@class SelectedAreaModel,AddAndModifTemplateCell;
@protocol AddAndModifTemplateCellDelegate <NSObject>

-(void)joinAreaDetailPageIndexPath:(NSIndexPath *)indexPath;
//键盘弹出的时候触发的方法
- (void)keyboardJumpCell:(AddAndModifTemplateCell *)cell;

@end

typedef void (^AddAndModifTemplateCellBlock) (CGFloat cellHeight);





@interface AddAndModifTemplateCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *lineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapContarnt;


//label显示城市
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeightContrant;
@property (weak, nonatomic) IBOutlet LabelPadding *areaLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTapContrant;










@property (weak, nonatomic) IBOutlet UIView *viewColor;

@property (weak,nonatomic)id<AddAndModifTemplateCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tapLenght;




@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLenght;

@property (nonatomic,assign)CGFloat iii;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLenght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lowerPartLenght;

@property (nonatomic,copy)AddAndModifTemplateCellBlock addAndModifTemplateCellBlock;



@property (nonatomic,strong)NSString *str;


@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIButton *cityButton;
@property (weak, nonatomic) IBOutlet UILabel *defaultLabel;

@property(weak,nonatomic)NSIndexPath *index_row;

@property (nonatomic,assign)CGFloat cellHeight;

@property (weak, nonatomic) IBOutlet UIView *backgroudView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityConstraint;
@property (weak, nonatomic) IBOutlet UILabel *dividerLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstThingLabel;


//首数量
@property (weak, nonatomic) IBOutlet UITextField *firstThingCountText;


//单位
@property (weak, nonatomic) IBOutlet UILabel *firstUnitLabel;

//首运费
@property (weak, nonatomic) IBOutlet UILabel *firstThingFreightLabel;

@property (weak, nonatomic) IBOutlet UITextField *firstThingFreightText;

//续
@property (nonatomic,strong)UILabel *goOnThingLabel;
//续数量
@property (nonatomic,strong)UILabel *goOnThingCountLabel;

//单位元

@property (weak, nonatomic) IBOutlet UILabel *firstYuanLabel;

//续运
@property (weak, nonatomic) IBOutlet UILabel *goOnThingFreightLabel;
//续费text
@property (weak, nonatomic) IBOutlet UITextField *goOnThingFreightText;


@property (weak, nonatomic) IBOutlet UILabel *secondKgLabel;

@property (weak, nonatomic) IBOutlet UILabel *goOnThingFreightMoneyLabel;




@property (weak, nonatomic) IBOutlet UITextField *goOnText;

@property (weak, nonatomic) IBOutlet UILabel *secondYuanLabel;


-(void)getNewFreightTemplateCellData:(NSString *)str;

@end
