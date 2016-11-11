//
//  CSPSellerTableViewCell.m
//  BuyerCenturySquare
//
//  Created by skyxfire on 7/6/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMerchantTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CSPMerchantTableViewCell ()

@property (nonatomic, strong)UIVisualEffectView *effectview;

@end

@implementation CSPMerchantTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.categoryNameLabel.layer.cornerRadius = 3.0f;
    self.categoryNameLabel.layer.masksToBounds = YES;

    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
    self.outBussinessLabel.text = NSLocalizedString(@"outBussiness", @"歇业中");
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setupWithDictionary:(NSDictionary*)dictionary {
    MerchantListDetailsDTO* merchantDetailsDTO = [[MerchantListDetailsDTO alloc]initWithDictionary:dictionary];
    [self setupWithMerchantDetailsDTO:merchantDetailsDTO];
}
// !给cell数据

- (void)setupWithMerchantDetailsDTO:(MerchantListDetailsDTO *)merchantDetailsDTO {
    
    // !商家名称
    self.merchantNameLabel.text = merchantDetailsDTO.merchantName;
    // !商家编码
    self.merchantNoLabel.text = merchantDetailsDTO.stallNo;
    // !商品数量,类型为int
    self.goodsNumLabel.text = [NSString stringWithFormat:@"%d", merchantDetailsDTO.goodsNum.intValue];
    //!商家类别名称
    self.categoryNameLabel.text = merchantDetailsDTO.categoryName;

    
    // !将歇业提示这一层移到后面
    [self.contentView sendSubviewToBack:self.blackAlphaView];
    
    // !营业状态(0:营业 1:歇业)
    if (merchantDetailsDTO.operateStatus.integerValue == 1) {
        
        [self.contentView bringSubviewToFront:self.blackAlphaView];

        NSDateFormatter* inputDateFormatter = [[NSDateFormatter alloc]init];
        inputDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate* startDate = [inputDateFormatter dateFromString:merchantDetailsDTO.closeStartTime];
        NSDate* endDate = [inputDateFormatter dateFromString:merchantDetailsDTO.closeEndTime];

        NSDateFormatter* outputDateFormatter = [[NSDateFormatter alloc]init];
        outputDateFormatter.dateFormat = @"yyyy/MM/dd";
        // !歇业时间段
        self.closingTimeLabel.text = [NSString stringWithFormat:@"%@ ~ %@", [outputDateFormatter stringFromDate:startDate], [outputDateFormatter stringFromDate:endDate]];
        
    } else {
        // !将歇业提示这一层移到后面
        [self.contentView sendSubviewToBack:self.blackAlphaView];
    }

    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:merchantDetailsDTO.pictureUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];

    if ([merchantDetailsDTO.flag isEqualToString:@"1"]) {
        self.cornerLabel.text = NSLocalizedString(@"recommend", @"推荐");
        [self.cornerView setHidden:NO];
        
    } else if ([merchantDetailsDTO.flag isEqualToString:@"2"]) {
        self.cornerLabel.text = NSLocalizedString(@"new", @"上新");
        [self.cornerView setHidden:NO];
        
    } else {
        self.cornerLabel.text = @"";
        [self.cornerView setHidden:YES];
    }
}

@end
