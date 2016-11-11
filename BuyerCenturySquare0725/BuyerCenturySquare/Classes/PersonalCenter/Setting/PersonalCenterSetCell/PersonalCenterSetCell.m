
//
//  PersonalCenterSetCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/12/10.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "PersonalCenterSetCell.h"
#import "PersonlCeterSetSingle.h"
@implementation PersonalCenterSetCell
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"common";
    PersonalCenterSetCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        
        cell = [[PersonalCenterSetCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        
    }
    return cell;
}


-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(59, 43, SCREEN_WIDTH, 0.5)];
        self.lineLabel.backgroundColor = [UIColor colorWithHexValue:0xc8c7cc alpha:1];
        [self.contentView addSubview:self.lineLabel];
        
        
        self.textLabel.font = [UIFont systemFontOfSize:14];
        [self.textLabel  setTextColor:[UIColor colorWithHexValue:0x666666 alpha:1]];
    }
    return  self;
}

#pragma mark ---setter---
-(void)setItem:(PersonlCeterSetSingle *)item
{
    _item = item;
    
    //设置基本数据
    self.imageView.image = [UIImage imageNamed:item.icon];
    
    self.textLabel.text = item.title;
}


@end
