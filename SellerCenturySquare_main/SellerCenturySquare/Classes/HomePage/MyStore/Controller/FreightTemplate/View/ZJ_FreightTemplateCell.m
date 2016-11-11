//
//  ZJ_FreightTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/4/16.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ZJ_FreightTemplateCell.h"
#import "LookFerightTempModel.h"
#import "LookFerightTempListModel.h"
#import "UIColor+UIColor.h"
#import "KeyboardToolBarTextField.h"

#define screenWeight  [[UIScreen mainScreen] bounds].size.width
#define unitWeight 8
@implementation ZJ_FreightTemplateCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.view = [[UIView alloc]init];
        self.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.view];
    
        
        self.groundView = [[UIView alloc]init];
        [self.contentView addSubview:self.groundView];
        self.groundView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];

        //运送至
        self.transportedLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.transportedLabel];
        

        //分割线
        
        self.firstLineLabel = [[UILabel alloc]init];
         self.firstLineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        [self.contentView addSubview:self.firstLineLabel];

        //删除按钮
        self.deletedButton = [[UIButton alloc]init];
        [self.contentView addSubview:self.deletedButton];
       
        
        
        
        
        //分割线
        self.firstLineLabel = [[UILabel alloc]init];
        self.firstLineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        [self.contentView addSubview:self.firstLineLabel];
        

        //选择城市区域
        self.shippedLabel =[[UILabel alloc]init];
//        self.shippedLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.shippedLabel];
        

        //城市区域
        self.cityLabel = [[UILabel alloc]init];
//        self.cityLabel.backgroundColor = [UIColor redColor];
        self.cityLabel.numberOfLines = 0;
        self.cityLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.cityLabel];
        
        
        //分割线
        self.dividerLabel = [[UILabel alloc]init];
        self.dividerLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
        [self.contentView addSubview:self.dividerLabel];
        
        //首
        self.firstThingLabel = [[UILabel alloc]init];
//        self.firstThingLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firstThingLabel];
        
        
        //首数量
        self.firstThingCountField = [[UITextField alloc]init];
//        self.firstThingCountField.backgroundColor = [UIColor redColor];
        self.firstThingCountField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
        self.firstThingCountField.layer.borderWidth = 1;
        self.firstThingCountField.layer.cornerRadius = 2;
        self.firstThingCountField.layer.masksToBounds = YES;
        self.firstThingCountField.textAlignment = NSTextAlignmentCenter;
        self.firstThingCountField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.firstThingCountField];
//         [KeyboardToolBarTextField registerKeyboardToolBar:self.firstThingCountField];

        
        //续
        self.goOnThingLabel = [[UILabel alloc]init];
//        self.goOnThingLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.goOnThingLabel];
        
        
        //续数量
        self.goOnThingCountField = [[UITextField alloc]init];
//        self.goOnThingCountField.backgroundColor = [UIColor redColor];
        self.goOnThingCountField.layer.borderWidth = 1;
        self.goOnThingCountField.layer.cornerRadius = 2;
        self.goOnThingCountField.layer.masksToBounds = YES;
         self.goOnThingCountField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
        self.goOnThingCountField.textAlignment = NSTextAlignmentCenter;
        self.goOnThingCountField.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.goOnThingCountField];
//        [KeyboardToolBarTextField registerKeyboardToolBar:self.goOnThingCountField];

        
        
        //首运费
        self.firtThingFreightLabel = [[UILabel alloc]init];
//        self.firtThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firtThingFreightLabel];
        
        
        //首运费money
        self.firstThingFreightMoneyField = [[UITextField alloc]init];
//        self.firstThingFreightMoneyField.backgroundColor = [UIColor redColor];
         self.firstThingFreightMoneyField.layer.borderWidth = 1;
        self.firstThingFreightMoneyField.layer.cornerRadius = 2;
        self.firstThingFreightMoneyField.layer.masksToBounds = YES;

        self.firstThingFreightMoneyField.textAlignment = NSTextAlignmentCenter;
        self.firstThingFreightMoneyField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.firstThingFreightMoneyField];
        self.firstThingFreightMoneyField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
//        [KeyboardToolBarTextField registerKeyboardToolBar:self.firstThingFreightMoneyField];

        
        //续运费
        self.goOnThingFreightLabel = [[UILabel alloc]init];
//        self.goOnThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.goOnThingFreightLabel];
        
        //续运费money
        self.goOnThingFreightMoneyField = [[UITextField alloc]init];
//        self.goOnThingFreightMoneyField.backgroundColor = [UIColor redColor];
        self.goOnThingFreightMoneyField.layer.borderWidth = 1;
        self.goOnThingFreightMoneyField.textAlignment = NSTextAlignmentCenter;

        self.goOnThingFreightMoneyField.layer.cornerRadius = 2;
        self.goOnThingFreightMoneyField.layer.masksToBounds = YES;
        self.goOnThingFreightMoneyField.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview: self.goOnThingFreightMoneyField];
         self.goOnThingFreightMoneyField.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
//         [KeyboardToolBarTextField registerKeyboardToolBar:self.goOnThingFreightMoneyField];
        
        self.firstUnitLabel = [[UILabel alloc]init];
//        self.firstUnitLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview: self.firstUnitLabel];
        
        self.secondUnitLabel = [[UILabel alloc]init];
//        self.secondUnitLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview: self.secondUnitLabel];

        self.thrstUnitLabel = [[UILabel alloc]init];
//        self.thrstUnitLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview: self.thrstUnitLabel];

        self.fourUnitLabel = [[UILabel alloc]init];
//        self.fourUnitLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview: self.fourUnitLabel];
        
        //箭头
        self.icon = [[UIImageView alloc]init];
        [self.contentView addSubview:self.icon];
        self.icon.image = [UIImage imageNamed:@"进入（深色）"];
        
        //添加手势
        self.cityLabel.userInteractionEnabled  = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTapGesture)];
        [self.cityLabel addGestureRecognizer: tapGesture];
        
     
        
    }
    return self;
}

//添加手势
-(void)addTapGesture
{
    NSLog(@"添加手势");
    
    if ([self.delegate respondsToSelector:@selector(joinAreaDetailPageIndexPath:)]) {
        
        [self.delegate joinAreaDetailPageIndexPath:self.index_row];
        
    }
}



//获取数据
-(void)getLookFreightTemplateCellType:(NSString *)type  cityStr:(NSString *)cityStr indexRow:(NSInteger )indexRow
{
    
    //根据屏幕宽度进行设置
   
    if (0 == indexRow) {
        
        //分割线
        self.dividerLabel.frame = CGRectMake(15, 8, SCREEN_WIDTH - 15, 1);
        self.firstLineLabel.frame = CGRectMake(15, 8,SCREEN_WIDTH - 1, 1);

        
    }
    else
    {

        self.transportedLabel.frame = CGRectMake(15, 10, 80, 15);
        self.transportedLabel.text = @"运送至:";
        [self.transportedLabel setTextColor:[UIColor blackColor]];
        self.transportedLabel.font = [UIFont systemFontOfSize:14];
        
        //分割线
        self.firstLineLabel.frame = CGRectMake(15, 35,SCREEN_WIDTH - 15, 1);
        
        //删除按钮
        self.deletedButton.frame =  CGRectMake(SCREEN_WIDTH - 81, 5, 68, 25);
        [self.deletedButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        [self.deletedButton setFont:[UIFont systemFontOfSize:14]];
        self.deletedButton.layer.borderWidth = 0.5;
        self.deletedButton.layer.cornerRadius = 2;
        self.deletedButton.layer.masksToBounds = YES;
        [self.deletedButton setTitle:@"删除" forState:(UIControlStateNormal)];
        [self.deletedButton addTarget:self action:@selector(deleteFreightTemplateCell) forControlEvents:UIControlEventTouchUpInside];
        
        
        
//运送到
//        self.shippedLabel.frame = CGRectMake(15, 10 + 40, 80, 15);
//        self.shippedLabel.font = [UIFont systemFontOfSize:14];
//        self.shippedLabel.text = @"请选择区域";
//        self.shippedLabel.textColor = [UIColor blackColor];
        

        //城市区域
       
        CGSize cityLabelSize = [self sizeWithText:cityStr font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake( SCREEN_WIDTH - 100, MAXFLOAT)];
        self.cityLabel.frame = CGRectMake(15, 50,SCREEN_WIDTH - 45, cityLabelSize.height);
        
        self.cityLabel.numberOfLines = 0;
        if ([cityStr isEqualToString:@""] || cityStr == nil) {
             self.cityLabel.text = @"请选择区域";
        }else
        {
         self.cityLabel.text = cityStr;
        }
        
        self.icon.frame = CGRectMake(self.cityLabel.frame.origin.x + self.cityLabel.frame.size.width + 5, self.cityLabel.center.y - 7, 10, 14);
        

        //分割线
        self.dividerLabel.frame = CGRectMake(15, self.cityLabel.frame.origin.y + self.cityLabel.frame.size.height + 12, SCREEN_WIDTH - 15, 1);
    }

    
    
    
    //////////////
    //首
    self.firstThingLabel.frame = CGRectMake(15, self.dividerLabel.frame.origin.y + 19, 40, 15);
    self.firstThingLabel.font = [UIFont systemFontOfSize:14];
    //首数量
    self.firstThingCountField.frame = CGRectMake(self.firstThingLabel.frame.origin.x + self.firstThingLabel.frame.size.width, self.dividerLabel.frame.origin.y + 11, 80, 30);
    self.firstThingCountField.text = nil;
    self.firstThingCountField.layer.borderWidth = 1;
    
    self.firstUnitLabel.frame = CGRectMake(self.firstThingCountField.frame.origin.x + self.firstThingCountField.frame.size.width + unitWeight, self.firstThingLabel.frame.origin.y, 40, 15);
    
    if (screenWeight == 320.0f) {
        //首运费
        self.firtThingFreightLabel.frame = CGRectMake(self.firstUnitLabel.frame.origin.x + self.firstUnitLabel.frame.size.width - 20, self.firstThingLabel.frame.origin.y, self.firstThingLabel.frame.size.width, self.firstThingLabel.frame.size.height);
    }else
    {
        //首运费
        self.firtThingFreightLabel.frame = CGRectMake(self.firstUnitLabel.frame.origin.x + self.firstUnitLabel.frame.size.width, self.firstThingLabel.frame.origin.y, self.firstThingLabel.frame.size.width, self.firstThingLabel.frame.size.height);
    }
    
    //首运费money
    self.firstThingFreightMoneyField.frame = CGRectMake(self.firtThingFreightLabel.frame.origin.x + self.firtThingFreightLabel.frame.size.width, self.firstThingCountField.frame.origin.y, self.firstThingCountField.frame.size.width, self.firstThingCountField.frame.size.height);
    self.firstThingFreightMoneyField.text = nil;
    self.secondUnitLabel.frame = CGRectMake(self.firstThingFreightMoneyField.frame.origin.x + self.firstThingFreightMoneyField.frame.size.width + unitWeight , self.firstUnitLabel.frame.origin.y, 40, 15);
    
    
    
    
    
    ///////////////
    //续
    self.goOnThingLabel.frame = CGRectMake(15, self.firstThingCountField.frame.origin.y + self.firstThingCountField.frame.size.height + 30, self.firstThingLabel.frame.size.width, self.firstThingLabel.frame.size.height);
    //续数量
    self.goOnThingCountField.frame = CGRectMake(self.goOnThingLabel.frame.origin.x + self.goOnThingLabel.frame.size.width, self.goOnThingLabel.center.y - 15, self.firstThingCountField.frame.size.width, self.firstThingCountField.frame.size.height);
    self.goOnThingCountField.text = nil;

    self.thrstUnitLabel.frame = CGRectMake(self.goOnThingCountField.frame.origin.x + self.goOnThingCountField.frame.size.width + unitWeight, self.goOnThingLabel.frame.origin.y, 40, 15);
    
    
    //续运费
    self.goOnThingFreightLabel.frame = CGRectMake(self.firtThingFreightLabel.frame.origin.x , self.goOnThingLabel.frame.origin.y, self.firtThingFreightLabel.frame.size.width, self.firtThingFreightLabel.frame.size.height);
    //续运费money
    self.goOnThingFreightMoneyField.frame = CGRectMake(self.firstThingFreightMoneyField.frame.origin.x, self.goOnThingCountField.frame.origin.y, self.goOnThingCountField.frame.size.width, self.goOnThingCountField.frame.size.height);
    self.goOnThingFreightMoneyField.text = nil;

    self.fourUnitLabel.frame = CGRectMake( self.goOnThingFreightMoneyField.frame.origin.x +  self.goOnThingFreightMoneyField.frame.size.width + unitWeight, self.goOnThingFreightLabel.frame.origin.y, 40, 15);
    
    self.view.frame = CGRectMake(0, 0,SCREEN_WIDTH , self.goOnThingFreightMoneyField.frame.origin.y +  self.goOnThingFreightMoneyField.frame.size.height + 20);
    
    self.groundView.frame = CGRectMake(0, self.view.frame.size.height - 10, SCREEN_WIDTH, 10);
    
    //根据传过来类型进行判断
    
    if (type.integerValue == 0) {
        
        self.firstUnitLabel.text = @"kg";
        
        self.thrstUnitLabel.text = @"kg";
        
        self.firstThingLabel.text = @"首重:";

        //续
        self.goOnThingLabel.text = @"续重:";
    
    }else
    {
        self.firstUnitLabel.text = @"件";
        
        self.thrstUnitLabel.text = @"件";
        
        self.firstThingLabel.text = @"首件:";
        
        //续
        self.goOnThingLabel.text = @"续件:";
    
    }
    
    self.secondUnitLabel.text = @"元";
    
    self.fourUnitLabel.text = @"元";
    
    //首运费
    self.firtThingFreightLabel.text = @"首费:";
    
    //续运费
    self.goOnThingFreightLabel.text = @"续费:";
    
    self.firstUnitLabel.font = [UIFont systemFontOfSize:14];
    
    self.thrstUnitLabel.font = [UIFont systemFontOfSize:14];

    self.firstThingLabel.font = [UIFont systemFontOfSize:14];

    self.goOnThingLabel.font = [UIFont systemFontOfSize:14];

    self.firtThingFreightLabel.font = [UIFont systemFontOfSize:14];

    self.goOnThingFreightLabel.font = [UIFont systemFontOfSize:14];
    
    self.secondUnitLabel.font = [UIFont systemFontOfSize:14];
    
    self.fourUnitLabel.font = [UIFont systemFontOfSize:14];
    
    self.numFloat =  self.view.frame.size.height;
    NSLog(@"self.numFloat =====%lf",self.numFloat);
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
}

-(void)deleteFreightTemplateCell
{

    //删除对应的数据
    if ([self.delegate respondsToSelector:@selector(deletedFreightTemplateCell:indexPath:)]) {
        
        [self.delegate deletedFreightTemplateCell:self indexPath:self.index_cellRow];
        
    }

}



@end
