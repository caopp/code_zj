//
//  DefineTextField.m
//  自定义textfield
//
//  Created by 张晓旭 on 16/4/18.
//  Copyright © 2016年 张晓旭. All rights reserved.
//

#import "DefineTextField.h"
#define EdgeDistance 10
//文字输入里左边的距离
@implementation DefineTextField

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self awakeFromNib];
    }
    return self;
}

//重写来重置编辑区域
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, EdgeDistance, 0);
}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds, EdgeDistance, 0);
}

//进行设置
-(void)awakeFromNib
{


}





@end
