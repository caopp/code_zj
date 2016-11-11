//
//  CSPMemberOnlineServiceObject.m
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/9/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "CSPMemberOnlineServiceObject.h"
#import "CSPOnlineServiceTableViewCell.h"
#import "CSPGoodsNewCheckTableViewController.h"

@implementation CSPMemberOnlineServiceObject

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 6;
    
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
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_查看实时上新可查看状态.png"];
            onlineCell.titleLabel.text = @"商品上新查看";
            onlineCell.detailLabel.text = @"实时浏览订购最新上架商品";
            break;
        case 1:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_可收藏状态.png"];
            onlineCell.titleLabel.text = @"商品收藏";
            onlineCell.detailLabel.text = @"一键收藏商品，方便快速查阅";
            break;
        case 2:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数10次可分享状态.png"];
            onlineCell.titleLabel.text = @"商品分享";
            onlineCell.detailLabel.text = @"分享商品图片到朋友圈，高效推广。";
            break;
        case 3:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_查看详情图可查看状态.png"];
            onlineCell.titleLabel.text = @"商品图片查看";
            onlineCell.detailLabel.text = @"查看窗口图客观图，全面了解商品此节。";
            break;
        case 4:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_免费下载次数10次可下载状态.png"];
            onlineCell.titleLabel.text = @"商品图片免费下载";
            onlineCell.detailLabel.text = @"每月赠送免费下载次数，不清零可累积。";
            break;
        case 5:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"08_会员等级权限_付费下载10次¥30可下载状态.png"];
            onlineCell.titleLabel.text = @"购买商品图片";
            onlineCell.detailLabel.text = @"付费购买商品图片，等级越高越便宜。";
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(onLineDidSelectAtRow:)]) {
        [self.delegate onLineDidSelectAtRow:indexPath];
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
