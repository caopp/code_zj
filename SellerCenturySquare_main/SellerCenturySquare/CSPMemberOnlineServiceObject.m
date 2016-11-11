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
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_设置采购商等级介绍_店铺置顶可点击状态.png"];
            onlineCell.titleLabel.text = @"店铺置顶";
            onlineCell.detailLabel.text = @"在邀请的采购商的商家列表置顶本店。";
            break;
        case 1:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_采购商分级选中状态.png"];
            onlineCell.titleLabel.text = @"采购商分级";
            onlineCell.detailLabel.text = @"设定采购商的本店等级。";
            break;
        case 2:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_采购商黑名单选中状态.png"];
            onlineCell.titleLabel.text = @"采购商黑名单";
            onlineCell.detailLabel.text = @"限制采购商浏览、购买本店的所有商品。";
            break;
        case 3:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_免费下载图片次数0.png"];
            onlineCell.titleLabel.text = @"商品图片免费下载";
            onlineCell.detailLabel.text = @"每月赠送免费下载次数，不清零可累计。";
            break;
        case 4:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"付费下载图片次数200"];
            onlineCell.titleLabel.text = @"购买商品图片";
            onlineCell.detailLabel.text = @"付费购买商品图片，等级越高越便宜。";
            break;
        case 5:
            onlineCell.onlineImageView.image = [UIImage imageNamed:@"04_商家中心_采购商_限制采购商下载选中状态.png"];
            onlineCell.titleLabel.text = @"限制采购商下载";
            onlineCell.detailLabel.text = @"限制无交易采购商下载本店新款商品图片。";
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (self.delegate && [self.delegate respondsToSelector:@selector(onLineDidSelectAtRow:)]) {
        [self.delegate onLineDidSelectAtRow:indexPath];
    }
}

@end
