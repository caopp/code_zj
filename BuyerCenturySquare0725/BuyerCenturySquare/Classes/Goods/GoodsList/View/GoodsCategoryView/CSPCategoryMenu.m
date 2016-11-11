//
//  CSPCategoryListView.m
//  DOPNavbarMenuDemo
//
//  Created by skyxfire on 8/5/15.
//  Copyright (c) 2015 weizhou. All rights reserved.
//

#import "CSPCategoryMenu.h"


@interface CSPCategoryMenu () <CSPMajorMenuDelegate, MinorMenuClickDelegate> {

    //选中的二级分类
    CommodityClassificationDTO* selectedSecondaryCategory;

}


@property (assign, nonatomic) CGFloat segmentHeight;
@property (assign, nonatomic) CGFloat leftMargin;

@property (assign, nonatomic) CGFloat beforeAnimationOriginY;
@property (assign, nonatomic) CGFloat afterAnimationOriginY;

@property (nonatomic, strong) CSPMajorMenu* majorMenu;
@property (nonatomic, strong) CSPMinorMenu* minorMenu;

@property (nonatomic, strong) NSNumber* majorCategoryId;
@property (nonatomic, strong) CommodityClassification * goodClassification;

@end

@implementation CSPCategoryMenu


- (id)initWithCommodityClassification:(CommodityClassification *)goodClassification parentId:(NSNumber *)parentId{
    
    
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    if (self) {
        
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)]];
        
        _beforeAnimationOriginY = -320.f;

        UIView* headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0.0, SCREEN_WIDTH, 64.0)];
        headerView.backgroundColor = [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1];

        [self addSubview:headerView];

        self.goodClassification = goodClassification;
        self.majorCategoryId = parentId;// !选中的父类id
        
        NSArray* secondaryCategory = [goodClassification getSecondaryCategoryWithParentId:parentId];

        _majorMenu = [[CSPMajorMenu alloc]init];
        // !创建二级分类
        for (int i = 0; i < secondaryCategory.count; i++) {
            
            CommodityClassificationDTO * model = (CommodityClassificationDTO *)[secondaryCategory objectAtIndex:i];
            
            if (i == secondaryCategory.count - 1) {
                
                [_majorMenu addSegmentWithTitle:model.categoryName isLastOne:YES];
                
            }else {
                
                [_majorMenu addSegmentWithTitle:model.categoryName isLastOne:NO];
            
            }
            
        }

        _majorMenu.delegate = self;
        [self addSubview:_majorMenu];

        // !第三级分类
        CommodityClassificationDTO * firstSecondaryCategory = [secondaryCategory firstObject];
        NSArray* thirdlyCategory = [goodClassification getThirdlyCategoryWithParentId:firstSecondaryCategory.id];

        
        _minorMenu = [[CSPMinorMenu alloc]initWithMinorItems:thirdlyCategory];
        _minorMenu.delegate = self;

        CGRect viewFrame = _minorMenu.frame;

        viewFrame.origin.y = CGRectGetMaxY(_majorMenu.frame);
        _minorMenu.frame = viewFrame;
       
        // !创建第三级分类、dissmiss分类的时候  隐藏第三级分类;点击对应的二级分类的时候再展开（因为需求是点击对应的二级分类再展开）
        _minorMenu.hidden = YES;
        
        [self addSubview:_minorMenu];

        self.afterAnimationOriginY = CGRectGetMinY(self.frame);

    }

    return self;
}

- (void)showInView:(UIView *)view belowSubview:(UIView*)subview {
   

    
    [view insertSubview:self belowSubview:subview];

    
    CGRect viewFrame = CGRectMake(0, self.beforeAnimationOriginY, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    self.frame = viewFrame;

    [UIView animateWithDuration:0.2
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CGRect viewFrame = self.frame;
                         viewFrame.origin.y = self.afterAnimationOriginY;
                         self.frame = viewFrame;
                     } completion:^(BOOL finished) {
                         
                         if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didShowCategoryMenu:)]) {
        
                             
                             [self.delegate didShowCategoryMenu:self];
                         
                         }
                         self.open = YES;
                         
                     }];
}

- (void)dismissWithAnimation:(BOOL)animation {
    void (^completion)(void) = ^void(void) {
        
        
        
        [self removeFromSuperview];

        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didDismissCategoryMenu:)]) {
            
            [self.delegate didDismissCategoryMenu:self];
            
        }
        self.open = NO;
    };
    if (animation) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect viewFrame = self.frame;
            viewFrame.origin.y += 20;
            self.frame = viewFrame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                CGRect viewFrame = self.frame;
                viewFrame.origin.y = self.beforeAnimationOriginY;
                self.frame = viewFrame;
            } completion:^(BOOL finished) {
                completion();
            }];
        }];
    } else {
        
        CGRect viewFrame = self.frame;
        viewFrame.origin.y = self.beforeAnimationOriginY;
        self.frame = viewFrame;
        completion();
    }
}
// !选中第二级分类的时候
- (void)segmentView:(CSPMajorMenu*)segmentView didSelectSegmentAtIndex:(NSInteger)index {

    // !创建第三级分类、dissmiss分类的时候  隐藏第三级分类，点击对应的二级分类的时候再展开（因为需求是点击对应的二级分类再展开）
    _minorMenu.hidden = NO;

    NSArray* secondaryCategory = [self.goodClassification getSecondaryCategoryWithParentId:self.majorCategoryId];
    
    selectedSecondaryCategory = secondaryCategory[index];
    
    NSArray* thirdlyCategory = [self.goodClassification getThirdlyCategoryWithParentId:selectedSecondaryCategory.id];

    [self.minorMenu setMinorItems:thirdlyCategory];
    self.minorMenu.parentStructureNo = selectedSecondaryCategory.structureNo;
    [self.minorMenu setNeedsLayout];

    CGRect viewFrame = _minorMenu.frame;

    viewFrame.origin.y = CGRectGetMaxY(_majorMenu.frame);
    _minorMenu.frame = viewFrame;


}
// !选中第三极分类
- (void)MinorMenuClick:(NSInteger)index withCSPMinorMenu:(CSPMinorMenu *)view{
    
    [self dismissWithAnimation:YES];
    
    // !创建第三级分类、dissmiss分类的时候  隐藏第三级分类，点击对应的二级分类的时候再展开（因为需求是点击对应的二级分类再展开）
    _minorMenu.hidden = YES;
    
    
    
    if (index == 1000) {
        
        if (self.delegate) {
            [self.delegate didSelectedCategoryMenu:self withStructureNo:selectedSecondaryCategory.structureNo];
        }
        view.selectStructureNo = selectedSecondaryCategory.structureNo;
    }else {
        
        NSArray* thirdlyCategory = [self.goodClassification getThirdlyCategoryWithParentId:selectedSecondaryCategory.id];
        
        CommodityClassificationDTO * model = [thirdlyCategory objectAtIndex:index - 1];
        
        if (self.delegate) {
            
            [self.delegate didSelectedCategoryMenu:self withStructureNo:model.structureNo];
            
        }
        view.selectStructureNo = model.structureNo;
        
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)tap {
    
    [self dismissWithAnimation:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
