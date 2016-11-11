//
//  GoodsCategoryMenuView.m
//  SellerCenturySquare
//
//  Created by 王剑粟 on 15/9/28.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "GoodsCategoryMenuView.h"
#import "ACMacros.h"
#import "GoodsCategoryDTO.h"
#import "GoodsCategorySecondMenuView.h"

@implementation GoodsCategoryMenuView


- (instancetype)initWithArray:(NSMutableArray *)array withParentView:(SMSegmentView *)parentView{
    
    CGRect rect = CGRectMake(parentView.frame.origin.x, parentView.frame.origin.y + parentView.frame.size.height, Main_Screen_Width, Main_Screen_Height - parentView.frame.origin.y - parentView.frame.size.height);
    self = [super initWithFrame:rect];
    if (self) {
        
        self.hidden = YES;
        self.categroyArray = array;
        self.firstLevelBtnArray = [[NSMutableArray alloc] init];
        self.firstLevelNameArray = [self getFirstLevelArray];
        self.secondLevelNameArray = [[NSMutableArray alloc] init];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)]];
        [self drawFirstMenu];
    }
    
    return self;
}


//画第一层菜单
- (void)drawFirstMenu {
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 75.0f)];
    [scrollView setBackgroundColor:[UIColor colorWithRed:0.27 green:0.27 blue:0.27 alpha:0.9f]];
    scrollView.showsHorizontalScrollIndicator = NO;
    [scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]init]];
    
    if (self.firstLevelNameArray != nil && self.firstLevelNameArray.count > 0) {
        
        for (int i = 0; i <= self.firstLevelNameArray.count; i++) {
            
            if (i == 0) {
                [scrollView addSubview:[self drawCircleButton:@"全部" withIndex:i]];
                [scrollView addSubview:[self drawEllipsis:i + 1]];
            }else {
                GoodsCategoryDTO * dto = (GoodsCategoryDTO *)[self.firstLevelNameArray objectAtIndex:i - 1];
                [scrollView addSubview:[self drawCircleButton:dto.categoryName withIndex:i]];
                if (i != self.firstLevelNameArray.count) {
                    [scrollView addSubview:[self drawEllipsis:i + 1]];
                }
            }
        }
    }
    scrolViewContentWidth = 29 * 2 + 49 * (self.firstLevelNameArray.count + 1) + 50 * self.firstLevelNameArray.count;
    
    [scrollView setContentSize:CGSizeMake(scrolViewContentWidth, 75.0f)];
    
    [self addSubview:scrollView];
    
}

//画圆形的button
- (UIButton *)drawCircleButton:(NSString *)title withIndex:(NSInteger)index {
    
    UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(29 + 49 * index + 50 * index, 13, 49, 49)];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize: 12.0];
    
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor;
    
    btn.layer.cornerRadius = btn.frame.size.height / 2;
    btn.tag = 100 + index;
    [btn addTarget:self action:@selector(firstLevelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstLevelBtnArray addObject:btn];
    
    return btn;
}

//画省略号
- (UILabel *)drawEllipsis:(int)index {
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(29 + 49 * index + 10 + 50 * (index - 1), 30, 30, 10)];
    label.text = @"...........";
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont systemFontOfSize:10.0f]];
    [label setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    return label;
}

//用于解析第一层菜单数据
- (NSMutableArray *)getFirstLevelArray {
    
    NSMutableArray * firstLevel = [[NSMutableArray alloc] init];
    for (GoodsCategoryDTO * dto in self.categroyArray) {
        if([dto.parentId integerValue] == 0){
            if ([firstLevel indexOfObject:dto.categoryName] == NSNotFound) {
                [firstLevel addObject:dto];
            }
        }
    }
    
    return firstLevel;
}

//用于解析第二次菜单的数据
- (NSMutableArray *)getSencondLevelArray:(NSInteger)parentID{
    
    NSMutableArray * secondLevel = [[NSMutableArray alloc] init];
    
    for (GoodsCategoryDTO * dto in self.categroyArray) {
        if([dto.parentId integerValue] == parentID) {
            [secondLevel addObject:dto];
        }
    }
    
    return secondLevel;
}

//用于获取parentCategoryNo
- (NSString *)getParentCategoryNo:(NSInteger)parentID{
    
    for (GoodsCategoryDTO * dto in self.categroyArray) {
        if([dto.Id integerValue] == parentID) {
            return dto.categoryNo;
        }
    }
    
    return nil;
}

- (NSString *)getParentStructureNo:(NSInteger)parentID{

    for (GoodsCategoryDTO * dto in self.categroyArray) {
        if([dto.Id integerValue] == parentID) {
            return dto.structureNo;
        }
    }

    return nil;
}

//第一层菜单按钮点击事件
- (void)firstLevelBtnClick:(UIButton *)sender {
    
    NSInteger btnTag = sender.tag;
    
    if (sender.state != UIControlStateSelected) {
        
        for (UIButton * btn in self.firstLevelBtnArray) {
            [btn.layer setBackgroundColor:[UIColor clearColor].CGColor];
            [btn setSelected:NO];
        }
        
        [sender.layer setBackgroundColor:[UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1].CGColor];
        [sender setSelected:YES];
        
        if(btnTag - 100 == 0){
            
            //点击
            [self showOrHidden];
            
            [categorySencondMenuView setHidden:YES];
            categorySencondMenuView.selectStructureNo = nil;

            
            if (self.delegate) {
                [self.delegate menuClick:nil];
            }
            
        }else {
            
            self.secondLevelNameArray = [self getSencondLevelArray:btnTag - 100];
            
            if (categorySencondMenuView == nil) {
                categorySencondMenuView = [[GoodsCategorySecondMenuView alloc] initWithArray:self.secondLevelNameArray withParentView:scrollView withBlock:^(NSString *searchId) {
                    
                    //点击
                    [self showOrHidden];
                    if (self.delegate) {
                        [self.delegate menuClick:searchId];
                    }
                    
                }];
                categorySencondMenuView.parentStructureNo = [self getParentStructureNo:btnTag - 100];
                [self addSubview:categorySencondMenuView];
            }else {
                categorySencondMenuView.parentStructureNo = [self getParentStructureNo:btnTag - 100];
                categorySencondMenuView.nameArray = self.secondLevelNameArray;
                [categorySencondMenuView setHidden:NO];
            }
        }
    }
}

- (void)showOrHidden {
    
    if ([self isHidden]) {
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:5];
        
        self.hidden = NO;
        
        //动画结束
        [UIView commitAnimations];
    }else {
        
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:5];
        
        self.hidden = YES;
        
        //动画结束
        [UIView commitAnimations];
    }
}

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)sender {
    
    [self showOrHidden];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
