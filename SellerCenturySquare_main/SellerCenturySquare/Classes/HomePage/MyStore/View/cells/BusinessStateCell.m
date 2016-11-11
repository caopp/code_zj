//
//  BusinessStateCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 15/11/20.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "BusinessStateCell.h"
#import "UIColor+HexColor.h"
#import "MyShopStateDTO.h"
#import "GetMerchantInfoDTO.h"
#import "UIColor+UIColor.h"


@implementation BusinessStateCell
{

    MyShopStateDTO *myShopStateDTO;
    GetMerchantInfoDTO *getMerchantInfoDTO;


}
- (void)awakeFromNib {
   
    myShopStateDTO = [MyShopStateDTO sharedInstance];
    
    getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    
    
    //    [self updateBusinessState:getMerchantInfoDTO.operateStatus];
    
    self.lineLabel.backgroundColor = [UIColor clearColor];
//    self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xe2e2e2 alpha:1];
    
    //!给等级图片添加点击事件
    UITapGestureRecognizer *levelImageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(levelClick)];
    self.levelImageView.userInteractionEnabled = YES;
    [self.levelImageView addGestureRecognizer:levelImageTap];

}
// !等级点击事件
- (void)levelClick{
    
    
    if (self.levelBlock) {
        
        self.levelBlock();
        
    }
    
    
}
- (void)setLevelString:(NSString*)level{
    
    NSString *lev = [NSString stringWithFormat:@"V%zi",[level integerValue]];
    [self.levelBadgeLabel changeViewToBadgeWithString:lev withScale:0.6];
    
    // 04_商家中心_我的店_%@级会员  等级图片
    NSString * levelName = [NSString stringWithFormat:@"04_商家中心_我的店_%d级会员",[level intValue]];
    
    [self.levelImageView setImage:[UIImage imageNamed:levelName]];
    
//    [self.levelImageView setImage:[UIImage imageNamed:@"04_商家中心_我的店_1级会员"]];

    
}

- (void)updateBusinessState:(BOOL)stateOn{
    
    
    if (stateOn){
        
        _businessStateL.text = @"状态：营业中";
        _businessStateL.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
        self.accessoryType = UITableViewCellAccessoryNone;
    }else{
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *start;
        NSDate *end;
        if (getMerchantInfoDTO.closeEndTime!=nil) {
            
            start = [dateFormatter dateFromString:getMerchantInfoDTO.closeStartTime];
            end = [dateFormatter dateFromString:getMerchantInfoDTO.closeEndTime];
        }
        
        NSDateFormatter *newFormatter = [[NSDateFormatter alloc]init];
        [newFormatter setDateFormat:@"yyyy/MM/dd HH时"];
        
        NSString *newStart = [newFormatter stringFromDate:start];
        NSString *newEnd = [newFormatter stringFromDate:end];
        
        if (newEnd==nil||newStart==nil) {
            
            newStart = @"";
            newEnd = @"";
        }
        
        _businessStateL.text = [NSString stringWithFormat:@"状态：歇业  %@ 至 %@",newStart,newEnd];
        _businessStateL.textColor = [UIColor whiteColor];
        _businessStateL.adjustsFontSizeToFitWidth = YES;
        self.backgroundColor = [UIColor colorWithHex:0x999999];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
