//
//  AddAndmodificationTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "AddAndmodificationTemplateCell.h"
#import "UIColor+UIColor.h"
#import "SelectedAreaModel.h"

@implementation AddAndmodificationTemplateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
       
        
        self.backgroundColor = [UIColor redColor];
        
        
    }
    
    return  self;

        
        /*
        // 背景视图
//        self.backgroundColor = [UIColor yellowColor];

//        self.getAeaButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
//        self.getAeaButton.frame = CGRectMake(100, 0, 50, 30);
//        self.getAeaButton.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:self.getAeaButton];
//        [self.getAeaButton addTarget:self action:@selector(didClickJoinDetailAreaPage) forControlEvents:(UIControlEventTouchUpInside)];
       
        //运送到
        self.shippedLabel =[[UILabel alloc]init];
        self.shippedLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.shippedLabel];
        self.shippedLabel.frame = CGRectMake(15, 10, 50, 14);
        self.shippedLabel.text = @"运动到";
        self.shippedLabel.font = [UIFont systemFontOfSize:14];
        [self.shippedLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        
        
        //城市区域
        self.cityLabel = [[UILabel alloc]init];
        self.cityLabel.frame = CGRectMake(self.shippedLabel.frame.size.width + self.shippedLabel.frame.origin.x, self.shippedLabel.frame.origin.y, self.frame.size.width - self.shippedLabel.frame.size.width + self.shippedLabel.frame.origin.x - 30, 14);
        self.cityLabel.backgroundColor = [UIColor purpleColor];
        self.cityLabel.numberOfLines = 0;
        self.cityLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.cityLabel];
        
        //分割线
        self.dividerLabel = [[UILabel alloc]init];
        self.dividerLabel.frame = CGRectMake(self.shippedLabel.frame.origin.x, self.cityLabel.frame.origin.y + 10 + self.cityLabel.frame.size.height, 500, 1);
        self.dividerLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.dividerLabel];
        
        //首
        self.firstThingLabel = [[UILabel alloc]init];
        self.firstThingLabel.backgroundColor = [UIColor redColor];
        self.firstThingLabel.frame = CGRectMake(self.dividerLabel.frame.origin.x, self.dividerLabel.frame.origin.y + 18, 42, 14);
        self.firstThingLabel.text = @"首件:";
        self.firstThingLabel.font = [UIFont systemFontOfSize:14];
        [self.firstThingLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        [self.contentView addSubview:self.firstThingLabel];
        
        
        //首数量
        self.firstThingCountField = [[UITextField alloc]init];
        self.firstThingCountField.frame = CGRectMake(self.firstThingLabel.frame.origin.x + self.firstThingLabel.frame.size.width, self.dividerLabel.frame.origin.y + 9, 100, 25);
        self.firstThingCountField.layer.borderWidth = 1;
        [self.contentView addSubview:self.firstThingCountField];
        
        
        
        //续
        self.goOnThingLabel = [[UILabel alloc]init];
        //        self.goOnThingLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.goOnThingLabel];
        
        //续数量
        self.goOnThingCountLabel = [[UILabel alloc]init];
        //        self.goOnThingCountLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.goOnThingCountLabel];
        
        //首运费
        self.firstThingFreightLabel = [[UILabel alloc]init];
        //        self.firstThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firstThingFreightLabel];
        
        //首运费money
        self.firstThingFreightMoneyLabel = [[UILabel alloc]init];
        //        self.firstThingFreightMoneyLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firstThingFreightMoneyLabel];
        
        //续运费
        self.goOnThingFreightLabel = [[UILabel alloc]init];
        //        self.goOnThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.goOnThingFreightLabel];
        
        //续运费money
        self.goOnThingFreightMoneyLabel = [[UILabel alloc]init];
        //        self.goOnThingFreightMoneyLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview: self.goOnThingFreightMoneyLabel];
        
        
    }
         
       */  
         
        
         
         
}




-(void)didClickJoinDetailAreaPage
{
    if ([self.delegate respondsToSelector:@selector(joinAreaDetailPageIndexPath:)]) {
        [self.delegate joinAreaDetailPageIndexPath:self.index_row];
    }
    
}







@end
