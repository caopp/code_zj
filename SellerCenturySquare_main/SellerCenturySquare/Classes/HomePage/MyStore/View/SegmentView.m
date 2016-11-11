//
//  SegmentView.m
//  BuyerCenturySquare
//
//  Created by zuojianshijue on 16/1/7.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SegmentView.h"
#import "ACMacros.h"
#import "UIColor+UIColor.h"
@implementation SegmentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _objectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width/3-1, 30)];
        [self addSubview:_objectBtn];
        [_objectBtn setTitle:@"客观图" forState:UIControlStateNormal];
        [_objectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _objectBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _objectBtn.backgroundColor = [UIColor whiteColor];
        [_objectBtn addTarget:_delegate action:@selector(objectiveImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _reftBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width/3, 0, Main_Screen_Width/3, 30)];
        [self addSubview:_reftBtn];
        [_reftBtn setTitle:@"参考图(0)" forState:UIControlStateNormal];
        [_reftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _reftBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _reftBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        [_reftBtn addTarget:_delegate action:@selector(referenceImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _attrBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width*2/3+1, 0, Main_Screen_Width/3, 30)];
        [self addSubview:_attrBtn];
        [_attrBtn setTitle:@"规格参数" forState:UIControlStateNormal];
        [_attrBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _attrBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        _attrBtn.backgroundColor = [UIColor colorWithHexValue:0x333333 alpha:1];
        [_attrBtn addTarget:_delegate action:@selector(attrBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
  
    return self;
}
@end
