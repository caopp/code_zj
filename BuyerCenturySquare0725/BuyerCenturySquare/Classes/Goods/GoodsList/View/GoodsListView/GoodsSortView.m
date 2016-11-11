//
//  GoodsSortView.m
//  BuyerCenturySquare
//
//  Created by 左键视觉 on 16/9/12.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "GoodsSortView.h"

@implementation GoodsSortView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code

    //!文字颜色
    [self.recommendBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
    [self.recommendBtn setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:UIControlStateSelected];
    
    [self.byTimeBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
    [self.byTimeBtn setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:UIControlStateSelected];
    
    [self.bySalesBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
    [self.bySalesBtn setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:UIControlStateSelected];
    
    
    [self.byPriceBtn setTitleColor:[UIColor colorWithHexValue:0xffffff alpha:1] forState:UIControlStateNormal];
    [self.byPriceBtn setTitleColor:[UIColor colorWithHexValue:0x000000 alpha:1] forState:UIControlStateSelected];
    
}

-(void)selectedRecommend:(BOOL)isRecommend isSelectedByTime:(BOOL)isByTime isSelectedBySales:(BOOL)isBySales isSelectedByPrice:(BOOL)isByPrice{
    
    self.recommendBtn.selected = isRecommend;
    
    self.byTimeBtn.selected = isByTime;
    self.bySalesBtn.selected = isBySales;
    self.byPriceBtn.selected = isByPrice;
    
    [self setBtnColorAndSortImageView];
    
}
-(void)setBtnColorAndSortImageView{

    //!未选中时的背景颜色
    self.recommendBtn.backgroundColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1];
    
    self.byTimeBtn.backgroundColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1];
    
    self.bySalesBtn.backgroundColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1];
    self.byPriceBtn.backgroundColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1];

    self.filterBtn.backgroundColor = [UIColor colorWithHexValue:0xd9d9d9 alpha:1];
    
    //!选中时的背景颜色
    if (self.recommendBtn.selected) {
        
        [self.recommendBtn setBackgroundColor:[UIColor whiteColor]];
        
        
    }
    if (self.byTimeBtn.selected) {
        
        [self.byTimeBtn setBackgroundColor:[UIColor whiteColor]];
        
    }
    if (self.bySalesBtn.selected) {
        
        [self.bySalesBtn setBackgroundColor:[UIColor whiteColor]];
        
    }
    if (self.byPriceBtn.selected) {
        
        [self.byPriceBtn setBackgroundColor:[UIColor whiteColor]];
        
    }

    //!升降序的图标都修改为未选中
    NSString * unSortImageName = @"normalSort";
    self.byTimeImgaeView.image = [UIImage imageNamed:unSortImageName];
    self.bySalesImageView.image = [UIImage imageNamed:unSortImageName];
    self.byPriceImageView.image = [UIImage imageNamed:unSortImageName];
    

}

//!修改dto的排序值
-(void)changeDtoOrderBy{
    
    if ([self.sortDTO.orderBy isEqualToString:orderBydesc]) {
        
        self.sortDTO.orderBy = orderByasc;
        
        
    }else{
        
        self.sortDTO.orderBy = orderBydesc;
        
    }
    
    
}
//!修改显示的排序图标
-(void)changeSortImageView:(UIImageView *)sortImageView{

    if ([self.sortDTO.orderBy isEqualToString:orderBydesc]) {
        
        [sortImageView setImage:[UIImage imageNamed:@"desSort"]];
        
    }else{
        
        [sortImageView setImage:[UIImage imageNamed:@"ascSort"]];
        
    }


}



//!推荐
- (IBAction)recommendBtnClick:(id)sender {

    if (!self.recommendBtn.selected) {//!原本没有选中，修改为选中、参数、返回进行数据请求
        
        [self setRecommendSelected];
        
        if (self.sortClickBlock) {
            
            self.sortClickBlock();
        }
        
    }
    
}
//!设置推荐按钮选中
-(void)setRecommendSelected{

    [self selectedRecommend:YES isSelectedByTime:NO isSelectedBySales:NO isSelectedByPrice:NO];
    self.sortDTO.orderBy = orderBydesc;//!接口要求选中“推荐”的时候这么传值
    
    self.sortDTO.orderByField = @"4";

}


//!按时间
- (IBAction)byTimeBtnClick:(id)sender {
    
    self.sortDTO.orderByField = @"1";

    if (self.byTimeBtn.selected) {//!原本就选中的状态，点击是进行排序修改
        
        [self changeDtoOrderBy];
        
    }else{
    
        //!原本没有选中，修改为选中，降序
        [self selectedRecommend:NO isSelectedByTime:YES isSelectedBySales:NO isSelectedByPrice:NO];
        
        self.sortDTO.orderBy = orderBydesc;
        
    }

    [self changeSortImageView:self.byTimeImgaeView];
    
    if (self.sortClickBlock) {
        
        self.sortClickBlock();
    }
    
    
}


//!按销量
- (IBAction)bySalesBtnClick:(id)sender {
    
    self.sortDTO.orderByField = @"2";

    if (self.bySalesBtn.selected) {
        
        [self changeDtoOrderBy];
        
    }else{
    
        [self selectedRecommend:NO isSelectedByTime:NO isSelectedBySales:YES isSelectedByPrice:NO];

        self.sortDTO.orderBy = orderBydesc;

    }
    
    [self changeSortImageView:self.bySalesImageView];

    if (self.sortClickBlock) {
        
        self.sortClickBlock();
    }
    
}
//!按价格
- (IBAction)byPriceBtnClick:(id)sender {

    self.sortDTO.orderByField = @"3";

    if (self.byPriceBtn.selected) {
        
        [self changeDtoOrderBy];
    
    }else{
    
        [self selectedRecommend:NO isSelectedByTime:NO isSelectedBySales:NO isSelectedByPrice:YES];

        self.sortDTO.orderBy = orderBydesc;

    }
    [self changeSortImageView:self.byPriceImageView];

    if (self.sortClickBlock) {
        
        self.sortClickBlock();
        
    }

}

//!初始化
-(void)setGoodsSortDTO:(GoodsSortDTO *)sortDTO{

    self.sortDTO = sortDTO;
    
    //!设置推荐按钮选中
    [self setRecommendSelected];

}


//!筛选
- (IBAction)filterBtnClick:(id)sender {
    
   //!显示筛选界面的通知
    NSMutableDictionary * sortDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    if (self.sortDTO.upDayNum) {
        
        [sortDic setObject:self.sortDTO.upDayNum forKey:@"upDayNum"];
    }
    
    if (self.sortDTO.minPrice) {
        
        [sortDic setObject:self.sortDTO.minPrice forKey:@"minPrice"];
        
    }
    
    if (self.sortDTO.maxPrice) {
        
        [sortDic setObject:self.sortDTO.maxPrice forKey:@"maxPrice"];
        
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ShowFilterViewNoti" object:nil userInfo:sortDic];
    
    
}

@end
