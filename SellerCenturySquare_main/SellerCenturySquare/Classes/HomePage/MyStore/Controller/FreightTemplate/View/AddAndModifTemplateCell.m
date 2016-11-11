//
//  AddAndModifTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddAndModifTemplateCell.h"
#import "UIColor+UIColor.h"
#import "SelectedAreaModel.h"
@implementation AddAndModifTemplateCell

- (void)awakeFromNib {
    
    [self.cityButton setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:(UIControlStateNormal)];
    
    self.firstThingCountText.delegate  = self;
    self.firstThingFreightText.delegate  = self;
    self.goOnThingFreightText.delegate  = self;
    self.goOnText.delegate  = self;
    self.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
    //
    self.firstThingCountText.layer.borderWidth = 1;
    self.firstThingCountText.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    
    //
    self.firstThingFreightText.layer.borderWidth = 1;
    self.firstThingFreightText.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    
    //
    self.goOnThingFreightText.layer.borderWidth = 1;
    self.goOnThingFreightText.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    
    //
    self.goOnText.layer.borderWidth = 1;
    self.goOnText.layer.borderColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1].CGColor;
    
    //
    self.areaLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addTapGesture)];
    [self.areaLabel addGestureRecognizer:tapGesture];
    [self.areaLabel setInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    
}

//添加手势
-(void)addTapGesture
{

    if ([self.delegate respondsToSelector:@selector(joinAreaDetailPageIndexPath:)]) {
        
        [self.delegate joinAreaDetailPageIndexPath:self.index_row];
        
    }
 
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.delegate keyboardJumpCell:self];

    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)didClickCityBtnActioin:(id)sender {
    
//    if ([self.delegate respondsToSelector:@selector(joinAreaDetailPageIndexPath:)]) {
//        
//        [self.delegate joinAreaDetailPageIndexPath:self.index_row];
//        
//    }
    

}

-(void)getNewFreightTemplateCellData:(NSString *)str
{
    
    [self sizeWithText:str font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(300, MAXFLOAT)];
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
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


-(void)didClickJoinDetailAreaPage
{
    
}
@end
