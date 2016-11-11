//
//  CourierTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/26.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "CourierTableViewCell.h"
#import "CourierModel.h"
#import "UIColor+UIColor.h"

@implementation CourierTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        //采购单地址
        self.courierAddressLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.courierAddressLabel];
        
        //采购单时间
        self.courierTimeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.courierTimeLabel];
        
        //线体
        self.lineLabel = [[UILabel alloc]init];
        self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        [self.contentView addSubview:self.lineLabel];
        //按钮
        self.selectedButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.contentView addSubview:self.selectedButton];
        
        //竖线
        self.verticalLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.verticalLabel];
        
        //下线
        self.underLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.underLabel];
        
    }
    return self;
}

//获取数据
-(void)getLookFreightTemplateCellData:(CourierModel *)data
{
    
    NSLog(@"data.acceptTime ==== %@",data.acceptTime);
    
    
    //按钮
    self.selectedButton.frame  =CGRectMake(15, 19, 7, 7);
    self.selectedButton.layer.cornerRadius = 3.5;
    self.selectedButton.layer.masksToBounds = YES;
    
   
    //采购单
    CGSize courierSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.acceptStation] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH - 37 - 15, MAXFLOAT)];
    
    self.courierAddressLabel.frame = CGRectMake(37, 15,courierSize.width, courierSize.height);
    self.courierAddressLabel.numberOfLines = 0;
    self.courierAddressLabel.font = [UIFont systemFontOfSize:14];
    [self.courierAddressLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    self.courierAddressLabel.text = data.acceptStation;
    
    
    //时间
    self.courierTimeLabel.frame = CGRectMake(self.courierAddressLabel.frame.origin.x+8, self.courierAddressLabel.frame.origin.y + self.courierAddressLabel.frame.size.height + 15, self.frame.size.width, 12);
    
    self.courierTimeLabel.text  = data.acceptTime;
    self.courierTimeLabel.font = [UIFont systemFontOfSize:14];
    [self.courierTimeLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    
    //线体
    self.lineLabel.frame = CGRectMake(self.courierTimeLabel.frame.origin.x, self.courierTimeLabel.frame.size.height + self.courierTimeLabel.frame.origin.y + 15, 500, 1);
    
    //上线
    self.verticalLabel.frame = CGRectMake(18, 0, 1, self.selectedButton.frame.origin.y);
    
    self.verticalLabel.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    //下线
    self.underLabel.frame = CGRectMake(18, self.verticalLabel.frame.size.height + 7, 1, self.lineLabel.frame.origin.y - self.verticalLabel.frame.size.height - 6);
    
    self.underLabel.backgroundColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    //    self.underLabel.backgroundColor = [UIColor redColor];
    self.heightCell = self.lineLabel.frame.origin.y + self.lineLabel.frame.size.height;
}

/**
 *  计算文字尺寸
 *
 *  @param text    需要计算尺寸的文字
 *  @param font    文字的字体
 *  @param maxSize 文字的最大尺寸
 */
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


-(NSString *)dateStr:(NSString *)dateStr
{
    
    //创建
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    //设置格式
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //进行转化
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:dateStr.doubleValue];
    //转化成字符串
    NSString* dateString = [formatter stringFromDate:date];
    
    return dateString;
}









- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
