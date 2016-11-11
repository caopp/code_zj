//
//  RecommendReceiveTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "RecommendReceiveTableViewCell.h"

@implementation RecommendReceiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)modifyReceivePersonNumButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kModifyReceivePersonNotification object:nil];
}

- (void)setNum:(NSInteger)num{
    
    _receiveL.text = [NSString stringWithFormat:@"已选收件人：%zi人",num];
}


@end
