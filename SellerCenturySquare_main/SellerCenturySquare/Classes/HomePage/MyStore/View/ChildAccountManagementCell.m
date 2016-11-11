//
//  ChildAccountManagementCell.m
//  SellerCenturySquare
//
//  Created by 陈光 on 15/11/4.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "ChildAccountManagementCell.h"
#import "HttpManager.h"
/**
 *  子账户自定义cell
 */
@interface ChildAccountManagementCell ()
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusName;


@end

@implementation ChildAccountManagementCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)accountAllDict:(NSDictionary *)dict
{
    self.accountLabel.text = dict[@"merchantAccount"];
    self.nameLabel.text = dict[@"nickName"];
    
    if ([dict[@"enableFlag"] isEqualToString:@"1"]) {
    self.statusName.text =  @"关闭";
    }else
    {
     self.statusName.text = @"开启";
    }
    
    
}
@end

