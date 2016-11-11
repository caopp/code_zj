//
//  CSPPersonCenterShopTableViewCell.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/10/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPPersonCenterShopTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Utils.h"
#import "CSPUtils.h"
#import "HttpManager.h"
@implementation CSPPersonCenterShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setEcSession:(ECSession *)ecSession{
    
    _ecSession = ecSession;
     _contentLabel.text =_ecSession.text;
    _nameL.text = [NSString stringWithFormat:@"%@",_ecSession.merchantName];
    
    
     _titleLabel.hidden = YES;
    if (_ecSession.type == 2) {
        NSString *goodsWillNo =[[_ecSession.goodsWillNo componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodsColor =[[_ecSession.goodColor componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodPrice =[[_ecSession.goodPrice componentsSeparatedByString:@";"] objectAtIndex:0];

        _contentLabel.text =  [NSString stringWithFormat:@"[商品]货号:%@ %@ ¥ %@",goodsWillNo,goodsColor,goodPrice];//_ecSession.goodsWillNo;
       
        
 
    }else if (_ecSession.type == 4){
        NSString *goodsWillNo =[[_ecSession.goodsWillNo componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodsColor =[[_ecSession.goodColor componentsSeparatedByString:@";"] objectAtIndex:0];
        NSString *goodPrice =[[_ecSession.goodPrice componentsSeparatedByString:@";"] objectAtIndex:0];
        
        _contentLabel.text =  [NSString stringWithFormat:@"[商品推荐]货号:%@ %@ ¥ %@",goodsWillNo,goodsColor,goodPrice];//_ecSession.goodsWillNo;
    }
   
        
    
        
    if(_ecSession.iconUrl == nil || [_ecSession.iconUrl isEqualToString:@""] || _ecSession.iconUrl.length == 0) {
        
        [_badgeimageView setImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    }else {
        NSLog(@"iconUrl-==%@",_ecSession.iconUrl);
        [_badgeimageView sd_setImageWithURL:[NSURL URLWithString:_ecSession.iconUrl] placeholderImage:[UIImage imageNamed:@"10_商品询单对话_个人"]];
    }
    _badgeimageView.layer.cornerRadius = 24.5f;
  
    NSLog(@"_ecSession.merchantName===%@",_ecSession.merchantName);
    if (_ecSession.dateTime == 0) {
        _timeLabel.text =  @"";
    }else
        _timeLabel.text = [self changeTheDateString:[CSPUtils getTime:_ecSession.dateTime]];
   // _badgeimageView.badgeNumber = [NSString stringWithFormat:@"%zi",ecSession.unreadCount];
    //self.badge = [CustomBadge customBadgeWithString:badgeNumber];
    //self.custombadge.frame = CGRectMake(22, -3, 15, 15);
    if (_ecSession.unreadCount >99) {
        self.badgeHeight.constant = 12;
        self.badgeWidth.constant = 12;
        [self.custombadge  changeViewToBadgeWithString:@" "];
    }
    else if (_ecSession.unreadCount <100&&_ecSession.unreadCount>9) {
        self.badgeHeight.constant = 18;

        self.badgeWidth.constant = 23;
        [self.custombadge  changeViewToBadgeWithString:[NSString stringWithFormat:@"%zi",ecSession.unreadCount] withScale:0.8];

    }else{
        self.badgeHeight.constant = 18;

        self.badgeWidth.constant = 18;
        [self.custombadge  changeViewToBadgeWithString:[NSString stringWithFormat:@"%zi",ecSession.unreadCount] withScale:0.8];

    }
    //self.custombadge.badgeStyle.badgeInsetColor = [UIColor colorWithHexValue:0xcf3125 alpha:1];;
    
    self.custombadge.hidden = !ecSession.unreadCount;
    
}
- (NSString *)changeTheDateString:(NSString *)Str
{
    NSString *subString = [Str substringWithRange:NSMakeRange(0, 19)];
    NSDate *lastDate = [NSDate dateFromString:subString withFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 1) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else if(days >1&&days<=5){
            dateStr = [lastDate weekday];
        }else{
            dateStr =[lastDate stringMonthDayH];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
//    if ([lastDate hour]>=5 && [lastDate hour]<12) {
//        period = @"上午";
//        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
//    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
//        period = @"下午";
//        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
//    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
//        period = @"晚上";
//        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
//    }else{
//        period = @"凌晨";
//        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
//    }
    // return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
    if ([dateStr length]) {
        return [NSString stringWithFormat:@"%@",dateStr];

    }else {
        return [NSString stringWithFormat:@"%@ %02d:%02d",dateStr,(int)[lastDate hour],(int)[lastDate minute]];

    }
}

@end
