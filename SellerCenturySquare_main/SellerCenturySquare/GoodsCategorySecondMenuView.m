//
//  GoodsCategorySecondMenuView.m
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "GoodsCategorySecondMenuView.h"
#import "ACMacros.h"
#import "GoodsCategoryDTO.h"

@implementation GoodsCategorySecondMenuView

- (instancetype)initWithArray:(NSMutableArray *)array withParentView:(UIScrollView *)parentView withBlock:(menuClick)block {
    
    //计算高度
    self = [super initWithFrame:CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y + parentView.frame.size.height, 0, 0)];
    if (self) {
        
        [self setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.95]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] init]];
        self.menuclick = block;
        btnWidth = (Main_Screen_Width - 15) / 5;
        btnHeight = btnWidth * 130 / 142;
        self.btnArray = [[NSMutableArray alloc] init];
        self.nameArray = array;
    }
    
    return self;
}

- (void)setNameArray:(NSMutableArray *)nameArray {
    
    _nameArray = nameArray;
    [self calculateRect];
    [self drawButton];
}

//根据数组数量计算CGRect
- (void)calculateRect {
    
    NSInteger total = self.nameArray.count + 1;
    NSInteger line = total / 5;
    if (total % 5 > 0) {
        line ++;
    }
    
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, Main_Screen_Width, line * btnHeight)];
}

//画按钮
- (void)drawButton {
    
    for (UIButton * btn in self.subviews) {
        [btn removeFromSuperview];
    }
    
    [self.btnArray removeAllObjects];
    
    for (int i = 0; i <= self.nameArray.count; i++) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(7.5 + btnWidth * (i % 5), btnHeight * (i / 5), btnWidth, btnHeight)];
        if (i == 0) {
            [btn setTitle:@"全部" forState:UIControlStateNormal];
            if ([self.selectStructureNo isEqualToString:self.parentStructureNo]) {
                
                [btn.layer setBackgroundColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1].CGColor];
                
            }
        }else {
            
            GoodsCategoryDTO * dto = [self.nameArray objectAtIndex:i - 1];
            [btn setTitle:dto.categoryName forState:UIControlStateNormal];
            if ([self.selectStructureNo isEqualToString:dto.structureNo]) {
                
                [btn.layer setBackgroundColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1].CGColor];
            }
        }
        
        [btn setTitleColor:[UIColor colorWithRed:0.73 green:0.73 blue:0.73 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        
        btn.layer.borderWidth = 0.5f;
        btn.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor;
        btn.tag = 200 + i;
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
}

//按钮点击事件
- (void)btnClick:(UIButton *)sender {
    
    NSInteger index = sender.tag - 200;
    
    if (sender.state != UIControlStateSelected) {
        
        for (UIButton * btn in self.btnArray) {
            [btn.layer setBackgroundColor:[UIColor clearColor].CGColor];
            [btn setSelected:NO];
        }
        
        [sender.layer setBackgroundColor:[UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:1].CGColor];
        [sender setSelected:YES];
        
    }
    
    if (index == 0) {
        self.selectStructureNo = self.parentStructureNo;
    }else {
        GoodsCategoryDTO * dto = (GoodsCategoryDTO *)[self.nameArray objectAtIndex:index - 1];
        self.selectStructureNo = dto.structureNo;
    }
    
    if (self.menuclick) {
        self.menuclick(self.selectStructureNo);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
