//
//  RecommendCollectionViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/16.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell

- (void)setShopGoodsDTO:(ShopGoodsDTO *)shopGoodsDTO{
    
    _shopGoodsDTO = shopGoodsDTO;
    
    NSString *urlStr = shopGoodsDTO.imgUrl;
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    [_imageView sd_setImageWithURL:url];
    
   
    _levelL.text = [NSString stringWithFormat:@"V%@",shopGoodsDTO.readLevel];
    
    _priceL.text = [NSString stringWithFormat:@"¥%0.2f",[shopGoodsDTO.price floatValue]];
    
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *newDateformatter = [[NSDateFormatter alloc]init];
    
    [newDateformatter setDateFormat:@"MM-dd"];
    
    NSDate *now = [NSDate date];
    
    NSDate *getTime = [dateformatter dateFromString:_shopGoodsDTO.firstOnsaleTime];
    
    NSString *getTimeStr = [newDateformatter stringFromDate:getTime];
    
    NSTimeInterval interval = [now timeIntervalSinceDate:getTime];
    
    int hour = (int)(interval/3600);
    
    if (hour<=24) {
        
        _tipsL.text = [NSString stringWithFormat:@"今日上架"];
    }else if(hour<=24*2){
        
        _tipsL.text = [NSString stringWithFormat:@"昨天上架"];
    }else if(hour<=24*3){
        
        _tipsL.text = [NSString stringWithFormat:@"前天上架"];
    }else if(hour<=24*5){
        
        _tipsL.text = [NSString stringWithFormat:@"3天前上新"];
    }else if(hour<=24*7){
        
        _tipsL.text = [NSString stringWithFormat:@"5天前上新"];
    }else if(hour<=10){
        
        _tipsL.text = [NSString stringWithFormat:@"7天前上新"];
    }else{
        
        _tipsL.text = [NSString stringWithFormat:@"%@",getTimeStr];
    }
}

- (void)setSelectedGoodsDic:(NSMutableDictionary *)selectedGoodsDic{
    
    _selectedGoodsDic = selectedGoodsDic;
    
    NSString *goodsNo = _shopGoodsDTO.goodsNo;
    
    if (selectedGoodsDic[goodsNo]) {
        
        _selectedStateView.hidden = NO;
    }else{
        
        _selectedStateView.hidden = YES;
    }
}

- (IBAction)touchButtonClicked:(id)sender {
    
    _selectedStateView.hidden = !_selectedStateView.hidden;
    
    if (!_selectedStateView.hidden) {
        
        [_selectedGoodsDic setObject:_shopGoodsDTO forKey:_shopGoodsDTO.goodsNo];
        
    }else{
        
        [_selectedGoodsDic removeObjectForKey:_shopGoodsDTO.goodsNo];
    }
    
}



@end
