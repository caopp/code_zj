//
//  LookFreightTemplateCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/3/18.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LookFreightTemplateCell.h"
#import "LookFerightTempModel.h"
#import "LookFerightTempListModel.h"
#import "UIColor+UIColor.h"


@implementation LookFreightTemplateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
     
        
        
        
        self.view = [[UIView alloc]init];
        [self.contentView addSubview:self.view];
//        self.backgroundColor = [UIColor yellowColor];
       
        //运送到
        self.shippedLabel =[[UILabel alloc]init];
//        self.shippedLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.shippedLabel];
        
        //城市区域
        self.cityLabel = [[UILabel alloc]init];
//        self.cityLabel.backgroundColor = [UIColor redColor];
        self.cityLabel.numberOfLines = 0;
        self.cityLabel.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:self.cityLabel];
        
        //分割线
        self.dividerLabel = [[UILabel alloc]init];
        [self.view addSubview:self.dividerLabel];
        
        //首
        self.firstThingLabel = [[UILabel alloc]init];
//        self.firstThingLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.firstThingLabel];
        
        //首数量
        self.firstThingCountLabel = [[UILabel alloc]init];
//        self.firstThingCountLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.firstThingCountLabel];
        
        //续
        self.goOnThingLabel = [[UILabel alloc]init];
//        self.goOnThingLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.goOnThingLabel];
        
        //续数量
        self.goOnThingCountLabel = [[UILabel alloc]init];
//        self.goOnThingCountLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.goOnThingCountLabel];
        
        //首运费
        self.firstThingFreightLabel = [[UILabel alloc]init];
//        self.firstThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.firstThingFreightLabel];
        
        //首运费money
        self.firstThingFreightMoneyLabel = [[UILabel alloc]init];
//        self.firstThingFreightMoneyLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.firstThingFreightMoneyLabel];
        
        //续运费
        self.goOnThingFreightLabel = [[UILabel alloc]init];
//        self.goOnThingFreightLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview:self.goOnThingFreightLabel];
        
        //续运费money
        self.goOnThingFreightMoneyLabel = [[UILabel alloc]init];
//        self.goOnThingFreightMoneyLabel.backgroundColor = [UIColor redColor];
        [self.view addSubview: self.goOnThingFreightMoneyLabel];
    
    }
    return self;
}


//获取数据
-(void)getLookFreightTemplateCellData:(LookFerightTempModel *)data type:(NSString *)type selectedDefault:(NSString *)selectedDefault
{

    
    DebugLog(@"selectedDefault ==== %@", selectedDefault);
    //传递上一个页面传递过来（包邮和选中，没有选中状态）
    if (selectedDefault.integerValue == 2) {
        self.shippedLabel.frame = CGRectMake(15, 10, 100 , 17);
        self.shippedLabel.text =  @"默认运费:";
        self.shippedLabel.font = [UIFont systemFontOfSize:14];
        [self.shippedLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        
        self.cityLabel.frame = CGRectMake(self.shippedLabel.frame.origin.x, self.shippedLabel.frame.origin.y + self.shippedLabel.frame.size.height, self.frame.size.width, 1);
        
    }else
    {
        
        if ([data.isDefault isEqualToString: @"0"]) {
            //运动到
            self.shippedLabel.frame = CGRectMake(15, 10, 100 , 17);
            self.shippedLabel.text =  @"默认运费:";
            self.shippedLabel.font = [UIFont systemFontOfSize:14];
            [self.shippedLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
            
            self.cityLabel.frame = CGRectMake(self.shippedLabel.frame.origin.x, self.shippedLabel.frame.origin.y + self.shippedLabel.frame.size.height + 10, self.frame.size.width, 12);
            self.cityLabel.text = @"除设置的指定区域之外均以此计价方式核算运费";
            self.cityLabel.font = [UIFont systemFontOfSize:13];
            [self.cityLabel setTextColor:[UIColor colorWithHexValue:0xeb301f alpha:1]];
            
        }else
        {
            //运动到
            self.shippedLabel.frame = CGRectMake(15, 10, 50 , 17);
            self.shippedLabel.text =  @"运送到:";
            self.shippedLabel.font = [UIFont systemFontOfSize:14];
            [self.shippedLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        }
        
    }
    
    //城市区域
    
    if ([data.isDefault isEqualToString:@"1"]) {
        if ([type isEqualToString:@"0"]) {
            self.cityLabel.text = data.expressArea;
            CGSize citySize = [self sizeWithText:data.expressArea font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -  self.shippedLabel.frame.size.width - 30, MAXFLOAT)];
            self.cityLabel.frame = CGRectMake(self.shippedLabel.frame.size.width + self.shippedLabel.frame.origin.x + 5, 10, citySize.width ,citySize.height);
            [self.cityLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        }else
        {
            self.cityLabel.text = data.expressArea;
            CGSize citySize = [self sizeWithText:data.expressArea font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(SCREEN_WIDTH -  self.shippedLabel.frame.size.width - 30, MAXFLOAT)];
            
            self.cityLabel.frame = CGRectMake(self.shippedLabel.frame.size.width + self.shippedLabel.frame.origin.x + 5, 10, citySize.width ,citySize.height );
            [self.cityLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
//            self.cityLabel.backgroundColor = [UIColor redColor];
            
        }
    }

    
//进行行间距设置
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:self.cityLabel.text];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    [paragraphStyle setLineSpacing:1];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.cityLabel.text.length)];
//    self.cityLabel.attributedText = attributedString;
    
//    if ([data.isDefault isEqualToString: @"0"]) {
//         //分割线
//         self.dividerLabel.frame = CGRectMake(15, self.cityLabel.frame.size.height+self.cityLabel.frame.origin.y + 5, 500, 1);
//      
//     }else
//     {
//         //分割线
//         CGFloat cityY = CGRectGetMaxY(self.cityLabel.frame);
//         
//         self.dividerLabel.frame = CGRectMake(15, cityY + self.cityLabel.frame.origin.y + 5, 500, 1);
//        
//         
//     }
//     CGFloat cityY = CGRectGetMaxY(self.cityLabel.frame);
    
    
     self.dividerLabel.frame = CGRectMake(15, self.cityLabel.frame.size.height + self.cityLabel.frame.origin.y + 10, 500, 1);
     self.dividerLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
    
    
    //首
    self.firstThingLabel.frame = CGRectMake(15, self.dividerLabel.frame.origin.y + 11, 40, 15);
    if ([type isEqualToString:@"0"]) {
        self.firstThingLabel.text = @"首重:";
    }else
    {
        self.firstThingLabel.text = @"首件:";
    }
    self.firstThingLabel.font = [UIFont systemFontOfSize:14];
    [self.firstThingLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    
    //首数量
    if ([type isEqualToString:@"0"]) {
     
        CGSize firstThingCountSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.frontWeight] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.firstThingCountLabel.frame = CGRectMake(self.firstThingLabel.frame.origin.x + self.firstThingLabel.frame.size.width + 5, self.firstThingLabel.frame.origin.y,firstThingCountSize.width, firstThingCountSize.height);
        self.firstThingCountLabel.text = [NSString stringWithFormat:@"%@",data.frontWeight];
        self.firstThingCountLabel.font = [UIFont systemFontOfSize:14];
        [self.firstThingCountLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

        
    }else
    {
        CGSize firstThingCountSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.frontQuantity] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        self.firstThingCountLabel.frame = CGRectMake(self.firstThingLabel.frame.origin.x + self.firstThingLabel.frame.size.width + 5, self.firstThingLabel.frame.origin.y,firstThingCountSize.width, firstThingCountSize.height);
        self.firstThingCountLabel.text = [NSString stringWithFormat:@"%@",data.frontQuantity];
        self.firstThingCountLabel.font = [UIFont systemFontOfSize:14];
        [self.firstThingCountLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
    }
   
    
    
    self.firstThingFreightLabel.frame = CGRectMake(self.firstThingCountLabel.frame.origin.x + self.firstThingCountLabel.frame.size.width + 10, self.firstThingCountLabel.frame.origin.y, 40, 15);
    self.firstThingFreightLabel.text = @"运费:";
    self.firstThingFreightLabel.font = [UIFont systemFontOfSize:14];
    [self.firstThingFreightLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
        
        CGSize firstThingFreightMoney = [self sizeWithText:[NSString stringWithFormat:@"%@",data.frontFreight] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        self.firstThingFreightMoneyLabel.frame = CGRectMake(self.firstThingFreightLabel.frame.origin.x + self.firstThingFreightLabel.frame.size.width +5 , self.firstThingFreightLabel.frame.origin.y, firstThingFreightMoney.width + 10, firstThingFreightMoney.height);
        
        self.firstThingFreightMoneyLabel.text = [NSString stringWithFormat:@"¥%@",data.frontFreight];
        self.firstThingFreightMoneyLabel.font = [UIFont systemFontOfSize:14];
        [self.firstThingFreightMoneyLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        
    
    
    //续
    self.goOnThingLabel.frame = CGRectMake(15, self.dividerLabel.frame.origin.y + 11 + self.firstThingLabel.frame.size.height + 15 , 40, 15);
    if ([type isEqualToString:@"0"]) {
       self.goOnThingLabel.text = @"续重:";
    }else
    {
    self.goOnThingLabel.text = @"续件:";
    }
    self.goOnThingLabel.font = [UIFont systemFontOfSize:14];
    [self.goOnThingLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    //续数量
    
    if ([type isEqualToString:@"0"]) {
         CGSize firstThingCountSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.afterWeight] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        self.goOnThingCountLabel.frame = CGRectMake(self.goOnThingLabel.frame.origin.x +self.goOnThingLabel.frame.size.width + 5,  self.goOnThingLabel.frame.origin.y, firstThingCountSize.width, firstThingCountSize.height);
         self.goOnThingCountLabel.text = [NSString stringWithFormat:@"%@",data.afterWeight];
        self.goOnThingCountLabel.font = [UIFont systemFontOfSize:14];
        [self.goOnThingCountLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];
        
    }else
    {
        CGSize firstThingCountSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.afterQuantity] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        self.goOnThingCountLabel.frame = CGRectMake(self.goOnThingLabel.frame.origin.x +self.goOnThingLabel.frame.size.width + 5,  self.goOnThingLabel.frame.origin.y, firstThingCountSize.width, firstThingCountSize.height);
        self.goOnThingCountLabel.text = [NSString stringWithFormat:@"%@",data.afterQuantity];
        self.goOnThingCountLabel.font = [UIFont systemFontOfSize:14];
        [self.goOnThingCountLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    }
    
    //续运费
    self.goOnThingFreightLabel.frame = CGRectMake(self.goOnThingCountLabel.frame.origin.x + self.goOnThingCountLabel.frame.size.width + 10,self.goOnThingCountLabel.frame.origin.y ,40 , 15);
    self.goOnThingFreightLabel.text = @"运费:";
    self.goOnThingFreightLabel.font = [UIFont systemFontOfSize:14];
    [self.goOnThingFreightLabel setTextColor:[UIColor colorWithHexValue:0x999999 alpha:1]];
    
    
         CGSize firstThingCountSize = [self sizeWithText:[NSString stringWithFormat:@"%@",data.afterFreight] font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
        
        
        self.goOnThingFreightMoneyLabel.frame = CGRectMake(self.goOnThingFreightLabel.frame.origin.x + self.goOnThingFreightLabel.frame.size.width + 5, self.goOnThingFreightLabel.frame.origin.y, firstThingCountSize.width + 10, firstThingCountSize.height);
        
        self.goOnThingFreightMoneyLabel.text = [NSString stringWithFormat:@"¥%@",data.afterFreight];
        self.goOnThingFreightMoneyLabel.font = [UIFont systemFontOfSize:14];
        [self.goOnThingFreightMoneyLabel setTextColor:[UIColor colorWithHexValue:0x000000 alpha:1]];

    
    
    
   
    
    
    
    NSLog(@"heght ==== %f===%f",self.goOnThingFreightMoneyLabel.frame.origin.y,self.goOnThingFreightMoneyLabel.frame.size.height);
    
    self.numFloat = self.goOnThingFreightMoneyLabel.frame.origin.y +self.goOnThingFreightMoneyLabel.frame.size.height + 10;

    self.view.frame = CGRectMake(0, 0,600, self.numFloat);
    
    
    self.contentView.backgroundColor = [UIColor colorWithHexValue:0xefeff4 alpha:1];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    

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
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
}






@end
