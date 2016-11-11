//
//  CSPMemberOfflineObject.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMemberOfflineObject.h"
#import "CSPOnlineServiceTableViewCell.h"

@implementation CSPMemberOfflineObject

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 3;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CSPOnlineServiceTableViewCell *onlineCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOnlineServiceTableViewCell"];
    
    
    if (!onlineCell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"CSPOnlineServiceTableViewCell" bundle:nil] forCellReuseIdentifier:@"CSPOnlineServiceTableViewCell"];
        onlineCell = [tableView dequeueReusableCellWithIdentifier:@"CSPOnlineServiceTableViewCell"];
    }
    
    switch (indexPath.row) {
        case 0:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_优秀供应商可点击状态.png"];
            onlineCell.titleLabel.text = @"推荐优质供应商";
            onlineCell.detailLabel.text = @"挑选潮流风格品牌,保障货品来源及质量认证。";
            break;
        case 1:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_开店指导可点击状态.png"];
            onlineCell.titleLabel.text = @"开店指导";
            onlineCell.detailLabel.text = @"选地段、选铺位、进货补货专业指导开店。";
            break;
        case 2:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_买手推荐可点击状态.png"];
            onlineCell.titleLabel.text = @"买手推荐";
            onlineCell.detailLabel.text = @"独到的眼光带来高品质的独特货源。";
            break;

            
        default:
            break;
    }
    
    return onlineCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(offLineDidSelectAtRow:)]) {
        [self.delegate offLineDidSelectAtRow:indexPath];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
@end
